/// Status : "Success"
/// Message : "We will notify you of free spot availabilty once you near your destination"

class ProviderCancelResponse {
  String _seekerId;
  String _providerId;
  String _status;
  String _message;

  String get seekerId => _seekerId;
  String get providerId => _providerId;
  String get status => _status;
  String get message => _message;

  ProviderCancelResponse({
    String seekerId,
    String providerId,
    String status,
    String message}){
    _seekerId= seekerId;
    _providerId= providerId;
    _status = status;
    _message = message;
  }

  ProviderCancelResponse.fromJson(dynamic json) {
    _seekerId = json["SeekerId"];
    _providerId = json["ProviderId"];
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["SeekerId"] = _seekerId;
    map["ProviderId"] = _providerId;
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }

}