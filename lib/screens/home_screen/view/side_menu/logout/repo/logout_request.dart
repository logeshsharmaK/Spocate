
class LogoutRequest {
  String userId;
  String deviceId;

  LogoutRequest({this.userId, this.deviceId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userId;
    data['DeviceID'] = this.deviceId;
    return data;
  }
}