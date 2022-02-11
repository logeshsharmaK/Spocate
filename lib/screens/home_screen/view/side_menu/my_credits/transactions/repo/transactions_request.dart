/// CustomerId : "47"
/// TransactionType : "All"
/// TransactionDate : ""

class TransactionsRequest {
  String _customerId;
  String _transactionType;
  String _transactionDate;

  String get customerId => _customerId;
  String get transactionType => _transactionType;
  String get transactionDate => _transactionDate;

  TransactionsRequest({
      String customerId, 
      String transactionType, 
      String transactionDate}){
    _customerId = customerId;
    _transactionType = transactionType;
    _transactionDate = transactionDate;
}

  TransactionsRequest.fromJson(dynamic json) {
    _customerId = json["CustomerId"];
    _transactionType = json["TransactionType"];
    _transactionDate = json["TransactionDate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["CustomerId"] = _customerId;
    map["TransactionType"] = _transactionType;
    map["TransactionDate"] = _transactionDate;
    return map;
  }

}