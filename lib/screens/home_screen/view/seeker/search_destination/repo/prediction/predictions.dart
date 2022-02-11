
class Prediction {
  bool isFavorite;
  String mainAddress;
  String secondaryAddress;
  String latitude;
  String longitude;
  String addressLine;
  String postalCode;
  String placeId;
  String favoriteId;

  Prediction({
    this.isFavorite,
    this.mainAddress,
    this.secondaryAddress,
    this.latitude,
    this.longitude,
    this.addressLine,
    this.postalCode,
    this.placeId,
    this.favoriteId,
  });
}

// class Prediction {
//   AutocompletePrediction autocompletePrediction;
//   bool isFavorite = false;
//
//   Prediction({
//     this.autocompletePrediction,
//     this.isFavorite,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'autocompletePrediction': autocompletePrediction,
//       'isFavorite': isFavorite,
//     };
//   }
// }
