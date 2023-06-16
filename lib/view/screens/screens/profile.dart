import 'package:age_calculator/age_calculator.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:restart_app/restart_app.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/constants/AppColors.dart';
import 'package:socio/core/constants/AppRoutes.dart';
import 'package:socio/core/constants/appTheme.dart';
import 'package:socio/core/functions/signupSuccessful.dart';
import 'package:socio/core/localization/changeLocale.dart';
import 'package:socio/core/services/sharedPreferences.dart';
import 'package:socio/model/feedback_model.dart';
import 'package:socio/model/notificationReq_model.dart';
import 'package:socio/model/request_model.dart';
import 'package:socio/model/service_user.dart';
import 'package:socio/view/screens/edit_request.dart';
import 'package:socio/view/screens/screens/in_chat_screen.dart';
import 'package:socio/view/widgets/custom_FeedBack.dart';
import 'package:socio/view/widgets/custom_request.dart';
import 'package:socio/view/widgets/favCustomServicer.dart';
import 'package:socio/view/widgets/profile_viewer.dart';
import 'package:socio/view/widgets/queueCustom_request.dart';
import 'package:tap_to_expand/tap_to_expand.dart';

import '../carousel_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return GetBuilder<MainScreenController>(builder: (controller) {
      DateTime birthday = DateTime.parse(controller.myAge);
      DateDuration duration;
      // Find out your age as of today's date 2021-03-08
      duration = AgeCalculator.age(birthday);

      return SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 15),
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(65),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(4, 4),
                                    blurRadius: 5,
                                    color: AppColors.gradientDarkColor,
                                  )
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 65,
                                backgroundImage:
                                    NetworkImage(controller.myImage),
                              ),
                            ),
                            Spacer(),
                            if (controller.amIAServicer)
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
                                            "${controller.myRatersId.length} / ${controller.myDisRatersId.length}",
                                            style: englishTheme
                                                .textTheme.bodyText1!
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
                                            controller.myExperienceLevel,
                                            style: englishTheme
                                                .textTheme.bodyText1!
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
                                            "${controller.myServiced} ${"serviced".tr}",
                                            style: englishTheme
                                                .textTheme.bodyText1!
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
                              controller.myUsername,
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
                          "     ${"Age".tr} : ${duration.years}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          "     ${"gender".tr} : ${controller.myGender}",
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
                              controller.myPhone,
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
                          "     ${"Address".tr} : ${controller.myAddress}",
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
                              controller.myEmail,
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
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    OutlinedButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.editProfileScreen);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Edit Profile".tr,
                              style: TextStyle(
                                color: AppColors.gradientDarkColor,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              IconlyBroken.edit,
                              size: 15,
                              color: AppColors.gradientDarkColor,
                            ),
                          ],
                        )),
                    SizedBox(height: 5),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            height: 900,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('requests')
                                  .where('requesterID',
                                      isEqualTo: controller.myUId)
                                  // .orderBy('dateTime', descending: true)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Something went wrong".tr);
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return snapshot.data!.docs.isEmpty
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(child: Text("No Requests".tr))
                                        ],
                                      )
                                    : Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        child: ListView(
                                          children: snapshot.data!.docs
                                              .map(
                                                (DocumentSnapshot document) {
                                                  Map<String, dynamic> data =
                                                      document.data()! as Map<
                                                          String, dynamic>;
                                                  RequestModel req =
                                                      RequestModel.fromJson(
                                                          data);

                                                  return CustomRequest(
                                                    name: req.username,
                                                    date: req.shownTime,
                                                    description: req.text,
                                                    img: req.image,
                                                    location: controller
                                                        .getTranslatedAddress(
                                                            req.location),
                                                    isDone: req.isDone,
                                                    tags: controller.mergeTags(
                                                        controller
                                                            .getTranslatedCategories(
                                                                req.tags)),
                                                    owner: controller.myUId ==
                                                            req.requesterID
                                                        ? true
                                                        : false,
                                                    onDoneTap: () {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'requests')
                                                          .where('requesterID',
                                                              isEqualTo:
                                                                  controller
                                                                      .myUId)
                                                          .where('ntpDateTime',
                                                              isEqualTo: req
                                                                  .ntpDateTime)
                                                          .get()
                                                          .then(
                                                              (querySnapshot) {
                                                        querySnapshot.docs
                                                            .forEach(
                                                                (doc) async {
                                                          bool isDone = await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'requests')
                                                              .doc(doc.id)
                                                              .get()
                                                              .then((value) =>
                                                                  value.data()![
                                                                      'isDone']);
                                                          isDone = !isDone;

                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'requests')
                                                              .doc(doc.id)
                                                              .update({
                                                            'isDone': isDone
                                                          });
                                                        });
                                                      });

                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(controller.myUId)
                                                          .collection(
                                                              'requests')
                                                          .where('requestId',
                                                              isEqualTo:
                                                                  req.requestId)
                                                          .get()
                                                          .then(
                                                              (querySnapshot) {
                                                        querySnapshot.docs
                                                            .forEach(
                                                                (doc) async {
                                                          bool isDone = await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(controller
                                                                  .myUId)
                                                              .collection(
                                                                  'requests')
                                                              .doc(doc.id)
                                                              .get()
                                                              .then((value) =>
                                                                  value.data()![
                                                                      'isDone']);
                                                          isDone = !isDone;

                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(controller
                                                                  .myUId)
                                                              .collection(
                                                                  'requests')
                                                              .doc(doc.id)
                                                              .update({
                                                            'isDone': isDone
                                                          });
                                                        });
                                                      });

                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(controller.myUId)
                                                          .collection('queue')
                                                          .where('requestId',
                                                              isEqualTo:
                                                                  req.requestId)
                                                          .get()
                                                          .then(
                                                              (querySnapshot) {
                                                        querySnapshot.docs
                                                            .forEach(
                                                                (doc) async {
                                                          bool isDone = await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(controller
                                                                  .myUId)
                                                              .collection(
                                                                  'queue')
                                                              .doc(doc.id)
                                                              .get()
                                                              .then((value) =>
                                                                  value.data()![
                                                                      'isDone']);
                                                          isDone = !isDone;

                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(controller
                                                                  .myUId)
                                                              .collection(
                                                                  'queue')
                                                              .doc(doc.id)
                                                              .update({
                                                            'isDone': isDone
                                                          });
                                                        });
                                                      });
                                                    },
                                                    addToQueue: () {
                                                      if (!controller
                                                          .myServicer) {
                                                        snackBar(
                                                            context: context,
                                                            contentType:
                                                                ContentType
                                                                    .failure,
                                                            title: "Oops !".tr,
                                                            body:
                                                                "You're a normal user , not a servicer .."
                                                                    .tr);
                                                      } else if (controller
                                                              .myUId ==
                                                          req.requesterID) {
                                                        snackBar(
                                                            context: context,
                                                            contentType:
                                                                ContentType
                                                                    .failure,
                                                            title: "Oops !".tr,
                                                            body:
                                                                "you posted this request you can't add it to your queue"
                                                                    .tr);
                                                      } else {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(controller
                                                                .myUId)
                                                            .collection('queue')
                                                            .add(req.toMap());
                                                        snackBar(
                                                            context: context,
                                                            contentType:
                                                                ContentType
                                                                    .success,
                                                            title: "Done !".tr,
                                                            body:
                                                                "Request added to your queue .."
                                                                    .tr);
                                                      }
                                                    },
                                                    contact: () {},
                                                    onOptionSelected:
                                                        (String? value) async {
                                                      controller.selectedOption(
                                                          value!);
                                                      if (value ==
                                                          "Delete".tr) {
                                                        Alert(
                                                          context: context,
                                                          type: AlertType.error,
                                                          title: "Delete ..".tr,
                                                          desc:
                                                              "Do you want to delete your request ?"
                                                                  .tr,
                                                          buttons: [
                                                            DialogButton(
                                                              onPressed: () {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'users')
                                                                    .doc(controller
                                                                        .myUId)
                                                                    .collection(
                                                                        'requests')
                                                                    .doc(
                                                                        document
                                                                            .id)
                                                                    .delete();
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'requests')
                                                                    .where(
                                                                        'requestId',
                                                                        isEqualTo: req
                                                                            .requestId)
                                                                    .get()
                                                                    .then(
                                                                        (querySnapshot) {
                                                                  querySnapshot
                                                                      .docs
                                                                      .forEach(
                                                                          (doc) async {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'requests')
                                                                        .doc(doc
                                                                            .id)
                                                                        .delete();
                                                                  });
                                                                });

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              width: 120,
                                                              child: Text(
                                                                "Yes".tr,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            )
                                                          ],
                                                        ).show();
                                                      } else if (value ==
                                                          "Edit".tr) {
                                                        Get.to(EditRequest(
                                                            req: req));
                                                      }
                                                    },
                                                    onApproveTap: () {
                                                      bool isDone = req.isDone;
                                                      bool amNotified = false;
                                                      List<dynamic>
                                                          notifiersId =
                                                          req.notifiersId;
                                                      if (notifiersId.contains(
                                                          controller.myUId)) {
                                                        amNotified = true;
                                                      }
                                                      late ServicerUser serUser;
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .where('uId',
                                                              isEqualTo: req
                                                                  .requesterID)
                                                          .get()
                                                          .then(
                                                              (querySnapshot) {
                                                        querySnapshot.docs
                                                            .forEach((doc) {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(doc.id)
                                                              .get()
                                                              .then((value) {
                                                            var userData =
                                                                value.data()!;
                                                            serUser = ServicerUser(
                                                                servicer: userData[
                                                                    'servicer'],
                                                                email: userData[
                                                                    'email'],
                                                                password: userData[
                                                                    'password'],
                                                                address: userData[
                                                                    'address'],
                                                                phone: userData[
                                                                    'phone'],
                                                                image: userData[
                                                                    'image'],
                                                                isVerified: userData[
                                                                    'isVerified'],
                                                                uId: userData[
                                                                    'uId'],
                                                                username: userData[
                                                                    'name'],
                                                                age: userData[
                                                                    'age'],
                                                                gender: userData[
                                                                    'gender'],
                                                                providence: userData[
                                                                    'providence'],
                                                                categories: userData[
                                                                    'categories'],
                                                                programmingLanguagesList:
                                                                    userData[
                                                                        'programmingLanguagesList'],
                                                                experiencedTools:
                                                                    userData[
                                                                        'experiencedTools'],
                                                                experienceLevel:
                                                                    userData[
                                                                        'experienceLevel'],
                                                                anotherExpertise:
                                                                    userData[
                                                                        'anotherExpertise'],
                                                                formerExperiences:
                                                                    userData['formerExperiences'],
                                                                rate: userData['rate'],
                                                                raters: userData['raters'],
                                                                disRaters: userData['disRaters'],
                                                                ratersId: userData['ratersId'],
                                                                disRatersId: userData['disRatersId'],
                                                                contacts: userData['contacts'],
                                                                serviced: userData['serviced']);
                                                          });
                                                        });
                                                      });

                                                      if (isDone == false &&
                                                          amNotified == false) {
                                                        DateTime now =
                                                            DateTime.now();
                                                        String formattedDate =
                                                            DateFormat(
                                                                    'yyyy-MM-dd – kk:mm')
                                                                .format(now);

                                                        NotificationReqModel
                                                            notifyReq =
                                                            NotificationReqModel(
                                                                username: req
                                                                    .username,
                                                                image:
                                                                    req.image,
                                                                text: req.text,
                                                                ntpDateTime: req
                                                                    .ntpDateTime,
                                                                location: req
                                                                    .location,
                                                                isApproved:
                                                                    req.isDone,
                                                                tags: req.tags,
                                                                approveRequesterID:
                                                                    controller
                                                                        .myUId,
                                                                requestId: req
                                                                    .requestId,
                                                                notifierName:
                                                                    controller
                                                                        .myUsername,
                                                                notifierEmail:
                                                                    controller
                                                                        .myEmail,
                                                                shownTime:
                                                                    formattedDate);
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(
                                                                req.requesterID)
                                                            .collection(
                                                                'notifications')
                                                            .add(notifyReq
                                                                .toMap())
                                                            .then(
                                                              (value) => snackBar(
                                                                  context:
                                                                      context,
                                                                  contentType:
                                                                      ContentType
                                                                          .failure,
                                                                  title:
                                                                      "Done !"
                                                                          .tr,
                                                                  body:
                                                                      "Approve Request Submitted .. "
                                                                          .tr),
                                                            );

                                                        notifiersId.add(
                                                            controller.myUId);

                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'requests')
                                                            .where('requestId',
                                                                isEqualTo: req
                                                                    .requestId)
                                                            .get()
                                                            .then(
                                                                (querySnapshot) {
                                                          querySnapshot.docs
                                                              .forEach((doc) {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'requests')
                                                                .doc(doc.id)
                                                                .update({
                                                              'notifiersId':
                                                                  notifiersId
                                                            });
                                                          });
                                                        });

                                                        snackBar(
                                                            context: context,
                                                            contentType:
                                                                ContentType
                                                                    .success,
                                                            title: "Done !".tr,
                                                            body:
                                                                "your approve request is submitted .."
                                                                    .tr);
                                                      } else if (isDone ==
                                                          true) {
                                                        snackBar(
                                                            context: context,
                                                            contentType:
                                                                ContentType
                                                                    .failure,
                                                            title: "Oops !".tr,
                                                            body:
                                                                "this request is serviced .."
                                                                    .tr);
                                                      } else if (amNotified ==
                                                          true) {
                                                        snackBar(
                                                            context: context,
                                                            contentType:
                                                                ContentType
                                                                    .failure,
                                                            title: "Oops !".tr,
                                                            body:
                                                                "this request is pending in the requester notifications .."
                                                                    .tr);
                                                      }
                                                    },
                                                    onViewTap: () {},
                                                  );
                                                },
                                              )
                                              .toList()
                                              .cast(),
                                        ),
                                      );
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                            boxShadow: [
                              const BoxShadow(
                                  offset: Offset(0, 3),
                                  blurRadius: 5,
                                  color: Colors.grey)
                            ],
                            gradient: LinearGradient(colors: [
                              AppColors.gradientLightColor,
                              AppColors.gradientDarkColor,
                            ])),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              IconlyBroken.profile,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "My Requests".tr,
                              style: englishTheme.textTheme.bodyText1!
                                  .copyWith(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: MaterialButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  height: 900,
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(controller.myUId)
                                        .collection('favorites')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError) {
                                        return Text("Something went wrong".tr);
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      return snapshot.data!.docs.isEmpty
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                    child: Text(
                                                        "No users in favorites"
                                                            .tr))
                                              ],
                                            )
                                          : Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 8),
                                              child: ListView(
                                                children: snapshot.data!.docs
                                                    .map(
                                                      (DocumentSnapshot
                                                          document) {
                                                        Map<String, dynamic>
                                                            data =
                                                            document.data()!
                                                                as Map<String,
                                                                    dynamic>;
                                                        ServicerUser serUser =
                                                            ServicerUser(
                                                          servicer:
                                                              data['servicer'],
                                                          email: data['email'],
                                                          password:
                                                              data['password'],
                                                          address:
                                                              data['address'],
                                                          phone: data['phone'],
                                                          image: data['image'],
                                                          isVerified: data[
                                                              'isVerified'],
                                                          uId: data['uId'],
                                                          username:
                                                              data['name'],
                                                          age: data['age'],
                                                          gender:
                                                              data['gender'],
                                                          providence: data[
                                                              'providence'],
                                                          categories: data[
                                                              'categories'],
                                                          programmingLanguagesList:
                                                              data[
                                                                  'programmingLanguagesList'],
                                                          experiencedTools: data[
                                                              'experiencedTools'],
                                                          experienceLevel: data[
                                                              'experienceLevel'],
                                                          anotherExpertise: data[
                                                              'anotherExpertise'],
                                                          formerExperiences: data[
                                                              'formerExperiences'],
                                                          rate: data['rate'],
                                                          raters:
                                                              data['raters'],
                                                          disRaters:
                                                              data['disRaters'],
                                                          ratersId:
                                                              data['ratersId'],
                                                          disRatersId: data[
                                                              'disRatersId'],
                                                          contacts:
                                                              data['contacts'],
                                                          serviced:
                                                              data['serviced'],
                                                        );

                                                        return FavCustomServicer(
                                                          img: serUser.image,
                                                          name:
                                                              serUser.username,
                                                          location:
                                                              serUser.address,
                                                          age: serUser.age,
                                                          rate: serUser.rate,
                                                          feedbackerImg:
                                                              controller
                                                                  .myImage,
                                                          level: serUser
                                                              .experienceLevel,
                                                          onViewTap: () {
                                                            showModalBottomSheet(
                                                              context: context,
                                                              isScrollControlled:
                                                                  true,
                                                              builder:
                                                                  (context) =>
                                                                      ProfileView(
                                                                serUser:
                                                                    serUser,
                                                                feedbackerImg:
                                                                    controller
                                                                        .myImage,
                                                                submitFeedback:
                                                                    () {
                                                                  if (controller
                                                                          .myUId ==
                                                                      serUser
                                                                          .uId) {
                                                                    snackBar(
                                                                        context:
                                                                            context,
                                                                        contentType:
                                                                            ContentType
                                                                                .warning,
                                                                        title: "Oops!"
                                                                            .tr,
                                                                        body: "you can't feedback yourself"
                                                                            .tr);
                                                                  } else {
                                                                    if (controller
                                                                        .feedbackCtrl
                                                                        .text
                                                                        .isNotEmpty) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'users')
                                                                          .doc(serUser
                                                                              .uId)
                                                                          .collection(
                                                                              'feedbacks')
                                                                          .add(FeedbackModel(feedBackerImg: controller.myImage, feedBackerMsg: controller.feedbackCtrl.text, feedBackerId: controller.myUId, servicerId: serUser.uId, feedBackerEmail: controller.myEmail, feedBackerName: controller.myUsername)
                                                                              .toMap());
                                                                      controller
                                                                          .feedbackCtrl
                                                                          .clear();
                                                                      snackBar(
                                                                          context:
                                                                              context,
                                                                          contentType: ContentType
                                                                              .success,
                                                                          title: "Done !"
                                                                              .tr,
                                                                          body:
                                                                              "your feedback added to the servicer profile ..".tr);
                                                                    }
                                                                  }
                                                                },
                                                              ),
                                                            );
                                                          },
                                                          submitFeedback: () {
                                                            if (controller
                                                                    .myUId ==
                                                                serUser.uId) {
                                                              snackBar(
                                                                  context:
                                                                      context,
                                                                  contentType:
                                                                      ContentType
                                                                          .warning,
                                                                  title: "Oops!"
                                                                      .tr,
                                                                  body:
                                                                      "you can't feedback yourself"
                                                                          .tr);
                                                            } else {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(serUser
                                                                      .uId)
                                                                  .collection(
                                                                      'feedbacks')
                                                                  .add(FeedbackModel(
                                                                          feedBackerImg: controller
                                                                              .myImage,
                                                                          feedBackerMsg: controller
                                                                              .feedbackCtrl
                                                                              .text,
                                                                          feedBackerId: controller
                                                                              .myUId,
                                                                          servicerId: serUser
                                                                              .uId,
                                                                          feedBackerEmail: controller
                                                                              .myEmail,
                                                                          feedBackerName:
                                                                              controller.myUsername)
                                                                      .toMap());
                                                              controller
                                                                  .feedbackCtrl
                                                                  .clear();
                                                              snackBar(
                                                                  context:
                                                                      context,
                                                                  contentType:
                                                                      ContentType
                                                                          .success,
                                                                  title:
                                                                      "Done !"
                                                                          .tr,
                                                                  body:
                                                                      "your feedback added to the servicer profile .."
                                                                          .tr);
                                                            }
                                                          },
                                                          contact: () {
                                                            Get.to(InChatScreen(
                                                              model: serUser,
                                                              receiverId:
                                                                  serUser.uId,
                                                            ));
                                                          },
                                                          removeFromFav: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(controller
                                                                    .myUId)
                                                                .collection(
                                                                    'favorites')
                                                                .doc(
                                                                    document.id)
                                                                .delete();
                                                          },
                                                          ratersId:
                                                              serUser.ratersId,
                                                          disRatersId: serUser
                                                              .disRatersId,
                                                        );
                                                      },
                                                    )
                                                    .toList()
                                                    .cast(),
                                              ),
                                            );
                                    },
                                  ),
                                ),
                              );
                            },
                            color: AppColors.gradientLightColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  IconlyBroken.heart,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Favorites".tr,
                                  style: englishTheme.textTheme.bodyText1!
                                      .copyWith(
                                          color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (controller.amIAServicer) const SizedBox(width: 8),
                        if (controller.amIAServicer)
                          Expanded(
                            flex: 1,
                            child: MaterialButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                    height: 900,
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('requests')
                                          .where('queuersId',
                                              arrayContains: controller.myUId)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              "Something went wrong".tr);
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        return snapshot.data!.docs.isEmpty
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                      child: Text(
                                                          "No requests in queue"
                                                              .tr))
                                                ],
                                              )
                                            : ListView(
                                                children: snapshot.data!.docs
                                                    .map(
                                                      (DocumentSnapshot
                                                          document) {
                                                        Map<String, dynamic>
                                                            data =
                                                            document.data()!
                                                                as Map<String,
                                                                    dynamic>;
                                                        RequestModel req =
                                                            RequestModel
                                                                .fromJson(data);

                                                        bool isDone =
                                                            req.isDone;
                                                        bool amNotified = false;
                                                        List<dynamic>
                                                            notifiersId =
                                                            req.notifiersId;
                                                        if (notifiersId
                                                            .contains(controller
                                                                .myUId)) {
                                                          amNotified = true;
                                                        }
                                                        late ServicerUser
                                                            serUser;
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .where('uId',
                                                                isEqualTo: req
                                                                    .requesterID)
                                                            .get()
                                                            .then(
                                                                (querySnapshot) {
                                                          querySnapshot.docs
                                                              .forEach((doc) {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(doc.id)
                                                                .get()
                                                                .then((value) {
                                                              var userData =
                                                                  value.data()!;
                                                              serUser = ServicerUser(
                                                                  servicer: userData[
                                                                      'servicer'],
                                                                  email: userData[
                                                                      'email'],
                                                                  password: userData[
                                                                      'password'],
                                                                  address: userData[
                                                                      'address'],
                                                                  phone: userData[
                                                                      'phone'],
                                                                  image: userData[
                                                                      'image'],
                                                                  isVerified: userData[
                                                                      'isVerified'],
                                                                  uId: userData[
                                                                      'uId'],
                                                                  username: userData[
                                                                      'name'],
                                                                  age: userData[
                                                                      'age'],
                                                                  gender: userData[
                                                                      'gender'],
                                                                  providence: userData[
                                                                      'providence'],
                                                                  categories: userData[
                                                                      'categories'],
                                                                  programmingLanguagesList:
                                                                      userData[
                                                                          'programmingLanguagesList'],
                                                                  experiencedTools:
                                                                      userData[
                                                                          'experiencedTools'],
                                                                  experienceLevel:
                                                                      userData[
                                                                          'experienceLevel'],
                                                                  anotherExpertise:
                                                                      userData[
                                                                          'anotherExpertise'],
                                                                  formerExperiences:
                                                                      userData['formerExperiences'],
                                                                  rate: userData['rate'],
                                                                  raters: userData['raters'],
                                                                  disRaters: userData['disRaters'],
                                                                  ratersId: userData['ratersId'],
                                                                  disRatersId: userData['disRatersId'],
                                                                  contacts: userData['contacts'],
                                                                  serviced: userData['serviced']);
                                                            });
                                                          });
                                                        });

                                                        return QueueCustomRequest(
                                                          name: req.username,
                                                          date: req.shownTime,
                                                          description: req.text,
                                                          img: req.image,
                                                          location:
                                                              req.location,
                                                          isDone: req.isDone,
                                                          tags: controller
                                                              .mergeTags(controller
                                                                  .getTranslatedCategories(
                                                                      req.tags)),
                                                          owner: controller
                                                                      .myUId ==
                                                                  req.requesterID
                                                              ? true
                                                              : false,
                                                          onDoneTap: () {
                                                            if (isDone ==
                                                                    false &&
                                                                amNotified ==
                                                                    false) {
                                                              DateTime now =
                                                                  DateTime
                                                                      .now();
                                                              String
                                                                  formattedDate =
                                                                  DateFormat(
                                                                          'yyyy-MM-dd – kk:mm')
                                                                      .format(
                                                                          now);

                                                              NotificationReqModel notifyReq = NotificationReqModel(
                                                                  username: req
                                                                      .username,
                                                                  image:
                                                                      req.image,
                                                                  text:
                                                                      req.text,
                                                                  ntpDateTime: req
                                                                      .ntpDateTime,
                                                                  location: req
                                                                      .location,
                                                                  isApproved: req
                                                                      .isDone,
                                                                  tags:
                                                                      req.tags,
                                                                  approveRequesterID:
                                                                      controller
                                                                          .myUId,
                                                                  requestId: req
                                                                      .requestId,
                                                                  notifierName:
                                                                      controller
                                                                          .myUsername,
                                                                  notifierEmail:
                                                                      controller
                                                                          .myEmail,
                                                                  shownTime:
                                                                      formattedDate);
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(req
                                                                      .requesterID)
                                                                  .collection(
                                                                      'notifications')
                                                                  .add(notifyReq
                                                                      .toMap())
                                                                  .then(
                                                                    (value) => snackBar(
                                                                        context:
                                                                            context,
                                                                        contentType:
                                                                            ContentType
                                                                                .failure,
                                                                        title: "Done !"
                                                                            .tr,
                                                                        body: "Approve Request Submitted .. "
                                                                            .tr),
                                                                  );

                                                              notifiersId.add(
                                                                  controller
                                                                      .myUId);

                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'requests')
                                                                  .where(
                                                                      'requestId',
                                                                      isEqualTo: req
                                                                          .requestId)
                                                                  .get()
                                                                  .then(
                                                                      (querySnapshot) {
                                                                querySnapshot
                                                                    .docs
                                                                    .forEach(
                                                                        (doc) {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'requests')
                                                                      .doc(doc
                                                                          .id)
                                                                      .update({
                                                                    'notifiersId':
                                                                        notifiersId
                                                                  });
                                                                });
                                                              });

                                                              snackBar(
                                                                  context:
                                                                      context,
                                                                  contentType:
                                                                      ContentType
                                                                          .success,
                                                                  title:
                                                                      "Done !"
                                                                          .tr,
                                                                  body:
                                                                      "your approve request is submitted .."
                                                                          .tr);
                                                            } else if (isDone ==
                                                                true) {
                                                              snackBar(
                                                                  context:
                                                                      context,
                                                                  contentType:
                                                                      ContentType
                                                                          .failure,
                                                                  title:
                                                                      "Oops !"
                                                                          .tr,
                                                                  body:
                                                                      "this request is serviced .."
                                                                          .tr);
                                                            } else if (amNotified ==
                                                                true) {
                                                              snackBar(
                                                                  context:
                                                                      context,
                                                                  contentType:
                                                                      ContentType
                                                                          .failure,
                                                                  title:
                                                                      "Oops !"
                                                                          .tr,
                                                                  body:
                                                                      "this request is pending in the requester notifications .."
                                                                          .tr);
                                                            }
                                                          },
                                                          contact: () {
                                                            Get.to(InChatScreen(
                                                              model: serUser,
                                                              receiverId:
                                                                  serUser.uId,
                                                            ));
                                                          },
                                                          onOptionSelected:
                                                              (String?
                                                                  value) {},
                                                          removeFromQueue: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'requests')
                                                                .get()
                                                                .then(
                                                                    (querySnapshot) {
                                                              querySnapshot.docs
                                                                  .forEach(
                                                                      (doc) async {
                                                                List<dynamic>
                                                                    queuersId =
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'requests')
                                                                        .doc(doc
                                                                            .id)
                                                                        .get()
                                                                        .then((value) =>
                                                                            value.data()!['queuersId']);
                                                                queuersId.remove(
                                                                    controller
                                                                        .myUId);
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'requests')
                                                                    .doc(doc.id)
                                                                    .update({
                                                                  'queuersId':
                                                                      queuersId
                                                                });
                                                              });
                                                            });
                                                          },
                                                          onViewTap: () {
                                                            if (serUser
                                                                .servicer) {
                                                              Get.to(
                                                                  CarouselView(
                                                                serUser:
                                                                    serUser,
                                                                feedbackerImg:
                                                                    controller
                                                                        .myImage,
                                                                submitFeedback:
                                                                    () {
                                                                  if (controller
                                                                          .myUId ==
                                                                      serUser
                                                                          .uId) {
                                                                    snackBar(
                                                                        contentType:
                                                                            ContentType
                                                                                .warning,
                                                                        title: "Oops!"
                                                                            .tr,
                                                                        body: "you can't feedback yourself"
                                                                            .tr);
                                                                  } else {
                                                                    if (controller
                                                                        .feedbackCtrl
                                                                        .text
                                                                        .isNotEmpty) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'users')
                                                                          .doc(serUser
                                                                              .uId)
                                                                          .collection(
                                                                              'feedbacks')
                                                                          .add(FeedbackModel(feedBackerImg: controller.myImage, feedBackerMsg: controller.feedbackCtrl.text, feedBackerId: controller.myUId, servicerId: serUser.uId, feedBackerEmail: controller.myEmail, feedBackerName: controller.myUsername)
                                                                              .toMap());
                                                                      controller
                                                                          .feedbackCtrl
                                                                          .clear();
                                                                      snackBar(
                                                                          contentType: ContentType
                                                                              .success,
                                                                          title: "Done !"
                                                                              .tr,
                                                                          body:
                                                                              "your feedback added to the servicer profile ..".tr);
                                                                    }
                                                                  }
                                                                },
                                                              ));
                                                            } else {
                                                              snackBar(
                                                                  context:
                                                                      context,
                                                                  contentType:
                                                                      ContentType
                                                                          .warning,
                                                                  title: "Oops!"
                                                                      .tr,
                                                                  body:
                                                                      "This user is not a servicer"
                                                                          .tr);
                                                            }
                                                          },
                                                        );
                                                      },
                                                    )
                                                    .toList()
                                                    .cast(),
                                              );
                                      },
                                    ),
                                  ),
                                );
                              },
                              color: AppColors.gradientDarkColor,
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
                                    "Queue".tr,
                                    style: englishTheme.textTheme.bodyText1!
                                        .copyWith(
                                            color: Colors.white, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (controller.amIAServicer)
                      Row(
                        children: [
                          const SizedBox(
                            width: 7,
                          ),
                          Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                "CV".tr,
                                style:
                                    englishTheme.textTheme.bodyText1!.copyWith(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (controller.amIAServicer)
                      Column(
                        children: [
                          Center(
                            child: TapToExpand(
                              content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: controller
                                      .stringsToTexts(controller.myCategories)),
                              title: Text(
                                "Fields Of Expertise".tr,
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
                                      controller.myProgrammingLanguagesList)),
                              title: Flexible(
                                child: Text(
                                  "Skillful With This Programming Languages".tr,
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
                                  children: controller.stringsToTexts(
                                      controller.myExperiencedTools)),
                              title: Flexible(
                                child: Text(
                                  "Skillful With This Programs".tr,
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
                                  children: controller.stringsToTexts(
                                      controller.myAnotherExpertise)),
                              title: Text(
                                "Another Expertise".tr,
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
                                      controller.myFormerExperiences)),
                              title: Text(
                                "Former Experiences".tr,
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
                    if (controller.amIAServicer)
                      Row(
                        children: [
                          const SizedBox(
                            width: 7,
                          ),
                          Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                "Feedbacks".tr,
                                style:
                                    englishTheme.textTheme.bodyText1!.copyWith(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (controller.amIAServicer)
                      Card(
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(width: 0)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            // color: Colors.deepPurpleAccent[100]
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColors.gradientLightColor,
                                AppColors.gradientDarkColor
                              ],
                            ),
                          ),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(controller.myUId)
                                .collection('feedbacks')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text("Something went wrong".tr);
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
                                      Map<String, dynamic> data = document
                                          .data()! as Map<String, dynamic>;
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
                      ),
                    if (controller.amIAServicer == false) SizedBox(height: 140),
                    OutlinedButton(
                        onPressed: () {
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "change language".tr,
                            desc: "Do you want to change the language?".tr,
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Yes".tr,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  LocaleController locale =
                                      Get.put(LocaleController());
                                  locale.changeLocale(locale
                                              .myServices.sharedPref
                                              .getString("lang") ==
                                          "en"
                                      ? "ar"
                                      : "en");
                                  controller.refresh();
                                  Restart.restartApp();
                                },
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(0, 179, 134, 1.0),
                                  Colors.greenAccent,
                                ]),
                              ),
                              DialogButton(
                                child: Text(
                                  "No".tr,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                gradient: LinearGradient(
                                    colors: [Colors.pink, Colors.redAccent]),
                              )
                            ],
                          ).show();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "change language".tr,
                              style: TextStyle(
                                color: AppColors.gradientDarkColor,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              IconlyBroken.swap,
                              size: 15,
                              color: AppColors.gradientDarkColor,
                            ),
                          ],
                        )),
                    SizedBox(height: 5),
                    OutlinedButton(
                        onPressed: () {
                          MyServices myServices = Get.find();
                          myServices.sharedPref.setString("logged", "0");

                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "Sign out".tr,
                            desc: "Do you want to Sign out?".tr,
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Yes".tr,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () =>
                                    Get.offAllNamed(AppRoutes.login),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(0, 179, 134, 1.0),
                                  Colors.greenAccent,
                                ]),
                              ),
                              DialogButton(
                                child: Text(
                                  "No".tr,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                gradient: LinearGradient(
                                    colors: [Colors.pink, Colors.redAccent]),
                              )
                            ],
                          ).show();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sign Out".tr,
                              style: TextStyle(
                                color: AppColors.gradientLightColor,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              IconlyBroken.logout,
                              size: 15,
                              color: AppColors.gradientLightColor,
                            ),
                          ],
                        )),
                    SizedBox(height: 5),
                    OutlinedButton(
                      onPressed: () {
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "Delete account".tr,
                          desc: "Do you want to delete your account?".tr,
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Yes".tr,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => controller.deleteUser(),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(0, 179, 134, 1.0),
                                Colors.greenAccent,
                              ]),
                            ),
                            DialogButton(
                              child: Text(
                                "No".tr,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              gradient: LinearGradient(
                                  colors: [Colors.pink, Colors.redAccent]),
                            )
                          ],
                        ).show();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Delete User".tr,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            IconlyBroken.delete,
                            size: 15,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      );
    });
  }
}
