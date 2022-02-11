/// UnParkUser : {"UserId":9,"Name":"Syed.openwave@gmail.com","CarNumber":"null","Sourcelat":"13.0936461","Sourcelong":"80.2230938","Destinationlat":"null","Destinationlong":"null","Distance":"20.83Km","Address":"91, O BLOCK 34th St, Block O, O Block, Annanagar East, Chennai, Tamil Nadu 600102, India","DrivingMinutes":"0.59Min","SpotId":574,"CarMake":"null","CarModel":"null","CarColor":"null","SeekerId":"null","Message":"null"}
/// ParkingUser : {"UserId":47,"Name":"null","CarNumber":"TN33AB3333","Sourcelat":"12.9066161","Sourcelong":"80.2339378","Destinationlat":"null","Destinationlong":"null","Distance":"17.65Km","Address":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India","DrivingMinutes":"0.59Min","SpotId":"null","CarMake":"MASERATI","CarModel":"Ghibli","CarColor":"Brown","SeekerId":null,"Message":"null"}
/// Status : "Success"
/// Message : "Free spot Located"

class UpdateLocationResponse {
  UnParkUser _unParkUser;
  ParkingUser _parkingUser;
  String _status;
  String _message;

  UnParkUser get unParkUser => _unParkUser;

  ParkingUser get parkingUser => _parkingUser;

  String get status => _status;

  String get message => _message;

  UpdateLocationResponse(
      {UnParkUser unParkUser,
      ParkingUser parkingUser,
      String status,
      String message}) {
    _unParkUser = unParkUser;
    _parkingUser = parkingUser;
    _status = status;
    _message = message;
  }

  UpdateLocationResponse.fromJson(dynamic json) {
    _unParkUser = json["UnParkUser"] != null
        ? UnParkUser.fromJson(json["UnParkUser"])
        : null;
    _parkingUser = json["ParkingUser"] != null
        ? ParkingUser.fromJson(json["ParkingUser"])
        : null;
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_unParkUser != null) {
      map["UnParkUser"] = _unParkUser.toJson();
    }
    if (_parkingUser != null) {
      map["ParkingUser"] = _parkingUser.toJson();
    }
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }
}

/// UserId : 47
/// Name : "null"
/// CarNumber : "TN33AB3333"
/// Sourcelat : "12.9066161"
/// Sourcelong : "80.2339378"
/// Destinationlat : "null"
/// Destinationlong : "null"
/// Distance : "17.65Km"
/// Address : "1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India"
/// DrivingMinutes : "0.59Min"
/// SpotId : "null"
/// CarMake : "MASERATI"
/// CarModel : "Ghibli"
/// CarColor : "Brown"
/// SeekerId : null
/// Message : "null"

class ParkingUser {
  int _userId;
  String _name;
  String _carNumber;
  String _sourcelat;
  String _sourcelong;
  String _destinationlat;
  String _destinationlong;
  String _distance;
  String _address;
  String _drivingMinutes;
  int _spotId;
  String _carMake;
  String _carModel;
  String _carColor;
  dynamic _seekerId;
  String _message;

  int get userId => _userId;

  String get name => _name;

  String get carNumber => _carNumber;

  String get sourcelat => _sourcelat;

  String get sourcelong => _sourcelong;

  String get destinationlat => _destinationlat;

  String get destinationlong => _destinationlong;

  String get distance => _distance;

  String get address => _address;

  String get drivingMinutes => _drivingMinutes;

  int get spotId => _spotId;

  String get carMake => _carMake;

  String get carModel => _carModel;

  String get carColor => _carColor;

  dynamic get seekerId => _seekerId;

  String get message => _message;

  ParkingUser(
      {int userId,
      String name,
      String carNumber,
      String sourcelat,
      String sourcelong,
      String destinationlat,
      String destinationlong,
      String distance,
      String address,
      String drivingMinutes,
      int spotId,
      String carMake,
      String carModel,
      String carColor,
      dynamic seekerId,
      String message}) {
    _userId = userId;
    _name = name;
    _carNumber = carNumber;
    _sourcelat = sourcelat;
    _sourcelong = sourcelong;
    _destinationlat = destinationlat;
    _destinationlong = destinationlong;
    _distance = distance;
    _address = address;
    _drivingMinutes = drivingMinutes;
    _spotId = spotId;
    _carMake = carMake;
    _carModel = carModel;
    _carColor = carColor;
    _seekerId = seekerId;
    _message = message;
  }

