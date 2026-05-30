# Circle OS - arm64 GSI target.
# Usage: lunch circle_arm64-trunk_staging-userdebug
#
# Inherits the AOSP GSI base products (generic_system, handheld + telephony
# system_ext, aosp_product) plus the generic_arm64 device.mk. Between them
# they define INSTALLED_SYSTEMIMAGE_TARGET, BOARD_SYSTEMIMAGE_PARTITION_SIZE,
# the system_ext image, the product image, and AB_OTA_UPDATER. Without
# these, `m systemimage` resolves to ninja's "no work to do" because no
# targets install into system.img and the product builds a metadata-only
# tree at out/target/product/generic_arm64/ with no .img files.
#
# circle_base.mk is layered on top so Circle PRODUCT_PACKAGES / properties /
# sepolicy still apply.
#
# TARGET_ARCH / TARGET_CPU_ABI / TARGET_2ND_ARCH and friends are set by the
# BoardConfig at build/make/target/board/generic_arm64/BoardConfig.mk
# (resolved via PRODUCT_DEVICE) — they do not need to be duplicated here,
# and duplicating them risked masking BoardConfigGsiCommon.mk inclusions.

# === AOSP GSI base ====================================================
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_system.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_system_ext.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_system_ext.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_product.mk)

# === Generic arm64 device tree (vendor / vendor_boot bits) ============
$(call inherit-product, $(SRC_TARGET_DIR)/board/generic_arm64/device.mk)

# === Circle OS additions (PRODUCT_PACKAGES, properties, sepolicy) ====
$(call inherit-product, build/circle/target/product/circle_base.mk)

# A/B OTA support — system-only A/B (same as upstream aosp_arm64).
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS ?= system

PRODUCT_NAME    := circle_arm64
PRODUCT_DEVICE  := generic_arm64
PRODUCT_BRAND   := Circle
PRODUCT_MODEL   := Circle OS

PRODUCT_NO_BIONIC_PAGE_SIZE_MACRO := true
