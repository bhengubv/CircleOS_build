# Circle OS - circle_tv product (one-codebase/every-device). GSI base + generic_arm64
# device + circle_core (Circle neutral base + core apps) + this face's app group.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_system.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_product.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/board/generic_arm64/device.mk)
$(call inherit-product, build/circle/target/product/circle_core.mk)
include vendor/circle/config/packages-tv.mk
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS ?= system
PRODUCT_CHARACTERISTICS := tv
PRODUCT_SYSTEM_PROPERTIES += ro.circle.formfactor=tv
PRODUCT_NAME    := circle_tv
PRODUCT_DEVICE  := generic_arm64
PRODUCT_BRAND   := Circle
PRODUCT_MODEL   := Circle OS (TV)
PRODUCT_NO_BIONIC_PAGE_SIZE_MACRO := true
