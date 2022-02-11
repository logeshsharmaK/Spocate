class PaymentStatusRequest {
  String userId;
  String paymentNonce;

  PaymentStatusRequest({this.userId, this.paymentNonce});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Customerid'] = this.userId;
    data['PaymentNonce'] = this.paymentNonce;
    return data;
  }
}
