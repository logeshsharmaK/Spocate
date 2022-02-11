class SpottedProviderResponse {
  String _status;
  String _message;

  String get status => _status;
  String get message => _message;

  SpottedProviderResponse({
    String status,
    String message}){
    _status = status;
    _message = message;
  }

  SpottedProviderResponse.fromJson(dynamic json) {
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }

}