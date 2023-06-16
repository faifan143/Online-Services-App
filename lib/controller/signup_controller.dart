import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:socio/core/functions/checkPasswordMatch.dart';
import 'package:socio/core/functions/signupSuccessful.dart';
import 'package:socio/core/localization/changeLocale.dart';
import 'package:socio/model/service_user.dart';

class SignupController extends GetxController {
  TextEditingController myEmail = TextEditingController();
  TextEditingController myPassword = TextEditingController();
  TextEditingController myPhone = TextEditingController();
  TextEditingController myUsername = TextEditingController();
  TextEditingController myRePassword = TextEditingController();
  TextEditingController myAddress = TextEditingController();
  late String myAge;
  late ServicerUser userModel;
  late UserCredential userCredential;
  bool loading = false;
  bool isPassword = true;
  bool isRePassword = true;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  changeAge(dynamic date) {
    DateTime dateTime = DateTime.parse(date.toString());
    myAge = "$dateTime";
    update();
  }

  changePassState() {
    isPassword = !isPassword;
    update();
  }

  changeRePassState() {
    isRePassword = !isRePassword;
    update();
  }

  changeLoadingState() {
    loading = !loading;
    update();
  }

  signup(BuildContext context) async {
    var dataState = formState.currentState;
    if (dataState!.validate() &&
        checkPasswordMatch(
            password: myPassword.text,
            rePassword: myRePassword.text,
            context: context)) {
      try {
        changeLoadingState();
        await fireBaseSignup();
        fireStoreSignup();
        snackBar(
            context: context,
            title: "Congrats !".tr,
            body: "Signed up successfully check your email to verify it ..".tr,
            contentType: ContentType.success);

        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          changeLoadingState();
          snackBar(
              context: context,
              title: "Watch out !".tr,
              body: "The password provided is too weak.".tr,
              contentType: ContentType.warning);
        } else if (e.code == 'email-already-in-use') {
          changeLoadingState();
          snackBar(
              context: context,
              title: "Watch out !".tr,
              body: "The account already exists for that email.".tr,
              contentType: ContentType.warning);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  fireBaseSignup() async {
    userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: myEmail.text, password: myPassword.text);
    userCredential.user!.sendEmailVerification();
  }

  fireStoreSignup() {
    userModel = ServicerUser(
      servicer: false,
      email: myEmail.text,
      password: myPassword.text,
      phone: myPhone.text,
      image:
          'https://cdn-icons-png.flaticon.com/512/188/188466.png?w=740&t=st=1676831240~exp=1676831840~hmac=cf016c0081e2c98ba8153c04403429bbecb2e85fb9e0b1b9c220ed0a808b0e69',
      isVerified: false,
      uId: userCredential.user!.uid,
      username: myUsername.text,
      address: selectedProvidence,
      age: myAge,
      gender: selectedGender,
      providence: 'unknown',
      categories: [],
      programmingLanguagesList: [],
      experiencedTools: [],
      experienceLevel: 'unknown',
      anotherExpertise: [],
      formerExperiences: [],
      rate: "unknown",
      raters: 'unknown',
      disRaters: 'unknown',
      ratersId: [],
      disRatersId: [],
      contacts: [],
      serviced: 'unknown',
    );

    FirebaseFirestore.instance
        .collection("users")
        .doc(userCredential.user?.uid)
        .set(userModel.toMap());
  }

// Servicer Signup controller section //
  late String selectedProvidence = "unknown";
  late String selectedLevel = "unknown";
  late String selectedGender = "unknown";
  late String rate = "5";

  bool loading2 = false;
  TextEditingController myExpertiseController = TextEditingController();
  TextEditingController myExperienceController = TextEditingController();
  TextEditingController myAgeController = TextEditingController();
  bool isProgrammer = false;
  List<String> selectedCategory = [];
  List<String> providences = [
    "Aleppo".tr,
    "Damascus".tr,
    "Damascus-Country".tr,
    "Tartous".tr,
    "Latakia".tr,
    "Homs".tr,
    "Hama".tr,
    "Der-Ezzour".tr,
    "Daraa".tr,
    "Rakka".tr,
    "Idleb".tr,
    "Hasaka".tr,
    "Qunaytira".tr,
    "Qameshli".tr,
  ];
  List<String> categories = [
    "Software and Data Analysis".tr,
    "Freelance".tr,
    "Graphic".tr,
    "Technician".tr,
    "Engineer".tr,
    "Doctors & Nurses".tr,
    "Plumber".tr,
    "Electrician".tr
  ];
  List<String> experienceLevel = [
    "Beginner".tr,
    "Junior".tr,
    "Intermediate".tr,
    "Senior".tr,
    "Professional".tr
  ];
  List<String> programmingLangs = [];
  List<String> experiencedPrograms = [];
  List<String> formerExpertise = [];
  List<String> formerExperiences = [];
  final List<String> genderItems = [
    "Male".tr,
    "Female".tr,
  ];

  final formKey = GlobalKey<FormState>();
  LocaleController locale = Get.put(LocaleController());

  selectProvidence(String providence) {
    if (locale.myServices.sharedPref.getString('lang') == "ar") {
      switch (providence) {
        case "حلب":
          selectedProvidence = "Aleppo";
          break;
        case "دمشق":
          selectedProvidence = "Damascus";
          break;
        case "القامشلي":
          selectedProvidence = "Qameshli";
          break;
        case "درعا":
          selectedProvidence = "Daraa";
          break;
        case "الحسكة":
          selectedProvidence = "Hasaka";
          break;
        case "ادلب":
          selectedProvidence = "Idleb";
          break;
        case "طرطوس":
          selectedProvidence = "Tartous";
          break;
        case "اللاذقية":
          selectedProvidence = "Latakia";
          break;
        case "حمص":
          selectedProvidence = "Homs";
          break;
        case "حماه":
          selectedProvidence = "Hama";
          break;
        case "السويداء":
          selectedProvidence = "Al-Swaydaa";
          break;
        case "ريف دمشق":
          selectedProvidence = "Damascus-Country";
          break;
        case "دير الزور":
          selectedProvidence = "Der-Ezzour";
          break;
        case "الرقة":
          selectedProvidence = "Rakka";
          break;
      }
    } else {
      selectedProvidence = providence;
    }

    update();
  }

  selectLevel(String level) {
    if (locale.myServices.sharedPref.getString('lang') == "ar") {
      switch (level) {
        case "مبتدئ":
          selectedLevel = "Beginner";
          break;
        case "قليل الخبرة":
          selectedLevel = "Junior";
          break;
        case "متوسط الخبرة":
          selectedLevel = "Intermediate";
          break;
        case "خبير":
          selectedLevel = "Senior";
          break;
        case "محترف":
          selectedLevel = "Professional";
          break;
      }
    } else {
      selectedLevel = level;
    }
    update();
  }

  changeLoadingState2() {
    loading2 = !loading2;
    update();
  }

  void onCategoriesSelectionComplete(values) {
    selectedCategory.clear();
    if (locale.myServices.sharedPref.getString('lang') == "ar") {
      for (String value in values) {
        if (value == "محلل أنظمة و بيانات") {
          selectedCategory.add("Software and Data Analysis");
        }
        if (value == " عمل حر") {
          selectedCategory.add("Freelance");
        }
        if (value == ("غرافيكس")) {
          selectedCategory.add("Graphic");
        }
        if (value == ("تقني")) {
          selectedCategory.add("Technician");
        }
        if (value == ("مهندس")) {
          selectedCategory.add("Engineer");
        }
        if (value == ("طبيب ة أو ممرض ة")) {
          selectedCategory.add("Doctors & Nurses");
        }
        if (value == ("عامل صحية")) {
          selectedCategory.add("Plumber");
        }
        if (value == ("عامل كهرباء")) {
          selectedCategory.add("Electrician");
        }
      }
    } else {
      for (String value in values) {
        selectedCategory.add(value);
      }
    }

    update();
  }

  servicerSignup(BuildContext context) async {
    var dataState = formKey.currentState;
    if (selectedCategory.isEmpty) {
      snackBar(
          context: context,
          contentType: ContentType.failure,
          title: "Wait a minute !!".tr,
          body: "Select your category".tr);
    } else if (selectedLevel == "unknown") {
      snackBar(
          context: context,
          contentType: ContentType.failure,
          title: "Wait a minute !!".tr,
          body: "Select your Level".tr);
    } else if (dataState!.validate() &&
        checkPasswordMatch(
            password: myPassword.text,
            rePassword: myRePassword.text,
            context: context)) {
      formerExperiences.clear();
      formerExpertise.clear();
      formerExpertise = myExpertiseController.text.split(",");
      formerExperiences = myExperienceController.text.split(",");

      try {
        changeLoadingState2();
        await fireBaseSignup();
        //TODO firestore servicer signup
        firestoreServicerSignup();
        snackBar(
            context: context,
            title: "Congrats !".tr,
            body: "Signed up successfully check your email to verify it ..".tr,
            contentType: ContentType.success);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          changeLoadingState2();
          snackBar(
              context: context,
              title: "Watch out !".tr,
              body: "The password provided is too weak.".tr,
              contentType: ContentType.warning);
        } else if (e.code == 'email-already-in-use') {
          changeLoadingState2();
          snackBar(
              context: context,
              title: "Watch out !".tr,
              body: "The account already exists for that email.".tr,
              contentType: ContentType.warning);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  late ServicerUser servicerSignupUser;
  firestoreServicerSignup() {
    servicerSignupUser = ServicerUser(
      servicer: true,
      email: myEmail.text,
      password: myPassword.text,
      phone: myPhone.text,
      image:
          'https://cdn-icons-png.flaticon.com/512/188/188466.png?w=740&t=st=1676831240~exp=1676831840~hmac=cf016c0081e2c98ba8153c04403429bbecb2e85fb9e0b1b9c220ed0a808b0e69',
      isVerified: false,
      uId: userCredential.user!.uid,
      username: myUsername.text,
      address: selectedProvidence,
      age: myAge,
      gender: selectedGender,
      providence: selectedProvidence,
      categories: selectedCategory,
      programmingLanguagesList: programmingLangs,
      experiencedTools: experiencedPrograms,
      experienceLevel: selectedLevel,
      anotherExpertise: formerExpertise,
      formerExperiences: formerExperiences,
      rate: rate,
      raters: '0',
      disRaters: '0',
      ratersId: [],
      disRatersId: [],
      contacts: [],
      serviced: '0',
    );

    FirebaseFirestore.instance
        .collection("users")
        .doc(userCredential.user?.uid)
        .set(servicerSignupUser.toMap());
  }
}
