import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/constants/AppColors.dart';
import 'package:socio/core/constants/AppRoutes.dart';
import 'package:socio/core/constants/appTheme.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return GetBuilder<MainScreenController>(builder: (controller) {
      FirebaseFirestore.instance
          .collection('requests')
          .where('requesterID', isEqualTo: controller.myUId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          FirebaseFirestore.instance
              .collection('requests')
              .doc(doc.id)
              .snapshots()
              .listen((event) {
            List<dynamic> notifiers = event.data()!['notifiersId'];
            if (notifiers.isNotEmpty) {
              controller.hasNotification = true;
            } else {
              controller.hasNotification = false;
            }
          });
        });
      });

      return RefreshIndicator(
        onRefresh: () =>
            Future.delayed(Duration(seconds: 1), () => controller.refresh()),
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: Align(
              alignment: Alignment.center,
              child: Text("Servicy".tr,
                  textAlign: TextAlign.center,
                  style: englishTheme.textTheme.headline1!.copyWith(
                      fontWeight: FontWeight.w300,
                      color: AppColors.gradientDarkColor)),
            ),
            leadingWidth: 76,
            elevation: 2,
            actions: [
              Stack(alignment: Alignment.center, children: [
                IconButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.notification);
                  },
                  icon: const Icon(IconlyBroken.notification),
                  color: AppColors.gradientDarkColor,
                ),
                if (controller.hasNotification == true)
                  Positioned(
                    right: 13,
                    top: 12,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
              ]),
              IconButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.searchScreen);
                },
                icon: const Icon(IconlyBroken.search),
                color: AppColors.gradientDarkColor,
              ),
            ],
          ),
          body: SafeArea(
            child: controller.screens[controller.currentPage],
          ),
          floatingActionButton: DotNavigationBar(
            currentIndex: controller.currentPage,
            backgroundColor: Colors.white,
            onTap: (p0) {
              if (p0 == 2) {
                Get.toNamed(AppRoutes.newRequestScreen);
              } else {
                controller.changePage(p0);
              }
            },
            enableFloatingNavBar: true,
            items: [
              DotNavigationBarItem(
                icon: Icon(IconlyBroken.home),
                selectedColor: Color(0xff009FFD),
              ),
              DotNavigationBarItem(
                icon: Icon(IconlyBroken.category),
                selectedColor: Colors.pink,
              ),
              DotNavigationBarItem(
                icon: Icon(IconlyBroken.plus),
                selectedColor: Colors.green,
              ),
              DotNavigationBarItem(
                icon: Icon(IconlyBroken.chat),
                selectedColor: Colors.deepPurple,
              ),
              DotNavigationBarItem(
                icon: Icon(IconlyBroken.profile),
                selectedColor: Colors.orangeAccent,
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      );
    });
  }
}
