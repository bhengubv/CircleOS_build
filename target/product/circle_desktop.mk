# Circle OS - circle_desktop product (one-codebase/every-device). GSI base + generic_arm64
# device + circle_core (Circle neutral base + core apps) + this face's app group.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_system.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_system_ext.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_product.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/board/generic_arm64/device.mk)
$(call inherit-product, build/circle/target/product/circle_core.mk)
include vendor/circle/config/packages-phone.mk
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS ?= system
PRODUCT_CHARACTERISTICS := tablet
PRODUCT_SYSTEM_PROPERTIES += persist.wm.extensions.enabled=true
PRODUCT_SYSTEM_PROPERTIES += ro.circle.formfactor=desktop
PRODUCT_NAME    := circle_desktop
PRODUCT_DEVICE  := generic_arm64
PRODUCT_BRAND   := Circle
PRODUCT_MODEL   := Circle OS (Desktop/Laptop)
PRODUCT_NO_BIONIC_PAGE_SIZE_MACRO := true
