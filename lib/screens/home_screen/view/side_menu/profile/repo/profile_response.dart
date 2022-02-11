
class ProfileResponse {
  String verificationCode;
  int isEmail;
  String username;
  String error;
  String status;
  String message;

  ProfileResponse(
      {this.verificationCode,
        this.isEmail,
        this.username,
        this.error,
        this.status,
        this.message});

  ProfileResponse.fromJson(dynamic json) {
    verificationCode = json['Verificationcode'];
    isEmail = json['Isemail'];
    username = json['Username'];
    error = json['Error'];
    status = json['Status'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Verificationcode'] = this.verificationCode;
    data['Isemail'] = this.isEmail;
    data['Username'] = this.username;
    data['Error'] = this.error;
    data['Status'] = this.status;
    data['Message'] = this.message;
    return data;
  }

}