import 'package:meta/meta.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';

import 'car_models_response.dart';

class CarModelListRepository {
  final Webservice webservice;


  CarModelListRepository(
      {@required this.webservice})
      : assert(webservice != null);

  Future<CarModelListResponse> getCarModelList(String carMakeName ) async {
    final response = await webservice.getAPICall(
        "${WebConstants.ACTION_CARS_MODEL_LIST}$carMakeName${WebConstants.ACTION_CARS_MODEL_LIST_QUERY}");
    return  CarModelListResponse.fromJson(response);
  }
}
