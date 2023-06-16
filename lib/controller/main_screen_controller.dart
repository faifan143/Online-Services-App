import 'dart:io';
import 'dart:math';

import 'package:age_calculator/age_calculator.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firestore_storage;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:socio/core/constants/AppRoutes.dart';
import 'package:socio/core/constants/appTheme.dart';
import 'package:socio/core/functions/signupSuccessful.dart';
import 'package:socio/core/services/sharedPreferences.dart';
import 'package:socio/model/feedback_model.dart';
import 'package:socio/model/messageModel.dart';
import 'package:socio/model/request_model.dart';
import 'package:socio/model/service_user.dart';
import 'package:socio/model/user_model.dart';
import 'package:socio/view/screens/carousel_view.dart';
import 'package:socio/view/screens/screens/categories.dart';
import 'package:socio/view/screens/screens/home.dart';
import 'package:socio/view/screens/screens/profile.dart';
import 'package:socio/view/widgets/custom_carousel_servicer.dart';

import '../view/screens/screens/chats.dart';

class MainScreenController extends GetxController {
  //الحالات
  int currentPage = 0;

  changePage(int index) {
    currentPage = index;
    update();
  }

  bool pickedImageLoading = false;

  bool updateProfileLoading = false;

  bool hasNotification = false;

  bool loadingHomeScreen = true;

  changeImageLoadingState() {
    pickedImageLoading = !pickedImageLoading;
    update();
  }

  void removePostImage() {
    postImage = null;
    postImageLink = '';
    update();
  }

  void refresher() {
    update();
  }

  String searchText = "";
  bool emojiShowing = false;
  var focusNode = FocusNode();
  bool isPassword = true;
  String categoriesScreenSelectedCategory = "";
  String? selectedValue;

  // Function to change the search text
  void changeSearchText(String query) {
    searchText = query;
    update();
  }

  // Function to check if a list of tags is showable to the user
  bool isShowableToMe(List<dynamic> tags) {
    bool result = false;
    getTranslatedCategories(tags).forEach((tag) {
      myCategories.forEach((category) {
        if (category == tag) {
          result = true;
        }
      });
    });
    return result;
  }

  // Function to toggle the emoji showing state
  void emojiStage(BuildContext context) {
    emojiShowing = !emojiShowing;
    if (emojiShowing) {
      focusNode = FocusNode();
    } else {
      FocusScope.of(context).requestFocus(focusNode);
    }
    update();
  }

  // Function to change the password state
  void changePassState() {
    isPassword = !isPassword;
    update();
  }

  // Function to handle the selected option
  void selectedOption(String option) {
    selectedValue = option;
    if (option == 'edit') update();
  }

  // Function to check if the user is a servicer
  void checkMe() {
    servicers.forEach((serUser) {
      if (serUser.uId == userAuth!.uid) {
        amIAServicer = true;
      }
    });
    update();
  }

  // Function to select a category in the category screen
  void selectCategoryScreen(String category) {
    categoriesScreenSelectedCategory = category;
    Get.toNamed(AppRoutes.categoriesJoker);
    update();
  }

// متحكمات الكتابة
  TextEditingController mySearch = TextEditingController();

  TextEditingController textCtrl = TextEditingController();

  TextEditingController feedbackCtrl = TextEditingController();

// اللوائح
  List<Widget> carouselItems = [];

