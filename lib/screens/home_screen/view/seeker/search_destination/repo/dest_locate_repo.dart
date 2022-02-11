import 'package:meta/meta.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/dest_locate_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/dest_locate_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/favorite/favorite_response.dart';

class DestLocateRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  DestLocateRequest destLocateRequest;


  DestLocateRepository({@required this.webservice, @required this.sharedPrefs})
      : assert(webservice != null);

  Future<DestLocateResponse> submitLocateDestination(
      dynamic locateRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_DEST_LOCATE, locateRequest);
    destLocateRequest = locateRequest;
    await sharedPrefs.setDestLocationDetails(
        double.parse(destLocateRequest.destLat),
        double.parse(destLocateRequest.destLong),
        destLocateRequest.destAddress,
        destLocateRequest.destPinCode);
    return DestLocateResponse.fromJson(response);
  }

  Future<FavoriteResponse> getFavoriteList(dynamic favoriteListRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_GET_FAVORITE, favoriteListRequest);
    return FavoriteResponse.fromJson(response);
  }

  Future<FavoriteResponse> addFavorite(dynamic favoriteRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_ADD_FAVORITE, favoriteRequest);
    return FavoriteResponse.fromJson(response);
  }

  Future<FavoriteResponse> removeFavorite(dynamic favoriteRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_DELETE_FAVORITE, favoriteRequest);
    return FavoriteResponse.fromJson(response);
  }
}
