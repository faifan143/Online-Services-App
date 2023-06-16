import 'package:get/get.dart';

validator(var val, int min, int max, var type) {
  if (type == "username") {
    if (!GetUtils.isUsername(val)) {
      return "Invalid Username";
    }
  }
  if (type == "email") {
    if (!GetUtils.isEmail(val)) {
      return "Invalid Email";
    }
  }
  if (type == "phone") {
    if (!GetUtils.isPhoneNumber(val)) {
      return "Invalid Phone Number";
    }
  }

  if (val.isEmpty) {
    return "Can't Be Empty";
  }

  if (val.length < min) {
    return "Can't Be Less Than $min";
  }
  if (val.length > max) {
    return "Can't Be More Than $max";
  }
}
