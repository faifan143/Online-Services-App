import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:socio/core/constants/AppRoutes.dart';
import 'package:socio/core/services/sharedPreferences.dart';

// Middleware for onBoarding redirection
class MyOnBoardingMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;
  MyServices myServices = Get.find();

  // Redirect user to login screen if already onboarded
  @override
  RouteSettings? redirect(String? route) {
    if (myServices.sharedPref.getString("onBoarded") == "1") {
      return const RouteSettings(name: AppRoutes.login);
    }
  }
}

// Middleware for login redirection
class MyLoginMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;
  MyServices myServices = Get.find();

  // Redirect user to main screen if already logged in
  @override
  RouteSettings? redirect(String? route) {
    if (myServices.sharedPref.getString("logged") == "1") {
      return const RouteSettings(name: AppRoutes.mainScreen);
    }
  }
}
