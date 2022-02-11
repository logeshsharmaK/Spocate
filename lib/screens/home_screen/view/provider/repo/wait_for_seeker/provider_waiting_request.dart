class ProviderWaitingRequest {
  String userId;
  String sourceLat;
  String sourceLong;

  ProviderWaitingRequest({
    this.userId,
    this.sourceLat,
    this.sourceLong,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Customerid'] = this.userId;
    data['Sourcelat'] = this.sourceLat;
    data['Sourcelong'] = this.sourceLong;
    return data;
  }
}
