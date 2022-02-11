/// Id : 89
/// Status : "Success"
/// Message : "Car details updated successfully"

class MyCarsUpdateResponse {
  int _id;
  String _status;
  String _message;

  int get id => _id;
  String get status => _status;
  String get message => _message;

  MyCarsUpdateResponse({
      int id, 
      String status, 
      String message}){
    _id = id;
    _status = status;
    _message = message;
}

  MyCarsUpdateResponse.fromJson(dynamic json) {
    _id = json["Id"];
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Id"] = _id;
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }

}