import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaky_animated_listview/scroll_animator.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/constants/appTheme.dart';
import 'package:socio/view/screens/screens/in_category_screen.dart';

class CategoriesScreen extends GetView<MainScreenController> {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      AnimatedGridView(
          shrinkWrap: true,
          duration: 100,
          crossAxisCount: 2,
          mainAxisExtent: 256,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            InkWell(
              onTap: () {
                Get.to(CategoryScreen(category: "Software and Data Analysis"));
              },
              child: Card(
                elevation: 20,
                shadowColor: Colors.greenAccent,
                color: Colors.greenAccent,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Software and Data Analysis".tr,
                          textAlign: TextAlign.center,
                          style: englishTheme.textTheme.headline1!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(CategoryScreen(category: "Freelance"));
              },
              child: Card(
                elevation: 20,
                shadowColor: Colors.blueAccent,
                color: Colors.blueAccent,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Freelance".tr,
                          textAlign: TextAlign.center,
                          style: englishTheme.textTheme.headline1!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(CategoryScreen(category: "Graphic"));
              },
              child: Card(
                elevation: 20,
                shadowColor: Colors.pinkAccent,
                color: Colors.pinkAccent,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Graphic".tr,
                          textAlign: TextAlign.center,
                          style: englishTheme.textTheme.headline1!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(CategoryScreen(category: "Engineer"));
              },
              child: Card(
                elevation: 20,
                shadowColor: Colors.amberAccent,
                color: Colors.amberAccent,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Engineer".tr,
                          textAlign: TextAlign.center,
                          style: englishTheme.textTheme.headline1!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(CategoryScreen(category: "Technician"));
              },
              child: Card(
                elevation: 20,
                shadowColor: Colors.indigo,
                color: Colors.indigo,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Technician".tr,
                          textAlign: TextAlign.center,
                          style: englishTheme.textTheme.headline1!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(CategoryScreen(category: "Doctors & Nurses"));
              },
              child: Card(
                elevation: 20,
                shadowColor: Colors.teal,
                color: Colors.teal,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Doctors & Nurses".tr,
                          textAlign: TextAlign.center,
                          style: englishTheme.textTheme.headline1!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(CategoryScreen(category: "Plumber"));
              },
              child: Card(
                elevation: 20,
                shadowColor: Colors.redAccent,
                color: Colors.redAccent,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Plumber".tr,
                          textAlign: TextAlign.center,
                          style: englishTheme.textTheme.headline1!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(CategoryScreen(category: "Electrician"));
              },
              child: Card(
                elevation: 20,
                shadowColor: Colors.blueGrey,
                color: Colors.blueGrey,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Electrician".tr,
                          textAlign: TextAlign.center,
                          style: englishTheme.textTheme.headline1!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
      SizedBox(
        height: 100,
      )
    ]);
  }
}
