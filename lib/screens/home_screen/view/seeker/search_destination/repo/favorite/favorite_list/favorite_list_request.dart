/// CustomerId : "24"

class FavoriteListRequest {
  String _customerId;

  String get customerId => _customerId;

  FavoriteListRequest({
      String customerId}){
    _customerId = customerId;
}

  FavoriteListRequest.fromJson(dynamic json) {
    _customerId = json["CustomerId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["CustomerId"] = _customerId;
    return map;
  }

}