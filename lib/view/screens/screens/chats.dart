import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/model/user_model.dart';
import 'package:socio/view/screens/screens/in_chat_screen.dart';

class ChatsScreen extends GetView<MainScreenController> {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return GetBuilder<MainScreenController>(
      builder: (controller) {
        return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('contacts', arrayContains: controller.myUId)
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
                      ? SizedBox(
                          height: (MediaQuery.of(context).size.height) / 2,
                          child: Center(child: Text("No Chats".tr)),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: ListView(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  UserModel userModel =
                                      UserModel.fromJson(data);
                                  return Column(
                                    children: [
                                      ChatUser(
                                        uModel: userModel,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 15),
                                        child: Container(
                                          width: double.infinity,
                                          height: 1,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ],
                                  );
                                })
                                .toList()
                                .cast(),
                          ),
                        );
                },
              ),
              SizedBox(
                height: 100,
              )
            ]);
      },
    );
  }
}

class ChatUser extends StatelessWidget {
  const ChatUser({
    Key? key,
    required this.uModel,
  }) : super(key: key);
  final UserModel uModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(InChatScreen(
          model: uModel,
          receiverId: uModel.uId,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(uModel.image),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      uModel.username,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      uModel.email,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
