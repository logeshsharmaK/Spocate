class ProviderLeavingRequest {
  String userId;

  ProviderLeavingRequest({
    this.userId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Customerid'] = this.userId;
    return data;
  }
}
