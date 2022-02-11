
class MyCarsResponse {
  List<CarItem> carList;
  String status;
  String message;

  MyCarsResponse({this.carList, this.status, this.message});

  MyCarsResponse.fromJson(dynamic json) {
    if (json['CarList'] != null) {
      carList = [];
      json['CarList'].forEach((v) {
        carList.add(new CarItem.fromJson(v));
      });
    }
    status = json['Status'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.carList != null) {
      data['CarList'] = this.carList.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    data['Message'] = this.message;
    return data;
  }


}

class CarItem {
  String mode;
  int id;
  int customerid;
  String carmake;
  String carmodel;
  String carcolor;
  String carnumber;
  int isdefault;
  String makeName;
  String modelName;
  String colorName;

  CarItem(
      {this.mode,
        this.id,
        this.customerid,
        this.carmake,
        this.carmodel,
        this.carcolor,
        this.carnumber,
        this.isdefault,
        this.makeName,
        this.modelName,
        this.colorName});

  CarItem.fromJson(dynamic json) {
    mode = json['Mode'];
    id = json['Id'];
    customerid = json['Customerid'];
    carmake = json['Carmake'];
    carmodel = json['Carmodel'];
    carcolor = json['Carcolor'];
    carnumber = json['Carnumber'];
    isdefault = json['Isdefault'];
    makeName = json['MakeName'];
    modelName = json['ModelName'];
    colorName = json['ColorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Mode'] = this.mode;
    data['Id'] = this.id;
    data['Customerid'] = this.customerid;
    data['Carmake'] = this.carmake;
    data['Carmodel'] = this.carmodel;
    data['Carcolor'] = this.carcolor;
    data['Carnumber'] = this.carnumber;
    data['Isdefault'] = this.isdefault;
    data['MakeName'] = this.makeName;
    data['ModelName'] = this.modelName;
    data['ColorName'] = this.colorName;
    return data;
  }
}