class UserModel {
  late String username;
  late String email;
  late String phone;
  late String password;
  late String address;
  late String image;
  late String uId;
  late List<dynamic> contacts;
  late bool isVerified;
  late bool servicer;
  UserModel({
    required this.email,
    required this.password,
    required this.address,
    required this.phone,
    required this.image,
    required this.isVerified,
    required this.uId,
    required this.username,
    required this.servicer,
    required this.contacts,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['name'];
    password = json['password'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    isVerified = json['isVerified'];
    uId = json['uId'];
    servicer = json['servicer'];
    contacts = json['contacts'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': username,
      'phone': phone,
      'email': email,
      'uId': uId,
      'password': password,
      'address': address,
      'image': image,
      'servicer': servicer,
      'isVerified': isVerified,
      'contacts': contacts,
    };
  }
}
