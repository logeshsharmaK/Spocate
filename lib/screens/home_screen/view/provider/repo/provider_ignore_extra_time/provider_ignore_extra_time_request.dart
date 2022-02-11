/// SeekerId : "58"
/// ProviderId : "56"

class ProviderIgnoreExtraTimeRequest {
  String _seekerId;
  String _providerId;

  String get seekerId => _seekerId;
  String get providerId => _providerId;

  ProviderIgnoreExtraTimeRequest({
    String seekerId,
    String providerId}){
    _seekerId = seekerId;
    _providerId = providerId;
  }

  ProviderIgnoreExtraTimeRequest.fromJson(dynamic json) {
    _seekerId = json["SeekerId"];
    _providerId = json["ProviderId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["SeekerId"] = _seekerId;
    map["ProviderId"] = _providerId;
    return map;
  }

}