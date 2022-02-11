
class MyCarsDeleteRequest {
  String carId;

  MyCarsDeleteRequest({this.carId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.carId;
    return data;
  }
}