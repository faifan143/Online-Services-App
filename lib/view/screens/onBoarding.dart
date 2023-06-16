import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio/controller/onBoardingController.dart';
import 'package:socio/view/widgets/OnBoarding/buttonOB.dart';
import 'package:socio/view/widgets/OnBoarding/indicatorOB.dart';
import 'package:socio/view/widgets/OnBoarding/skipButtonOB.dart';
import 'package:socio/view/widgets/OnBoarding/sliderOB.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OnBoardingCtrl controller = Get.put(OnBoardingCtrl());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          SkipButtonOB(controller: controller),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Expanded(
              flex: 3,
              child: SliderOB(),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const IndicatorOB(),
                  const Spacer(flex: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      ButtonOB(),
                      SizedBox(width: 0),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
