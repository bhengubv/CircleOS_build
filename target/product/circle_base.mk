# Circle OS - Base product definition
# Inherited by all Circle hardware targets.

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Circle vendor overlay
$(call inherit-product, vendor/circle/circle.mk)

# Product identity
PRODUCT_NAME    := circle_base
PRODUCT_BRAND   := Circle
PRODUCT_MANUFACTURER := CircleFoundation
PRODUCT_MODEL   := Circle OS

# Circle OS version
PRODUCT_VERSION_MAJOR := 0
PRODUCT_VERSION_MINOR := 1
PRODUCT_VERSION_PATCH := 0
CIRCLE_VERSION        := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_PATCH)-alpha

# Round 21: Use partition-specific PRODUCT_SYSTEM_PROPERTIES instead of
# legacy PRODUCT_PROPERTY_OVERRIDES. Round 20 (vendor/circle 442644e)
# labelled ro.circle.* as system_property_type via system_public_prop(
# circle_prop) — so writes belong in PRODUCT_SYSTEM_PROPERTIES which
# targets /system/build.prop. PRODUCT_PROPERTY_OVERRIDES still works
# for standard build properties like ro.build.display.id.
PRODUCT_SYSTEM_PROPERTIES += \
    ro.circle.version=$(CIRCLE_VERSION) \
    ro.circle.build.type=$(TARGET_BUILD_VARIANT)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.display.id=CircleOS-$(CIRCLE_VERSION)-$(shell date +%Y%m%d)


# Release signing keys — built from vendor/circle/release/security/.
# Every key type (releasekey, platform, shared, media, networkstack) lives
# in that directory; AOSP resolves them relative to the directory of the
# key named here. The .pk8 files are mode 600 and .gitignored.
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/circle/release/security/releasekey
# Privacy framework services (registered in SystemServer)
PRODUCT_PACKAGES += \
    CircleSettings

# SELinux policy lives in vendor/circle/sepolicy and is registered as
# system_ext sepolicy via SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS in
# vendor/circle/config/common.mk (which this product inherits via circle.mk).
# Do NOT also add it to BOARD_SEPOLICY_DIRS — that would route the same
# files to vendor partition where the namespace check rejects the
# circle_* context names and the OEM brand property prefix.
