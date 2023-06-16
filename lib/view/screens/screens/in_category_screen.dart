import 'package:age_calculator/age_calculator.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/functions/signupSuccessful.dart';
import 'package:socio/model/feedback_model.dart';
import 'package:socio/model/service_user.dart';
import 'package:socio/view/screens/carousel_view.dart';
import 'package:socio/view/widgets/OnBoarding/category_custom_servicer.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key, required this.category}) : super(key: key);
  final String category;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<MainScreenController>(builder: (controller) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('categories', arrayContains: category)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong".tr);
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return snapshot.data!.docs.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Center(child: Text("Empty".tr))],
                      )
                    : ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;

                              late ServicerUser serUser;
                              var userData = data;
                              serUser = ServicerUser(
                                  servicer: userData['servicer'],
                                  email: userData['email'],
                                  password: userData['password'],
                                  address: userData['address'],
                                  phone: userData['phone'],
                                  image: userData['image'],
                                  isVerified: userData['isVerified'],
                                  uId: userData['uId'],
                                  username: userData['name'],
                                  age: userData['age'],
                                  gender: userData['gender'],
                                  providence: userData['providence'],
                                  categories: userData['categories'],
                                  programmingLanguagesList:
                                      userData['programmingLanguagesList'],
                                  experiencedTools:
                                      userData['experiencedTools'],
                                  experienceLevel: userData['experienceLevel'],
                                  anotherExpertise:
                                      userData['anotherExpertise'],
                                  formerExperiences:
                                      userData['formerExperiences'],
                                  rate: userData['rate'],
                                  raters: userData['raters'],
                                  disRaters: userData['disRaters'],
                                  ratersId: userData['ratersId'],
                                  disRatersId: userData['disRatersId'],
                                  contacts: userData['contacts'],
                                  serviced: userData['serviced']);
                              DateTime birthday = DateTime.parse(serUser.age);
                              DateDuration duration;
                              // Find out your age as of today's date 2021-03-08
                              duration = AgeCalculator.age(birthday);
                              return serUser.uId != controller.myUId
                                  ? CategoryCustomServicer(
                                      img: serUser.image,
                                      name: serUser.username,
                                      location: serUser.address,
                                      age: "${duration.years}",
                                      rate: serUser.rate,
                                      level: serUser.experienceLevel,
                                      addToFav: () {
                                        if (controller.myUId == serUser.uId) {
                                          snackBar(
                                              context: context,
                                              contentType: ContentType.failure,
                                              title: "Oops !".tr,
                                              body: "it's you sir ..".tr);
                                        } else {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(controller.myUId)
                                              .collection('favorites')
                                              .add(serUser.toMap());
                                          snackBar(
                                              context: context,
                                              contentType: ContentType.success,
                                              title: "Done !".tr,
                                              body:
                                                  "Servicer added to your favorite .."
                                                      .tr);
                                        }
                                      },
                                      onViewTap: () {
                                        Get.to(CarouselView(
                                          serUser: serUser,
                                          feedbackerImg: controller.myImage,
                                          submitFeedback: () {
                                            if (controller.myUId ==
                                                serUser.uId) {
                                              snackBar(
                                                  contentType:
                                                      ContentType.warning,
                                                  title: "Oops!".tr,
                                                  body:
                                                      "you can't feedback yourself"
                                                          .tr);
                                            } else {
                                              if (controller.feedbackCtrl.text
                                                  .isNotEmpty) {
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(serUser.uId)
                                                    .collection('feedbacks')
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
                                                                serUser.uId,
                                                            feedBackerEmail:
                                                                controller
                                                                    .myEmail,
                                                            feedBackerName:
                                                                controller
                                                                    .myUsername)
                                                        .toMap());
                                                controller.feedbackCtrl.clear();
                                                snackBar(
                                                    contentType:
                                                        ContentType.success,
                                                    title: "Done !".tr,
                                                    body:
                                                        "your feedback added to the servicer profile .."
                                                            .tr);
                                              }
                                            }
                                          },
                                        ));
                                      },
                                      contact: () {},
                                      ratersId: serUser.ratersId,
                                      disRatersId: serUser.disRatersId,
                                    )
                                  : Container();
                            })
                            .toList()
                            .cast(),
                      );
              },
            ),
          );
        }),
      ),
    );
  }
}

// {
// showModalBottomSheet(
// context: context,
// isScrollControlled: true,
// builder: (context) => ProfileView(
// serUser: serUser,
// feedbackerImg: controller.myImage,
// submitFeedback: () {
// if (controller.myUId ==
// serUser.uId) {
// snackBar(
// context: context,
// contentType:
// ContentType.warning,
// title: "Oops!".tr,
// body:
// "you can't feedback yourself"
//     .tr);
// } else {
// if (controller.feedbackCtrl.text
//     .isNotEmpty) {
// FirebaseFirestore.instance
//     .collection('users')
//     .doc(serUser.uId)
//     .collection('feedbacks')
//     .add(FeedbackModel(
// feedBackerImg:
// controller
//     .myImage,
// feedBackerMsg:
// controller
//     .feedbackCtrl
//     .text,
// feedBackerId:
// controller
//     .myUId,
// servicerId:
// serUser.uId,
// feedBackerEmail:
// controller
//     .myEmail,
// feedBackerName:
// controller
//     .myUsername)
//     .toMap());
// controller.feedbackCtrl
//     .clear();
// snackBar(
// context: context,
// contentType:
// ContentType.success,
// title: "Done !".tr,
// body:
// "your feedback added to the servicer profile .."
//     .tr);
// }
// }
// },
// ),
// );
// },
