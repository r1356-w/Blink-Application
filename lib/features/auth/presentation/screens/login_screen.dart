import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.bolt_rounded,
                  color: AppColors.primary,
                  size: AppDimens.xxl,
                ),
                const SizedBox(height: AppDimens.md),
                Text('auth_login_title'.tr, style: AppTypography.h1),
                const SizedBox(height: AppDimens.xl),
                AppTextField(
                  controller: controller.phoneController,
                  hintText: 'auth_phone_hint'.tr,
                  keyboardType: TextInputType.phone,
                  validator: controller.validatePhone,
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimens.lg),
                Obx(
                  () => AppButton(
                    label: 'auth_send_otp'.tr,
                    isLoading: controller.isRequestingOtp.value,
                    onPressed: controller.requestOtp,
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
