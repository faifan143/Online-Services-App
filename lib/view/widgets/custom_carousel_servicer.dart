import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/constants/AppColors.dart';
import 'package:socio/core/constants/appTheme.dart';

class CustomCarouselServicer extends GetView<MainScreenController> {
  CustomCarouselServicer({
    Key? key,
    required this.onViewTap,
    required this.submitFeedback,
    required this.img,
    required this.name,
    required this.location,
    required this.age,
    required this.rate,
    required this.feedbackerImg,
    required this.level,
    required this.addToFav,
    required this.category,
    required this.ratersId,
    required this.disRatersId,
  }) : super(key: key);
  final String img;
  final String name;
  final String location;
  final String age;
  final String category;
  final String rate;
  final String level;
  final String feedbackerImg;
  final VoidCallback addToFav;
  final VoidCallback submitFeedback;
  final VoidCallback onViewTap;
  final List<dynamic> ratersId;
  final List<dynamic> disRatersId;
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
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
                        age,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        location,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              IconlyBroken.arrow_up,
                              size: 18,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${ratersId.length} / ${disRatersId.length}",
                              style: englishTheme.textTheme.bodyText1!.copyWith(
                                  fontWeight: FontWeight.w300, fontSize: 15),
                            ),
                            const Icon(
                              IconlyBroken.arrow_down,
                              size: 18,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              IconlyBroken.bookmark,
                              size: 18,
                              color: Colors.red,
                            ),
                            SizedBox(width: 5),
                            Text(
                              level,
                              style: englishTheme.textTheme.bodyText1!.copyWith(
                                  fontWeight: FontWeight.w300, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "#${category}",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            InkWell(
              onTap: onViewTap,
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
                    Icon(
                      IconlyBroken.profile,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "View".tr,
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
