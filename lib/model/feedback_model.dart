class FeedbackModel {
  late String feedBackerImg;
  late String feedBackerMsg;
  late String feedBackerId;
  late String feedBackerName;
  late String feedBackerEmail;
  late String servicerId;

  FeedbackModel(
      {required this.feedBackerImg,
      required this.feedBackerMsg,
      required this.feedBackerId,
      required this.servicerId,
      required this.feedBackerEmail,
      required this.feedBackerName});
  FeedbackModel.fromJson(Map<String, dynamic> json) {
    feedBackerEmail = json['feedBackerEmail'];
    feedBackerName = json['feedBackerName'];
    feedBackerId = json['feedBackerId'];
    feedBackerImg = json['feedBackerImg'];
    feedBackerMsg = json['feedBackerMsg'];
    servicerId = json['servicerId'];
  }

  Map<String, dynamic> toMap() {
    return {
      "feedBackerId": feedBackerId,
      "feedBackerImg": feedBackerImg,
      "feedBackerMsg": feedBackerMsg,
      "feedBackerName": feedBackerName,
      "feedBackerEmail": feedBackerEmail,
      "servicerId": servicerId,
    };
  }
}
