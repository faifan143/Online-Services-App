import 'package:age_calculator/age_calculator.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/constants/AppColors.dart';
import 'package:socio/core/constants/appTheme.dart';
import 'package:socio/core/functions/signupSuccessful.dart';
import 'package:socio/model/feedback_model.dart';
import 'package:socio/model/service_user.dart';
import 'package:socio/view/screens/screens/in_chat_screen.dart';
import 'package:socio/view/widgets/custom_FeedBack.dart';
import 'package:tap_to_expand/tap_to_expand.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    Key? key,
    required this.serUser,
    required this.feedbackerImg,
    required this.submitFeedback,
  }) : super(key: key);

  final ServicerUser serUser;
  final String feedbackerImg;
  final VoidCallback submitFeedback;
  @override
  Widget build(BuildContext context) {
    bool ratedU;
    bool ratedD;

    return SizedBox(
      height: 600,
      child: GetBuilder<MainScreenController>(
        builder: (controller) {
          DateTime birthday = DateTime.parse(serUser.age);
          DateDuration duration;
          // Find out your age as of today's date 2021-03-08
          duration = AgeCalculator.age(birthday);

          int raters = int.parse(serUser.raters);
          int disRaters = int.parse(serUser.disRaters);
          List<dynamic> ratersIds = serUser.ratersId;
          List<dynamic> disRatersId = serUser.disRatersId;
          ratedU = ratersIds.contains(controller.myUId);
          ratedD = disRatersId.contains(controller.myUId);
          return SingleChildScrollView(
            child: Column(
              children: [
                ProfilePaintedHeader(
                  serUser: serUser,
                  dateDuration: duration,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        child: Text("Rate".tr)),
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 5,
                          child: OutlinedButton(
                              onPressed: () {
                                if (ratedU == true && ratedD == false) {
                                  snackBar(
                                      context: context,
                                      contentType: ContentType.success,
                                      title: 'Ops'.tr,
                                      body:
                                          'you already rated this user ..'.tr);
                                } else if (ratedU == false && ratedD == true) {
                                  disRaters--;
                                  if (disRaters < 0) disRaters = 0;
                                  disRatersId.remove(controller.myUId);
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(serUser.uId)
                                      .update({
                                    'disRatersId': disRatersId,
                                    'disRaters': disRaters.toString()
                                  });
                                  controller.refresher();
                                  snackBar(
                                      context: context,
                                      contentType: ContentType.success,
                                      title: 'done'.tr,
                                      body: 'unrated successfully'.tr);
                                } else if (ratedU == false && ratedD == false) {
                                  raters = raters + 1;
                                  ratersIds.add(controller.myUId);
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(serUser.uId)
                                      .update({
                                    'ratersId': ratersIds,
                                    'raters': raters.toString()
                                  });
                                  controller.refresher();
                                  snackBar(
                                      context: context,
                                      contentType: ContentType.success,
                                      title: 'done'.tr,
                                      body: 'rated successfully'.tr);
                                }
                              },
                              child: Text(
                                ratedU == true ? "Upped".tr : "Up".tr,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 5,
                          child: OutlinedButton(
                              onPressed: () {
                                if (ratedU == true && ratedD == false) {
                                  raters--;
                                  if (raters < 0) raters = 0;
                                  ratersIds.remove(controller.myUId);
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(serUser.uId)
                                      .update({
                                    'ratersId': ratersIds,
                                    'raters': raters.toString(),
                                  });
                                  controller.refresher();
                                  snackBar(
                                      context: context,
                                      contentType: ContentType.success,
                                      title: 'done'.tr,
                                      body: 'unrated successfully'.tr);
                                } else if (ratedU == false && ratedD == true) {
                                  snackBar(
                                      context: context,
                                      contentType: ContentType.success,
                                      title: 'Ops'.tr,
                                      body:
                                          'you already disRated this user'.tr);
                                } else if (ratedU == false && ratedD == false) {
                                  disRaters++;
                                  disRatersId.add(controller.myUId);
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(serUser.uId)
                                      .update({
                                    'disRatersId': disRatersId,
                                    'disRaters': disRaters.toString(),
                                  });
                                  controller.refresher();
                                  snackBar(
                                      context: context,
                                      contentType: ContentType.success,
                                      title: 'done'.tr,
                                      body: 'disRated successfully'.tr);
                                }
                              },
                              child: Text(
                                ratedD == true ? "Downed".tr : "Down".tr,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 2,
                          child: OutlinedButton(
                              onPressed: () {
                                Get.to(InChatScreen(
                                  model: serUser,
                                  receiverId: serUser.uId,
                                ));
                              },
                              child: const Icon(
                                IconlyBroken.send,
                                color: Colors.greenAccent,
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 7,
                        ),
                        Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              "CV".tr,
                              style: englishTheme.textTheme.bodyText1!.copyWith(
                                  fontWeight: FontWeight.w300, fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Center(
                          child: TapToExpand(
                            content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: controller.stringsToTexts(
                                    controller.getTranslatedCategories(
                                        serUser.categories))),
                            title: Text(
                              'Fields Of Expertise'.tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTapPadding: 10,
                            closedHeight: 100,
                            scrollable: true,
                            borderRadius: 10,
                            openedHeight: 200,
                          ),
                        ),
                        Center(
                          child: TapToExpand(
                            content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: controller.stringsToTexts(
                                    serUser.programmingLanguagesList)),
                            title: Flexible(
                              child: Text(
                                'Skillful With This Programming Languages'.tr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onTapPadding: 10,
                            closedHeight: 100,
                            scrollable: true,
                            borderRadius: 10,
                            openedHeight: 200,
                          ),
                        ),
                        Center(
                          child: TapToExpand(
                            content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: controller
                                    .stringsToTexts(serUser.experiencedTools)),
                            title: Flexible(
                              child: Text(
                                'Skillful With This Programs'.tr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onTapPadding: 10,
                            closedHeight: 100,
                            scrollable: true,
                            borderRadius: 10,
                            openedHeight: 200,
                          ),
                        ),
                        Center(
                          child: TapToExpand(
                            content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: controller
                                    .stringsToTexts(serUser.anotherExpertise)),
                            title: Text(
                              'Another Expertise'.tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTapPadding: 10,
                            closedHeight: 100,
                            scrollable: true,
                            borderRadius: 10,
                            openedHeight: 200,
                          ),
                        ),
                        Center(
                          child: TapToExpand(
                            content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: controller
                                    .stringsToTexts(serUser.formerExperiences)),
                            title: Text(
                              'Former Experiences'.tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTapPadding: 10,
                            closedHeight: 100,
                            scrollable: true,
                            borderRadius: 10,
                            openedHeight: 200,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 7,
                        ),
                        Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              "Feedbacks".tr,
                              style: englishTheme.textTheme.bodyText1!.copyWith(
                                  fontWeight: FontWeight.w300, fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.gradientLightColor,
                            AppColors.gradientDarkColor,
                          ],
                        ),
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(serUser.uId)
                            .collection('feedbacks')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong'.tr);
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return ListView(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  FeedbackModel fbm =
                                      FeedbackModel.fromJson(data);
                                  return CustomFeedBack(
                                    img: fbm.feedBackerImg,
                                    name: fbm.feedBackerName,
                                    feedback: fbm.feedBackerMsg,
                                    email: fbm.feedBackerEmail,
                                  );
                                })
                                .toList()
                                .cast(),
                          );
                        },
                      ),
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8),
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
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfilePaintedHeader extends GetView<MainScreenController> {
  const ProfilePaintedHeader({
    Key? key,
    required this.serUser,
    required this.dateDuration,
  }) : super(key: key);

  final ServicerUser serUser;
  final DateDuration dateDuration;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
        height: 350,
        width: double.infinity,
        child: CustomPaint(
          painter: LogoPainter(),
          size: const Size(400, 195),
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            child: SingleChildScrollView(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundImage: NetworkImage(serUser.image),
                  ),
                  Spacer(),
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
                                "${serUser.ratersId.length} / ${serUser.disRatersId.length}",
                                style: englishTheme.textTheme.bodyText1!
                                    .copyWith(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15),
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
                              const Icon(
                                IconlyBroken.bookmark,
                                size: 18,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                controller.getTranslatedLevel(
                                    serUser.experienceLevel),
                                style: englishTheme.textTheme.bodyText1!
                                    .copyWith(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15),
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
                              const Icon(
                                IconlyBroken.tick_square,
                                size: 18,
                                color: Colors.greenAccent,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${serUser.serviced} ${"serviced".tr}",
                                style: englishTheme.textTheme.bodyText1!
                                    .copyWith(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: 20),
              Row(
                children: [
                  Text(
                    serUser.username,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
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
                "     ${"Age".tr} : ${dateDuration.years}",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white),
              ),
              Text(
                "     ${"gender".tr} : ${controller.getTranslatedGender(serUser.gender)}",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 10),
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    serUser.phone,
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                "     ${"Address".tr} : ${controller.getTranslatedAddress(serUser.address).capitalize}",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 10),
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    serUser.email,
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ]);
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    Paint paint = Paint();
    Path path = Path();
    paint.shader = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        AppColors.gradientDarkColor,
        AppColors.gradientLightColor,
      ],
    ).createShader(rect);
    path.lineTo(0, size.height - size.height / 8);
    path.conicTo(size.width / 1.2, size.height, size.width,
        size.height - size.height / 8, 9);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawShadow(path, Colors.grey, 35, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
