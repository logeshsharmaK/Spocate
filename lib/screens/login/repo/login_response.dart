/// Verificationcode : 5663
/// Isemail : 0
/// Username : 7200707613
/// Error : 0
/// UserId : 0
/// IsCar : 1
/// Status : "Success"
/// Message : "Valid User"

class LoginResponse {
  String _verificationCode;
  int _isEmail;
  String _username;
  String _error;
  int _userId;
  int _isCar;
  String _status;
  String _message;

  String get verificationCode => _verificationCode;
  int get isEmail => _isEmail;
  String get username => _username;
  String get error => _error;
  int get userId => _userId;
  int get isCar => _isCar;
  String get status => _status;
  String get message => _message;

  LoginResponse({
    String verificationCode,
    int isEmail,
    String username,
    String error,
    int userId,
    int isCar,
    String status,
    String message}){
    _verificationCode = verificationCode;
    _isEmail = isEmail;
    _username = username;
    _error = error;
    _userId = userId;
    _isCar = isCar;
    _status = status;
    _message = message;
  }

  LoginResponse.fromJson(dynamic json) {
    _verificationCode = json["Verificationcode"];
    _isEmail = json["Isemail"];
    _username = json["Username"];
    _error = json["Error"];
    _userId = json["UserId"];
    _isCar = json["IsCar"];
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Verificationcode"] = _verificationCode;
    map["Isemail"] = _isEmail;
    map["Username"] = _username;
    map["Error"] = _error;
    map["UserId"] = _userId;
    map["IsCar"] = _isCar;
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }

}