  List<Widget> screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    Container(),
    const ChatsScreen(),
    const ProfileScreen(),
  ];

  List<String> requestTags = [];

  List<String> availableTags = [
    "Software and Data Analysis".tr,
    "Freelance".tr,
    "Graphic".tr,
    "Technician".tr,
    "Engineer".tr,
    "Doctors & Nurses".tr,
    "Plumber".tr,
    "Electrician".tr
  ];

  // Merges a list of tags into a single string with a '#' symbol prefixing each tag.
  String mergeTags(List<dynamic> Tags) {
    String result = "";
    for (String string in Tags) {
      result = result +
          "#$string"; // Adds the tag with a '#' symbol prefix to the result string.
    }
    return result;
  }

  void onCategoriesSelectionComplete(values) {
    // Clear the list of requested tags
    requestTags.clear();

    // Check the selected language and map each selected value to its English equivalent
    if (myServices.sharedPref.getString('lang') == "ar") {
      for (String value in values) {
        switch (value) {
          case "محلل أنظمة و بيانات":
            requestTags.add("Software and Data Analysis");
            break;
          case " عمل حر":
            requestTags.add("Freelance");
            break;
          case "غرافيكس":
            requestTags.add("Graphic");
            break;
          case "تقني":
            requestTags.add("Technician");
            break;
          case "مهندس":
            requestTags.add("Engineer");
            break;
          case "طبيب ة أو ممرض ة":
            requestTags.add("Doctors & Nurses");
            break;
          case "عامل صحية":
            requestTags.add("Plumber");
            break;
          case "عامل كهرباء":
            requestTags.add("Electrician");
            break;
        }
      }
    } else {
      // If the selected language is not Arabic, simply add each selected value to the list of requested tags
      for (String value in values) {
        requestTags.add(value);
      }
    }

    // Notify any listener that the state of this object has changed
    update();
  }

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

  List<Text> stringsToTexts(List<dynamic> strings) {
    List<Text> texts = [];

    // loop through the list of strings
    for (String string in strings) {
      // create a Text widget with the string as the content
      Text textWidget = Text(
        string,
        style: englishTheme.textTheme.headline1!.copyWith(
            color: CupertinoColors.white,
            fontWeight: FontWeight.w300,
            fontSize: 18),
      );

      // add the Text widget to the list of Text widgets
      texts.add(textWidget);
    }

    // return the list of Text widgets
    return texts;
  }

  //للتعامل مع معلومات صاحب الحساب
  bool amIAServicer = false;
  String myUsername = '';
  String myPhone = '';
  String myEmail = '';
  String myPassword = '';
  String myUId = '';
  bool myServicer = false;
  bool myIsVerified = false;
  String myImage = '';
  String myAddress = "";
  String myAge = "";
  String myGender = "";
  String myProvidence = "";
  String myExperienceLevel = "";
  List<dynamic> myCategories = [''];
  List<dynamic> myEnCategories = [];
  List<dynamic> myFormerExperiences = [];
  List<dynamic> myAnotherExpertise = [];
  List<dynamic> myExperiencedTools = [];
  List<dynamic> myProgrammingLanguagesList = [];
  String myRate = "";
  String myServiced = "";
  String myRaters = "";
  String myDisRaters = "";
  List<dynamic> myRatersId = [];
  List<dynamic> myDisRatersId = [];
  List<dynamic> myContacts = [];
  var userAuth = FirebaseAuth.instance.currentUser;

  getDoc() async {
    // get user document with matching userAuth id
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userAuth!.uid)
        .get();

    // extract user data from the document
    final data = doc.data()!;

    // update local variables with the extracted data
    myUsername = data['name'];
    myEmail = data['email'];
    myPassword = data['password'];
    myUId = data['uId'];
    myServicer = data['servicer'];
    myIsVerified = data['isVerified'];
    myPhone = data['phone'];
    myImage = data['image'];
    myAddress = getTranslatedAddress(data['address']);
    myAge = data['age'];
    myGender = getTranslatedGender(data['gender']);
    myRate = data['rate'];
    myRaters = data['raters'];
    myDisRaters = data['disRaters'];
    myProvidence = data['providence'];
    myExperienceLevel = getTranslatedLevel(data['experienceLevel']);
    myCategories = getTranslatedCategories(data['categories']);
    myFormerExperiences = data['formerExperiences'];
    myAnotherExpertise = data['anotherExpertise'];
    myExperiencedTools = data['experiencedTools'];
    myProgrammingLanguagesList = data['programmingLanguagesList'];
    myRatersId = data['ratersId'];
    myDisRatersId = data['disRatersId'];
    myContacts = data['contacts'];
    myServiced = data['serviced'];

    // update loadingHomeScreen and notify listeners
    loadingHomeScreen = false;
    update();
  }

  // للتعامل مع معلومات باقي المستخدمين
  List<ServicerUser> servicers = [];

  List<UserModel> users = [];

