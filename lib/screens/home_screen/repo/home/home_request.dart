class HomeRequest {
  String userId;

  HomeRequest({this.userId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.userId;
    return data;
  }
}
