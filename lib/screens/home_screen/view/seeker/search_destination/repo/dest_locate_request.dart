class DestLocateRequest {
  String userId;
  String sourceLat;
  String sourceLong;
  String sourceAddress;
  String sourcePinCode;
  String destLat;
  String destLong;
  String destAddress;
  String destPinCode;
  String destinationMainAddress;
  String destinationSubAddress;
  String destinationPlaceId;

  DestLocateRequest({
    this.userId,
    this.sourceLat,
    this.sourceLong,
    this.sourceAddress,
    this.sourcePinCode,
    this.destLat,
    this.destLong,
    this.destAddress,
    this.destPinCode,
    this.destinationMainAddress,
    this.destinationSubAddress,
    this.destinationPlaceId,
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
    data['DestinationMainAddress'] = this.destinationMainAddress;
    data['DestinationSubAddress'] = this.destinationSubAddress;
    data['DestinationPlaceId'] = this.destinationPlaceId;
    return data;
  }
}