// Fetches all user documents from Firestore and converts them to ServicerUser objects
  getUsers() async {
    // Fetch user documents
    var querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    // Convert each document's data to a ServicerUser object and store in users list
    users = querySnapshot.docs.map((doc) {
      var userData = doc.data();
      return ServicerUser.fromJson(userData);
    }).toList();
    // Update UI
    update();
  }

  // Method to retrieve all servicers from Firestore and add them to the servicers list
  getServicers() {
    // Access the Firestore 'users' collection, and retrieve only the documents where the 'servicer' field is true
    FirebaseFirestore.instance
        .collection('users')
        .where("servicer", isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      // For each document retrieved from Firestore
      snapshot.docs.forEach((user) {
        // Extract the user data as a Map
        var userData = user.data();
        // Create a ServicerUser object from the user data
        servicers.add(ServicerUser.fromJson(userData));
        // Call the checkMe method (not shown) to check if the current user is a servicer
        checkMe();
        // Notify the UI that the servicers list has been updated
        update();
      });
    });
  }

  MyServices myServices = Get.find();

  Future<void> deleteUser() async {
    try {
      // Get a reference to the user document
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userAuth!.uid);

      // Delete the user document
      await userDocRef.delete();

      // Clear the shared preferences value for 'logged'
      myServices.sharedPref.setString("logged", "0");

      // Notify listeners that the state has been updated
      update();

      // Delete the user's authentication account
      await userAuth!.delete();

      // Navigate to the login page
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      // Log any errors
      print("Error deleting user: $e");
    }
  }

  List<CustomCarouselServicer> carouselUsersList = [];

  void carouselUsers() {
    FirebaseFirestore.instance
        .collection('users')
        .where('uId', isNotEqualTo: myUId) // filter out current user
        .snapshots()
        .listen((snapshot) {
      snapshot.docs.forEach((user) {
        final userData = user.data();
        final servicerUser = ServicerUser.fromJson(userData);
        // Check if the user is a servicer and there are less than 3 servicers in the carousel
        if (carouselUsersList.length < 3 &&
            servicerUser.servicer &&
            servicerUser.uId != userAuth!.uid) {
          final birthday = DateTime.parse(servicerUser.age);
          final duration = AgeCalculator.age(birthday);

          // Add servicer to the carousel list
          carouselUsersList.add(CustomCarouselServicer(
            onViewTap: () {
              Get.to(CarouselView(
                serUser: servicerUser,
                feedbackerImg: myImage,
                submitFeedback: () {
                  if (myUId == servicerUser.uId) {
                    snackBar(
                        contentType: ContentType.warning,
                        title: "Oops!".tr,
                        body: "you can't feedback yourself".tr);
                  } else if (feedbackCtrl.text.isNotEmpty) {
                    // Add feedback to the servicer's profile
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(servicerUser.uId)
                        .collection('feedbacks')
                        .add(FeedbackModel(
                          feedBackerImg: myImage,
                          feedBackerMsg: feedbackCtrl.text,
                          feedBackerId: myUId,
                          servicerId: servicerUser.uId,
                          feedBackerEmail: myEmail,
                          feedBackerName: myUsername,
                        ).toMap());
                    feedbackCtrl.clear();
                    snackBar(
                        contentType: ContentType.success,
                        title: "Done !".tr,
                        body: "your feedback added to the servicer profile .."
                            .tr);
                  }
                },
              ));
            },
            submitFeedback: () {},
            img: servicerUser.image,
            name: servicerUser.username,
            location: getTranslatedAddress(servicerUser.address),
            age: duration.years.toString(),
            rate: servicerUser.rate,
            feedbackerImg: myImage,
            level: getTranslatedLevel(servicerUser.experienceLevel),
            category:
                getTranslatedCategories(servicerUser.categories).join(' #'),
            addToFav: () {},
            ratersId: servicerUser.ratersId,
            disRatersId: servicerUser.disRatersId,
          ));
        }
      });
    });
  }

  // Refreshes the user data in the app by listening to the 'users' collection in Firestore
