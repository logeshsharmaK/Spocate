/// ParkingUser : {"UserId":10076,"Name":null,"CarNumber":"AP44DD4444","Sourcelat":"12.906298977977135","Sourcelong":"80.2283879129887","Destinationlat":null,"Destinationlong":null,"Distance":"0.58Km","Address":"Accenture sholinganallur","DrivingMinutes":null,"SpotId":null,"CarMake":"ROLLS ROYCE","CarModel":"Touring Limousine","CarColor":"Silver","SeekerId":null,"Message":null,"SpottoDestination":null}
/// Status : "Success"
/// Message : "UnParked Successfully"

class UnParkResponse {
  ParkingUser _parkingUser;
  String _status;
  String _message;

  ParkingUser get parkingUser => _parkingUser;
  String get status => _status;
  String get message => _message;

  UnParkResponse({
    ParkingUser parkingUser,
    String status,
    String message}){
    _parkingUser = parkingUser;
    _status = status;
    _message = message;
  }

  UnParkResponse.fromJson(dynamic json) {
    _parkingUser = json["ParkingUser"] != null ? ParkingUser.fromJson(json["ParkingUser"]) : null;
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_parkingUser != null) {
      map["ParkingUser"] = _parkingUser.toJson();
    }
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }

}

/// UserId : 10076
/// Name : null
/// CarNumber : "AP44DD4444"
/// Sourcelat : "12.906298977977135"
/// Sourcelong : "80.2283879129887"
/// Destinationlat : null
/// Destinationlong : null
/// Distance : "0.58Km"
/// Address : "Accenture sholinganallur"
/// DrivingMinutes : null
/// SpotId : null
/// CarMake : "ROLLS ROYCE"
/// CarModel : "Touring Limousine"
/// CarColor : "Silver"
/// SeekerId : null
/// Message : null
/// SpottoDestination : null

class ParkingUser {
  int _userId;
  dynamic _name;
  String _carNumber;
  String _sourcelat;
  String _sourcelong;
  dynamic _destinationlat;
  dynamic _destinationlong;
  String _distance;
  String _address;
  dynamic _drivingMinutes;
  dynamic _spotId;
  String _carMake;
  String _carModel;
  String _carColor;
  dynamic _seekerId;
  dynamic _message;
  dynamic _spottoDestination;

  int get userId => _userId;
  dynamic get name => _name;
  String get carNumber => _carNumber;
  String get sourcelat => _sourcelat;
  String get sourcelong => _sourcelong;
  dynamic get destinationlat => _destinationlat;
  dynamic get destinationlong => _destinationlong;
  String get distance => _distance;
  String get address => _address;
  dynamic get drivingMinutes => _drivingMinutes;
  dynamic get spotId => _spotId;
  String get carMake => _carMake;
  String get carModel => _carModel;
  String get carColor => _carColor;
  dynamic get seekerId => _seekerId;
  dynamic get message => _message;
  dynamic get spottoDestination => _spottoDestination;

  ParkingUser({
    int userId,
    dynamic name,
    String carNumber,
    String sourcelat,
    String sourcelong,
    dynamic destinationlat,
    dynamic destinationlong,
    String distance,
    String address,
    dynamic drivingMinutes,
    dynamic spotId,
    String carMake,
    String carModel,
    String carColor,
    dynamic seekerId,
    dynamic message,
    dynamic spottoDestination}){
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
    _spottoDestination = spottoDestination;
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
    _spottoDestination = json["SpottoDestination"];
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
    map["SpottoDestination"] = _spottoDestination;
    return map;
  }

}