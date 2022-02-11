
class PaymentStatusResponse {
  String _paymentStatus;
  String _status;
  String _message;

  String get paymentStatus => _paymentStatus;
  String get status => _status;
  String get message => _message;

  PaymentStatusResponse({
    String paymentStatus,
    String status,
    String message}){
    _paymentStatus = paymentStatus;
    _status = status;
    _message = message;
  }

  PaymentStatusResponse.fromJson(dynamic json) {
    _paymentStatus = json["PaymentStatus"];
    _status = json["Status"];
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["PaymentStatus"] = _paymentStatus;
    map["Status"] = _status;
    map["Message"] = _message;
    return map;
  }

}