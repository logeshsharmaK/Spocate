/// Balancepoints : 5
/// Earnedpoints : 5
/// Spentpoints : 0
/// TransactionList : [{"Transactiontype":"Signup Bonus","Name":"9500017590","Points":5,"Ridedate":"2021-08-16T19:03:19.83","Seekeraddress":"70a, 6th Street, Kumaraswami Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India","Provideraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India"},{"Transactiontype":"Signup Bonus","Name":"9500017590","Points":5,"Ridedate":"2021-08-17T10:39:27.723","Seekeraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India","Provideraddress":null},{"Transactiontype":"Signup Bonus","Name":"9500017590","Points":5,"Ridedate":"2021-08-17T10:42:52.59","Seekeraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India","Provideraddress":null},{"Transactiontype":"Signup Bonus","Name":"9500017590","Points":5,"Ridedate":"2021-08-17T10:43:28.91","Seekeraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India","Provideraddress":null},{"Transactiontype":"Signup Bonus","Name":"9500017590","Points":5,"Ridedate":"2021-08-17T10:45:14.403","Seekeraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India","Provideraddress":null},{"Transactiontype":"Signup Bonus","Name":"9500017590","Points":5,"Ridedate":"2021-08-17T10:49:22.28","Seekeraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India","Provideraddress":null},{"Transactiontype":"Signup Bonus","Name":"9500017590","Points":5,"Ridedate":"2021-08-17T10:50:02.513","Seekeraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India","Provideraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India"},{"Transactiontype":"Signup Bonus","Name":"9500017590","Points":5,"Ridedate":"2021-08-17T10:50:53.927","Seekeraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India","Provideraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India"},{"Transactiontype":"Signup Bonus","Name":"9500017590","Points":5,"Ridedate":"2021-08-17T10:58:28.753","Seekeraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India","Provideraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India"},{"Transactiontype":"Signup Bonus","Name":"9500017590","Points":5,"Ridedate":"2021-08-17T11:34:02.14","Seekeraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India","Provideraddress":"22, 5th Cross St, Sholinganallur, Chennai, Tamil Nadu 600119, India"},{"Transactiontype":"Signup Bonus","Name":"9500017590","Points":5,"Ridedate":"2021-08-17T11:36:06.627","Seekeraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India","Provideraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India"},{"Transactiontype":"Signup Bonus","Name":"9500017590","Points":5,"Ridedate":"2021-08-17T11:36:46.977","Seekeraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India","Provideraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India"},{"Transactiontype":"Signup Bonus","Name":"9500017590","Points":5,"Ridedate":"2021-08-17T11:37:20.55","Seekeraddress":"1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India","Provideraddress":"22, Village High Rd, Sholinganallur, Chennai, Tamil Nadu 600119, India"}]
/// Status : "Success"
/// Message : "Data fetched Successfully"

class TransactionsResponse {
  int _balancepoints;
  int _earnedpoints;
  int _spentpoints;
  List<TransactionItem> _transactionList;
  String _status;
  String _message;

  int get balancepoints => _balancepoints;
  int get earnedpoints => _earnedpoints;
  int get spentpoints => _spentpoints;
  List<TransactionItem> get transactionList => _transactionList;
  String get status => _status;
  String get message => _message;

  TransactionsResponse({
      int balancepoints, 
      int earnedpoints, 
      int spentpoints, 
      List<TransactionItem> transactionList,
      String status, 
      String message}){
    _balancepoints = balancepoints;
    _earnedpoints = earnedpoints;
    _spentpoints = spentpoints;
    _transactionList = transactionList;
    _status = status;
    _message = message;
}

  TransactionsResponse.fromJson(dynamic json) {
    _balancepoints = json["Balancepoints"];
    _earnedpoints = json["Earnedpoints"];
    _spentpoints = json["Spentpoints"];
    if (json["List"] != null) {
      _transactionList = [];
      json["List"].forEach((v) {
        _transactionList.add(TransactionItem.fromJson(v));
      });
    }
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Balancepoints"] = _balancepoints;
    map["Earnedpoints"] = _earnedpoints;
    map["Spentpoints"] = _spentpoints;
    if (_transactionList != null) {
      map["List"] = _transactionList.map((v) => v.toJson()).toList();
    }
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }

}

/// Transactiontype : "Signup Bonus"
/// Name : "9500017590"
/// Points : 5
/// Ridedate : "2021-08-16T19:03:19.83"
/// Seekeraddress : "70a, 6th Street, Kumaraswami Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India"
/// Provideraddress : "1, New Kumaran Nagar 2nd Main Rd, New Kumaran Nagar, Sholinganallur, Chennai, Tamil Nadu 600119, India"

class TransactionItem {
  String _transactiontype;
  String _name;
  int _points;
  String _ridedate;
  String _seekeraddress;
  String _provideraddress;

  String get transactiontype => _transactiontype;
  String get name => _name;
  int get points => _points;
  String get ridedate => _ridedate;
  String get seekeraddress => _seekeraddress;
  String get provideraddress => _provideraddress;

  TransactionItem({
      String transactiontype, 
      String name, 
      int points, 
      String ridedate, 
      String seekeraddress, 
      String provideraddress}){
    _transactiontype = transactiontype;
    _name = name;
    _points = points;
    _ridedate = ridedate;
    _seekeraddress = seekeraddress;
    _provideraddress = provideraddress;
}

  TransactionItem.fromJson(dynamic json) {
    _transactiontype = json["Transactiontype"];
    _name = json["Name"];
    _points = json["Points"];
    _ridedate = json["Ridedate"];
    _seekeraddress = json["Seekeraddress"];
    _provideraddress = json["Provideraddress"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Transactiontype"] = _transactiontype;
    map["Name"] = _name;
    map["Points"] = _points;
    map["Ridedate"] = _ridedate;
    map["Seekeraddress"] = _seekeraddress;
    map["Provideraddress"] = _provideraddress;
    return map;
  }

}