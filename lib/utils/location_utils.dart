// import 'package:geocoder/geocoder.dart';
// import 'package:google_place/google_place.dart';
//
// class LocationUtils {
//   // Singleton approach
//   static final LocationUtils _instance = LocationUtils._internal();
//   GooglePlace googlePlaceAutoComplete;
//
//   factory LocationUtils(GooglePlace googlePlaceAutoComplete) {
//     _instance.googlePlaceAutoComplete = googlePlaceAutoComplete;
//     return _instance;
//   }
//
//   LocationUtils._internal();
//
//   Future<DetailsResult> _getDetailResultFromPrediction(
//       AutocompletePrediction prediction) async {
//     DetailsResult detailsResult;
//     var addressWithPlaceId = await googlePlaceAutoComplete.details
//         .get(prediction.placeId, fields: "name,geometry");
//     if (addressWithPlaceId != null && addressWithPlaceId.result != null) {
//       detailsResult = addressWithPlaceId.result;
//       print("Step2 name ${detailsResult.name}");
//     }
//     return detailsResult;
//   }
//
//   Future<Address> _getAddressFromDetailResult(
//       DetailsResult detailsResult) async {
//     var location = detailsResult.geometry.location;
//     print("Location latitude ${location.lat}");
//     print("Location latitude ${location.lng}");
//     final destinationCoordinate = Coordinates(location.lat, location.lng);
//     var destAddress = await Geocoder.local
//         .findAddressesFromCoordinates(destinationCoordinate);
//     print("Step4 addressLine ${destAddress.first.addressLine}");
//     print("Step4 postalCode ${destAddress.first.postalCode}");
//     return destAddress.first;
//   }
// }