  ParkingUser.fromJson(dynamic json) {
    _userId = json["UserId"];
    _name = json["Name"];
    _carNumber = json["CarNumber"];
    _sourcelat = json["Sourcelat"];
    _sourcelong = json["Sourcelong"];
    _destinationlat = json["Destinationlat"];
    _destinationlong = json["Destinationlong"];
    _distance = json["Distance"];
    _address = json["Address"];
    _drivingMinutes = json["DrivingMinutes"];
    _spotId = json["SpotId"];
    _carMake = json["CarMake"];
    _carModel = json["CarModel"];
    _carColor = json["CarColor"];
    _seekerId = json["SeekerId"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["UserId"] = _userId;
    map["Name"] = _name;
    map["CarNumber"] = _carNumber;
    map["Sourcelat"] = _sourcelat;
    map["Sourcelong"] = _sourcelong;
    map["Destinationlat"] = _destinationlat;
    map["Destinationlong"] = _destinationlong;
    map["Distance"] = _distance;
    map["Address"] = _address;
    map["DrivingMinutes"] = _drivingMinutes;
    map["SpotId"] = _spotId;
    map["CarMake"] = _carMake;
    map["CarModel"] = _carModel;
    map["CarColor"] = _carColor;
    map["SeekerId"] = _seekerId;
    map["Message"] = _message;
    return map;
  }
}

/// UserId : 9
/// Name : "Syed.openwave@gmail.com"
/// CarNumber : "null"
/// Sourcelat : "13.0936461"
/// Sourcelong : "80.2230938"
/// Destinationlat : "null"
/// Destinationlong : "null"
/// Distance : "20.83Km"
/// Address : "91, O BLOCK 34th St, Block O, O Block, Annanagar East, Chennai, Tamil Nadu 600102, India"
/// DrivingMinutes : "0.59Min"
/// SpotId : 574
/// CarMake : "null"
/// CarModel : "null"
/// CarColor : "null"
/// SeekerId : "null"
/// Message : "null"

class UnParkUser {
  int _userId;
  String _name;
  String _carNumber;
  String _sourcelat;
  String _sourcelong;
  String _destinationlat;
  String _destinationlong;
  String _distance;
  String _address;
  String _drivingMinutes;
  int _spotId;
  String _carMake;
  String _carModel;
  String _carColor;
  String _seekerId;
  String _message;

  int get userId => _userId;

  String get name => _name;

  String get carNumber => _carNumber;

  String get sourcelat => _sourcelat;

  String get sourcelong => _sourcelong;

  String get destinationlat => _destinationlat;

  String get destinationlong => _destinationlong;

  String get distance => _distance;

  String get address => _address;

  String get drivingMinutes => _drivingMinutes;

  int get spotId => _spotId;

  String get carMake => _carMake;

  String get carModel => _carModel;

  String get carColor => _carColor;

  String get seekerId => _seekerId;

  String get message => _message;

  UnParkUser(
      {int userId,
      String name,
      String carNumber,
      String sourcelat,
      String sourcelong,
      String destinationlat,
      String destinationlong,
      String distance,
      String address,
      String drivingMinutes,
      int spotId,
      String carMake,
      String carModel,
      String carColor,
      String seekerId,
      String message}) {
    _userId = userId;
    _name = name;
    _carNumber = carNumber;
    _sourcelat = sourcelat;
    _sourcelong = sourcelong;
    _destinationlat = destinationlat;
    _destinationlong = destinationlong;
    _distance = distance;
    _address = address;
    _drivingMinutes = drivingMinutes;
    _spotId = spotId;
    _carMake = carMake;
    _carModel = carModel;
    _carColor = carColor;
    _seekerId = seekerId;
    _message = message;
  }

  UnParkUser.fromJson(dynamic json) {
    _userId = json["UserId"];
    _name = json["Name"];
    _carNumber = json["CarNumber"];
    _sourcelat = json["Sourcelat"];
    _sourcelong = json["Sourcelong"];
    _destinationlat = json["Destinationlat"];
    _destinationlong = json["Destinationlong"];
    _distance = json["Distance"];
    _address = json["Address"];
    _drivingMinutes = json["DrivingMinutes"];
    _spotId = json["SpotId"];
    _carMake = json["CarMake"];
    _carModel = json["CarModel"];
    _carColor = json["CarColor"];
    _seekerId = json["SeekerId"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["UserId"] = _userId;
    map["Name"] = _name;
    map["CarNumber"] = _carNumber;
    map["Sourcelat"] = _sourcelat;
    map["Sourcelong"] = _sourcelong;
    map["Destinationlat"] = _destinationlat;
    map["Destinationlong"] = _destinationlong;
    map["Distance"] = _distance;
    map["Address"] = _address;
    map["DrivingMinutes"] = _drivingMinutes;
    map["SpotId"] = _spotId;
    map["CarMake"] = _carMake;
    map["CarModel"] = _carModel;
    map["CarColor"] = _carColor;
    map["SeekerId"] = _seekerId;
    map["Message"] = _message;
    return map;
  }
}
