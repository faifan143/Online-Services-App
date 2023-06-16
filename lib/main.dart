import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:socio/core/localization/changeLocale.dart';
import 'package:socio/core/localization/myDictionary.dart';
import 'package:socio/core/services/sharedPreferences.dart';
import 'package:socio/routes.dart';

void main() async {
  // Ensure the Flutter widgets binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the app's services
  await initialServices();

  // Initialize the Firebase app
  await Firebase.initializeApp();

  // Run the app with the Phoenix package (for hot restarts)
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the language controller
    LocaleController controller = Get.put(LocaleController());

    // Create and return the GetMaterialApp widget
    return GetMaterialApp(
      title: "Servicy",
      debugShowCheckedModeBanner: false,
      theme: controller.appTheme,
      locale: controller.language,
      translations: MyDictionary(),
      getPages: pages, // Define the app's routes
    );
  }
}
