import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/functions/signupSuccessful.dart';
import 'package:socio/model/notificationReq_model.dart';
import 'package:socio/view/widgets/notification_request.dart';

class Notifications extends GetView<MainScreenController> {
  const Notifications({Key? key}) : super(key: key);

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
              "Notifications".tr,
              style: TextStyle(color: Colors.blue[900]),
            ),
            SizedBox(width: 15),
            Icon(
              IconlyBroken.notification,
              color: Colors.blue[900],
            )
          ],
        ),
      ),
      body: SafeArea(
        child: GetBuilder<MainScreenController>(builder: (controller) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(controller.myUId)
                .collection('notifications')
                .orderBy('ntpDateTime', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      children: [Center(child: Text("No notifications".tr))],
                    )
                  : ListView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            NotificationReqModel req =
                                NotificationReqModel.fromJson(data);
                            int serviced = 0;
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(req.approveRequesterID)
                                .get()
                                .then((value) {
                              serviced = int.parse(value.data()!['serviced']);
                            });

                            return NotificationRequest(
                              name: req.username,
                              date: req.shownTime,
                              description: req.text,
                              img: req.image,
                              location: req.location,
                              onDoneTap: () {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(req.approveRequesterID)
                                    .get()
                                    .then((value) {
                                  serviced++;

                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(req.approveRequesterID)
                                      .update(
                                          {'serviced': serviced.toString()});

                                  FirebaseFirestore.instance
                                      .collection('requests')
                                      .where('requestId',
                                          isEqualTo: req.requestId)
                                      .get()
                                      .then((querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                      FirebaseFirestore.instance
                                          .collection('requests')
                                          .doc(doc.id)
                                          .update({'isDone': true});
                                      FirebaseFirestore.instance
                                          .collection('requests')
                                          .where('requestId',
                                              isEqualTo: req.requestId)
                                          .get()
                                          .then((querySnapshot) {
                                        querySnapshot.docs.forEach((doc) async {
                                          List<dynamic> notifiersId =
                                              await FirebaseFirestore.instance
                                                  .collection('requests')
                                                  .doc(doc.id)
                                                  .get()
                                                  .then((value) => value
                                                      .data()!['notifiersId']);
                                          notifiersId
                                              .remove(req.approveRequesterID);
                                          FirebaseFirestore.instance
                                              .collection('requests')
                                              .doc(doc.id)
                                              .update(
                                                  {'notifiersId': notifiersId});
                                        });
                                      });

                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(controller.myUId)
                                          .collection('notifications')
                                          .where('requestId',
                                              isEqualTo: req.requestId)
                                          .get()
                                          .then((querySnapshot) {
                                        querySnapshot.docs.forEach((doc) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(controller.myUId)
                                              .collection('notifications')
                                              .doc(doc.id)
                                              .delete();
                                        });
                                      });
                                    });
                                  });

                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(controller.myUId)
                                      .collection('notifications')
                                      .doc(document.id)
                                      .delete();

                                  snackBar(
                                      context: context,
                                      contentType: ContentType.success,
                                      title: "Done !".tr,
                                      body: "Notification Approved".tr);
                                });
                              },
                              notifierEmail: req.notifierEmail,
                              notifierName: req.notifierName,
                              onRemoveTap: () {
                                FirebaseFirestore.instance
                                    .collection('requests')
                                    .where('requestId',
                                        isEqualTo: req.requestId)
                                    .get()
                                    .then((querySnapshot) {
                                  querySnapshot.docs.forEach((doc) async {
                                    List<dynamic> notifiersId =
                                        await FirebaseFirestore.instance
                                            .collection('requests')
                                            .doc(doc.id)
                                            .get()
                                            .then((value) =>
                                                value.data()!['notifiersId']);
                                    notifiersId.remove(req.approveRequesterID);
                                    FirebaseFirestore.instance
                                        .collection('requests')
                                        .doc(doc.id)
                                        .update({'notifiersId': notifiersId});
                                  });
                                });

                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(controller.myUId)
                                    .collection('notifications')
                                    .where('requestId',
                                        isEqualTo: req.requestId)
                                    .get()
                                    .then((querySnapshot) {
                                  querySnapshot.docs.forEach((doc) {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(controller.myUId)
                                        .collection('notifications')
                                        .doc(doc.id)
                                        .delete();
                                  });
                                });

                                snackBar(
                                    context: context,
                                    contentType: ContentType.success,
                                    title: "Done!".tr,
                                    body: "Notification Removed".tr);
                              },
                              onViewTap: () {},
                            );
                          })
                          .toList()
                          .cast(),
                    );
            },
          );
        }),
      ),
    );
  }
}
