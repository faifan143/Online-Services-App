import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:socio/controller/login_controller.dart';
import 'package:socio/core/constants/AppRoutes.dart';
import 'package:socio/core/functions/signupSuccessful.dart';
import 'package:socio/core/functions/validator.dart';
import 'package:socio/core/localization/changeLocale.dart';
import 'package:socio/core/services/sharedPreferences.dart';
import 'package:socio/view/widgets/reusable_button.dart';
import 'package:socio/view/widgets/reusable_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    LocaleController localeController = Get.put(LocaleController());
    MyServices myServices = Get.find();
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<LoginController>(
        builder: (controller) {
          return ModalProgressHUD(
            inAsyncCall: controller.loading,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: controller.formState,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 200,
                    ),
                    ListTile(
                      title: Text(
                        "LOGIN".tr,
                        style: const TextStyle(fontSize: 28),
                      ),
                      subtitle: Text(
                        "Login now and share the moment with friends.".tr,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ReusableFormField(
                      checkValidate: (value) {
                        return validator(
                            controller.myLoginEmail.text, 5, 100, "email");
                      },
                      isPassword: false,
                      label: "emailLabel".tr,
                      hint: "Enter your email".tr,
                      keyType: TextInputType.emailAddress,
                      icon: const Icon(Icons.email_outlined),
                      controller: controller.myLoginEmail,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusableFormField(
                        checkValidate: (value) {
                          return validator(controller.myLoginPassword.text, 5,
                              30, "password");
                        },
                        isPassword: controller.isPassword,
                        onTap: (() => controller.changePassState()),
                        controller: controller.myLoginPassword,
                        label: "PasswordLabel".tr,
                        hint: "Enter your password".tr,
                        keyType: TextInputType.text,
                        icon: const Icon(Icons.lock_outline)),
                    const SizedBox(
                      height: 20,
                    ),
                    ReUsableButton(
                      text: "loginButton".tr,
                      height: 20,
                      radius: 10,
                      colour: Colors.blueAccent,
                      onPressed: () async {
                        UserCredential response =
                            await controller.login(context);

                        if ((response != null)) {
                          if (!response.user!.emailVerified) {
                            controller.changeLoadingState();
                            snackBar(
                                context: context,
                                contentType: ContentType.failure,
                                title: "Failed logging in !!".tr,
                                body:
                                    "Email isn't verified , we are sending you another verification email .."
                                        .tr);
                            response.user!.sendEmailVerification();
                          } else {
                            controller.changeLoadingState();
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(response.user?.uid)
                                .update({'isVerified': true});
                            Get.offAllNamed(AppRoutes.mainScreen);
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        controller.gotoForgetPassword();
                      },
                      child: Text(
                        "Forgot Password".tr,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't Have An Account?".tr),
                        Text(" "),
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.signup);
                          },
                          child: Text(
                            "SignUpText".tr,
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
        },
      ),
    );
  }
}
