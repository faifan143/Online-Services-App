import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio/controller/onBoardingController.dart';
import 'package:socio/core/constants/AppColors.dart';
import 'package:socio/data/data_src/static/static.dart';

class IndicatorOB extends StatelessWidget {
  const IndicatorOB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingCtrl>(
      // A state management widget that rebuilds this widget whenever its controller changes
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              onBoardingList
                  .length, // The number of indicators should match the number of onboarding pages
              (index) => AnimatedContainer(
                margin: const EdgeInsets.only(right: 3),
                duration: const Duration(milliseconds: 600),
                width: controller.currentPage == index
                    ? 20
                    : 6, // The current page has a wider indicator
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
