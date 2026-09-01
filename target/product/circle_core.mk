# Circle OS - form-factor-NEUTRAL base product. Inherited by every device-class
# product (phone/tablet/desktop/tv/wear). Contains the Circle identity, hardening,
# microG, init, neutral config and the CORE app group -- but NO telephony, NO
# handheld, NO launcher, NO consumer suite. Concrete products add those.

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, vendor/circle/security/hardening.mk)

include vendor/circle/config/core-config.mk
include vendor/circle/config/packages-core.mk

PRODUCT_COPY_FILES += \
    vendor/circle/etc/init/circle_init.rc:$(TARGET_COPY_OUT_SYSTEM)/etc/init/circle_init.rc

include vendor/circle/microg/microg.mk

PRODUCT_PACKAGES += CircleSettings

PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/circle/release/security/releasekey

PRODUCT_BRAND        := Circle
PRODUCT_MANUFACTURER := CircleFoundation
PRODUCT_NAME         := circle_core
PRODUCT_MODEL        := Circle OS (core)
