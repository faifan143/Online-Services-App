import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio/controller/onBoardingController.dart';
import 'package:socio/core/constants/appTheme.dart';
import 'package:socio/core/localization/changeLocale.dart';
import 'package:socio/data/data_src/static/static.dart';

// A widget class that represents the onboarding slider view.
// It displays a PageView widget that allows the user to swipe through different onboarding screens.
class SliderOB extends GetView<OnBoardingCtrl> {
  const SliderOB({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
// Get the LocaleController instance using GetBuilder and build the widget tree.
    return GetBuilder<LocaleController>(builder: (controller2) {
// Use a PageView widget to display the onboarding screens.
      return PageView.builder(
// Listen for page changes and call the controller's onPageChanged method.
        onPageChanged: (value) => controller.onPageChanged(value),
        controller: controller.pageController, // Set the PageView controller.
        itemCount: onBoardingList
            .length, // Set the total number of onboarding screens.
        itemBuilder: (context, index) => Column(
          children: [
// Display the onboarding screen's title.
            Text(
              onBoardingList[index].title!,
              style: controller2.myServices.sharedPref.getString("lang") == "ar"
                  ? arabicTheme.textTheme.headline1
                  : englishTheme.textTheme.headline1,
            ),
            const SizedBox(height: 30),
// Display the onboarding screen's image.
            Image.asset(
              onBoardingList[index].imgPath!,
              height: 280,
              width: 280,
            ),
            const SizedBox(height: 50),
// Display the onboarding screen's description.
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                onBoardingList[index].description!,
                textAlign: TextAlign.center,
                style:
                    controller2.myServices.sharedPref.getString("lang") == "ar"
                        ? arabicTheme.textTheme.bodyText2
                        : englishTheme.textTheme.bodyText2,
              ),
            ),
          ],
        ),
      );
    });
  }
}
