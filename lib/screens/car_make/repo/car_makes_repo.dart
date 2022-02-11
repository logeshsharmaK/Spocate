import 'package:meta/meta.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/car_make/repo/car_makes_response.dart';

class CarMakeListRepository {
  final Webservice webservice;
  CarMakeListRepository({@required this.webservice}) : assert(webservice != null);

  Future<CarMakeListResponse> getCarList() async {
    final response = await webservice.getAPICall(WebConstants.ACTION_CARS_LIST);
    return CarMakeListResponse.fromJson(response);
  }
}
