import 'package:flutter/material.dart';
import 'package:flutter_custom_selector/flutter_custom_selector.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/constants/appTheme.dart';

class NewRequest extends StatelessWidget {
  NewRequest({Key? key}) : super(key: key);
  TextEditingController textCtrl = TextEditingController();
  TextEditingController tagCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MainScreenController controller = Get.put(MainScreenController());
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
        title: Text("Create Request".tr,
            style: englishTheme.textTheme.bodyText1!
                .copyWith(fontWeight: FontWeight.w300)),
        actions: [
          TextButton(
            onPressed: () {
              controller.createRequest(
                text: textCtrl.text,
                context: context,
              );
            },
            child: Text(
              "Request".tr,
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
                    backgroundImage: NetworkImage('${controller.myImage}'),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    children: [
                      Text('${controller.myUsername}'),
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
                  controller: textCtrl,
                  decoration: InputDecoration(
                    hintText:
                        '${"What is on your Request,".tr} ${controller.myUsername}?',
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
