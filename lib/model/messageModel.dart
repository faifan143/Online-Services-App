class MessageModel {
  late String senderId;
  late String receiverId;
  late String text;
  late String ntpDateTime;
  late String postImage;
  MessageModel({
    required this.text,
    required this.ntpDateTime,
    required this.receiverId,
    required this.senderId,
    required this.postImage,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    receiverId = json['receiverId'];
    text = json['text'];
    ntpDateTime = json['ntpDateTime'];
    senderId = json['senderId'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'receiverId': receiverId,
      'senderId': senderId,
      'ntpDateTime': ntpDateTime,
      'postImage': postImage,
    };
  }
}
