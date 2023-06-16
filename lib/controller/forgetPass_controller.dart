import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio/core/constants/AppRoutes.dart';
import 'package:socio/core/functions/auth_status.dart';
import 'package:socio/core/functions/signupSuccessful.dart';

// Abstract class for Forget Password controller
abstract class ForgetPasswordController extends GetxController {
  // Function to submit email
  submitEmail(BuildContext context);
}

// Implementation of Forget Password controller
class ForgetPassCtrl extends ForgetPasswordController {
  // Initialize necessary variables and objects
  late TextEditingController emailCtrl;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late AuthStatus _status;

  // Initialize email controller on initialization of controller
  @override
  void onInit() {
    emailCtrl = TextEditingController();
    super.onInit();
  }

  // Function to reset password given an email address
  Future<AuthStatus> resetPassword({required String email}) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));
    return _status;
  }

  // Function to submit email for resetting password
  @override
  submitEmail(BuildContext context) async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      final _status2 = await resetPassword(
        email: emailCtrl.text.trim(),
      );
      if (_status2 == AuthStatus.successful) {
        // Show success snackbar and navigate to login page
        snackBar(
            context: context,
            contentType: ContentType.success,
            title: "Done !!".tr,
            body: "Reset Password Link Has Been Sent To Your Email ..".tr);
        Get.offAllNamed(AppRoutes.login);
      } else {
        // Show error snackbar with error message
        final error = AuthExceptionHandler.generateErrorMessage(_status2);
        snackBar(
            context: context,
            contentType: ContentType.failure,
            title: "Oops ! ".tr,
            body: error);
      }
    }
  }
}
