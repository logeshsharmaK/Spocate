class SpottedProviderRequest {
  String userId;
  String unParkUserId;
  String isSpotted;

  SpottedProviderRequest({
    this.userId,
    this.unParkUserId,
    this.isSpotted,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Customerid'] = this.userId;
    data['UnparkUserId'] = this.unParkUserId;
    data['IsSpotted'] = this.isSpotted;
    return data;
  }
}
