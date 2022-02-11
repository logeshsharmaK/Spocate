class AcceptSpotRequest {
  String userId;
  String sourceLat;
  String sourceLong;
  String spotId;

  AcceptSpotRequest({
    this.userId,
    this.sourceLat,
    this.sourceLong,
    this.spotId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Customerid'] = this.userId;
    data['Sourcelat'] = this.sourceLat;
    data['Sourcelong'] = this.sourceLong;
    data['SpotId'] = this.spotId;
    return data;
  }
}
