import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio/core/constants/AppImgAsset.dart';
import 'package:socio/core/constants/appTheme.dart';
import 'package:socio/core/localization/changeLocale.dart';

import '../widgets/Language/langButton.dart';

class Language extends GetView<LocaleController> {
  const Language({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImgAsset.langImg,
              width: 300,
              height: 300,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 10),
            Text(
              "chooseLang".tr,
              style: controller.myServices.sharedPref.getString("lang") == "ar"
                  ? arabicTheme.textTheme.headline1
                  : englishTheme.textTheme.headline1,
            ),
            SizedBox(height: 10),
            LangButton(controller: controller, lang: "arabic"),
            SizedBox(height: 10),
            LangButton(controller: controller, lang: "english"),
          ],
        ),
      ),
    );
  }
}
