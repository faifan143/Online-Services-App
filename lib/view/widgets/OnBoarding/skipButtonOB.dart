import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio/controller/onBoardingController.dart';
import 'package:socio/core/constants/AppColors.dart';
import 'package:socio/core/constants/appTheme.dart';
import 'package:socio/core/localization/changeLocale.dart';

// This widget displays a button for skipping the onboarding screens.
class SkipButtonOB extends StatelessWidget {
  const SkipButtonOB({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final OnBoardingCtrl controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          controller
              .skip(); // Call the skip method in the controller when the button is tapped.
        },
        child: GetBuilder<LocaleController>(builder: (controller2) {
          return Text(
            "skip".tr, // Get the localized "skip" string.
            style: controller2.myServices.sharedPref.getString("lang") == "ar"
                ? arabicTheme.textTheme.bodyText1!.copyWith(
                    color: AppColors.primaryColor, fontWeight: FontWeight.w400)
                : englishTheme.textTheme.bodyText1!.copyWith(
                    color: AppColors.primaryColor, fontWeight: FontWeight.w400),
            // Use the appropriate text style based on the language setting.
          );
        }),
      ),
    );
  }
}
