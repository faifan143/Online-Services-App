import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/constants/appTheme.dart';

import '../../core/constants/AppColors.dart';

class NotificationRequest extends GetView<MainScreenController> {
  NotificationRequest({
    Key? key,
    required this.notifierEmail,
    required this.notifierName,
    required this.img,
    required this.name,
    required this.location,
    required this.date,
    required this.description,
    required this.onDoneTap,
    required this.onViewTap,
    required this.onRemoveTap,
  }) : super(key: key);
  final String notifierName;
  final String notifierEmail;
  final String img;
  final String name;
  final String location;
  final String date;
  final String description;
  final VoidCallback onDoneTap;
  final VoidCallback onViewTap;
  final VoidCallback onRemoveTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${"from :".tr} $notifierEmail ${",".tr} ",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 16)),
            SizedBox(height: 5),
            Text(" ${"-->".tr} $notifierName ${"requested your approve :".tr}",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 16)),
            SizedBox(height: 15),
            InkWell(
              onTap: onViewTap,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(img),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.lightBlue,
                              size: 16,
                            )
                          ],
                        ),
                        Text(
                          controller.getTranslatedAddress(location),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          date,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Icon(
                    IconlyBroken.tick_square,
                    size: 20,
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: onDoneTap,
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    boxShadow: [
                      const BoxShadow(
                          offset: Offset(0, 3),
                          blurRadius: 5,
                          color: Colors.grey)
                    ],
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(colors: [
                      AppColors.gradientLightColor,
                      AppColors.gradientDarkColor,
                    ])),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      IconlyBroken.tick_square,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Approve".tr,
                      style: englishTheme.textTheme.bodyText1!
                          .copyWith(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            MaterialButton(
              onPressed: onRemoveTap,
              color: Colors.redAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    IconlyBroken.delete,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Remove".tr,
                    style: englishTheme.textTheme.bodyText1!
                        .copyWith(color: Colors.white, fontSize: 15),
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
