import 'package:age_calculator/age_calculator.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_selector/widget/flutter_single_select.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:socio/controller/main_screen_controller.dart';
import 'package:socio/core/constants/AppColors.dart';
import 'package:socio/core/constants/appTheme.dart';
import 'package:socio/core/functions/signupSuccessful.dart';
import 'package:socio/core/functions/validator.dart';
import 'package:socio/view/widgets/profile_viewer.dart';
import 'package:socio/view/widgets/reusable_form_field.dart';

import '../widgets/reusable_button.dart';

class EditProfileScreen extends StatelessWidget {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController expertiseController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController experiencedProgramsController = TextEditingController();
  TextEditingController programmingLangsController = TextEditingController();

  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainScreenController controller = Get.put(MainScreenController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              controller.myServices.sharedPref.getString("lang") == "en"
                  ? IconlyBroken.arrow_left_2
                  : IconlyBroken.arrow_right_2,
              color: Colors.blue,
            )),
        title: Text(
          "Edit Profile".tr,
          style: TextStyle(color: Colors.blue),
        ),
        actions: [
          TextButton(
              onPressed: () {
                controller.updateProfileLoading = true;
                controller.uploadProfileImage(
                  username: nameCtrl.text,
                  email: emailCtrl.text,
                  address: controller.selectedProvidence,
                  phone: phoneCtrl.text,
                  anotherExpertise: expertiseController.text,
                  formerExperiences: experienceController.text,
                  experiencedPrograms: experiencedProgramsController.text,
                  programmingLangs: programmingLangsController.text,
                );
              },
              child: Text(
                "UPDATE".tr,
                style: TextStyle(fontSize: 16),
              )),
        ],
      ),
      body: GetBuilder<MainScreenController>(
        builder: (controller) {
          nameCtrl.text = controller.myUsername;
          phoneCtrl.text = controller.myPhone;
          passwordCtrl.text = controller.myPassword;
          emailCtrl.text = controller.myEmail;
          addressCtrl.text = controller.myAddress;
          experienceController.text = controller.myFormerExperiences.join(',');
          expertiseController.text = controller.myAnotherExpertise.join(',');
          experiencedProgramsController.text =
              controller.myExperiencedTools.join(',');
          programmingLangsController.text =
              controller.myProgrammingLanguagesList.join(',');
          DateTime birthday = DateTime.parse(controller.myAge);
          DateDuration duration;
          // Find out your age as of today's date 2021-03-08
          duration = AgeCalculator.age(birthday);
          return ModalProgressHUD(
            inAsyncCall: controller.updateProfileLoading,
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
                                CircleAvatar(
                                  radius: 65,
                                  backgroundImage:
                                      NetworkImage(controller.myImage),
                                ),
                                Spacer(),
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
                                                      fontWeight:
                                                          FontWeight.w300,
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
                                              controller.getTranslatedLevel(
                                                  controller.myExperienceLevel),
                                              style: englishTheme
                                                  .textTheme.bodyText1!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w300,
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
                                                      fontWeight:
                                                          FontWeight.w300,
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
                              "     ${"gender".tr} : ${controller.getTranslatedGender(controller.myGender)}",
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
                              "     ${"Address".tr} : ${controller.myAddress.tr}",
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
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: OutlinedButton(
                              onPressed: () {
                                controller.getProfileImage();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Change Profile Image".tr,
                                    style: TextStyle(
                                      color: AppColors.gradientDarkColor,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    IconlyBroken.edit,
                                    size: 15,
                                    color: AppColors.gradientDarkColor,
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(height: 15),
                        ReusableFormField(
                          isPassword: false,
                          controller: nameCtrl,
                          label: 'Username'.tr,
                          hint: 'Edit your username'.tr,
                          icon: Icon(IconlyBroken.user_2),
                          checkValidate: (val) {
                            return validator(nameCtrl.text, 3, 50, "username");
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        // ReusableFormField(
                        //   isPassword: false,
                        //   label: 'Address'.tr,
                        //   controller: addressCtrl,
                        //   hint: 'Edit your address'.tr,
                        //   icon: Icon(IconlyBroken.location),
                        //   checkValidate: (val) {},
                        // ),
                        CustomSingleSelectField<String>(
                          items: controller.providences,
                          initialValue: addressCtrl.text,
                          title: "Providence".tr,
                          onSelectionDone: (value) {
                            controller.assignEngProvidenceToSP(value);
                          },
                          itemAsString: (item) => item,
                        ),

                        SizedBox(
                          height: 15,
                        ),
                        ReusableFormField(
                          isPassword: false,
                          label: 'Phone'.tr,
                          controller: phoneCtrl,
                          keyType: TextInputType.number,
                          hint: 'Edit your phone'.tr,
                          icon: Icon(IconlyBroken.info_circle),
                          checkValidate: (val) {
                            return validator(phoneCtrl.text, 10, 10, "phone");
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),

                        ReUsableButton(
                          height: 20,
                          radius: 10,
                          onPressed: () async {
                            controller.updateProfileLoading = true;
                            controller.refresh();
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: controller.myEmail);
                            controller.updateProfileLoading = false;
                            controller.refresh();
                            snackBar(
                                context: context,
                                contentType: ContentType.success,
                                title: "reset password".tr,
                                body:
                                    "we've sent a reset password link to your email"
                                        .tr);
                          },
                          colour: Colors.blueGrey,
                          text: 'Edit your age'.tr,
                        ),

                        if (controller.amIAServicer) const SizedBox(height: 20),
                        if (controller.amIAServicer)
                          ReusableFormField(
                              isPassword: false,
                              icon: const Icon(IconlyBroken.work),
                              checkValidate: (val) => null,
                              label: "Programming Languages".tr,
                              hint:
                                  "Write all your programming languages with a ',' between them .."
                                      .tr,
                              controller: programmingLangsController),
                        if (controller.amIAServicer) const SizedBox(height: 20),
                        if (controller.amIAServicer)
                          ReusableFormField(
                              isPassword: false,
                              icon: const Icon(IconlyBroken.work),
                              checkValidate: (val) => null,
                              label: "Experienced tools & programs".tr,
                              hint:
                                  "Write all your experienced programs with a ',' between them .."
                                      .tr,
                              controller: experiencedProgramsController),
                        if (controller.amIAServicer) const SizedBox(height: 20),
                        if (controller.amIAServicer)
                          ReusableFormField(
                              isPassword: false,
                              icon: const Icon(IconlyBroken.star),
                              checkValidate: (val) => null,
                              label: "Another Expertise".tr,
                              hint:
                                  "Write all your other expertise with a ',' between them .."
                                      .tr,
                              controller: expertiseController),
                        if (controller.amIAServicer) const SizedBox(height: 20),
                        if (controller.amIAServicer)
                          ReusableFormField(
                              isPassword: false,
                              icon: const Icon(IconlyBroken.work),
                              checkValidate: (val) => null,
                              label: "Former Experiences".tr,
                              hint:
                                  "Write all your former experiences with a ',' between them .."
                                      .tr,
                              controller: experienceController),
                        if (controller.amIAServicer) const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
