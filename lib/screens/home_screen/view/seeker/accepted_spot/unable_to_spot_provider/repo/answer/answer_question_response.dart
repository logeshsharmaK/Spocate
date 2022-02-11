/// Status : "Success"
/// Message : "Request Submitted Successfully"

class AnswerQuestionResponse {
  String _status;
  String _message;

  String get status => _status;
  String get message => _message;

  AnswerQuestionResponse({
      String status, 
      String message}){
    _status = status;
    _message = message;
}

  AnswerQuestionResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }

}