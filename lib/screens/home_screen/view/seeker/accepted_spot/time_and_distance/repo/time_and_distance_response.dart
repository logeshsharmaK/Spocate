/// destination_addresses : ["7, Perumbakkam Main Rd, Sholinganallur, Chennai, Tamil Nadu 600119, India"]
/// origin_addresses : ["56, Pachaiappas College Hostel Rd, Dasspuram, Chetpet, Chennai, Tamil Nadu 600031, India"]
/// rows : [{"elements":[{"distance":{"text":"23.3 km","value":23271},"duration":{"text":"49 mins","value":2948},"status":"OK"}]}]
/// status : "OK"

class TimeAndDistanceResponse {
  List<String> _destinationAddresses;
  List<String> _originAddresses;
  List<Rows> _rows;
  String _status;

  List<String> get destinationAddresses => _destinationAddresses;
  List<String> get originAddresses => _originAddresses;
  List<Rows> get rows => _rows;
  String get status => _status;

  TimeAndDistanceResponse({
      List<String> destinationAddresses, 
      List<String> originAddresses, 
      List<Rows> rows, 
      String status}){
    _destinationAddresses = destinationAddresses;
    _originAddresses = originAddresses;
    _rows = rows;
    _status = status;
}

  TimeAndDistanceResponse.fromJson(dynamic json) {
    _destinationAddresses = json["destination_addresses"] != null ? json["destination_addresses"].cast<String>() : [];
    _originAddresses = json["origin_addresses"] != null ? json["origin_addresses"].cast<String>() : [];
    if (json["rows"] != null) {
      _rows = [];
      json["rows"].forEach((v) {
        _rows.add(Rows.fromJson(v));
      });
    }
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["destination_addresses"] = _destinationAddresses;
    map["origin_addresses"] = _originAddresses;
    if (_rows != null) {
      map["rows"] = _rows.map((v) => v.toJson()).toList();
    }
    map["status"] = _status;
    return map;
  }

}

/// elements : [{"distance":{"text":"23.3 km","value":23271},"duration":{"text":"49 mins","value":2948},"status":"OK"}]

class Rows {
  List<Elements> _elements;

  List<Elements> get elements => _elements;

  Rows({
      List<Elements> elements}){
    _elements = elements;
}

  Rows.fromJson(dynamic json) {
    if (json["elements"] != null) {
      _elements = [];
      json["elements"].forEach((v) {
        _elements.add(Elements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_elements != null) {
      map["elements"] = _elements.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// distance : {"text":"23.3 km","value":23271}
/// duration : {"text":"49 mins","value":2948}
/// status : "OK"

class Elements {
  Distance _distance;
  Duration _duration;
  String _status;

  Distance get distance => _distance;
  Duration get duration => _duration;
  String get status => _status;

  Elements({
      Distance distance, 
      Duration duration, 
      String status}){
    _distance = distance;
    _duration = duration;
    _status = status;
}

  Elements.fromJson(dynamic json) {
    _distance = json["distance"] != null ? Distance.fromJson(json["distance"]) : null;
    _duration = json["duration"] != null ? Duration.fromJson(json["duration"]) : null;
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_distance != null) {
      map["distance"] = _distance.toJson();
    }
    if (_duration != null) {
      map["duration"] = _duration.toJson();
    }
    map["status"] = _status;
    return map;
  }

}

/// text : "49 mins"
/// value : 2948

class Duration {
  String _text;
  int _value;

  String get text => _text;
  int get value => _value;

  Duration({
      String text, 
      int value}){
    _text = text;
    _value = value;
}

  Duration.fromJson(dynamic json) {
    _text = json["text"];
    _value = json["value"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["text"] = _text;
    map["value"] = _value;
    return map;
  }

}

/// text : "23.3 km"
/// value : 23271

class Distance {
  String _text;
  int _value;

  String get text => _text;
  int get value => _value;

  Distance({
      String text, 
      int value}){
    _text = text;
    _value = value;
}

  Distance.fromJson(dynamic json) {
    _text = json["text"];
    _value = json["value"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["text"] = _text;
    map["value"] = _value;
    return map;
  }

}