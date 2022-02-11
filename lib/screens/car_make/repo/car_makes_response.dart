/// Count : 9618
/// Message : "Response returned successfully"
/// SearchCriteria : null
/// Results : [{"Make_ID":"440","Make_Name":"ASTON MARTIN"},{"Make_ID":"441","Make_Name":"TESLA"}]

class CarMakeListResponse {
  int _count;
  String _message;
  dynamic _searchCriteria;
  List<CarMake> _results;

  int get count => _count;
  String get message => _message;
  dynamic get searchCriteria => _searchCriteria;
  List<CarMake> get results => _results;

  CarMakeListResponse({
      int count, 
      String message, 
      dynamic searchCriteria, 
      List<CarMake> results}){
    _count = count;
    _message = message;
    _searchCriteria = searchCriteria;
    _results = results;
}

  CarMakeListResponse.fromJson(dynamic json) {
    _count = json["Count"];
    _message = json["Message"];
    _searchCriteria = json["SearchCriteria"];
    if (json["Results"] != null) {
      _results = [];
      json["Results"].forEach((v) {
        _results.add(CarMake.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Count"] = _count;
    map["Message"] = _message;
    map["SearchCriteria"] = _searchCriteria;
    if (_results != null) {
      map["Results"] = _results.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// Make_ID : "440"
/// Make_Name : "ASTON MARTIN"

class CarMake {
  int _makeID;
  String _makeName;

  int get makeID => _makeID;
  String get makeName => _makeName;

  CarMake({
      int makeID,
      String makeName}){
    _makeID = makeID;
    _makeName = makeName;
}

  CarMake.fromJson(dynamic json) {
    _makeID = json["Make_ID"];
    _makeName = json["Make_Name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Make_ID"] = _makeID;
    map["Make_Name"] = _makeName;
    return map;
  }

}