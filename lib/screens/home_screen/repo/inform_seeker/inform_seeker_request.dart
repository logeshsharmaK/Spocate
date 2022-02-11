class InformSeekerRequest {
  String userId;
  String sourceLat;
  String sourceLong;
  String sourceAddress;
  String sourcePinCode;
  String isParked;
  String isWait;

  InformSeekerRequest({
    this.userId,
    this.sourceLat,
    this.sourceLong,
    this.sourceAddress,
    this.sourcePinCode,
    this.isParked,
    this.isWait,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Customerid'] = this.userId;
    data['Sourcelat'] = this.sourceLat;
    data['Sourcelong'] = this.sourceLong;
    data['Sourceaddress'] = this.sourceAddress;
    data['Sourcepincode'] = this.sourcePinCode;
    data['Isparked'] = this.isParked;
    data['IsWait'] = this.isWait;
    return data;
  }
}

