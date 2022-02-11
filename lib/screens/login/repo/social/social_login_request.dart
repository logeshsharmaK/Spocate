class SocialLoginRequest {
  String username;
  String isEmail;
  String accessToken;
  String deviceId;
  String deviceToken;
  String platForm;
  String appVersion;

  SocialLoginRequest({
    this.username,
    this.isEmail,
    this.accessToken,
    this.deviceId,
    this.deviceToken,
    this.platForm,
    this.appVersion,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Username'] = this.username;
    data['Isemail'] = this.isEmail;
    data['AccessToken'] = this.accessToken;
    data['DeviceId'] = this.deviceId;
    data['DeviceToken'] = this.deviceToken;
    data['Platform'] = this.platForm;
    data['AppVersion'] = this.appVersion;
    return data;
  }
}
