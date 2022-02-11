/// destination_addresses : []
/// error_message : "The provided API key is invalid."
/// origin_addresses : []
/// rows : []
/// status : "REQUEST_DENIED"

class TimeAndDistanceFailedResponse {

  String _errorMessage;
  String _status;

  String get status => _status;
  String get errorMessage => _errorMessage;

  TimeAndDistanceFailedResponse({
      String errorMessage,
      String status}){
    _errorMessage = errorMessage;
    _status = status;
}

  TimeAndDistanceFailedResponse.fromJson(dynamic json) {
    _errorMessage = json["error_message"];
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["error_message"] = _errorMessage;
    map["status"] = _status;
    return map;
  }
}