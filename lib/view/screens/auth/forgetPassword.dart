import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio/controller/forgetPass_controller.dart';
import 'package:socio/core/functions/validator.dart';
import 'package:socio/view/widgets/reusable_button.dart';
import 'package:socio/view/widgets/reusable_form_field.dart';

class ForgetPass extends StatelessWidget {
  ForgetPass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ForgetPassCtrl controller = Get.put(ForgetPassCtrl());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Forget Password".tr,
          style: Theme.of(context)
              .textTheme
              .headline1!
              .copyWith(color: Colors.grey),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: Form(
            key: controller.formState,
            child: ListView(
              children: [
                Text(
                  "Check Email ..".tr,
                  style: Theme.of(context).textTheme.headline2,
                ),
                const SizedBox(height: 20),
                ReusableFormField(
                  checkValidate: (val) {
                    return validator(
                        controller.emailCtrl.text, 5, 100, "email");
                  },
                  label: "emailLabel".tr,
                  hint: "Enter your email".tr,
                  icon: const Icon(Icons.email_outlined),
                  controller: controller.emailCtrl,
                  isPassword: false,
                ),
                const SizedBox(height: 20),
                ReUsableButton(
                  text: "Send".tr,
                  onPressed: () {
                    controller.submitEmail(context);
                  },
                  height: 10,
                  radius: 10,
                  colour: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
