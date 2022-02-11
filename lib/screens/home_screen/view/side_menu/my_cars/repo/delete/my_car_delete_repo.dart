import 'package:flutter/widgets.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'my_car_delete_response.dart';

class MyCarDeleteRepository {
  final Webservice webservice;

  MyCarDeleteRepository({@required this.webservice}) : assert(webservice != null);

  Future<MyCarDeleteResponse> submitCarList(dynamic myCarDeletedRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_MY_CAR_DELETE, myCarDeletedRequest);
    return MyCarDeleteResponse.fromJson(response);
  }
}
