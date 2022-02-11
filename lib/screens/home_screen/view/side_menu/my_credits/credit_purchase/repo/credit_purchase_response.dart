/// CreditPurchaseList : [{"Id":1,"Amount":5.00,"Points":11,"Currency":"USD","Mode":null},{"Id":2,"Amount":15.00,"Points":20,"Currency":"USD","Mode":null},{"Id":3,"Amount":25.00,"Points":30,"Currency":"USD","Mode":null},{"Id":4,"Amount":35.00,"Points":40,"Currency":"USD","Mode":null},{"Id":5,"Amount":45.00,"Points":50,"Currency":"USD","Mode":null}]
/// Status : "Success"
/// Message : "Data fetched Successfully"

class CreditPurchaseResponse {
  List<CreditPurchaseItem> _creditPurchaseList;
  String _status;
  String _message;

  List<CreditPurchaseItem> get creditPurchaseList => _creditPurchaseList;
  String get status => _status;
  String get message => _message;

  CreditPurchaseResponse({
      List<CreditPurchaseItem> creditPurchaseList,
      String status, 
      String message}){
    _creditPurchaseList = creditPurchaseList;
    _status = status;
    _message = message;
}

  CreditPurchaseResponse.fromJson(dynamic json) {
    if (json["List"] != null) {
      _creditPurchaseList = [];
      json["List"].forEach((v) {
        _creditPurchaseList.add(CreditPurchaseItem.fromJson(v));
      });
    }
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_creditPurchaseList != null) {
      map["List"] = _creditPurchaseList.map((v) => v.toJson()).toList();
    }
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }

}

/// Id : 1
/// Amount : 5.00
/// Points : 11
/// Currency : "USD"
/// Mode : null

class CreditPurchaseItem {
  int _id;
  double _amount;
  int _points;
  String _currency;
  dynamic _mode;

  int get id => _id;
  double get amount => _amount;
  int get points => _points;
  String get currency => _currency;
  dynamic get mode => _mode;

  CreditPurchaseItem({
      int id, 
      double amount, 
      int points, 
      String currency, 
      dynamic mode}){
    _id = id;
    _amount = amount;
    _points = points;
    _currency = currency;
    _mode = mode;
}

  CreditPurchaseItem.fromJson(dynamic json) {
    _id = json["Id"];
    _amount = json["Amount"];
    _points = json["Points"];
    _currency = json["Currency"];
    _mode = json["Mode"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Id"] = _id;
    map["Amount"] = _amount;
    map["Points"] = _points;
    map["Currency"] = _currency;
    map["Mode"] = _mode;
    return map;
  }

}