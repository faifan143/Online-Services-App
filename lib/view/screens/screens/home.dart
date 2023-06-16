import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/constants/AppColors.dart';
import 'package:socio/core/constants/appTheme.dart';
import 'package:socio/core/functions/signupSuccessful.dart';
import 'package:socio/model/feedback_model.dart';
import 'package:socio/model/request_model.dart';
import 'package:socio/model/service_user.dart';
import 'package:socio/view/screens/edit_request.dart';
import 'package:socio/view/screens/screens/in_chat_screen.dart';
import 'package:socio/view/widgets/custom_request.dart';

import '../../../model/notificationReq_model.dart';
import '../carousel_view.dart';

class HomeScreen extends GetView<MainScreenController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return GetBuilder<MainScreenController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: ListView(
          children: [
            Row(
              children: [
                Card(
                  elevation: 5,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      "New Servicers".tr,
                      style: englishTheme.textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.gradientDarkColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CarouselSlider(
              items: controller.carouselUsersList.isEmpty
                  ? [Center(child: Text("No New Servicers".tr))]
                  : controller.carouselUsersList,
              options: CarouselOptions(
                height: 210,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayInterval: const Duration(seconds: 4),
                viewportFraction: 1,
              ),
            ),
            Row(
              children: [
                Card(
                  elevation: 5,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      "Requests".tr,
                      style: englishTheme.textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.gradientDarkColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            controller.loadingHomeScreen == true
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    ],
                  )
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('requests')
                        .where('tags',
                            arrayContainsAny: controller
                                .getEngCategories(controller.myCategories))
                        .where('requesterID', isNotEqualTo: controller.myUId)
                        .orderBy('requesterID')
                        .orderBy('ntpDateTime', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong'.tr);
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        );
                      }

                      return snapshot.data!.docs.isEmpty
                          ? SizedBox(
                              height: 300,
                              child: Center(child: Text("No Requests".tr)),
                            )
                          : ListView(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    RequestModel req =
                                        RequestModel.fromJson(data);

                                    late ServicerUser serUser;
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .where('uId',
                                            isEqualTo: req.requesterID)
                                        .get()
                                        .then((querySnapshot) {
                                      querySnapshot.docs.forEach((doc) {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(doc.id)
                                            .get()
                                            .then((value) {
                                          var userData = value.data()!;
                                          serUser = ServicerUser(
                                              servicer: userData['servicer'],
                                              email: userData['email'],
                                              password: userData['password'],
                                              address: userData['address'],
                                              phone: userData['phone'],
                                              image: userData['image'],
                                              isVerified:
                                                  userData['isVerified'],
                                              uId: userData['uId'],
                                              username: userData['name'],
                                              age: userData['age'],
                                              gender: userData['gender'],
                                              providence:
                                                  userData['providence'],
                                              categories:
                                                  userData['categories'],
                                              programmingLanguagesList: userData[
                                                  'programmingLanguagesList'],
                                              experiencedTools:
                                                  userData['experiencedTools'],
                                              experienceLevel:
                                                  userData['experienceLevel'],
                                              anotherExpertise:
                                                  userData['anotherExpertise'],
                                              formerExperiences:
                                                  userData['formerExperiences'],
                                              rate: userData['rate'],
                                              raters: userData['raters'],
                                              disRaters: userData['disRaters'],
                                              ratersId: userData['ratersId'],
                                              disRatersId:
                                                  userData['disRatersId'],
                                              contacts: userData['contacts'],
                                              serviced: userData['serviced']);
                                        });
                                      });
                                    });
                                    return controller.isShowableToMe(req.tags)
                                        ? CustomRequest(
                                            name: req.username,
                                            date: req.shownTime,
                                            description: req.text,
                                            img: req.image,
                                            location:
                                                controller.getTranslatedAddress(
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
                                                  .collection('requests')
                                                  .where('requesterID',
                                                      isEqualTo:
                                                          controller.myUId)
                                                  .where('ntpDateTime',
                                                      isEqualTo:
                                                          req.ntpDateTime)
                                                  .get()
                                                  .then((querySnapshot) {
                                                querySnapshot.docs
                                                    .forEach((doc) async {
                                                  bool isDone =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'requests')
                                                          .doc(doc.id)
                                                          .get()
                                                          .then((value) =>
                                                              value.data()![
                                                                  'isDone']);
                                                  isDone = !isDone;

                                                  FirebaseFirestore.instance
                                                      .collection('requests')
                                                      .doc(doc.id)
                                                      .update(
                                                          {'isDone': isDone});
                                                });
                                              });

                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(controller.myUId)
                                                  .collection('requests')
                                                  .where('requestId',
                                                      isEqualTo: req.requestId)
                                                  .get()
                                                  .then((querySnapshot) {
                                                querySnapshot.docs
                                                    .forEach((doc) async {
                                                  bool isDone =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(controller.myUId)
                                                          .collection(
                                                              'requests')
                                                          .doc(doc.id)
                                                          .get()
                                                          .then((value) =>
                                                              value.data()![
                                                                  'isDone']);
                                                  isDone = !isDone;

                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(controller.myUId)
                                                      .collection('requests')
                                                      .doc(doc.id)
                                                      .update(
                                                          {'isDone': isDone});
                                                });
                                              });

                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(controller.myUId)
                                                  .collection('queue')
                                                  .where('requestId',
                                                      isEqualTo: req.requestId)
                                                  .get()
                                                  .then((querySnapshot) {
                                                querySnapshot.docs
                                                    .forEach((doc) async {
                                                  bool isDone =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(controller.myUId)
                                                          .collection('queue')
                                                          .doc(doc.id)
                                                          .get()
                                                          .then((value) =>
                                                              value.data()![
                                                                  'isDone']);
                                                  isDone = !isDone;

                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(controller.myUId)
                                                      .collection('queue')
                                                      .doc(doc.id)
                                                      .update(
                                                          {'isDone': isDone});
                                                });
                                              });
                                            },
                                            addToQueue: () {
                                              if (req.isDone == false) {
                                                if (!controller.myServicer) {
                                                  snackBar(
                                                      context: context,
                                                      contentType:
                                                          ContentType.failure,
                                                      title: "Oops !".tr,
                                                      body:
                                                          "You're a normal user , not a servicer .."
                                                              .tr);
                                                } else if (controller.myUId ==
                                                    req.requesterID) {
                                                  snackBar(
                                                      context: context,
                                                      contentType:
                                                          ContentType.failure,
                                                      title: "Oops !".tr,
                                                      body:
                                                          "you posted this request you can't add it to your queue"
                                                              .tr);
                                                } else if (req.isDone == true) {
                                                  snackBar(
                                                      context: context,
                                                      contentType:
                                                          ContentType.failure,
                                                      title: "Oops !".tr,
                                                      body:
                                                          "this request is done .. "
                                                              .tr);
                                                } else {
                                                  FirebaseFirestore.instance
                                                      .collection('requests')
                                                      .where('requestId',
                                                          isEqualTo:
                                                              req.requestId)
                                                      .get()
                                                      .then((querySnapshot) {
                                                    querySnapshot.docs
                                                        .forEach((doc) async {
                                                      List<dynamic> queuersId =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'requests')
                                                              .doc(doc.id)
                                                              .get()
                                                              .then((value) =>
                                                                  value.data()![
                                                                      'queuersId']);
                                                      if (queuersId.contains(
                                                              controller
                                                                  .myUId) ==
                                                          false) {
                                                        queuersId.add(
                                                            controller.myUId);
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'requests')
                                                            .doc(doc.id)
                                                            .update({
                                                          'queuersId': queuersId
                                                        });
                                                      }
                                                    });
                                                  });
                                                  snackBar(
                                                      context: context,
                                                      contentType:
                                                          ContentType.success,
                                                      title: "Done !".tr,
                                                      body:
                                                          "Request added to your queue .."
                                                              .tr);
                                                }
                                              } else if (req.isDone == true) {
                                                snackBar(
                                                    context: context,
                                                    contentType:
                                                        ContentType.failure,
                                                    title: "Oops!".tr,
                                                    body:
                                                        "This Request is Served"
                                                            .tr);
                                              }
                                            },
                                            contact: () {
                                              Get.to(InChatScreen(
                                                model: serUser,
                                                receiverId: serUser.uId,
                                              ));
                                            },
                                            onOptionSelected:
                                                (String? value) async {
                                              controller.selectedOption(value!);
                                              if (value == "Delete".tr) {
                                                Alert(
                                                  context: context,
                                                  type: AlertType.error,
                                                  title: "Delete ..".tr,
                                                  desc:
                                                      "Do you want to delete your request ?"
                                                          .tr,
                                                  buttons: [
                                                    DialogButton(
                                                      onPressed: () async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'requests')
                                                            .doc(document.id)
                                                            .delete();

                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(controller
                                                                .myUId)
                                                            .collection(
                                                                'requests')
                                                            .where('requestId',
                                                                isEqualTo: req
                                                                    .requestId)
                                                            .get()
                                                            .then(
                                                                (querySnapshot) {
                                                          querySnapshot.docs
                                                              .forEach(
                                                                  (doc) async {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(controller
                                                                    .myUId)
                                                                .collection(
                                                                    'requests')
                                                                .doc(doc.id)
                                                                .delete();
                                                          });
                                                        });

                                                        Navigator.pop(context);
                                                      },
                                                      width: 120,
                                                      child: Text(
                                                        "Yes".tr,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                    )
                                                  ],
                                                ).show();
                                              } else if (value == "Edit".tr) {
                                                Get.to(EditRequest(req: req));
                                              }
                                            },
                                            onApproveTap: () {
                                              bool isDone = req.isDone;
                                              bool amNotified = false;
                                              List<dynamic> notifiersId =
                                                  req.notifiersId;
                                              if (notifiersId
                                                  .contains(controller.myUId)) {
                                                amNotified = true;
                                              }
                                              late ServicerUser serUser;
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .where('uId',
                                                      isEqualTo:
                                                          req.requesterID)
                                                  .get()
                                                  .then((querySnapshot) {
                                                querySnapshot.docs
                                                    .forEach((doc) {
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(doc.id)
                                                      .get()
                                                      .then((value) {
                                                    var userData =
                                                        value.data()!;
                                                    serUser = ServicerUser(
                                                        servicer: userData[
                                                            'servicer'],
                                                        email:
                                                            userData['email'],
                                                        password: userData[
                                                            'password'],
                                                        address:
                                                            userData['address'],
                                                        phone:
                                                            userData['phone'],
                                                        image:
                                                            userData['image'],
                                                        isVerified: userData[
                                                            'isVerified'],
                                                        uId: userData['uId'],
                                                        username:
                                                            userData['name'],
                                                        age: userData['age'],
                                                        gender:
                                                            userData['gender'],
                                                        providence: userData[
                                                            'providence'],
                                                        categories: userData[
                                                            'categories'],
                                                        programmingLanguagesList:
                                                            userData[
                                                                'programmingLanguagesList'],
                                                        experiencedTools: userData[
                                                            'experiencedTools'],
                                                        experienceLevel: userData[
                                                            'experienceLevel'],
                                                        anotherExpertise: userData[
                                                            'anotherExpertise'],
                                                        formerExperiences: userData[
                                                            'formerExperiences'],
                                                        rate: userData['rate'],
                                                        raters:
                                                            userData['raters'],
                                                        disRaters: userData[
                                                            'disRaters'],
                                                        ratersId: userData[
                                                            'ratersId'],
                                                        disRatersId: userData[
                                                            'disRatersId'],
                                                        contacts: userData[
                                                            'contacts'],
                                                        serviced: userData[
                                                            'serviced']);
                                                  });
                                                });
                                              });

                                              if (isDone == false &&
                                                  amNotified == false) {
                                                DateTime now = DateTime.now();
                                                String formattedDate =
                                                    DateFormat(
                                                            'yyyy-MM-dd – kk:mm')
                                                        .format(now);

                                                NotificationReqModel notifyReq =
                                                    NotificationReqModel(
                                                        username: req.username,
                                                        image: req.image,
                                                        text: req.text,
                                                        ntpDateTime:
                                                            req.ntpDateTime,
                                                        location: req.location,
                                                        isApproved: req.isDone,
                                                        tags: req.tags,
                                                        approveRequesterID:
                                                            controller.myUId,
                                                        requestId:
                                                            req.requestId,
                                                        notifierName: controller
                                                            .myUsername,
                                                        notifierEmail:
                                                            controller.myEmail,
                                                        shownTime:
                                                            formattedDate);
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(req.requesterID)
                                                    .collection('notifications')
                                                    .add(notifyReq.toMap())
                                                    .then(
                                                      (value) => snackBar(
                                                          context: context,
                                                          contentType:
                                                              ContentType
                                                                  .failure,
                                                          title: "Done !".tr,
                                                          body:
                                                              "Approve Request Submitted .. "
                                                                  .tr),
                                                    );

                                                notifiersId
                                                    .add(controller.myUId);

                                                FirebaseFirestore.instance
                                                    .collection('requests')
                                                    .where('requestId',
                                                        isEqualTo:
                                                            req.requestId)
                                                    .get()
                                                    .then((querySnapshot) {
                                                  querySnapshot.docs
                                                      .forEach((doc) {
                                                    FirebaseFirestore.instance
                                                        .collection('requests')
                                                        .doc(doc.id)
                                                        .update({
                                                      'notifiersId': notifiersId
                                                    });
                                                  });
                                                });

                                                snackBar(
                                                    context: context,
                                                    contentType:
                                                        ContentType.success,
                                                    title: "Done !".tr,
                                                    body:
                                                        "your approve request is submitted .."
                                                            .tr);
                                              } else if (isDone == true) {
                                                snackBar(
                                                    context: context,
                                                    contentType:
                                                        ContentType.failure,
                                                    title: "Oops !".tr,
                                                    body:
                                                        "this request is serviced .."
                                                            .tr);
                                              } else if (amNotified == true) {
                                                snackBar(
                                                    context: context,
                                                    contentType:
                                                        ContentType.failure,
                                                    title: "Oops !".tr,
                                                    body:
                                                        "this request is pending in the requester notifications .."
                                                            .tr);
                                              }
                                            },
                                            onViewTap: () {
                                              if (serUser.servicer) {
                                                Get.to(CarouselView(
                                                  serUser: serUser,
                                                  feedbackerImg:
                                                      controller.myImage,
                                                  submitFeedback: () {
                                                    if (controller.myUId ==
                                                        serUser.uId) {
                                                      snackBar(
                                                          contentType:
                                                              ContentType
                                                                  .warning,
                                                          title: "Oops!".tr,
                                                          body:
                                                              "you can't feedback yourself"
                                                                  .tr);
                                                    } else {
                                                      if (controller
                                                          .feedbackCtrl
                                                          .text
                                                          .isNotEmpty) {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(serUser.uId)
                                                            .collection(
                                                                'feedbacks')
                                                            .add(FeedbackModel(
                                                                    feedBackerImg:
                                                                        controller
                                                                            .myImage,
                                                                    feedBackerMsg:
                                                                        controller
                                                                            .feedbackCtrl
                                                                            .text,
                                                                    feedBackerId:
                                                                        controller
                                                                            .myUId,
                                                                    servicerId:
                                                                        serUser
                                                                            .uId,
                                                                    feedBackerEmail:
                                                                        controller
                                                                            .myEmail,
                                                                    feedBackerName:
                                                                        controller
                                                                            .myUsername)
                                                                .toMap());
                                                        controller.feedbackCtrl
                                                            .clear();
                                                        snackBar(
                                                            contentType:
                                                                ContentType
                                                                    .success,
                                                            title: "Done !".tr,
                                                            body:
                                                                "your feedback added to the servicer profile .."
                                                                    .tr);
                                                      }
                                                    }
                                                  },
                                                ));
                                              } else {
                                                snackBar(
                                                    context: context,
                                                    contentType:
                                                        ContentType.warning,
                                                    title: "Oops!".tr,
                                                    body:
                                                        "This user is not a servicer"
                                                            .tr);
                                              }
                                            },
                                          )
                                        : Container();
                                  })
                                  .toList()
                                  .cast(),
                            );
                    },
                  ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      );
    });
  }
}
