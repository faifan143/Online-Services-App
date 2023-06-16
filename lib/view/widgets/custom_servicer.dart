import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/constants/AppColors.dart';
import 'package:socio/core/constants/appTheme.dart';

class CustomServicer extends GetView<MainScreenController> {
  CustomServicer({
    Key? key,
    required this.onViewTap,
    required this.contact,
    required this.submitFeedback,
    required this.img,
    required this.name,
    required this.location,
    required this.age,
    required this.rate,
    required this.feedbackerImg,
    required this.level,
    required this.ratersId,
    required this.disRatersId,
    required this.addToFav,
  }) : super(key: key);
  final String img;
  final String name;
  final String location;
  final String age;

  final String rate;
  final String level;
  final String feedbackerImg;
  final VoidCallback addToFav;
  final VoidCallback submitFeedback;
  final VoidCallback onViewTap;
  final VoidCallback contact;
  final List<dynamic> ratersId;
  final List<dynamic> disRatersId;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 5,
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
                        controller.getTranslatedAddress(location),
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
                              controller.getTranslatedLevel(level),
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
                  width: 5,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            MaterialButton(
              onPressed: onViewTap,
              child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    onPressed: addToFav,
                    color: Colors.blueAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconlyBroken.heart,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Add to favorite".tr,
                          style: englishTheme.textTheme.bodyText1!
                              .copyWith(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(feedbackerImg),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: controller.feedbackCtrl,
                            decoration: InputDecoration(
                              hintText: 'Write your feedback ..'.tr,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: controller.feedbackCtrl.text.isNotEmpty
                              ? submitFeedback
                              : null,
                          child: Card(
                            color: Colors.greenAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(
                                IconlyBroken.send,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
