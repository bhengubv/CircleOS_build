# Circle OS - automotive (car / IVI) product. GSI base + generic_arm64 device +
# circle_core + the automotive app group. One codebase, every device.
#
# NOTE: a production car OS also needs Android Automotive's CarService + IVI HALs
# (more than a product makefile, like watch) -- this slots the face into the one
# tree; the AAOS layer is follow-on work.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_system.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_product.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/board/generic_arm64/device.mk)
$(call inherit-product, build/circle/target/product/circle_core.mk)
include vendor/circle/config/packages-auto.mk
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS ?= system
PRODUCT_CHARACTERISTICS := automotive
PRODUCT_SYSTEM_PROPERTIES += ro.circle.formfactor=car
PRODUCT_NAME    := circle_auto
PRODUCT_DEVICE  := generic_arm64
PRODUCT_BRAND   := Circle
PRODUCT_MODEL   := Circle OS (Automotive)
PRODUCT_NO_BIONIC_PAGE_SIZE_MACRO := true
