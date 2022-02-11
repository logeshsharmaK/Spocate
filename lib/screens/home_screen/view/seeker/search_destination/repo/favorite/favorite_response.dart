/// FavouriteList : [{"Favouriteid":2,"Favouritelat":"12.084641","Favouritelong":"80.211971","Favouriteaddress":"chennai","MainAddress":"chennai","Favouritesubaddress":"chennai","Favouritepincode":"600119","PlaceId":"2345","CustomerId":24,"Isrecent":1,"Mode":null},{"Favouriteid":1,"Favouritelat":"13.084641","Favouritelong":"80.211971","Favouriteaddress":"Annanagar","MainAddress":"Annanagar","Favouritesubaddress":"Annanagar","Favouritepincode":"600012","PlaceId":"1234","CustomerId":24,"Isrecent":null,"Mode":null}]
/// RecentList : [{"Favouriteid":2,"Favouritelat":"12.084641","Favouritelong":"80.211971","Favouriteaddress":"chennai","MainAddress":"chennai","Favouritesubaddress":"chennai","Favouritepincode":"600119","PlaceId":"2345","CustomerId":24,"Isrecent":1,"Mode":null}]
/// Status : "Success"
/// Message : "Data fetched Successfully"

class FavoriteResponse {
  List<FavouriteList> _favouriteList;
  List<RecentList> _recentList;
  String _status;
  String _message;

  List<FavouriteList> get favouriteList => _favouriteList;
  List<RecentList> get recentList => _recentList;
  String get status => _status;
  String get message => _message;

  FavoriteResponse({
      List<FavouriteList> favouriteList, 
      List<RecentList> recentList, 
      String status, 
      String message}){
    _favouriteList = favouriteList;
    _recentList = recentList;
    _status = status;
    _message = message;
}

  FavoriteResponse.fromJson(dynamic json) {
    if (json["FavouriteList"] != null) {
      _favouriteList = [];
      json["FavouriteList"].forEach((v) {
        _favouriteList.add(FavouriteList.fromJson(v));
      });
    }
    if (json["RecentList"] != null) {
      _recentList = [];
      json["RecentList"].forEach((v) {
        _recentList.add(RecentList.fromJson(v));
      });
    }
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_favouriteList != null) {
      map["FavouriteList"] = _favouriteList.map((v) => v.toJson()).toList();
    }
    if (_recentList != null) {
      map["RecentList"] = _recentList.map((v) => v.toJson()).toList();
    }
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }

}

/// Favouriteid : 2
/// Favouritelat : "12.084641"
/// Favouritelong : "80.211971"
/// Favouriteaddress : "chennai"
/// MainAddress : "chennai"
/// Favouritesubaddress : "chennai"
/// Favouritepincode : "600119"
/// PlaceId : "2345"
/// CustomerId : 24
/// Isrecent : 1
/// Mode : null

class RecentList {
  int _favouriteid;
  String _favouritelat;
  String _favouritelong;
  String _favouriteaddress;
  String _mainAddress;
  String _favouritesubaddress;
  String _favouritepincode;
  String _placeId;
  int _customerId;
  int _isrecent;
  dynamic _mode;

  int get favouriteid => _favouriteid;
  String get favouritelat => _favouritelat;
  String get favouritelong => _favouritelong;
  String get favouriteaddress => _favouriteaddress;
  String get mainAddress => _mainAddress;
  String get favouritesubaddress => _favouritesubaddress;
  String get favouritepincode => _favouritepincode;
  String get placeId => _placeId;
  int get customerId => _customerId;
  int get isrecent => _isrecent;
  dynamic get mode => _mode;

  RecentList({
      int favouriteid,
      String favouritelat, 
      String favouritelong, 
      String favouriteaddress, 
      String mainAddress, 
      String favouritesubaddress, 
      String favouritepincode, 
      String placeId, 
      int customerId,
      int isrecent,
      dynamic mode}){
    _favouriteid = favouriteid;
    _favouritelat = favouritelat;
    _favouritelong = favouritelong;
    _favouriteaddress = favouriteaddress;
    _mainAddress = mainAddress;
    _favouritesubaddress = favouritesubaddress;
    _favouritepincode = favouritepincode;
    _placeId = placeId;
    _customerId = customerId;
    _isrecent = isrecent;
    _mode = mode;
}

