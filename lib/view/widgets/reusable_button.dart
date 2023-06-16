import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio/core/constants/appTheme.dart';
import 'package:socio/core/localization/changeLocale.dart';

class ReUsableButton extends StatelessWidget {
  ReUsableButton({
    Key? key,
    this.onPressed,
    this.text,
    this.colour,
    this.radius,
    this.height,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final String? text;
  final Color? colour;
  double? height = 20;
  double? radius = 20;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: 4,
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius!), color: colour),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: height!),
        child: GetBuilder<LocaleController>(builder: (controller2) {
          return Text(
            text!,
            textAlign: TextAlign.center,
            style: controller2.myServices.sharedPref.getString("lang") == "ar"
                ? arabicTheme.textTheme.bodyText1!.copyWith(color: Colors.white)
                : englishTheme.textTheme.bodyText1!
                    .copyWith(color: Colors.white),
          );
        }),
      ),
    );
  }
}
