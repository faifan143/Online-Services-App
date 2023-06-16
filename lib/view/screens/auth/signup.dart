import 'package:bottom_picker/bottom_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_selector/widget/flutter_single_select.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:socio/controller/signup_controller.dart';
import 'package:socio/core/constants/AppRoutes.dart';
import 'package:socio/core/functions/validator.dart';
import 'package:socio/view/screens/auth/login.dart';
import 'package:socio/view/widgets/reusable_button.dart';
import 'package:socio/view/widgets/reusable_form_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(SignupController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<SignupController>(builder: (controller) {
        return ModalProgressHUD(
          inAsyncCall: controller.loading,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: controller.formState,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
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
                  const SizedBox(height: 50),
                  ReusableFormField(
                    checkValidate: (value) {
                      return validator(
                          controller.myUsername.text, 3, 50, "username");
                    },
                    isPassword: false,
                    label: "Username".tr,
                    controller: controller.myUsername,
                    hint: "Enter your username".tr,
                    keyType: TextInputType.text,
                    icon: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReUsableButton(
                    height: 20,
                    radius: 10,
                    onPressed: () {
                      BottomPicker.date(
                        title: "Set your Birthday".tr,
                        titleStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.blue),
                        onSubmit: (index) {
                          controller.changeAge(index);
                        },
                      ).show(context);
                    },
                    colour: Colors.blueGrey,
                    text: "Date of birth".tr,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButtonFormField2(
                          decoration: InputDecoration(
                            //Add isDense true and zero Padding.
                            //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            //Add more decoration as you want here
                            //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                          ),
                          isExpanded: true,
                          hint: Text(
                            "Select Your Gender".tr,
                            style: TextStyle(fontSize: 14),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 30,
                          buttonHeight: 60,
                          buttonPadding:
                              const EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          items: controller.genderItems
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return "Please select gender.".tr;
                            }
                          },
                          onChanged: (value) {
                            //Do something when changing the item if you want.
                            if (controller.locale.myServices.sharedPref
                                    .getString("lang") ==
                                "ar") {
                              if (value == "ذكر") {
                                controller.selectedGender = "Male";
                              } else if (value == "انثى") {
                                controller.selectedGender = "Female";
                              }
                            } else {
                              controller.selectedGender = value.toString();
                            }
                          },
                          onSaved: (value) {
                            if (controller.locale.myServices.sharedPref
                                    .getString("lang") ==
                                "ar") {
                              if (value == "ذكر") {
                                controller.selectedGender = "Male";
                              } else if (value == "انثى") {
                                controller.selectedGender = "Female";
                              }
                            } else {
                              controller.selectedGender = value.toString();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReusableFormField(
                    checkValidate: (value) {
                      return validator(
                          controller.myPhone.text, 10, 10, "phone");
                    },
                    isPassword: false,
                    controller: controller.myPhone,
                    label: "Phone".tr,
                    hint: "Enter your phone".tr,
                    keyType: TextInputType.phone,
                    icon: const Icon(Icons.phone_outlined),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomSingleSelectField<String>(
                    items: controller.providences,
                    title: "Providence".tr,
                    onSelectionDone: (value) {
                      controller.selectProvidence(value);
                    },
                    itemAsString: (item) => item,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReusableFormField(
                    checkValidate: (value) {
                      return validator(
                          controller.myEmail.text, 5, 100, "email");
                    },
                    isPassword: false,
                    label: "emailLabel".tr,
                    hint: "Enter your email".tr,
                    keyType: TextInputType.emailAddress,
                    icon: const Icon(Icons.email_outlined),
                    controller: controller.myEmail,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReusableFormField(
                    checkValidate: (value) {
                      return validator(
                          controller.myPassword.text, 5, 30, "password");
                    },
                    label: "PasswordLabel".tr,
                    hint: "Enter your password".tr,
                    keyType: TextInputType.text,
                    isPassword: controller.isPassword,
                    onTap: () {
                      controller.changePassState();
                    },
                    icon: const Icon(Icons.lock_outline),
                    controller: controller.myPassword,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReusableFormField(
                    checkValidate: (value) {
                      return validator(
                          controller.myRePassword.text, 5, 30, "password");
                    },
                    label: "Re-Password".tr,
                    hint: "Re-Enter your password".tr,
                    keyType: TextInputType.text,
                    isPassword: controller.isRePassword,
                    onTap: () {
                      controller.changeRePassState();
                    },
                    icon: const Icon(Icons.lock_outline),
                    controller: controller.myRePassword,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReUsableButton(
                    text: "SignUp as a user".tr,
                    height: 10,
                    radius: 10,
                    colour: Colors.blueAccent,
                    onPressed: () async {
                      UserCredential response =
                          await controller.signup(context);
                      if (response != null) {
                        controller.changeLoadingState();
                        Get.offAllNamed(AppRoutes.login);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReUsableButton(
                    text: "SignUp to offer services".tr,
                    height: 10,
                    radius: 10,
                    colour: Colors.greenAccent,
                    onPressed: () {
                      Get.toNamed(AppRoutes.servicerSignup);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already Have An Account?".tr),
                      const Text(" "),
                      InkWell(
                        onTap: () {
                          Get.off(const LoginScreen());
                        },
                        child: Text(
                          "LOGIN".tr,
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
