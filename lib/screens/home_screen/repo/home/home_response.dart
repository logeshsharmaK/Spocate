import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/my_cars_response.dart';

/// UserInfo : {"Id":24,"Username":"7200707613","Name":"null","Email":"null","Mobile":"null","CarNumber":"tn10jd39i3","Status":"Active"}
/// CarInfo : {"Mode":"null","Id":70,"Customerid":24,"Carmake":"2-G TRAILER CO LLC","Carmodel":"2-G Trailer Co LLC","Carcolor":"Blue","Carnumber":"tn10jd39i3","Isdefault":1}
/// SupportEmail : "carpal@openwavecomp.in"
/// SupportMobile : "9860001234"
/// Status : "Success"
/// Message : "Data fetched Successfully"

class HomeResponse {
  UserInfo _userInfo;
  CarItem _carInfo;
  String _supportEmail;
  String _supportMobile;
  String _status;
  String _message;

  UserInfo get userInfo => _userInfo;

  CarItem get carInfo => _carInfo;

  String get supportEmail => _supportEmail;

  String get supportMobile => _supportMobile;

  String get status => _status;

  String get message => _message;

  HomeResponse(
      {UserInfo userInfo,
        CarItem carInfo,
      String supportEmail,
      String supportMobile,
      String status,
      String message}) {
    _userInfo = userInfo;
    _carInfo = carInfo;
    _supportEmail = supportEmail;
    _supportMobile = supportMobile;
    _status = status;
    _message = message;
  }

  HomeResponse.fromJson(dynamic json) {
    _userInfo =
        json["UserInfo"] != null ? UserInfo.fromJson(json["UserInfo"]) : null;
    _carInfo =
        json["CarInfo"] != null ? CarItem.fromJson(json["CarInfo"]) : null;
    _supportEmail = json["SupportEmail"];
    _supportMobile = json["SupportMobile"];
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_userInfo != null) {
      map["UserInfo"] = _userInfo.toJson();
    }
    if (_carInfo != null) {
      map["CarInfo"] = _carInfo.toJson();
    }
    map["SupportEmail"] = _supportEmail;
    map["SupportMobile"] = _supportMobile;
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }
}

/// Mode : "null"
/// Id : 70
/// Customerid : 24
/// Carmake : "2-G TRAILER CO LLC"
/// Carmodel : "2-G Trailer Co LLC"
/// Carcolor : "Blue"
/// Carnumber : "tn10jd39i3"
/// Isdefault : 1

/*
class CarInfo {
  String _mode;
  int _id;
  int _customerid;
  String _carmake;
  String _carmodel;
  String _carcolor;
  String _carnumber;
  int _isdefault;

  String get mode => _mode;

  int get id => _id;

  int get customerid => _customerid;

  String get carmake => _carmake;

  String get carmodel => _carmodel;

  String get carcolor => _carcolor;

  String get carnumber => _carnumber;

  int get isdefault => _isdefault;

  CarInfo(
      {String mode,
      int id,
      int customerid,
      String carmake,
      String carmodel,
      String carcolor,
      String carnumber,
      int isdefault}) {
    _mode = mode;
    _id = id;
    _customerid = customerid;
    _carmake = carmake;
    _carmodel = carmodel;
    _carcolor = carcolor;
    _carnumber = carnumber;
    _isdefault = isdefault;
  }

  CarInfo.fromJson(dynamic json) {
    _mode = json["Mode"];
    _id = json["Id"];
    _customerid = json["Customerid"];
    _carmake = json["Carmake"];
    _carmodel = json["Carmodel"];
    _carcolor = json["Carcolor"];
    _carnumber = json["Carnumber"];
    _isdefault = json["Isdefault"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Mode"] = _mode;
    map["Id"] = _id;
    map["Customerid"] = _customerid;
    map["Carmake"] = _carmake;
    map["Carmodel"] = _carmodel;
    map["Carcolor"] = _carcolor;
    map["Carnumber"] = _carnumber;
    map["Isdefault"] = _isdefault;
    return map;
  }
}
*/

/// Id : 24
/// Username : "7200707613"
/// Name : "null"
/// Email : "null"
/// Mobile : "null"
/// CarNumber : "tn10jd39i3"
/// Status : "Active"

class UserInfo {
  int _id;
  String _username;
  String _name;
  String _email;
  String _mobile;
  String _carNumber;
  String _status;
  int _isParked;
  String _deviceId;
  int _creditCount;

  int get id => _id;
  String get username => _username;
  String get name => _name;
  String get email => _email;
  String get mobile => _mobile;
  String get carNumber => _carNumber;
  String get status => _status;
  int get isParked => _isParked;
  String get deviceId => _deviceId;
  int get creditCount => _creditCount;

  UserInfo(
      {int id,
      String username,
      String name,
      String email,
      String mobile,
      String carNumber,
      String status,String deviceId,int creditCount}) {
    _id = id;
    _username = username;
    _name = name;
    _email = email;
    _mobile = mobile;
    _carNumber = carNumber;
    _status = status;
    _isParked = isParked;
    _deviceId = deviceId;
    _creditCount = creditCount;
  }

  UserInfo.fromJson(dynamic json) {
    _id = json["Id"];
    _username = json["Username"];
    _name = json["Name"];
    _email = json["Email"];
    _mobile = json["Mobile"];
    _carNumber = json["CarNumber"];
    _status = json["Status"];
    _isParked = json["IsParked"] ?? 0;
    _deviceId = json["DeviceID"];
    _creditCount = json["Credits"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Id"] = _id;
    map["Username"] = _username;
    map["Name"] = _name;
    map["Email"] = _email;
    map["Mobile"] = _mobile;
    map["CarNumber"] = _carNumber;
    map["Status"] = _status;
    map["IsParked"] = _isParked;
    map["DeviceID"] = _deviceId;
    map["Credits"] = _creditCount;
    return map;
  }
}
