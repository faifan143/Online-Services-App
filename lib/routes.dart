import 'package:get/get.dart';
import 'package:socio/core/constants/AppRoutes.dart';
import 'package:socio/core/middleware/myMiddleware.dart';
import 'package:socio/view/screens/Language.dart';
import 'package:socio/view/screens/auth/login.dart';
import 'package:socio/view/screens/auth/serivcer_signup.dart';
import 'package:socio/view/screens/auth/signup.dart';
import 'package:socio/view/screens/edit_profile.dart';
import 'package:socio/view/screens/new_request.dart';
import 'package:socio/view/screens/onBoarding.dart';
import 'package:socio/view/screens/screens/notifications.dart';
import 'package:socio/view/screens/screens/search_screen.dart';

import 'view/screens/auth/forgetPassword.dart';
import 'view/screens/main_screen.dart';

// Define a list of GetPages to represent all the app screens and their associated routes
List<GetPage<dynamic>>? pages = [
  // Language selection screen
  GetPage(
    name: "/", // Default route
    page: () => const Language(), // Use Language screen as page
    middlewares: [
      MyOnBoardingMiddleware(),
      MyLoginMiddleware()
    ], // Use the defined middlewares for this screen
  ),
  // OnBoarding screen
  GetPage(name: AppRoutes.onBoarding, page: () => const OnBoarding()),
  // Auth screens
  GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
  GetPage(name: AppRoutes.forgetPass, page: () => ForgetPass()),
  GetPage(name: AppRoutes.signup, page: () => const SignupScreen()),
  GetPage(name: AppRoutes.servicerSignup, page: () => const ServicerSignup()),
  // App screens
  GetPage(name: AppRoutes.mainScreen, page: () => const MainScreen()),
  GetPage(name: AppRoutes.notification, page: () => const Notifications()),
  GetPage(name: AppRoutes.searchScreen, page: () => const SearchScreen()),
  GetPage(name: AppRoutes.newRequestScreen, page: () => NewRequest()),
  GetPage(name: AppRoutes.editProfileScreen, page: () => EditProfileScreen()),
];
