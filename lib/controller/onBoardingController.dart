import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:socio/core/constants/AppRoutes.dart';
import 'package:socio/core/services/sharedPreferences.dart';
import 'package:socio/data/data_src/static/static.dart';

abstract class OnBoardingController extends GetxController {
  next();
  onPageChanged(int index);
  skip();
}

class OnBoardingCtrl extends OnBoardingController {
  // Keep track of the current page
  int currentPage = 0;

  // Create a PageController to control the onboarding page view
  late PageController pageController;

  // Get an instance of MyServices to interact with shared preferences
  MyServices myServices = Get.find();

  // Initialize the PageController
  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }

  // Called when the user wants to skip the onboarding process
  @override
  skip() {
    // Set the current page to the last onboarding page
    currentPage = onBoardingList.length - 1;

    // Animate to the last page
    pageController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );

    // Mark the user as onboarded
    myServices.sharedPref.setString("onBoarded", "1");

    // Update the state of the controller
    update();
  }

  // Called when the user wants to go to the next onboarding page
  @override
  next() {
    // Increment the current page index
    currentPage++;

    // If the current page is the last page, go to the login screen
    if (currentPage > onBoardingList.length - 1) {
      myServices.sharedPref.setString("onBoarded", "1");
      Get.offAllNamed(AppRoutes.login);
    } else {
      // Otherwise, animate to the next page
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  // Called when the user swipes to a different page
  @override
  onPageChanged(int index) {
    // Update the current page index
    currentPage = index;

    // Update the state of the controller
    update();
  }
}
