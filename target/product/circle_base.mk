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

PRODUCT_PROPERTY_OVERRIDES += \
    ro.circle.version=$(CIRCLE_VERSION) \
    ro.circle.build.type=$(TARGET_BUILD_VARIANT) \
    ro.build.display.id=CircleOS-$(CIRCLE_VERSION)-$(shell date +%Y%m%d)

# Privacy framework services (registered in SystemServer)
PRODUCT_PACKAGES += \
    CircleSettings \
    CirclePrivacyManagerService \
    CirclePermissionService

# SELinux policy lives in vendor/circle/sepolicy and is registered as
# system_ext sepolicy via SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS in
# vendor/circle/config/common.mk (which this product inherits via circle.mk).
# Do NOT also add it to BOARD_SEPOLICY_DIRS — that would route the same
# files to vendor partition where the namespace check rejects the
# circle_* context names and the OEM brand property prefix.
