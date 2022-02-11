/// SeekerId  : "56"

class ProviderAcceptExtraTimeRequest {
  String _seekerId ;

  String get seekerId  => _seekerId ;

  ProviderAcceptExtraTimeRequest({
      String seekerId }){
    _seekerId  = seekerId ;
}

  ProviderAcceptExtraTimeRequest.fromJson(dynamic json) {
    _seekerId  = json["SeekerId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["SeekerId"] = _seekerId ;
    return map;
  }

}