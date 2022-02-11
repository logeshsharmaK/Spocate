import 'package:meta/meta.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'car_colors_response.dart';

class CarColorListRepository {
  final Webservice webservice;

  CarColorListRepository({@required this.webservice})
      : assert(webservice != null);

  Future<CarColorListResponse> getCarColorList() async {
    final response = await webservice
        .postAPICallOnlyAction(WebConstants.ACTION_CAR_COLOR_LIST);
    return CarColorListResponse.fromJson(response);
  }
}
