import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/constants/AppColors.dart';
import 'package:socio/core/constants/appTheme.dart';

class CustomRequest extends GetView<MainScreenController> {
  CustomRequest({
    Key? key,
    required this.onApproveTap,
    required this.img,
    required this.name,
    required this.location,
    required this.date,
    required this.description,
    required this.tags,
    required this.isDone,
    required this.addToQueue,
    required this.contact,
    required this.owner,
    required this.onOptionSelected,
    required this.onDoneTap,
    required this.onViewTap,
  }) : super(key: key);
  final String img;
  final String name;
  final String location;
  final String date;
  final String description;
  final String tags;
  final VoidCallback addToQueue;
  final VoidCallback onDoneTap;
  final VoidCallback onViewTap;
  final VoidCallback onApproveTap;
  final VoidCallback contact;
  final void Function(String?) onOptionSelected;
  bool isDone;
  final bool owner;

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
                          location,
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
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      IconlyBroken.tick_square,
                      size: 20,
                      color: isDone == true
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                  ),
                  if (owner)
                    CustomDropdownButton2(
                      buttonWidth: 22,
                      buttonHeight: 22,
                      buttonPadding: EdgeInsets.zero,
                      iconSize: 22,
                      buttonDecoration: const BoxDecoration(
                          border: Border.fromBorderSide(BorderSide.none)),
                      icon: const Icon(IconlyBroken.more_square),
                      dropdownItems: items,
                      value: controller.selectedValue,
                      onChanged: onOptionSelected,
                      hint: '',
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
            Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  tags,
                  style: const TextStyle(color: Colors.blue),
                )),
            const SizedBox(
              height: 10,
            ),
            if (controller.amIAServicer && !owner)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: MaterialButton(
                      onPressed: addToQueue,
                      color: Colors.blueAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            IconlyBroken.upload,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Add to queue".tr,
                            style: englishTheme.textTheme.bodyText1!
                                .copyWith(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: MaterialButton(
                      onPressed: contact,
                      color: Colors.greenAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            IconlyBroken.send,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Contact".tr,
                            style: englishTheme.textTheme.bodyText1!
                                .copyWith(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (owner == false)
              InkWell(
                onTap: onApproveTap,
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
                        "Serviced".tr,
                        style: englishTheme.textTheme.bodyText1!
                            .copyWith(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            if (owner)
              InkWell(
                onTap: onDoneTap,
                child: Ink(
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
                        "Done".tr,
                        style: englishTheme.textTheme.bodyText1!
                            .copyWith(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final List<String> items = [
  'Edit'.tr,
  'Delete'.tr,
];
