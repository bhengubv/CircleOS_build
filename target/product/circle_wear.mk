# Circle OS - circle_wear product (one-codebase/every-device). GSI base + generic_arm64
# device + circle_core (Circle neutral base + core apps) + this face's app group.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_system.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_product.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/board/generic_arm64/device.mk)
$(call inherit-product, build/circle/target/product/circle_core.mk)
include vendor/circle/config/packages-wear.mk
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS ?= system
PRODUCT_CHARACTERISTICS := watch
PRODUCT_SYSTEM_PROPERTIES += ro.circle.formfactor=watch
PRODUCT_NAME    := circle_wear
PRODUCT_DEVICE  := generic_arm64
PRODUCT_BRAND   := Circle
PRODUCT_MODEL   := Circle OS (Watch)
PRODUCT_NO_BIONIC_PAGE_SIZE_MACRO := true
