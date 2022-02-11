/// ParkingUser : {"UserId":9,"Name":"Syed.openwave@gmail.com","CarNumber":null,"Sourcelat":"13.0921508","Sourcelong":"80.2214843","Destinationlat":null,"Destinationlong":null,"Distance":"20.67Km","Address":null,"DrivingMinutes":"0.69Min","SpotId":388,"CarMake":null,"CarModel":null,"CarColor":null,"SeekerId":null,"Message":null,"SpottoDestination":"8948870.19M"}
/// Status : "Success"
/// Message : "UnParked Successfully"

class InformSeekerResponse {
  ParkingUser _parkingUser;
  String _status;
  String _message;

  ParkingUser get parkingUser => _parkingUser;
  String get status => _status;
  String get message => _message;

  InformSeekerResponse({
      ParkingUser parkingUser, 
      String status, 
      String message}){
    _parkingUser = parkingUser;
    _status = status;
    _message = message;
}

  InformSeekerResponse.fromJson(dynamic json) {
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

/// UserId : 9
/// Name : "Syed.openwave@gmail.com"
/// CarNumber : null
/// Sourcelat : "13.0921508"
/// Sourcelong : "80.2214843"
/// Destinationlat : null
/// Destinationlong : null
/// Distance : "20.67Km"
/// Address : null
/// DrivingMinutes : "0.69Min"
/// SpotId : 388
/// CarMake : null
/// CarModel : null
/// CarColor : null
/// SeekerId : null
/// Message : null
/// SpottoDestination : "8948870.19M"

class ParkingUser {
  int _userId;
  String _name;
  dynamic _carNumber;
  String _sourcelat;
  String _sourcelong;
  dynamic _destinationlat;
  dynamic _destinationlong;
  String _distance;
  dynamic _address;
  String _drivingMinutes;
  int _spotId;
  dynamic _carMake;
  dynamic _carModel;
  dynamic _carColor;
  dynamic _seekerId;
  dynamic _message;
  String _spottoDestination;

  int get userId => _userId;
  String get name => _name;
  dynamic get carNumber => _carNumber;
  String get sourcelat => _sourcelat;
  String get sourcelong => _sourcelong;
  dynamic get destinationlat => _destinationlat;
  dynamic get destinationlong => _destinationlong;
  String get distance => _distance;
  dynamic get address => _address;
  String get drivingMinutes => _drivingMinutes;
  int get spotId => _spotId;
  dynamic get carMake => _carMake;
  dynamic get carModel => _carModel;
  dynamic get carColor => _carColor;
  dynamic get seekerId => _seekerId;
  dynamic get message => _message;
  String get spottoDestination => _spottoDestination;

  ParkingUser({
      int userId, 
      String name, 
      dynamic carNumber, 
      String sourcelat, 
      String sourcelong, 
      dynamic destinationlat, 
      dynamic destinationlong, 
      String distance, 
      dynamic address, 
      String drivingMinutes, 
      int spotId, 
      dynamic carMake, 
      dynamic carModel, 
      dynamic carColor, 
      dynamic seekerId, 
      dynamic message, 
      String spottoDestination}){
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
    _name = json["Name"]?? "";
    _carNumber = json["CarNumber"]?? "";
    _sourcelat = json["Sourcelat"]?? "";
    _sourcelong = json["Sourcelong"]?? "";
    _destinationlat = json["Destinationlat"]?? "";
    _destinationlong = json["Destinationlong"]?? "";
    _distance = json["Distance"]?? "";
    _address = json["Address"]?? "";
    _drivingMinutes = json["DrivingMinutes"]?? "";
    _spotId = json["SpotId"];
    _carMake = json["CarMake"]?? "";
    _carModel = json["CarModel"]?? "";
    _carColor = json["CarColor"]?? "";
    _seekerId = json["SeekerId"]?? "";
    _message = json["Message"]?? "";
    _spottoDestination = json["SpottoDestination"]?? "";
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