// and checking if the document ID matches the current user's ID. If so, it calls the
// 'getDoc' method to update the user's data.
  refreshUser() async {
    FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((snapshots) {
      // Loop through all the documents in the 'users' collection
      snapshots.docs.forEach((doc) {
        // Check if the document ID matches the current user's ID
        if (myUId == doc.id) {
          // If it does, call the 'getDoc' method to update the user's data
          getDoc();
        }
      });
    });
  }

//  مستخدمي المحادثات
  List<ChatUser> chatUsers = [];

  List<dynamic> chattersIds = [];

  getChatters() {
    // Clears existing chatter IDs and chat users
    chattersIds.clear();
    chatUsers.clear();

    // Fetches the user document for the current user and listens to updates
    FirebaseFirestore.instance
        .collection('users')
        .doc(myUId)
        .snapshots()
        .listen((value) {
      // Gets the chatter IDs from the document data
      chattersIds = value.data()!['contacts'];
      chatUsers.clear();

      // Iterates through all users and finds those that match the chatter IDs
      users.forEach((user) {
        chattersIds.forEach((chatterID) {
          if (chatterID == user.uId) {
            chatUsers.add(ChatUser(
              uModel: user,
            ));
          }
        });
      });

      // Triggers a UI update
      update();
    });
  }

  // Sends a message to a user with the given receiverId, text and postImage
  sendMessage({
    required String receiverId,
    required String text,
    required String postImage,
  }) async {
    // Get the current time from NTP server
    final myTime = await NTP.now();
    final ntpOffset = await NTP.getNtpOffset(localTime: DateTime.now());
    // Add NTP offset to the current time to get the correct time
    final ntpTime = myTime.add(Duration(milliseconds: ntpOffset));

    // Create a MessageModel with the message information
    final messageModel = MessageModel(
      text: text,
      ntpDateTime: ntpTime.toString(),
      receiverId: receiverId,
      senderId: userAuth!.uid,
      postImage: postImage,
    );

    // Add the receiverId to the sender's contact list if it doesn't exist
    if (!chattersIds.contains(receiverId)) {
      chattersIds.add(receiverId);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(myUId)
          .update({'contacts': chattersIds});
    }

    // Add the sender's Id to the receiver's contact list if it doesn't exist
    final receiverDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();
    final receiverChattersIds =
        List<String>.from(receiverDoc.data()!['contacts']);
    if (!receiverChattersIds.contains(myUId)) {
      receiverChattersIds.add(myUId);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .update({'contacts': receiverChattersIds});
    }

    // Add the message to the sender's chat collection
    FirebaseFirestore.instance
        .collection('users')
        .doc(messageModel.senderId)
        .collection('chats')
        .doc(messageModel.receiverId)
        .collection('messages')
        .add(messageModel.toMap());

    // Add the message to the receiver's chat collection
    FirebaseFirestore.instance
        .collection('users')
        .doc(messageModel.receiverId)
        .collection('chats')
        .doc(messageModel.senderId)
        .collection('messages')
        .add(messageModel.toMap());
  }

