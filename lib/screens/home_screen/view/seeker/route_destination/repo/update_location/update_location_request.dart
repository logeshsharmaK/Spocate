class UpdateLocationRequest {
  String userId;
  String sourceLat;
  String sourceLong;
  String sourceAddress;
  String sourcePinCode;
  String destLat;
  String destLong;
  String destAddress;
  String destPinCode;
  String distance;
  String duration;

  UpdateLocationRequest({
    this.userId,
    this.sourceLat,
    this.sourceLong,
    this.sourceAddress,
    this.sourcePinCode,
    this.destLat,
    this.destLong,
    this.destAddress,
    this.destPinCode,
    this.distance,
    this.duration,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Customerid'] = this.userId;
    data['Sourcelat'] = this.sourceLat;
    data['Sourcelong'] = this.sourceLong;
    data['Sourceaddress'] = this.sourceAddress;
    data['Sourcepincode'] = this.sourcePinCode;
    data['Destinationlat'] = this.destLat;
    data['Destinationlong'] = this.destLong;
    data['Destinationaddress'] = this.destAddress;
    data['Destinationpincode'] = this.destPinCode;
    data['Distance'] = this.distance;
    data['DrivingMinutes'] = this.duration;
    return data;
  }
}
