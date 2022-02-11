 class LogoutResponse {
  String userID;
  String deviceID;
  String status;
  String message;

  LogoutResponse({this.userID, this.deviceID, this.status, this.message});

  LogoutResponse.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    deviceID = json['DeviceID'];
    status = json['Status'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    data['DeviceID'] = this.deviceID;
    data['Status'] = this.status;
    data['Message'] = this.message;
    return data;
  }
}