import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio/core/constants/AppRoutes.dart';

class ServicerSignupController extends GetxController {
  late String selectedProvidence = "";
  late String selectedLevel = "";
  late String selectedGender = "";
  bool loading = false;
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
  String? selectedGenderValue;
  final formKey = GlobalKey<FormState>();

  signup() {
    Get.offAllNamed(AppRoutes.login);
  }
}
