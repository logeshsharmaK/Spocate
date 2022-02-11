/// Status : "Success"
/// Message : "We will notify you of free spot availabilty once you near your destination"

class DestLocateResponse {
  String _status;
  String _message;

  String get status => _status;
  String get message => _message;

  DestLocateResponse({
      String status, 
      String message}){
    _status = status;
    _message = message;
}

  DestLocateResponse.fromJson(dynamic json) {
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