import 'package:meta/meta.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/add_car/repo/add_car_response.dart';

class AddCarRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;

  // AddCarResponse addCarResponse;
  AddCarRepository({@required this.webservice, @required this.sharedPrefs})
      : assert(webservice != null);

  Future<AddCarResponse> submitAddCar(dynamic addCarRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_ADD_CAR, addCarRequest);
    // addCarResponse =  AddCarResponse.fromJson(response);
    return AddCarResponse.fromJson(response);
  }
}
