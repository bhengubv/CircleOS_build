# Circle OS - CleanSpec.mk
# Lists files/directories that must be cleaned when their build rules change.
# Add entries here when renaming or moving Circle build outputs.

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/app/CircleSettings)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/system/priv-app/CircleSettings)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/data/circle)
