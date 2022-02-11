class AddCarRequest {
  String userId;
  String mode;
  String isDefault;
  String carMake;
  String carModel;
  String carColor;
  String carNumber;

  AddCarRequest({this.userId, this.mode, this.isDefault,this.carMake,this.carModel,this.carColor,this.carNumber,});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Customerid'] = this.userId;
    data['Mode'] = this.mode;
    data['Isdefault'] = this.isDefault;
    data['Carmake'] = this.carMake;
    data['Carmodel'] = this.carModel;
    data['Carcolor'] = this.carColor;
    data['Carnumber'] = this.carNumber;
    return data;
  }
}
