class IgnoreSpotRequest {
  String userId;
  String spotId;

  IgnoreSpotRequest({
    this.userId,
    this.spotId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Customerid'] = this.userId;
    data['SpotId'] = this.spotId;
    return data;
  }
}
