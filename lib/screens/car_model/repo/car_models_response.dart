/// Count : 14
/// Message : "Response returned successfully"
/// SearchCriteria : "Make:ASTON MARTIN"
/// Results : [{"Make_ID":440,"Make_Name":"ASTON MARTIN","Model_ID":1684,"Model_Name":"V8 Vantage"},{"Make_ID":440,"Make_Name":"ASTON MARTIN","Model_ID":1686,"Model_Name":"DBS"},{"Make_ID":440,"Make_Name":"ASTON MARTIN","Model_ID":1687,"Model_Name":"DB9"},{"Make_ID":440,"Make_Name":"ASTON MARTIN","Model_ID":1688,"Model_Name":"Rapide"},{"Make_ID":440,"Make_Name":"ASTON MARTIN","Model_ID":1695,"Model_Name":"V12 Vantage"},{"Make_ID":440,"Make_Name":"ASTON MARTIN","Model_ID":1697,"Model_Name":"Virage"},{"Make_ID":440,"Make_Name":"ASTON MARTIN","Model_ID":1701,"Model_Name":"Vanquish"},{"Make_ID":440,"Make_Name":"ASTON MARTIN","Model_ID":13751,"Model_Name":"DB11"},{"Make_ID":440,"Make_Name":"ASTON MARTIN","Model_ID":14157,"Model_Name":"Lagonda"},{"Make_ID":440,"Make_Name":"ASTON MARTIN","Model_ID":14162,"Model_Name":"Vantage"},{"Make_ID":440,"Make_Name":"ASTON MARTIN","Model_ID":14164,"Model_Name":"V8"},{"Make_ID":440,"Make_Name":"ASTON MARTIN","Model_ID":19609,"Model_Name":"Vanquish S"},{"Make_ID":440,"Make_Name":"ASTON MARTIN","Model_ID":19610,"Model_Name":"Vanquish Zagato"},{"Make_ID":440,"Make_Name":"ASTON MARTIN","Model_ID":27591



class CarModelListResponse {
  int _count;
  String _message;
  String _searchCriteria;
  List<CarModel> _results;

  int get count => _count;
  String get message => _message;
  String get searchCriteria => _searchCriteria;
  List<CarModel> get results => _results;

  CarModelListResponse({
      int count, 
      String message, 
      String searchCriteria, 
      List<CarModel> results}){
    _count = count;
    _message = message;
    _searchCriteria = searchCriteria;
    _results = results;
}

  CarModelListResponse.fromJson(dynamic json) {
    _count = json["Count"];
    _message = json["Message"];
    _searchCriteria = json["SearchCriteria"];
    if (json["Results"] != null) {
      _results = [];
      json["Results"].forEach((v) {
        _results.add(CarModel.fromJson(v));
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

/// Make_ID : 440
/// Make_Name : "ASTON MARTIN"
/// Model_ID : 1684
/// Model_Name : "V8 Vantage"

class CarModel {
  int _makeID;
  String _makeName;
  int _modelID;
  String _modelName;

  int get makeID => _makeID;
  String get makeName => _makeName;
  int get modelID => _modelID;
  String get modelName => _modelName;

  CarModel({
      int makeID, 
      String makeName, 
      int modelID, 
      String modelName}){
    _makeID = makeID;
    _makeName = makeName;
    _modelID = modelID;
    _modelName = modelName;
}

  CarModel.fromJson(dynamic json) {
    _makeID = json["Make_ID"];
    _makeName = json["Make_Name"];
    _modelID = json["Model_ID"];
    _modelName = json["Model_Name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Make_ID"] = _makeID;
    map["Make_Name"] = _makeName;
    map["Model_ID"] = _modelID;
    map["Model_Name"] = _modelName;
    return map;
  }

}