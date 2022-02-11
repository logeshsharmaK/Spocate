/// Status : "Success"
/// Message : "Seeker removed from queue"

class RemoveSeekerResponse {
  String _status;
  String _message;

  String get status => _status;
  String get message => _message;

  RemoveSeekerResponse({
      String status, 
      String message}){
    _status = status;
    _message = message;
}

  RemoveSeekerResponse.fromJson(dynamic json) {
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