// للتعامل مع الريكويستات
  Future<void> createRequest({
    required String text,
    required BuildContext context,
  }) async {
    // Check if the user has selected at least one tag for the request
    if (requestTags.isEmpty) {
      snackBar(
        context: context,
        contentType: ContentType.failure,
        title: "Oops !!".tr,
        body: "Choose a category".tr,
      );
    } else {
      // Get current date and time
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

      // Get NTP time
      DateTime _myTime;
      DateTime _ntpTime;
      _myTime = await NTP.now();
      final int offset = await NTP.getNtpOffset(localTime: DateTime.now());
      _ntpTime = _myTime.add(Duration(milliseconds: offset));

      // Create a request model object
      final model = RequestModel(
        username: myUsername,
        image: myImage,
        text: text,
        ntpDateTime: _ntpTime.toString(),
        location: getEngProvidence(myAddress),
        isDone: false,
        tags: requestTags,
        requesterID: userAuth!.uid,
        requestId: "${Random().nextInt(1000)}$myUId${Random().nextInt(1000)}",
        notifiersId: [],
        queuersId: [],
        shownTime: formattedDate,
      );

      // Add the request to the user's collection of requests
      FirebaseFirestore.instance
          .collection('users')
          .doc(userAuth!.uid)
          .collection("requests")
          .add(model.toMap())
          .then((value) {})
          .catchError((onError) {});

      // Add the request to the global collection of requests
      FirebaseFirestore.instance
          .collection('requests')
          .add(model.toMap())
          .then((value) {
        // Show a success message and pop the context after a short delay
        snackBar(
          context: context,
          contentType: ContentType.success,
          title: "Done !!".tr,
          body: "Request Uploaded ..".tr,
        );
        Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
      }).catchError((onError) {});
    }
  }

  // This function is responsible for editing a request.
  editRequest({
    required String text,
    required BuildContext context,
    required String requestId,
  }) async {
    // Initialize empty lists for notifiers and queuers.
    List<dynamic> notifiersList = [];
    List<dynamic> queuersList = [];

    // Retrieve the current notifiers and queuers of the request.
    await FirebaseFirestore.instance
        .collection('requests')
        .where('requestId', isEqualTo: requestId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        notifiersList = await FirebaseFirestore.instance
            .collection('requests')
            .doc(doc.id)
            .get()
            .then((value) => value.data()!['notifiersId']);
        queuersList = await FirebaseFirestore.instance
            .collection('requests')
            .doc(doc.id)
            .get()
            .then((value) => value.data()!['queuersId']);
      });
    });

    // Check if the request tags are empty.
    if (requestTags.isEmpty) {
      // Display a snackbar with a failure message if the tags are empty.
      snackBar(
        context: context,
        contentType: ContentType.failure,
        title: "Oops !!",
        body: "Choose a category",
      );
    } else {
      // Get the current date and time.
      DateTime now = DateTime.now();

      // Format the date and time as a string.
      String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

      // Get the NTP time.
      DateTime _myTime = await NTP.now();

      // Get the NTP offset and add it to the current time.
      final int offset = await NTP.getNtpOffset(localTime: DateTime.now());
      DateTime _ntpTime = _myTime.add(Duration(milliseconds: offset));

      // Create a request model with the updated information.
      RequestModel model = RequestModel(
        username: myUsername,
        image: myImage,
        text: text,
        ntpDateTime: _ntpTime.toString(),
        location: myAddress.tr,
        isDone: false,
        tags: requestTags,
        requesterID: userAuth!.uid,
        requestId: requestId,
        notifiersId: notifiersList,
        queuersId: [],
        shownTime: formattedDate,
      );

      // Update the request in the user's requests collection.
      var firestoreInstance = FirebaseFirestore.instance
          .collection('users')
          .doc(userAuth!.uid)
          .collection("requests");
      firestoreInstance
          .where('requestId', isEqualTo: requestId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          firestoreInstance.doc(doc.id).update(model.toMap());
        });
      });

      // Update the request in the requests collection.
      FirebaseFirestore.instance
          .collection('requests')
          .where('requestId', isEqualTo: requestId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          FirebaseFirestore.instance
              .collection('requests')
              .doc(doc.id)
              .update(model.toMap());
        });

        // Display a success message and pop the screen after a delay.
        snackBar(
          context: context,
          contentType: ContentType.success,
          title: "Done !!".tr,
          body: "Request Updated ..".tr,
        );
        Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
      });
    }
  }

