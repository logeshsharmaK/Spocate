class AddCarResponse {
  int id;
  String status;
  String message;

  AddCarResponse({this.id, this.status, this.message});

  AddCarResponse.fromJson(dynamic json) {
    id = json['Id'];
    status = json['Status'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Status'] = this.status;
    data['Message'] = this.message;
    return data;
  }
}
