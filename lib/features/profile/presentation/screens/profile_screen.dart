import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/localization/app_translations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('profile_title'.tr)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.lg),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: controller.firstNameController,
                  hintText: 'profile_first_name_hint'.tr,
                  validator: controller.validateFirstName,
                ),
                const SizedBox(height: AppDimens.md),
                AppTextField(
                  controller: controller.lastNameController,
                  hintText: 'profile_last_name_hint'.tr,
                  validator: controller.validateLastName,
                ),
                const SizedBox(height: AppDimens.md),
                AppTextField(
                  controller: controller.emailController,
                  hintText: 'profile_email_hint'.tr,
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),
                const SizedBox(height: AppDimens.lg),
                Obx(
                  () => AppButton(
                    label: 'profile_save'.tr,
                    isLoading: controller.isUpdating.value,
                    onPressed: controller.updateProfile,
                  ),
                ),
                const SizedBox(height: AppDimens.xl),
                const Divider(color: AppColors.divider),
                const SizedBox(height: AppDimens.md),
                Text('profile_language'.tr, style: AppTypography.h3),
                const SizedBox(height: AppDimens.sm),
                Obx(() => _LanguageToggle(controller: controller)),
                const SizedBox(height: AppDimens.xl),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: controller.isLoggingOut.value
                          ? null
                          : controller.confirmLogout,
                      child: controller.isLoggingOut.value
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'profile_logout'.tr,
                              style: AppTypography.bodyLarge.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  final ProfileController controller;

  const _LanguageToggle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _LanguageOption(
            label: 'profile_language_en'.tr,
            isSelected: controller.activeLanguageCode.value ==
                AppLocales.codeEn,
            onTap: () => controller.toggleLanguage(AppLocales.codeEn),
          ),
        ),
        const SizedBox(width: AppDimens.sm),
        Expanded(
          child: _LanguageOption(
            label: 'profile_language_ar'.tr,
            isSelected: controller.activeLanguageCode.value ==
                AppLocales.codeAr,
            onTap: () => controller.toggleLanguage(AppLocales.codeAr),
          ),
        ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
