import 'package:flutter/widgets.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'my_cars_response.dart';

class MyCarsRepository {
  final Webservice webservice;

  MyCarsRepository({@required this.webservice}) : assert(webservice != null);

  Future<MyCarsResponse> getMyCars(dynamic myCarsRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_MY_CARS, myCarsRequest);
    return MyCarsResponse.fromJson(response);
  }

}
