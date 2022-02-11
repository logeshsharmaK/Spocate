/// Customerid : "10082"

class RemoveSeekerRequest {
  String _customerid;

  String get customerid => _customerid;

  RemoveSeekerRequest({
      String customerid}){
    _customerid = customerid;
}

  RemoveSeekerRequest.fromJson(dynamic json) {
    _customerid = json["Customerid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Customerid"] = _customerid;
    return map;
  }

}