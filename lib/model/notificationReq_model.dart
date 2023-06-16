class NotificationReqModel {
  late String username;
  late String image;
  late String text;
  late String ntpDateTime;
  late String shownTime;
  late String location;
  late bool isApproved = false;
  late List<dynamic> tags = [];
  late String requestId;
  late String notifierEmail;
  late String notifierName;
  late String approveRequesterID;

  NotificationReqModel({
    required this.username,
    required this.image,
    required this.text,
    required this.ntpDateTime,
    required this.shownTime,
    required this.location,
    required this.isApproved,
    required this.tags,
    required this.approveRequesterID,
    required this.requestId,
    required this.notifierName,
    required this.notifierEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': username,
      'text': text,
      'ntpDateTime': ntpDateTime,
      'shownTime': shownTime,
      'image': image,
      'tags': tags,
      'address': location,
      'isApproved': isApproved,
      'approveRequesterID': approveRequesterID,
      'requestId': requestId,
      'notifierEmail': notifierEmail,
      'notifierName': notifierName,
    };
  }

  NotificationReqModel.fromJson(Map<String, dynamic> json) {
    username = json['name'];
    text = json['text'];
    ntpDateTime = json['ntpDateTime'];
    shownTime = json['shownTime'];
    image = json['image'];
    tags = json['tags'];
    location = json['address'];
    isApproved = json['isApproved'];
    approveRequesterID = json['approveRequesterID'];
    requestId = json['requestId'];
    notifierName = json['notifierName'];
    notifierEmail = json['notifierEmail'];
  }
}
