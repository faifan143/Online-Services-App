import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio/core/constants/AppColors.dart';
import 'package:socio/core/constants/AppRoutes.dart';
import 'package:socio/core/constants/appTheme.dart';
import 'package:socio/core/localization/changeLocale.dart';

class LangButton extends StatelessWidget {
  const LangButton({
    Key? key,
    required this.controller,
    required this.lang,
  }) : super(key: key);

  final LocaleController controller;
  final String lang;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: MaterialButton(
        onPressed: () {
          if (lang == "arabic")
            controller.changeLocale("ar");
          else if (lang == "english") controller.changeLocale("en");
          Get.toNamed(AppRoutes.onBoarding);
        },
        child: Text(
          lang.tr,
          style: controller.myServices.sharedPref.getString("lang") == "ar"
              ? arabicTheme.textTheme.bodyText1!.copyWith(color: Colors.white)
              : englishTheme.textTheme.bodyText1!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
