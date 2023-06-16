import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/constants/AppColors.dart';
import 'package:socio/model/messageModel.dart';
import 'package:socio/model/user_model.dart';

class InChatScreen extends GetView<MainScreenController> {
  InChatScreen({
    Key? key,
    required this.model,
    required this.receiverId,
  }) : super(key: key);

  UserModel model;
  String receiverId;

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return GetBuilder<MainScreenController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(
              controller.myServices.sharedPref.getString("lang") == "en"
                  ? IconlyBroken.arrow_left
                  : IconlyBroken.arrow_right,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(model.image),
              ),
              const SizedBox(width: 15),
              Text(
                model.username,
                style: const TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: controller.pickedImageLoading,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg.jpg"), fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(controller.myUId)
                        .collection('chats')
                        .doc(receiverId)
                        .collection('messages')
                        .orderBy('ntpDateTime', descending: false)
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

                      return SingleChildScrollView(
                        reverse: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20),
                          child: Column(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  MessageModel message =
                                      MessageModel.fromJson(data);

                                  if (controller.userAuth!.uid ==
                                          message.senderId &&
                                      model.uId == message.receiverId) {
                                    return Column(
                                      children: [
                                        BuildMyMessage(
                                          messageModel: message,
                                        ),
                                        const SizedBox(height: 15),
                                      ],
                                    );
                                  } else {
                                    if (!controller.chattersIds
                                        .contains(message.senderId)) {
                                      controller.chattersIds
                                          .add(message.senderId);
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(controller.myUId)
                                          .update({
                                        'contacts': controller.chattersIds
                                      });
                                    }
                                    return Column(
                                      children: [
                                        BuildContactMessage(
                                          messageModel: message,
                                        ),
                                        const SizedBox(height: 15),
                                      ],
                                    );
                                  }
                                })
                                .toList()
                                .cast(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    if (controller.postImage != null)
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: FileImage(controller.postImage!),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.removePostImage();
                            },
                            icon: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.lightBlue,
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 5),
                    Container(
                      height: 61,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(35.0),
                                boxShadow: [
                                  const BoxShadow(
                                      offset: Offset(0, 3),
                                      blurRadius: 5,
                                      color: Colors.grey)
                                ],
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: const Icon(
                                        Icons.face,
                                        color: Colors.blueAccent,
                                      ),
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        controller.emojiStage(context);
                                      }),
                                  Expanded(
                                    child: TextField(
                                      autofocus: true,
                                      controller: controller.textCtrl,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                          hintText: "Type Something...".tr,
                                          hintStyle: TextStyle(
                                              color: Colors.blueAccent),
                                          border: InputBorder.none),
                                      onTap: () {
                                        controller.emojiShowing = false;
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.photo_camera,
                                        color: Colors.blueAccent),
                                    onPressed: () {
                                      controller.getPostImage();
                                      controller.pickedImageLoading = true;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              if (controller.textCtrl.text.isNotEmpty ||
                                  controller.postImage != null) {
                                controller.sendMessage(
                                  receiverId: model.uId,
                                  text: controller.textCtrl.text,
                                  postImage: controller.postImageLink ?? '',
                                );
                                controller.textCtrl.clear();
                                if (controller.emojiShowing) {
                                  controller.emojiStage(context);
                                }
                                controller.removePostImage();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: const BoxDecoration(
                                  boxShadow: [
                                    const BoxShadow(
                                        offset: Offset(0, 3),
                                        blurRadius: 5,
                                        color: Colors.grey)
                                  ],
                                  color: Colors.blueAccent,
                                  shape: BoxShape.circle),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Offstage(
                      offstage: !controller.emojiShowing,
                      child: SizedBox(
                          height: 250,
                          child: EmojiPicker(
                            textEditingController: controller.textCtrl,
                            config: Config(
                              columns: 7,
                              emojiSizeMax: 32 *
                                  (foundation.defaultTargetPlatform ==
                                          TargetPlatform.iOS
                                      ? 1.30
                                      : 1.0),
                              verticalSpacing: 0,
                              horizontalSpacing: 0,
                              gridPadding: EdgeInsets.zero,
                              initCategory: Category.RECENT,
                              bgColor: const Color(0xFFF2F2F2),
                              indicatorColor: Colors.blue,
                              iconColor: Colors.grey,
                              iconColorSelected: Colors.blue,
                              backspaceColor: Colors.blue,
                              skinToneDialogBgColor: Colors.white,
                              skinToneIndicatorColor: Colors.grey,
                              enableSkinTones: true,
                              showRecentsTab: true,
                              recentsLimit: 28,
                              replaceEmojiOnLimitExceed: false,
                              noRecents: Text(
                                "No Recents".tr,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black26),
                                textAlign: TextAlign.center,
                              ),
                              loadingIndicator: const SizedBox.shrink(),
                              tabIndicatorAnimDuration: kTabScrollDuration,
                              categoryIcons: const CategoryIcons(),
                              buttonMode: ButtonMode.MATERIAL,
                              checkPlatformCompatibility: true,
                            ),
                          )),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class BuildMyMessage extends StatelessWidget {
  BuildMyMessage({
    Key? key,
    required this.messageModel,
  }) : super(key: key);
  MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            boxShadow: [
              const BoxShadow(
                  offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
            ],
            gradient: LinearGradient(
              colors: [
                AppColors.gradientDarkColor,
                AppColors.gradientLightColor,
              ],
            ),
            borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(10),
                topEnd: Radius.circular(10),
                bottomStart: Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (messageModel.postImage != '')
              InkWell(
                  onTap: () {
                    Get.to(() => ShowImage(image: messageModel.postImage));
                  },
                  child: Image(
                      height: 200,
                      image: NetworkImage(messageModel.postImage))),
            if (messageModel.postImage != '')
              SizedBox(
                height: 5,
              ),
            Text(
              messageModel.text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildContactMessage extends GetView<MainScreenController> {
  BuildContactMessage({
    Key? key,
    required this.messageModel,
  }) : super(key: key);
  MessageModel messageModel;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            boxShadow: [
              const BoxShadow(
                  offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
            ],
            gradient: LinearGradient(
              colors: [Color(0xff0D324D), Color(0xff7F5A83)],
            ),
            borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(10),
                topEnd: Radius.circular(10),
                bottomEnd: Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (messageModel.postImage != '')
              InkWell(
                  onTap: () {
                    Get.to(() => ShowImage(image: messageModel.postImage));
                  },
                  onLongPress: () {
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "Download . . .".tr,
                      desc:
                          "Do you want to save this photo to your gallery ?".tr,
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Yes".tr,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () async {
                            // controller.changeImageLoadingState();
                            Navigator.pop(context);
                            await GallerySaver.saveImage(messageModel.postImage,
                                albumName: 'Servicy');
                            // controller.changeImageLoadingState();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Saved To Gallery".tr)));
                          },
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(0, 179, 134, 1.0),
                            Colors.greenAccent,
                          ]),
                        ),
                        DialogButton(
                          child: Text(
                            "No".tr,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          gradient: LinearGradient(
                              colors: [Colors.pink, Colors.redAccent]),
                        )
                      ],
                    ).show();
                  },
                  child: Image(
                      height: 200,
                      image: NetworkImage(messageModel.postImage))),
            if (messageModel.postImage != '')
              SizedBox(
                height: 5,
              ),
            Text(
              messageModel.text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  const ShowImage({
    Key? key,
    required this.image,
  }) : super(key: key);
  final String image;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          child: Image(image: NetworkImage(image)),
        ),
      ),
    );
  }
}
