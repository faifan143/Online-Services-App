class RequestModel {
  late String username;
  late String image;
  late String text;
  late String ntpDateTime;
  late String shownTime;
  late String location;
  late bool isDone = false;
  late List<dynamic> notifiersId = [];
  late List<dynamic> tags = [];
  late List<dynamic> queuersId = [];
  late String requesterID;
  late String requestId;

  RequestModel({
    required this.username,
    required this.image,
    required this.text,
    required this.ntpDateTime,
    required this.shownTime,
    required this.location,
    required this.isDone,
    required this.notifiersId,
    required this.queuersId,
    required this.tags,
    required this.requesterID,
    required this.requestId,
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
      'isDone': isDone,
      'notifiersId': notifiersId,
      'queuersId': queuersId,
      'requesterID': requesterID,
      'requestId': requestId,
    };
  }

  RequestModel.fromJson(Map<String, dynamic> json) {
    username = json['name'];
    text = json['text'];
    ntpDateTime = json['ntpDateTime'];
    shownTime = json['shownTime'];
    image = json['image'];
    tags = json['tags'];
    location = json['address'];
    isDone = json['isDone'];
    notifiersId = json['notifiersId'];
    queuersId = json['queuersId'];
    requesterID = json['requesterID'];
    requestId = json['requestId'];
  }
}
