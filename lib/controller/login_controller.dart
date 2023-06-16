import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:socio/core/constants/AppRoutes.dart';
import 'package:socio/core/functions/signupSuccessful.dart';
import 'package:socio/core/services/sharedPreferences.dart';
import 'package:socio/model/service_user.dart';

class LoginController extends GetxController {
  // Text editing controllers for the login email and password fields.
  TextEditingController myLoginEmail = TextEditingController();
  TextEditingController myLoginPassword = TextEditingController();

  // Boolean to toggle password visibility.
  bool isPassword = true;

  // Boolean to display loading indicator.
  bool loading = false;

  // Object representing a user in the database.
  ServicerUser? userModel;

  // Form key to be used for validation and saving.
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  // Object representing a user in the app.
  User? user;

  // Function to handle login attempts.
  login(BuildContext context) async {
    // Retrieve the current state of the form.
    var dataState = formState.currentState;

    // Validate the form.
    if (dataState!.validate()) {
      try {
        // Show loading indicator.
        changeLoadingState();

        // Attempt to sign in the user with the provided email and password.
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: myLoginEmail.text, password: myLoginPassword.text);

        // Return the user credentials.
        return userCredential;
      } on FirebaseAuthException catch (e) {
        // If the user is not found, display a snackbar message.
        if (e.code == 'user-not-found') {
          changeLoadingState();
          snackBar(
              context: context,
              contentType: ContentType.warning,
              title: "user-not-found".tr,
              body: "No user found for that email.".tr);
        }
        // If the password is incorrect, display a snackbar message.
        else if (e.code == 'wrong-password') {
          changeLoadingState();
          snackBar(
              context: context,
              contentType: ContentType.warning,
              title: "wrong-password".tr,
              body: "Wrong password provided for that user.".tr);
        }
      }
    }
  }

  // Function to toggle password visibility.
  changePassState() {
    isPassword = !isPassword;
    update();
  }

  // Function to toggle loading indicator.
  changeLoadingState() {
    loading = !loading;
    update();
  }

  // Object representing the app's services.
  MyServices myServices = Get.find();

  // Function to navigate to the forget password screen.
  gotoForgetPassword() {
    Get.toNamed(AppRoutes.forgetPass);
  }
}
