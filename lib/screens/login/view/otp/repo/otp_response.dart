class OTPResponse {
  int _userId;
  int _isCar;
  String _status;
  String _message;

  int get userId => _userId;
  int get isCar => _isCar;
  String get status => _status;
  String get message => _message;

  OTPResponse({
    int userId,
    int isCar,
    String status,
    String message}){
    _userId = userId;
    _isCar = isCar;
    _status = status;
    _message = message;
  }

  OTPResponse.fromJson(dynamic json) {
    _userId = json["UserId"];
    _isCar = json["IsCar"];
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["UserId"] = _userId;
    map["IsCar"] = _isCar;
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }

}