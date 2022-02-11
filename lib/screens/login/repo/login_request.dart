class LoginRequest {
  String username;
  String isEmail;
  String accessToken;

  LoginRequest({this.username, this.isEmail, this.accessToken});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Username'] = this.username;
    data['Isemail'] = this.isEmail;
    data['AccessToken'] = this.accessToken;
    return data;
  }
}