// للتعامل مع تحديث معلومات الحساب الشخصي
  File? profileImage;

  var picker = ImagePicker();

  // A function to get a profile image from the device's gallery.
  Future<void> getProfileImage() async {
    // Pick an image from the gallery.
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    // Check if an image is picked.
    if (pickedFile != null) {
      // Set the profile image to the picked image file.
      profileImage = File(pickedFile.path);

      // Update the state to notify listeners.
      update();
    } else {
      // If no image is picked, update the state to notify listeners.
      update();
    }
  }

  uploadProfileImage({
    required String username,
    required String email,
    required String address,
    required String phone,
    required String anotherExpertise,
    required String formerExperiences,
    required String experiencedPrograms,
    required String programmingLangs,
  }) {
    // If no profile image is selected, update user data with the given arguments
    // and update the 'name' and 'address' fields in all 'requests' documents
    if (profileImage == null) {
      updateUserData(
        username: username,
        email: email,
        address: address,
        phone: phone,
        anotherExpertise: anotherExpertise.split(','),
        formerExperiences: formerExperiences.split(','),
        experiencedProgramsTools: experiencedPrograms.split(','),
        programmingLangs: programmingLangs.split(','),
      );

      FirebaseFirestore.instance
          .collection('requests')
          .where('requesterID', isEqualTo: userAuth!.uid)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          FirebaseFirestore.instance
              .collection('requests')
              .doc(doc.id)
              .update({'name': username, 'address': address});
        });
      });
    }
    // If a profile image is selected, upload it to Firebase Storage, get its download URL,
    // update user data with the given arguments and the image URL, and update the 'name',
    // 'address', and 'image' fields in all 'requests' documents
    else {
      firestore_storage.FirebaseStorage.instance
          .ref()
          .child("users/${Uri.file(profileImage!.path).pathSegments.last}")
          .putFile(profileImage!)
          .then(
        (snapshot) {
          snapshot.ref.getDownloadURL().then(
            (value) {
              updateUserData(
                username: username,
                email: email,
                address: address,
                phone: phone,
                anotherExpertise: anotherExpertise.split(','),
                formerExperiences: formerExperiences.split(','),
                image: value,
                experiencedProgramsTools: experiencedPrograms.split(','),
                programmingLangs: programmingLangs.split(','),
              );
              FirebaseFirestore.instance
                  .collection('requests')
                  .where('requesterID', isEqualTo: userAuth!.uid)
                  .get()
                  .then((querySnapshot) {
                querySnapshot.docs.forEach((doc) {
                  FirebaseFirestore.instance
                      .collection('requests')
                      .doc(doc.id)
                      .update({
                    'name': username,
                    'address': address,
                    'image': value
                  });
                });
              });
              profileImage = null;
              update();
            },
          ).catchError((onError) {});
        },
      ).catchError((onError) {});
    }
  }

// Updates the user data in the Firestore database
  updateUserData({
    required String username,
    required String email,
    required String address,
    required String phone,
    required List<String> anotherExpertise,
    required List<String> formerExperiences,
    required List<String> experiencedProgramsTools,
    required List<String> programmingLangs,
    String? image,
  }) {
    // Create a new ServicerUser object with the updated data
    ServicerUser model = ServicerUser(
        servicer: myServicer,
        email: email,
        password: myPassword,
        address: selectedProvidence,
        phone: phone,
        image: image ?? myImage,
        isVerified: myIsVerified,
        uId: myUId,
        username: username,
        age: myAge,
        gender: getEngGender(myGender),
        providence: getEngProvidence(selectedProvidence),
        categories: getEngCategories(myCategories),
        programmingLanguagesList: programmingLangs,
        experiencedTools: experiencedProgramsTools,
        experienceLevel: getEngLevel(myExperienceLevel),
        anotherExpertise: anotherExpertise,
        formerExperiences: formerExperiences,
        rate: myRate,
        raters: myRaters,
        disRaters: myDisRaters,
        ratersId: myRatersId,
        disRatersId: myDisRatersId,
        contacts: myContacts,
        serviced: myServiced);

    // Update the user data in the Firestore database
    FirebaseFirestore.instance
        .collection('users')
        .doc(userAuth!.uid)
        .update(model.toMap())
        .then((value) {
      // Reload the document data
      getDoc();
      // Set the profile update loading state to false
      updateProfileLoading = false;
    }).catchError((onError) {});

    // Update the UI
    update();
  }

