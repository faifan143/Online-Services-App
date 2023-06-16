import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/functions/signupSuccessful.dart';
import 'package:socio/model/feedback_model.dart';
import 'package:socio/model/service_user.dart';
import 'package:socio/view/screens/carousel_view.dart';
import 'package:socio/view/widgets/custom_carousel_servicer.dart';

class SearchScreen extends GetView<MainScreenController> {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            controller.myServices.sharedPref.getString("lang") == "en"
                ? IconlyBroken.arrow_left
                : IconlyBroken.arrow_right,
            color: Colors.blue[900],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Text(
              "Search".tr,
              style: TextStyle(color: Colors.blue[900]),
            ),
            SizedBox(width: 15),
            Icon(
              IconlyBroken.search,
              color: Colors.blue[900],
            )
          ],
        ),
      ),
      body: SafeArea(
        child: GetBuilder<MainScreenController>(builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  TextField(
                    onChanged: (query) {
                      controller.changeSearchText(query.trim());
                    },
                    decoration: InputDecoration(
                        hintText: " Search . . .".tr,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(height: 15),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('name', isEqualTo: controller.searchText.trim())
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
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    late ServicerUser serUser;
                                    serUser = ServicerUser(
                                        servicer: data['servicer'],
                                        email: data['email'],
                                        password: data['password'],
                                        address: data['address'],
                                        phone: data['phone'],
                                        image: data['image'],
                                        isVerified: data['isVerified'],
                                        uId: data['uId'],
                                        username: data['name'],
                                        contacts: data['contacts'],
                                        age: data['age'],
                                        gender: data['gender'],
                                        providence: data['providence'],
                                        categories: data['categories'],
                                        programmingLanguagesList:
                                            data['programmingLanguagesList'],
                                        experiencedTools:
                                            data['experiencedTools'],
                                        experienceLevel:
                                            data['experienceLevel'],
                                        anotherExpertise:
                                            data['anotherExpertise'],
                                        formerExperiences:
                                            data['formerExperiences'],
                                        rate: data['rate'],
                                        raters: data['raters'],
                                        disRaters: data['disRaters'],
                                        ratersId: data['ratersId'],
                                        disRatersId: data['disRatersId'],
                                        serviced: data['serviced']);

                                    return SizedBox(
                                      height: 250,
                                      child: CustomCarouselServicer(
                                        onViewTap: () {
                                          Get.to(CarouselView(
                                            serUser: serUser,
                                            feedbackerImg: controller.myImage,
                                            submitFeedback: () {
                                              if (controller.myUId ==
                                                  serUser.uId) {
                                                snackBar(
                                                    context: context,
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
                                                  controller.feedbackCtrl
                                                      .clear();
                                                  snackBar(
                                                      context: context,
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
                                        submitFeedback: () {},
                                        img: data['image'],
                                        name: data['name'],
                                        location: data['address'],
                                        age: data['age'],
                                        rate: data['rate'],
                                        feedbackerImg: controller.myImage,
                                        level: data['experienceLevel'],
                                        category: data['categories'].join(' #'),
                                        addToFav: () {},
                                        ratersId: data['ratersId'],
                                        disRatersId: data['disRatersId'],
                                      ),
                                    );
                                  })
                                  .toList()
                                  .cast(),
                            );
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('email', isEqualTo: controller.searchText)
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

                      return ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              late ServicerUser serUser;
                              serUser = ServicerUser(
                                  servicer: data['servicer'],
                                  email: data['email'],
                                  password: data['password'],
                                  address: data['address'],
                                  phone: data['phone'],
                                  image: data['image'],
                                  isVerified: data['isVerified'],
                                  uId: data['uId'],
                                  username: data['name'],
                                  contacts: data['contacts'],
                                  age: data['age'],
                                  gender: data['gender'],
                                  providence: data['providence'],
                                  categories: data['categories'],
                                  programmingLanguagesList:
                                      data['programmingLanguagesList'],
                                  experiencedTools: data['experiencedTools'],
                                  experienceLevel: data['experienceLevel'],
                                  anotherExpertise: data['anotherExpertise'],
                                  formerExperiences: data['formerExperiences'],
                                  rate: data['rate'],
                                  raters: data['raters'],
                                  disRaters: data['disRaters'],
                                  ratersId: data['ratersId'],
                                  disRatersId: data['disRatersId'],
                                  serviced: data['serviced']);

                              return SizedBox(
                                height: 250,
                                child: CustomCarouselServicer(
                                  onViewTap: () {
                                    Get.to(CarouselView(
                                      serUser: serUser,
                                      feedbackerImg: controller.myImage,
                                      submitFeedback: () {
                                        if (controller.myUId == serUser.uId) {
                                          snackBar(
                                              context: context,
                                              contentType: ContentType.warning,
                                              title: "Oops!".tr,
                                              body:
                                                  "you can't feedback yourself"
                                                      .tr);
                                        } else {
                                          if (controller
                                              .feedbackCtrl.text.isNotEmpty) {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(serUser.uId)
                                                .collection('feedbacks')
                                                .add(FeedbackModel(
                                                        feedBackerImg:
                                                            controller.myImage,
                                                        feedBackerMsg:
                                                            controller
                                                                .feedbackCtrl
                                                                .text,
                                                        feedBackerId:
                                                            controller.myUId,
                                                        servicerId: serUser.uId,
                                                        feedBackerEmail:
                                                            controller.myEmail,
                                                        feedBackerName:
                                                            controller
                                                                .myUsername)
                                                    .toMap());
                                            controller.feedbackCtrl.clear();
                                            snackBar(
                                                context: context,
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
                                  submitFeedback: () {},
                                  img: data['image'],
                                  name: data['name'],
                                  location: data['address'],
                                  age: data['age'],
                                  rate: data['rate'],
                                  feedbackerImg: controller.myImage,
                                  level: data['experienceLevel'],
                                  category: data['categories'].join(' #'),
                                  addToFav: () {},
                                  ratersId: data['ratersId'],
                                  disRatersId: data['disRatersId'],
                                ),
                              );
                            })
                            .toList()
                            .cast(),
                      );
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('phone', isEqualTo: controller.searchText)
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

                      return ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              late ServicerUser serUser;
                              serUser = ServicerUser(
                                  servicer: data['servicer'],
                                  email: data['email'],
                                  password: data['password'],
                                  address: data['address'],
                                  phone: data['phone'],
                                  image: data['image'],
                                  isVerified: data['isVerified'],
                                  uId: data['uId'],
                                  username: data['name'],
                                  contacts: data['contacts'],
                                  age: data['age'],
                                  gender: data['gender'],
                                  providence: data['providence'],
                                  categories: data['categories'],
                                  programmingLanguagesList:
                                      data['programmingLanguagesList'],
                                  experiencedTools: data['experiencedTools'],
                                  experienceLevel: data['experienceLevel'],
                                  anotherExpertise: data['anotherExpertise'],
                                  formerExperiences: data['formerExperiences'],
                                  rate: data['rate'],
                                  raters: data['raters'],
                                  disRaters: data['disRaters'],
                                  ratersId: data['ratersId'],
                                  disRatersId: data['disRatersId'],
                                  serviced: data['serviced']);

                              return SizedBox(
                                height: 250,
                                child: CustomCarouselServicer(
                                  onViewTap: () {
                                    Get.to(CarouselView(
                                      serUser: serUser,
                                      feedbackerImg: controller.myImage,
                                      submitFeedback: () {
                                        if (controller.myUId == serUser.uId) {
                                          snackBar(
                                              context: context,
                                              contentType: ContentType.warning,
                                              title: "Oops!".tr,
                                              body:
                                                  "you can't feedback yourself"
                                                      .tr);
                                        } else {
                                          if (controller
                                              .feedbackCtrl.text.isNotEmpty) {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(serUser.uId)
                                                .collection('feedbacks')
                                                .add(FeedbackModel(
                                                        feedBackerImg:
                                                            controller.myImage,
                                                        feedBackerMsg:
                                                            controller
                                                                .feedbackCtrl
                                                                .text,
                                                        feedBackerId:
                                                            controller.myUId,
                                                        servicerId: serUser.uId,
                                                        feedBackerEmail:
                                                            controller.myEmail,
                                                        feedBackerName:
                                                            controller
                                                                .myUsername)
                                                    .toMap());
                                            controller.feedbackCtrl.clear();
                                            snackBar(
                                                context: context,
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
                                  submitFeedback: () {},
                                  img: data['image'],
                                  name: data['name'],
                                  location: data['address'],
                                  age: data['age'],
                                  rate: data['rate'],
                                  feedbackerImg: controller.myImage,
                                  level: data['experienceLevel'],
                                  category: data['categories'].join(' #'),
                                  addToFav: () {},
                                  ratersId: data['ratersId'],
                                  disRatersId: data['disRatersId'],
                                ),
                              );
                            })
                            .toList()
                            .cast(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
