/// ReasonList : [{"Id":1,"Reason":"Parking spot already taken"},{"Id":2,"Reason":"It was a No parking zone"},{"Id":3,"Reason":"My Car size is big"},{"Id":4,"Reason":"Location was wrong on Map"}]
/// Status : "Success"
/// Message : "Data fetched Successfully"

class QuestionResponse {
  List<Reason> _reasonList;
  String _status;
  String _message;

  List<Reason> get reasonList => _reasonList;
  String get status => _status;
  String get message => _message;

  QuestionResponse({
      List<Reason> reasonList,
      String status, 
      String message}){
    _reasonList = reasonList;
    _status = status;
    _message = message;
}

  QuestionResponse.fromJson(dynamic json) {
    if (json["ReasonList"] != null) {
      _reasonList = [];
      json["ReasonList"].forEach((v) {
        _reasonList.add(Reason.fromJson(v));
      });
    }
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_reasonList != null) {
      map["ReasonList"] = _reasonList.map((v) => v.toJson()).toList();
    }
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }

}

/// Id : 1
/// Reason : "Parking spot already taken"

class Reason {
  int _id;
  String _reason;

  int get id => _id;
  String get reason => _reason;

  Reason({
      int id, 
      String reason}){
    _id = id;
    _reason = reason;
}

  Reason.fromJson(dynamic json) {
    _id = json["Id"];
    _reason = json["Reason"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Id"] = _id;
    map["Reason"] = _reason;
    return map;
  }

}