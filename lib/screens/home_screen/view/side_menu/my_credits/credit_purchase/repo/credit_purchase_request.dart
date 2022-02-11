class CreditPurchaseRequest {
  String customerId;
  CreditPurchaseRequest({this.customerId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Customerid'] = this.customerId;
    return data;
  }
}
