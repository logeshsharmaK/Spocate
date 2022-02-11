/// ColorList : [{"Colorid":1,"Colorname":"White","Status":1},{"Colorid":2,"Colorname":"Black","Status":1},{"Colorid":3,"Colorname":"Gray","Status":1},{"Colorid":4,"Colorname":"Silver","Status":1},{"Colorid":5,"Colorname":"Red","Status":1},{"Colorid":6,"Colorname":"Blue","Status":1},{"Colorid":7,"Colorname":"Brown","Status":1},{"Colorid":8,"Colorname":"Green","Status":1},{"Colorid":9,"Colorname":"Beige","Status":1},{"Colorid":10,"Colorname":"Orange","Status":1},{"Colorid":11,"Colorname":"Gold","Status":1},{"Colorid":12,"Colorname":"Yellow","Status":1},{"Colorid":13,"Colorname":"Purple","Status":1}]
/// Status : "Success"
/// Message : "Data fetched Successfully"

class CarColorListResponse {
  List<ColorList> _colorList;
  String _status;
  String _message;

  List<ColorList> get colorList => _colorList;
  String get status => _status;
  String get message => _message;

  CarColorListResponse({
      List<ColorList> colorList, 
      String status, 
      String message}){
    _colorList = colorList;
    _status = status;
    _message = message;
}

  CarColorListResponse.fromJson(dynamic json) {
    if (json["ColorList"] != null) {
      _colorList = [];
      json["ColorList"].forEach((v) {
        _colorList.add(ColorList.fromJson(v));
      });
    }
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_colorList != null) {
      map["ColorList"] = _colorList.map((v) => v.toJson()).toList();
    }
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }

}

/// Colorid : 1
/// Colorname : "White"
/// Status : 1

class ColorList {
  int _colorid;
  String _colorname;
  int _status;

  int get colorid => _colorid;
  String get colorname => _colorname;
  int get status => _status;

  ColorList({
      int colorid, 
      String colorname, 
      int status}){
    _colorid = colorid;
    _colorname = colorname;
    _status = status;
}

  ColorList.fromJson(dynamic json) {
    _colorid = json["Colorid"];
    _colorname = json["Colorname"];
    _status = json["Status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Colorid"] = _colorid;
    map["Colorname"] = _colorname;
    map["Status"] = _status;
    return map;
  }

}