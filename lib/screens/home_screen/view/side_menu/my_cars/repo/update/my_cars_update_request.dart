
class MyCarsUpdateRequest {
  String mode;
  String carId;
  String customerId;
  String carMake;
  String carModel;
  String carColor;
  String carNumber;
  String isDefault;

  MyCarsUpdateRequest(
      {this.mode, this.carId, this.customerId, this.carMake, this.carModel, this.carColor, this.carNumber, this.isDefault});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Mode'] = this.mode;
    data['Id'] = this.carId;
    data['Customerid'] = this.customerId;
    data['Carmake'] = this.carMake;
    data['Carmodel'] = this.carModel;
    data['Carcolor'] = this.carColor;
    data['Carnumber'] = this.carNumber;
    data['Isdefault'] = this.isDefault;
    return data;
  }
}