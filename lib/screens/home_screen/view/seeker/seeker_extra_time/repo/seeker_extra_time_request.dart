/// ProviderId : "58"

class SeekerExtraTimeRequest {
  String _providerId;

  String get providerId => _providerId;

  SeekerExtraTimeRequest({
      String providerId}){
    _providerId = providerId;
}

  SeekerExtraTimeRequest.fromJson(dynamic json) {
    _providerId = json["ProviderId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["ProviderId"] = _providerId;
    return map;
  }

}