import 'package:meta/meta.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';

import 'my_cars_update_response.dart';

class MyCarsUpdateRepository {
  final Webservice webservice;

  MyCarsUpdateRepository({@required this.webservice})
      : assert(webservice != null);

  Future<MyCarsUpdateResponse> updateMyCarDetails(dynamic myCarsUpdateRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_ADD_CAR, myCarsUpdateRequest);
    return MyCarsUpdateResponse.fromJson(response);
  }
}
