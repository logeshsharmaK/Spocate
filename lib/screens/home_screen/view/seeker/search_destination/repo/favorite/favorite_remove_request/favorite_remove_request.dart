/// Favouriteid : "1"

class FavoriteRemoveRequest {
  String _favouriteid;

  String get favouriteid => _favouriteid;

  FavoriteRemoveRequest({
      String favouriteid}){
    _favouriteid = favouriteid;
}

  FavoriteRemoveRequest.fromJson(dynamic json) {
    _favouriteid = json["Favouriteid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Favouriteid"] = _favouriteid;
    return map;
  }

}