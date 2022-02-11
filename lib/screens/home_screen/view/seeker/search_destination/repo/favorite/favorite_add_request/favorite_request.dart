/// CustomerId : "24"
/// Favouritelat : "12.084641"
/// Favouritelong : "80.211971"
/// Favouriteaddress : "chennai"
/// MainAddress : "chennai"
/// Favouritesubaddress : "chennai"
/// Favouritepincode : "600119"
/// PlaceId : "2345"
/// Isrecent : "1"

class FavoriteRequest {
  String _customerId;
  String _favouritelat;
  String _favouritelong;
  String _favouriteaddress;
  String _mainAddress;
  String _favouritesubaddress;
  String _favouritepincode;
  String _placeId;
  String _isrecent;

  String get customerId => _customerId;
  String get favouritelat => _favouritelat;
  String get favouritelong => _favouritelong;
  String get favouriteaddress => _favouriteaddress;
  String get mainAddress => _mainAddress;
  String get favouritesubaddress => _favouritesubaddress;
  String get favouritepincode => _favouritepincode;
  String get placeId => _placeId;
  String get isrecent => _isrecent;

  FavoriteRequest({
      String customerId, 
      String favouritelat, 
      String favouritelong, 
      String favouriteaddress, 
      String mainAddress, 
      String favouritesubaddress, 
      String favouritepincode, 
      String placeId, 
      String isrecent}){
    _customerId = customerId;
    _favouritelat = favouritelat;
    _favouritelong = favouritelong;
    _favouriteaddress = favouriteaddress;
    _mainAddress = mainAddress;
    _favouritesubaddress = favouritesubaddress;
    _favouritepincode = favouritepincode;
    _placeId = placeId;
    _isrecent = isrecent;
}

  FavoriteRequest.fromJson(dynamic json) {
    _customerId = json["CustomerId"];
    _favouritelat = json["Favouritelat"];
    _favouritelong = json["Favouritelong"];
    _favouriteaddress = json["Favouriteaddress"];
    _mainAddress = json["MainAddress"];
    _favouritesubaddress = json["Favouritesubaddress"];
    _favouritepincode = json["Favouritepincode"];
    _placeId = json["PlaceId"];
    _isrecent = json["Isrecent"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["CustomerId"] = _customerId;
    map["Favouritelat"] = _favouritelat;
    map["Favouritelong"] = _favouritelong;
    map["Favouriteaddress"] = _favouriteaddress;
    map["MainAddress"] = _mainAddress;
    map["Favouritesubaddress"] = _favouritesubaddress;
    map["Favouritepincode"] = _favouritepincode;
    map["PlaceId"] = _placeId;
    map["Isrecent"] = _isrecent;
    return map;
  }
}