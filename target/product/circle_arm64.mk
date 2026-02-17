# Circle OS - arm64 lunch target
# Usage: lunch circle_arm64-userdebug

$(call inherit-product, build/circle/target/product/circle_base.mk)

PRODUCT_NAME   := circle_arm64
PRODUCT_DEVICE := generic_arm64

# Architecture
TARGET_ARCH         := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI      := arm64-v8a
TARGET_CPU_VARIANT  := generic

TARGET_2ND_ARCH         := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI      := armeabi-v7a
TARGET_2ND_CPU_ABI2     := armeabi
TARGET_2ND_CPU_VARIANT  := generic
