class OTPRequest {
  String username;
  String otpVerificationCode;
  String deviceId;
  String deviceToken;
  String platform;
  String appVersion;

  OTPRequest(
      {this.username,
      this.otpVerificationCode,
      this.deviceId,
      this.deviceToken,
      this.platform,
      this.appVersion});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Username'] = this.username;
    data['Verificationcode'] = this.otpVerificationCode;
    data['DeviceId'] = this.deviceId;
    data['DeviceToken'] = this.deviceToken;
    data['Platform'] = this.platform;
    data['AppVersion'] = this.appVersion;
    return data;
  }
}
