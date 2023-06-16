import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/constants/appTheme.dart';

class CategoryCustomServicer extends GetView<MainScreenController> {
  // Properties
  final String img;
  final String name;
  final String location;
  final String age;
  final String rate;
  final String level;
  final List<dynamic> ratersId;
  final List<dynamic> disRatersId;
  final VoidCallback addToFav;
  final VoidCallback onViewTap;
  final VoidCallback contact;

  // Constructor
  CategoryCustomServicer({
    Key? key,
    required this.img,
    required this.name,
    required this.location,
    required this.age,
    required this.rate,
    required this.level,
    required this.ratersId,
    required this.disRatersId,
    required this.addToFav,
    required this.onViewTap,
    required this.contact,
  }) : super(key: key);

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
              color: Colors.blueGrey,
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
          ],
        ),
      ),
    );
  }
}
