/// UnParkUser : {"UserId":23,"Name":"dhamu.openwave","CarNumber":"TN01-2014","Sourcelat":"13.010575","Sourcelong":"80.23727400000001","Destinationlat":null,"Destinationlong":null,"Distance":"0.99Km","Address":"Anna University, Kotturpuram, Chennai, 600025, Tamil Nadu, India","DrivingMinutes":"0Min","SpotId":417,"CarMake":"MERCEDES-BENZ","CarModel":"M-Class","CarColor":"Silver","SeekerId":24}
/// Status : "Success"
/// Message : "Provider is waiting"

class ProviderWaitingResponse {
  UnParkUser _unParkUser;
  String _status;
  String _message;

  UnParkUser get unParkUser => _unParkUser;
  String get status => _status;
  String get message => _message;

  ProviderWaitingResponse({
      UnParkUser unParkUser, 
      String status, 
      String message}){
    _unParkUser = unParkUser;
    _status = status;
    _message = message;
}

  ProviderWaitingResponse.fromJson(dynamic json) {
    _unParkUser = json["UnParkUser"] != null ? UnParkUser.fromJson(json["UnParkUser"]) : null;
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_unParkUser != null) {
      map["UnParkUser"] = _unParkUser.toJson();
    }
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }

}

/// UserId : 23
/// Name : "dhamu.openwave"
/// CarNumber : "TN01-2014"
/// Sourcelat : "13.010575"
/// Sourcelong : "80.23727400000001"
/// Destinationlat : null
/// Destinationlong : null
/// Distance : "0.99Km"
/// Address : "Anna University, Kotturpuram, Chennai, 600025, Tamil Nadu, India"
/// DrivingMinutes : "0Min"
/// SpotId : 417
/// CarMake : "MERCEDES-BENZ"
/// CarModel : "M-Class"
/// CarColor : "Silver"
/// SeekerId : 24

class UnParkUser {
  int _userId;
  String _name;
  String _carNumber;
  String _sourcelat;
  String _sourcelong;
  dynamic _destinationlat;
  dynamic _destinationlong;
  String _distance;
  String _address;
  String _drivingMinutes;
  int _spotId;
  String _carMake;
  String _carModel;
  String _carColor;
  int _seekerId;

  int get userId => _userId;
  String get name => _name;
  String get carNumber => _carNumber;
  String get sourcelat => _sourcelat;
  String get sourcelong => _sourcelong;
  dynamic get destinationlat => _destinationlat;
  dynamic get destinationlong => _destinationlong;
  String get distance => _distance;
  String get address => _address;
  String get drivingMinutes => _drivingMinutes;
  int get spotId => _spotId;
  String get carMake => _carMake;
  String get carModel => _carModel;
  String get carColor => _carColor;
  int get seekerId => _seekerId;

  UnParkUser({
      int userId, 
      String name, 
      String carNumber, 
      String sourcelat, 
      String sourcelong, 
      dynamic destinationlat, 
      dynamic destinationlong, 
      String distance, 
      String address, 
      String drivingMinutes, 
      int spotId, 
      String carMake, 
      String carModel, 
      String carColor, 
      int seekerId}){
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
    return map;
  }

}