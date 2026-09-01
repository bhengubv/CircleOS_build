#!/usr/bin/env bash
# Circle OS - one build, every device.  The "Build Solution" button.
#
# One tree, one command, every Circle device image.  Like a Visual Studio
# solution build: one invocation walks every product in the "solution" and
# emits each artifact -- here, one system image per device class -- while the
# shared framework compiles once (ccache), so images 2..N are cheap deltas.
#
# The Circle "solution" (the device classes this one tree yields):
#     phone . tablet . desktop . tv . wear . auto
#     (+ the C companion node for sub-Android chips -- the $5-sensor tier).
#
# Usage:
#   build/circle/build_all.sh                     analysis gate for ALL products
#                                                 (cheap: lunch + `m nothing`, no images)
#   build/circle/build_all.sh --images            full: gate THEN system image per product,
#                                                 each staged into dist/circle/<product>/
#   build/circle/build_all.sh --images circle_tablet circle_tv
#                                                 only the named products
#   build/circle/build_all.sh --list              print the product list
#
# Discipline -- HARD RULE (AOSP_BUILD_DISCIPLINE.md): every product passes
# `m nothing` (Soong analysis) + a PRODUCT_PACKAGES sanity line BEFORE any
# `m systemimage`.  ccache is REUSED (USE_CCACHE=1); this script NEVER clears it.
#
# NOTE: the six products currently share TARGET_DEVICE=generic_arm64, so their
# images land in the same out/ dir.  In --images mode we build them serially and
# copy each image out to dist/circle/<product>/ before the next (AOSP installclean
# fires between same-device products).  Clean long-term fix: a per-product board
# dir so all six build side-by-side.
set -uo pipefail

AOSP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$AOSP_ROOT" || { echo "cannot cd to aosp root ($AOSP_ROOT)"; exit 1; }

PRODUCTS=(circle_phone circle_tablet circle_desktop circle_tv circle_wear circle_auto)
VARIANT="trunk_staging-userdebug"
JOBS="${JOBS:-$(nproc)}"
DIST="$AOSP_ROOT/dist/circle"

MODE="check"
SELECT=()
while [ $# -gt 0 ]; do
  case "$1" in
    --images) MODE="images" ;;
    --check)  MODE="check" ;;
    --list)   printf '%s\n' "${PRODUCTS[@]}"; exit 0 ;;
    -h|--help) sed -n '2,33p' "${BASH_SOURCE[0]}"; exit 0 ;;
    circle_*) SELECT+=("$1") ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
  shift
done
[ "${#SELECT[@]}" -gt 0 ] && PRODUCTS=("${SELECT[@]}")

export USE_CCACHE=1          # reuse ccache; never cleared here
source build/envsetup.sh >/dev/null

SUMMARY=()
ok=0; bad=0
for p in "${PRODUCTS[@]}"; do
  echo "==================================================================="
  echo ">>> $p   [$MODE]"
  echo "==================================================================="
  if ! lunch "${p}-${VARIANT}" >/dev/null 2>&1; then
    echo "!!! lunch failed"; SUMMARY+=("$p  LUNCH-FAIL"); bad=$((bad+1)); continue
  fi
  chars="$(get_build_var PRODUCT_CHARACTERISTICS 2>/dev/null)"
  ff="$(get_build_var PRODUCT_SYSTEM_PROPERTIES 2>/dev/null | tr ' ' '\n' | sed -n 's/^ro\.circle\.formfactor=//p' | head -1)"
  npkg="$(get_build_var PRODUCT_PACKAGES 2>/dev/null | wc -w)"
  echo "    characteristics=[$chars]  formfactor=${ff:-?}  packages=$npkg"

  echo "    m nothing (Soong analysis gate) ..."
  if ! m -j"$JOBS" nothing >"/tmp/circle_nothing_${p}.log" 2>&1; then
    echo "!!! analysis FAILED -- tail /tmp/circle_nothing_${p}.log:"; tail -20 "/tmp/circle_nothing_${p}.log"
    SUMMARY+=("$p  chars=[$chars] ff=${ff:-?} pkgs=$npkg  ANALYSIS-FAIL"); bad=$((bad+1)); continue
  fi

  if [ "$MODE" = check ]; then
    SUMMARY+=("$p  chars=[$chars] ff=${ff:-?} pkgs=$npkg  ANALYSIS-OK"); ok=$((ok+1)); continue
  fi

  echo "    m systemimage ..."
  if m -j"$JOBS" systemimage 2>&1 | tail -8; then
    dev="$(get_build_var TARGET_DEVICE 2>/dev/null)"
    src="out/target/product/$dev"
    mkdir -p "$DIST/$p"
    for img in system.img vendor.img boot.img super.img; do
      [ -f "$src/$img" ] && cp -f "$src/$img" "$DIST/$p/" && echo "      staged $img -> dist/circle/$p/"
    done
    SUMMARY+=("$p  chars=[$chars] ff=${ff:-?} pkgs=$npkg  IMAGE-OK -> dist/circle/$p/"); ok=$((ok+1))
  else
    SUMMARY+=("$p  chars=[$chars] ff=${ff:-?} pkgs=$npkg  IMAGE-FAIL"); bad=$((bad+1))
  fi
done

# companion (sub-Android tier): the $5-chip node -- like the solution's mobile project.
if [ "$MODE" = images ]; then
  echo "==================================================================="
  echo ">>> companion mesh node (C, sub-Android tier)"
  echo "==================================================================="
  if make -C vendor/circle/companion >/tmp/circle_companion.log 2>&1; then
    SUMMARY+=("companion  BUILT -> vendor/circle/companion/circle_mesh_node")
  else
    echo "    not linked yet -- expected until the aether-protocol C port + libsodium-dev"
    echo "    are synced (see vendor/circle/companion/README.md).  Not counted as a failure."
    tail -4 /tmp/circle_companion.log 2>/dev/null
    SUMMARY+=("companion  EXPECTED-GAP (needs libsodium-dev + libaether-protocol)")
  fi
fi

echo
echo "=================== Circle build summary ($MODE) ==================="
printf '  %s\n' "${SUMMARY[@]}"
echo "  ---- $ok ok, $bad failed ----"
[ "$bad" -eq 0 ]
