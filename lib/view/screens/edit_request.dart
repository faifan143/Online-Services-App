import 'package:flutter/material.dart';
import 'package:flutter_custom_selector/flutter_custom_selector.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/constants/appTheme.dart';
import 'package:socio/model/request_model.dart';

class EditRequest extends StatelessWidget {
  EditRequest({Key? key, required this.req}) : super(key: key);
  final RequestModel req;

  TextEditingController textCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MainScreenController controller = Get.put(MainScreenController());
    textCtrl.text = req.text;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(controller.myServices.sharedPref.getString("lang") == "en"
              ? IconlyBroken.arrow_left_2
              : IconlyBroken.arrow_right_2),
          color: Colors.black,
        ),
        title: Text("Edit Request".tr,
            style: englishTheme.textTheme.bodyText1!
                .copyWith(fontWeight: FontWeight.w300)),
        actions: [
          TextButton(
            onPressed: () {
              controller.editRequest(
                text: textCtrl.text,
                context: context,
                requestId: req.requestId,
              );
            },
            child: Text(
              "Submit".tr,
              style: englishTheme.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            width: 12,
          )
        ],
      ),
      body: GetBuilder<MainScreenController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 25),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage('${req.image}'),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    children: [
                      Text('${req.username}'),
                      const SizedBox(height: 5),
                      Text(
                        'Public'.tr,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: TextFormField(
                  autofocus: true,
                  controller: textCtrl,
                  decoration: InputDecoration(
                    hintText:
                        '${"What is on your Request,".tr} ${req.username}?',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CustomMultiSelectField<String>(
                title: "Tags".tr,
                items: controller.availableTags,
                enableAllOptionSelect: true,
                onSelectionDone: controller.onCategoriesSelectionComplete,
                itemAsString: (item) => item.toString(),
                selectedItemColor: Colors.blueAccent,
              ),
            ],
          ),
        );
      }),
    );
  }
}
