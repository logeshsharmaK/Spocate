

class ProfileRequest {
  String userId;
  String name;
  String email;
  String mobileNumber;

  ProfileRequest({this.userId, this.name,this.email,this.mobileNumber});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.userId;
    data['Name'] = this.name;
    data['Email'] = this.email;
    data['Mobile'] = this.mobileNumber;
    return data;
  }
}