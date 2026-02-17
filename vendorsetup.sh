#!/bin/bash
# Circle OS - vendorsetup.sh
# Registers Circle lunch combos with the AOSP build system.
# Sourced automatically by build/envsetup.sh.

add_lunch_combo circle_arm64-userdebug
add_lunch_combo circle_arm64-user

# Xiaomi Redmi Note 12 — minimum supported device
add_lunch_combo circle_redmi_note12-userdebug
add_lunch_combo circle_redmi_note12-user

# Google Pixel 6 — flagship reference device
add_lunch_combo circle_pixel6-userdebug
add_lunch_combo circle_pixel6-user

# x86_64 emulator — CI testing
add_lunch_combo circle_emulator-userdebug
