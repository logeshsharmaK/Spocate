/// Status : "Success"
/// Message : "have you spot your provider?"

class AcceptSpotResponse {
  String _status;
  String _message;

  String get status => _status;
  String get message => _message;

  AcceptSpotResponse({
      String status, 
      String message}){
    _status = status;
    _message = message;
}

  AcceptSpotResponse.fromJson(dynamic json) {
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