  RecentList.fromJson(dynamic json) {
    _favouriteid = json["Favouriteid"];
    _favouritelat = json["Favouritelat"];
    _favouritelong = json["Favouritelong"];
    _favouriteaddress = json["Favouriteaddress"];
    _mainAddress = json["MainAddress"];
    _favouritesubaddress = json["Favouritesubaddress"];
    _favouritepincode = json["Favouritepincode"];
    _placeId = json["PlaceId"];
    _customerId = json["CustomerId"];
    _isrecent = json["Isrecent"];
    _mode = json["Mode"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Favouriteid"] = _favouriteid;
    map["Favouritelat"] = _favouritelat;
    map["Favouritelong"] = _favouritelong;
    map["Favouriteaddress"] = _favouriteaddress;
    map["MainAddress"] = _mainAddress;
    map["Favouritesubaddress"] = _favouritesubaddress;
    map["Favouritepincode"] = _favouritepincode;
    map["PlaceId"] = _placeId;
    map["CustomerId"] = _customerId;
    map["Isrecent"] = _isrecent;
    map["Mode"] = _mode;
    return map;
  }

}

/// Favouriteid : 2
/// Favouritelat : "12.084641"
/// Favouritelong : "80.211971"
/// Favouriteaddress : "chennai"
/// MainAddress : "chennai"
/// Favouritesubaddress : "chennai"
/// Favouritepincode : "600119"
/// PlaceId : "2345"
/// CustomerId : 24
/// Isrecent : 1
/// Mode : null

class FavouriteList {
  int _favouriteid;
  String _favouritelat;
  String _favouritelong;
  String _favouriteaddress;
  String _mainAddress;
  String _favouritesubaddress;
  String _favouritepincode;
  String _placeId;
  int _customerId;
  int _isrecent;
  dynamic _mode;

  int get favouriteid => _favouriteid;
  String get favouritelat => _favouritelat;
  String get favouritelong => _favouritelong;
  String get favouriteaddress => _favouriteaddress;
  String get mainAddress => _mainAddress;
  String get favouritesubaddress => _favouritesubaddress;
  String get favouritepincode => _favouritepincode;
  String get placeId => _placeId;
  int get customerId => _customerId;
  int get isrecent => _isrecent;
  dynamic get mode => _mode;

  FavouriteList({
      int favouriteid,
      String favouritelat, 
      String favouritelong, 
      String favouriteaddress, 
      String mainAddress, 
      String favouritesubaddress, 
      String favouritepincode, 
      String placeId, 
      int customerId,
      int isrecent,
      dynamic mode}){
    _favouriteid = favouriteid;
    _favouritelat = favouritelat;
    _favouritelong = favouritelong;
    _favouriteaddress = favouriteaddress;
    _mainAddress = mainAddress;
    _favouritesubaddress = favouritesubaddress;
    _favouritepincode = favouritepincode;
    _placeId = placeId;
    _customerId = customerId;
    _isrecent = isrecent;
    _mode = mode;
}

  FavouriteList.fromJson(dynamic json) {
    _favouriteid = json["Favouriteid"];
    _favouritelat = json["Favouritelat"];
    _favouritelong = json["Favouritelong"];
    _favouriteaddress = json["Favouriteaddress"];
    _mainAddress = json["MainAddress"];
    _favouritesubaddress = json["Favouritesubaddress"];
    _favouritepincode = json["Favouritepincode"];
    _placeId = json["PlaceId"];
    _customerId = json["CustomerId"];
    _isrecent = json["Isrecent"];
    _mode = json["Mode"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Favouriteid"] = _favouriteid;
    map["Favouritelat"] = _favouritelat;
    map["Favouritelong"] = _favouritelong;
    map["Favouriteaddress"] = _favouriteaddress;
    map["MainAddress"] = _mainAddress;
    map["Favouritesubaddress"] = _favouritesubaddress;
    map["Favouritepincode"] = _favouritepincode;
    map["PlaceId"] = _placeId;
    map["CustomerId"] = _customerId;
    map["Isrecent"] = _isrecent;
    map["Mode"] = _mode;
    return map;
  }

}