// للتعامل مع صور المحادثات
  File? postImage;
  String? postImageLink;
  var postImagePicker = ImagePicker();

  // This function allows the user to pick an image from their gallery and upload it to Firebase storage
  Future<void> getPostImage() async {
    // Prompt the user to pick an image from their gallery
    final pickedFile =
        await postImagePicker.getImage(source: ImageSource.gallery);

    // If an image was picked
    if (pickedFile != null) {
      // Set postImage to the picked image
      postImage = File(pickedFile.path);

      // If postImage is not null
      if (postImage != null) {
        // Upload the image to Firebase storage
        firestore_storage.FirebaseStorage.instance
            .ref()
            .child("messages/${Uri.file(postImage!.path).pathSegments.last}")
            .putFile(postImage!)
            .then((value) {
          // When the upload is complete, get the download URL of the image
          return value.ref.getDownloadURL().then((imgLink) {
            // Set postImageLink to the download URL of the image
            postImageLink = imgLink;
            // Set pickedImageLoading to false to indicate that the image has been uploaded
            pickedImageLoading = false;
            // If pickedImageLoading is false, call update() to update the UI
            if (pickedImageLoading == false) update();
          });
        }).catchError((onError) {
          // If there is an error while uploading the image, print the error and set pickedImageLoading to false
          print(onError);
          pickedImageLoading = false;
          // If pickedImageLoading is false, call update() to update the UI
          if (pickedImageLoading == false) update();
        });
      }
      // If postImage is null, call update() to update the UI
      update();
    } else {
      // If an image was not picked, set pickedImageLoading to false
      pickedImageLoading = false;
      // If pickedImageLoading is false, call update() to update the UI
      if (pickedImageLoading == false) update();
    }
  }

  // للحصول على القيم بلغة التطبيق الحالية لاستخدامهم في الواجهات

// Translates an address from English to Arabic, if the app language is set to Arabic.
  String getTranslatedAddress(String address) {
    // Check if app language is set to Arabic.
    if (myServices.sharedPref.getString('lang') == "ar") {
      // Translate the address to Arabic.
      switch (address) {
        case "Aleppo":
          return "حلب";
        case "Damascus":
          return "دمشق";
        case "Qameshli":
          return "القامشلي";
        case "Daraa":
          return "درعا";
        case "Hasaka":
          return "الحسكة";
        case "Idleb":
          return "ادلب";
        case "Tartous":
          return "طرطوس";
        case "Latakia":
          return "اللاذقية";
        case "Homs":
          return "حمص";
        case "Hama":
          return "حماه";
        case "Al-Swaydaa":
          return "السويداء";
        case "Damascus-Country":
          return "ريف دمشق";
        case "Der-Ezzour":
          return "دير الزور";
        case "Rakka":
          return "الرقة";
      }
    }
    // Return the original address if the app language is not set to Arabic.
    return address;
  }

  String getTranslatedLevel(String level) {
    // Check if app language is set to Arabic
    if (myServices.sharedPref.getString('lang') == "ar") {
      // Translate level to Arabic based on its English equivalent
      switch (level) {
        case "Beginner":
          return "مبتدئ";
        case "Junior":
          return "قليل الخبرة";
        case "Intermediate":
          return "متوسط الخبرة";
        case "Senior":
          return "خبير";
        case "Professional":
          return "محترف";
      }
    }
    // Return the input string if the app language is not set to Arabic
    return level;
  }

// This function takes a list of categories and returns a new list
// with translated values if the user's selected language is Arabic.
  List<String> getTranslatedCategories(List<dynamic> categories) {
    List<String> result = [];

    // Check if the user's selected language is Arabic.
    if (myServices.sharedPref.getString('lang') == "ar") {
      // Translate each category to Arabic and add it to the result list.
      for (String value in categories) {
        switch (value) {
          case "Software and Data Analysis":
            result.add("محلل أنظمة و بيانات");
            break;
          case "Freelance":
            result.add("عمل حر");
            break;
          case "Graphic":
            result.add("غرافيكس");
            break;
          case "Technician":
            result.add("تقني");
            break;
          case "Engineer":
            result.add("مهندس");
            break;
          case "Doctors & Nurses":
            result.add("طبيب ة أو ممرض ة");
            break;
          case "Plumber":
            result.add("عامل صحية");
            break;
          case "Electrician":
            result.add("عامل كهرباء");
            break;
          default:
            result.add(value);
        }
      }
    } else {
      // If the user's selected language is not Arabic, simply copy the categories
      // as they are to the result list.
      for (String category in categories) {
        result.add(category);
      }
    }

    return result;
  }

