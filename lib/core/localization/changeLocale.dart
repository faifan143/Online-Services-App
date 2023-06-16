import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio/core/constants/appTheme.dart';
import 'package:socio/core/services/sharedPreferences.dart';

class LocaleController extends GetxController {
  Locale? language; // holds the currently selected language
  MyServices myServices = Get
      .find(); // an instance of a service class to retrieve shared preferences

  ThemeData appTheme = englishTheme; // default theme is English

  // changes the language of the app and updates the theme accordingly
  void changeLocale(String langCode) {
    Locale locale = Locale(langCode);
    myServices.sharedPref.setString(
        "lang", langCode); // stores the selected language in shared preferences
    appTheme = langCode == "ar"
        ? arabicTheme
        : englishTheme; // sets the theme based on the selected language
    Get.changeTheme(appTheme); // updates the theme of the app
    Get.updateLocale(locale); // updates the locale of the app
  }

  @override
  void onInit() {
    if (myServices.sharedPref.getString("lang") == "ar") {
      language = Locale("ar");
      appTheme = arabicTheme;
    } else if (myServices.sharedPref.getString("lang") == "en") {
      language = Locale("en");
      appTheme = englishTheme;
    } else {
      language = Locale(Get.deviceLocale!.languageCode);
      appTheme = englishTheme;
    }
    super.onInit();
  }
}
