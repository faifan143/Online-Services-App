import 'package:socio/model/user_model.dart';

class ServicerUser extends UserModel {
  late String age;
  late String gender;
  late String providence;
  late List<dynamic> categories;
  late List<dynamic> programmingLanguagesList = [];
  late List<dynamic> experiencedTools = [];
  late String experienceLevel;
  late List<dynamic> anotherExpertise = [];
  late List<dynamic> formerExperiences = [];
  late String rate;
  late String raters;
  late String disRaters;
  late List<dynamic> ratersId;
  late List<dynamic> disRatersId;
  late String serviced;

  ServicerUser({
    required super.servicer,
    required super.email,
    required super.password,
    required super.address,
    required super.phone,
    required super.image,
    required super.isVerified,
    required super.uId,
    required super.username,
    required super.contacts,
    required this.age,
    required this.gender,
    required this.providence,
    required this.categories,
    required this.programmingLanguagesList,
    required this.experiencedTools,
    required this.experienceLevel,
    required this.anotherExpertise,
    required this.formerExperiences,
    required this.rate,
    required this.raters,
    required this.disRaters,
    required this.ratersId,
    required this.disRatersId,
    required this.serviced,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': username,
      'phone': phone,
      'email': email,
      'uId': uId,
      'contacts': contacts,
      'password': password,
      'address': address,
      'image': image,
      'isVerified': isVerified,
      'servicer': servicer,
      'age': age,
      'gender': gender,
      'providence': providence,
      'categories': categories,
      'programmingLanguagesList': programmingLanguagesList,
      'experiencedTools': experiencedTools,
      'experienceLevel': experienceLevel,
      'anotherExpertise': anotherExpertise,
      'formerExperiences': formerExperiences,
      'rate': rate,
      'raters': raters,
      'disRaters': disRaters,
      'ratersId': ratersId,
      'disRatersId': disRatersId,
      'serviced': serviced,
    };
  }

  ServicerUser.fromJson(Map<String, dynamic> json)
      : super(
          email: json['email'],
          image: json['image'],
          address: json['address'],
          contacts: json['contacts'],
          isVerified: json['isVerified'],
          password: json['password'],
          phone: json['phone'],
          servicer: json['servicer'],
          uId: json['uId'],
          username: json['username'],
        ) {
    username = json['name'];
    password = json['password'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    servicer = json['servicer'];
    isVerified = json['isVerified'];
    uId = json['uId'];
    contacts = json['contacts'];
    age = json['age'];
    gender = json['gender'];
    providence = json['providence'];
    categories = json['category'];
    programmingLanguagesList = json['programmingLanguageList'];
    experiencedTools = json['experiencedTools'];
    experienceLevel = json['experienceLevel'];
    anotherExpertise = json['anotherExpertise'];
    formerExperiences = json['formerExperiences'];
    rate = json['rate'];
    raters = json['raters'];
    disRaters = json['disRaters'];
    ratersId = json['ratersId'];
    disRatersId = json['disRatersId'];
    serviced = json['serviced'];
  }
}