// A function that returns the translated version of a given gender string
  String getTranslatedGender(String gender) {
    // Check the language preference stored in shared preferences
    if (myServices.sharedPref.getString("lang") == "ar") {
      // If the language preference is Arabic, translate the gender
      if (gender == "Male")
        return "ذكر";
      else if (gender == "Female")
        return "انثى";
      else
        return "غير معروف"; // If the gender is unknown, return "غير معروف" (unknown)
    }
    // If the language preference is not Arabic, return the original gender string
    return gender;
  }

  // للحصول على القيم باللغة الانجليزية للتعامل مع قاعدة البيانات

  String selectedProvidence = '';

  // Assign the English province name corresponding to the Arabic one
  void assignEngProvidenceToSP(String providence) {
    // Check the language selected by the user
    if (myServices.sharedPref.getString('lang') == "ar") {
      // Map the Arabic province names to their English equivalents
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
      // If the language is not Arabic, use the selected province name directly
      selectedProvidence = providence;
    }
    // Call the 'update' method
    update();
  }

// Returns a list of English categories based on the given values
  List<String> getEngCategories(List<dynamic> values) {
    List<String> selectedCategory = [];

    // Check if the user's preferred language is Arabic
    if (myServices.sharedPref.getString('lang') == "ar") {
      // Map Arabic categories to their corresponding English categories
      for (String value in values) {
        if (value == "محلل أنظمة و بيانات") {
          selectedCategory.add("Software and Data Analysis");
        }
        if (value == "عمل حر") {
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
    }
    // Otherwise, use the same categories as provided in the input
    else {
      for (String value in values) {
        selectedCategory.add(value);
      }
    }

    return selectedCategory;
  }

// Function to convert Arabic experience level to English
  String getEngLevel(String level) {
    String selectedLevel =
        myExperienceLevel; // set default value to the global variable `myExperienceLevel`

    // Check if language is Arabic
    if (myServices.sharedPref.getString('lang') == "ar") {
      // Convert Arabic level to English
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
      // If language is not Arabic, return the original level
      selectedLevel = level;
    }
    return selectedLevel; // return the selected level
  }

  // This function maps Arabic gender terms to their English equivalents
  String getEngGender(String gender) {
    // Check if language preference is Arabic
    if (myServices.sharedPref.getString("lang") == "ar") {
      // Map Arabic gender terms to their English equivalents
      if (gender == "ذكر")
        return "Male";
      else if (gender == "انثى")
        return "Female";
      else
        return "unknown"; // return "unknown" if gender is unrecognized
    }
    // If language preference is not Arabic, return the input gender
    return gender;
  }

// Converts Arabic province names to their English equivalents
  String getEngProvidence(String providence) {
    // Check if the language selected is Arabic
    if (myServices.sharedPref.getString('lang') == "ar") {
      // Convert province names using a switch statement
      switch (providence) {
        case "حلب":
          return "Aleppo";
        case "دمشق":
          return "Damascus";
        case "القامشلي":
          return "Qameshli";
        case "درعا":
          return "Daraa";
        case "الحسكة":
          return "Hasaka";
        case "ادلب":
          return "Idleb";
        case "طرطوس":
          return "Tartous";
        case "اللاذقية":
          return "Latakia";
        case "حمص":
          return "Homs";
        case "حماه":
          return "Hama";
        case "السويداء":
          return "Al-Swaydaa";
        case "ريف دمشق":
          return "Damascus-Country";
        case "دير الزور":
          return "Der-Ezzour";
        case "الرقة":
          return "Rakka";
      }
    }
    // Return the original province name if the language is not Arabic
    return providence;
  }

  // عند بناء متحكم ال main screen
  // This method is called when the controller is initialized
  // It sets a value in shared preferences to indicate that the user is logged in
  // It then calls several asynchronous methods to fetch data and initialize the controller
  // Finally, it calls the parent onInit method
  @override
  Future<void> onInit() async {
    // Set the 'logged' flag to indicate that the user is logged in
    myServices.sharedPref.setString("logged", "1");
    // Fetch users, servicers, and doc
    getUsers();
    getServicers();
    getDoc();
    // Refresh user data
    refreshUser();
    // Create a carousel of users
    carouselUsers();
    // Get chatters
    getChatters();
    // Call parent onInit method
    super.onInit();
  }
}
