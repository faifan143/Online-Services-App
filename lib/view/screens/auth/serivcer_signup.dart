import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_selector/flutter_custom_selector.dart';
// import 'package:flutter_custom_selector/widget/flutter_single_select.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:socio/controller/signup_controller.dart';
import 'package:socio/core/constants/AppRoutes.dart';
import 'package:socio/view/widgets/reusable_button.dart';
import 'package:socio/view/widgets/reusable_form_field.dart';

class ServicerSignup extends StatelessWidget {
  const ServicerSignup({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(SignupController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<SignupController>(builder: (controller) {
        return ModalProgressHUD(
          inAsyncCall: controller.loading2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                ListTile(
                  title: Text(
                    "SignUpText".tr,
                    style: const TextStyle(fontSize: 28),
                  ),
                  subtitle: Text(
                    "Signup now and share the moment with friends.".tr,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 30),
                CustomMultiSelectField<String>(
                  title: "Category".tr,
                  items: controller.categories,
                  enableAllOptionSelect: true,
                  onSelectionDone: controller.onCategoriesSelectionComplete,
                  itemAsString: (item) => item.toString(),
                  selectedItemColor: Colors.blueAccent,
                ),
                const SizedBox(height: 20),
                if (controller.isProgrammer)
                  MultiSelectContainer(
                      itemsDecoration: MultiSelectDecorations(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.green.withOpacity(0.2),
                              Colors.grey.withOpacity(0.1),
                            ]),
                            border: Border.all(color: Colors.green[200]!),
                            borderRadius: BorderRadius.circular(20)),
                        selectedDecoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.green, Colors.lightGreen]),
                            border: Border.all(color: Colors.green[700]!),
                            borderRadius: BorderRadius.circular(5)),
                        disabledDecoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(color: Colors.grey[500]!),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      items: [
                        MultiSelectCard(value: 'Dart', label: 'Dart'),
                        MultiSelectCard(value: 'Python', label: 'Python'),
                        MultiSelectCard(
                          value: 'JavaScript',
                          label: 'JavaScript',
                        ),
                        MultiSelectCard(value: 'Java', label: 'Java'),
                        MultiSelectCard(value: 'C#', label: 'C#'),
                        MultiSelectCard(value: 'C++', label: 'C++'),
                        MultiSelectCard(value: 'MySQL', label: 'MySQL'),
                      ],
                      onChange: (allSelectedItems, selectedItem) {
                        controller.programmingLangs = allSelectedItems;
                      }),
                if (controller.isProgrammer) const SizedBox(height: 20),
                Text("Experienced with :".tr),
                const SizedBox(height: 20),
                MultiSelectContainer(
                    itemsDecoration: MultiSelectDecorations(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.blue.withOpacity(0.2),
                            Colors.grey.withOpacity(0.1),
                          ]),
                          border: Border.all(color: Colors.blue[200]!),
                          borderRadius: BorderRadius.circular(20)),
                      selectedDecoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Colors.blue, Colors.lightBlue]),
                          border: Border.all(color: Colors.blue[700]!),
                          borderRadius: BorderRadius.circular(5)),
                      disabledDecoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(color: Colors.grey[500]!),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    items: [
                      MultiSelectCard(
                        value: 'Microsoft_Word',
                        label: 'Microsoft Word',
                      ),
                      MultiSelectCard(
                        value: 'Microsoft_PowerPoint',
                        label: 'Microsoft PowerPoint',
                      ),
                      MultiSelectCard(value: 'Unity', label: 'Unity'),
                      MultiSelectCard(
                          value: 'Android_Studio', label: 'Android Studio'),
                      MultiSelectCard(
                          value: 'Visual_Studio', label: 'Visual Studio'),
                      MultiSelectCard(
                          value: 'SocialMedia_Apps', label: 'SocialMedia Apps'),
                      MultiSelectCard(
                        value: 'Microsoft_Excel',
                        label: 'Microsoft Excel',
                      ),
                      MultiSelectCard(
                          value: 'Adobe_Photoshop', label: 'Adobe Photoshop'),
                      MultiSelectCard(
                          value: 'Adobe_Premier', label: 'Adobe Premier'),
                      MultiSelectCard(
                          value: 'Adobe_Aftereffects',
                          label: 'Adobe Aftereffects'),
                      MultiSelectCard(
                          value: 'Visual_Paradigm', label: 'Visual Paradigm'),
                    ],
                    onChange: (allSelectedItems, selectedItem) {
                      controller.experiencedPrograms = allSelectedItems;
                    }),
                const SizedBox(height: 20),
                CustomSingleSelectField<String>(
                  items: controller.experienceLevel,
                  title: "Experience Level".tr,
                  onSelectionDone: (value) {
                    controller.selectLevel(value);
                  },
                  itemAsString: (item) => item,
                ),
                const SizedBox(height: 20),
                ReusableFormField(
                    isPassword: false,
                    icon: const Icon(IconlyBroken.star),
                    checkValidate: (val) => null,
                    label: "Another Expertise".tr,
                    hint:
                        "Write all your other expertise with a ',' between them .."
                            .tr,
                    controller: controller.myExpertiseController),
                const SizedBox(height: 20),
                ReusableFormField(
                    isPassword: false,
                    icon: const Icon(IconlyBroken.work),
                    checkValidate: (val) => null,
                    label: "Former Experiences".tr,
                    hint:
                        "Write all your former experiences with a ',' between them .."
                            .tr,
                    controller: controller.myExperienceController),
                const SizedBox(height: 20),
                ReUsableButton(
                  text: "SignUp to offer services".tr,
                  height: 10,
                  radius: 10,
                  colour: Colors.blueAccent,
                  onPressed: () async {
                    UserCredential response =
                        await controller.servicerSignup(context);
                    if (response != null) {
                      controller.changeLoadingState2();
                      Get.offAllNamed(AppRoutes.login);
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}
