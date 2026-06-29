import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';

class OtpScreen extends GetView<AuthController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('auth_otp_title'.tr)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
          child: Form(
            key: controller.otpFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    'auth_otp_subtitle'
                        .trParams({'phone': controller.phoneNumber.value}),
                    style: AppTypography.bodyMedium,
                  ),
                ),
                const SizedBox(height: AppDimens.lg),
                AppTextField(
                  controller: controller.otpController,
                  hintText: '•••••',
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 5,
                  validator: controller.validateOtp,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: AppDimens.lg),
                Obx(
                  () => AppButton(
                    label: 'auth_verify'.tr,
                    isLoading: controller.isVerifyingOtp.value,
                    onPressed: controller.verifyOtp,
                  ),
                ),
                const SizedBox(height: AppDimens.md),
                Center(
                  child: Obx(
                    () => TextButton(
                      onPressed: controller.isRequestingOtp.value
                          ? null
                          : controller.resendOtp,
                      child: Text(
                        'auth_resend_code'.tr,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primary,
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
