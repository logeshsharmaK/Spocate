class SpottedSeekerRequest {
  String unParkUserId;
  String isSpotted;

  SpottedSeekerRequest({
    this.unParkUserId,
    this.isSpotted,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UnparkUserId'] = this.unParkUserId;
    data['IsSpotted'] = this.isSpotted;
    return data;
  }
}
