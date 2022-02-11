import 'package:shared_preferences/shared_preferences.dart';
import 'package:spocate/notification/NotificationParser.dart';
import 'package:spocate/screens/home_screen/repo/home/home_response.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/notification/provider_notification.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/notification/spot_location_notification.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/destination_location.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/my_cars_response.dart';
import 'package:spocate/screens/home_screen/view/source_location.dart';
import 'package:spocate/screens/login/repo/social/social_info.dart';

import 'pref_constants.dart';

class SharedPrefs {
  // Singleton approach
  static final SharedPrefs _instance = SharedPrefs._internal();

  factory SharedPrefs() => _instance;

  SharedPrefs._internal();

  // App
  Future<void> setLastVisitedScreen(String screenName) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString(PrefConstants.PREF_SCREEN_VISITED, screenName);
  }

  Future<String> getLastVisitedScreen() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
   return sharedPreferences.getString(PrefConstants.PREF_SCREEN_VISITED)??"";
  }

  Future<void> setNotificationToken(String token) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString(PrefConstants.PREF_ACCESS_TOKEN, token);
  }

  Future<void> setNotificationOnTokenRefresh(String token) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    sharedPreferences.setString(PrefConstants.PREF_ACCESS_ON_TOKEN_REFRESH, token);
  }

  Future<String> getNotificationToken() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences
            .getString(PrefConstants.PREF_ACCESS_TOKEN)
            .toString() ??
        "";
  }

  Future<String> getNotificationOnTokenRefresh() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    return sharedPreferences
        .getString(PrefConstants.PREF_ACCESS_ON_TOKEN_REFRESH);
  }

  // SignUp
  Future<void> addOTPAndUserNameAndIsEmail(
      String otp, String username, String isEmail) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString(PrefConstants.PREF_USER_OTP_CODE, otp);
    sharedPreferences.setString(PrefConstants.PREF_USER_NAME, username);
    sharedPreferences.setString(PrefConstants.PREF_USER_IS_EMAIL, isEmail);
  }

  Future<void> addSocialUserDetails(
      int userId, String isCar, String username, String isEmail) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setInt(PrefConstants.PREF_USER_ID, userId);
    sharedPreferences.setString(PrefConstants.PREF_USER_IS_CAR, isCar);
    sharedPreferences.setString(PrefConstants.PREF_USER_NAME, username);
    sharedPreferences.setString(PrefConstants.PREF_USER_IS_EMAIL, isEmail);
  }

  Future<void> addSocialProfileData(int isSocial, String profileName,
      String email, String profilePhoto) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setInt(PrefConstants.PREF_IS_SOCIAL, isSocial);
    sharedPreferences.setString(
        PrefConstants.PREF_SOCIAL_PROFILE_NAME, profileName);
    sharedPreferences.setString(PrefConstants.PREF_SOCIAL_EMAIL, email);
    sharedPreferences.setString(
        PrefConstants.PREF_SOCIAL_PROFILE_PHOTO, profilePhoto);
  }

  Future<void> addNonSocialProfileData(int isSocial, String phoneNumberOrEmail,
      String isEmail, String email) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setInt(PrefConstants.PREF_IS_SOCIAL, isSocial);
    sharedPreferences.setString(
        PrefConstants.PREF_PHONE_NUMBER, phoneNumberOrEmail);
    sharedPreferences.setString(PrefConstants.PREF_SOCIAL_EMAIL, email);
    sharedPreferences.setString(PrefConstants.PREF_USER_IS_EMAIL, isEmail);
  }

  Future<SocialInfo> getProfileData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    int isSocial = sharedPreferences.getInt(PrefConstants.PREF_IS_SOCIAL) ?? 0;
    String name =
        sharedPreferences.getString(PrefConstants.PREF_SOCIAL_PROFILE_NAME) ??
            "";
    String email =
        sharedPreferences.getString(PrefConstants.PREF_SOCIAL_EMAIL) ?? "";
    String profilePhoto =
        sharedPreferences.getString(PrefConstants.PREF_SOCIAL_PROFILE_PHOTO) ??
            "";
    String phoneNumber =
        sharedPreferences.getString(PrefConstants.PREF_PHONE_NUMBER) ?? "";
    String isEmail =
        sharedPreferences.getString(PrefConstants.PREF_USER_IS_EMAIL) ?? "";
    int isUpdated =
        sharedPreferences.getInt(PrefConstants.PREF_IS_UPDATED) ?? 0;
    return SocialInfo(
        isSocial: isSocial,
        name: name,
        email: email,
        profilePhoto: profilePhoto,
        phoneNumber: phoneNumber,
        isEmail: isEmail,
        isUpdated: isUpdated);
  }

/*  Future<void> addFaceBookProfileData(String profileName, String email, String profilePhoto) async{
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    sharedPreferences.setString(PrefConstants.PREF_FACEBOOK_PROFILE_NAME, profileName);
    sharedPreferences.setString(PrefConstants.PREF_FACEBOOK_EMAIL, email);
    sharedPreferences.setString(PrefConstants.PREF_FACEBOOK_PROFILE_PHOTO, profilePhoto);
  }*/
  Future<void> addLoginType(int loginType) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setInt(PrefConstants.PREF_LOGIN_TYPE, loginType);
  }

  Future<int> getLoginType() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getInt(PrefConstants.PREF_LOGIN_TYPE) ?? 0;
  }

  Future<String> getLoginOTP() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString(PrefConstants.PREF_USER_OTP_CODE) ?? "";
  }

  Future<String> getLoginUsername() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString(PrefConstants.PREF_USER_NAME) ?? "";
  }

  Future<String> getIsEmail() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString(PrefConstants.PREF_USER_IS_EMAIL) ?? "";
  }

  // OTP verification
  Future<void> addUserIdAndIsCar(int userId, String isCar) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setInt(PrefConstants.PREF_USER_ID, userId);
    sharedPreferences.setString(PrefConstants.PREF_USER_IS_CAR, isCar);
  }

  Future<String> getUserId() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getInt(PrefConstants.PREF_USER_ID).toString() ??
        "";
  }

  // Home Details
  Future<void> addUserInfo(UserInfo userInfo) async {
    // int userId, String username, String email,
    // String mobile, String carNumber, String name, String status
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setInt(PrefConstants.PREF_USER_ID, userInfo.id);
    sharedPreferences.setString(
        PrefConstants.PREF_USER_NAME, userInfo.username ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_USER_EMAIL, userInfo.email ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_USER_MOBILE, userInfo.mobile ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_CAR_NUMBER, userInfo.carNumber);
    sharedPreferences.setString(
        PrefConstants.PREF_HOME_NAME, userInfo.name ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_HOME_STATUS, userInfo.status);
    if (userInfo.name != null) {
      sharedPreferences.setString(
          PrefConstants.PREF_SOCIAL_PROFILE_NAME, userInfo.name);
    }
    if (userInfo.email != null) {
      sharedPreferences.setString(
          PrefConstants.PREF_SOCIAL_EMAIL, userInfo.email);
    }
    if (userInfo.mobile != null) {
      sharedPreferences.setString(
          PrefConstants.PREF_PHONE_NUMBER, userInfo.mobile);
    }
  }

  //Profile
  Future<void> updateUserInfo(UserInfo userInfo) async {
    // int userId, String username, String email,
    // String mobile, String carNumber, String name, String status
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setInt(PrefConstants.PREF_USER_ID, userInfo.id);
    sharedPreferences.setString(
        PrefConstants.PREF_USER_NAME, userInfo.username ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_USER_EMAIL, userInfo.email ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_USER_MOBILE, userInfo.mobile ?? "");
  }

  //Profile
  Future<void> updateProfileData(SocialInfo socialInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString(
        PrefConstants.PREF_SOCIAL_PROFILE_NAME, socialInfo.name);
    sharedPreferences.setString(
        PrefConstants.PREF_SOCIAL_EMAIL, socialInfo.email);
    sharedPreferences.setString(
        PrefConstants.PREF_PHONE_NUMBER, socialInfo.phoneNumber);
    sharedPreferences.setInt(
        PrefConstants.PREF_IS_UPDATED, socialInfo.isUpdated);
  }

  Future<UserInfo> getUserInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    int userId = sharedPreferences.getInt(PrefConstants.PREF_USER_ID) ?? 0;
    String username =
        sharedPreferences.getString(PrefConstants.PREF_USER_NAME) ?? "";
    String email =
        sharedPreferences.getString(PrefConstants.PREF_USER_EMAIL) ?? "";
    String mobile =
        sharedPreferences.getString(PrefConstants.PREF_USER_MOBILE) ?? "";
    String carNumber =
        sharedPreferences.getString(PrefConstants.PREF_CAR_NUMBER) ?? "";
    String name =
        sharedPreferences.getString(PrefConstants.PREF_HOME_NAME) ?? "";
    String status =
        sharedPreferences.getString(PrefConstants.PREF_HOME_STATUS) ?? "";
    return UserInfo(
        id: userId,
        username: username,
        email: email,
        mobile: mobile,
        carNumber: carNumber,
        name: name,
        status: status);
  }

  Future<void> addCarInfo(CarItem carInfo) async {
    // String mode, int carId, int customerId,
    // String carMake, String carModel, String carColor, String carNumber, int isDefault
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString(
        PrefConstants.PREF_CAR_MODE, carInfo.mode ?? "");
    sharedPreferences.setInt(PrefConstants.PREF_CAR_ID, carInfo.id);
    sharedPreferences.setInt(
        PrefConstants.PREF_CAR_CUSTOMER_ID, carInfo.customerid);
    sharedPreferences.setInt(
        PrefConstants.PREF_CAR_IS_DEFAULT, carInfo.isdefault);
    sharedPreferences.setString(PrefConstants.PREF_CAR_MAKE, carInfo.carmake);
    sharedPreferences.setString(PrefConstants.PREF_CAR_MODEL, carInfo.carmodel);
    sharedPreferences.setString(
        PrefConstants.PREF_CAR_NUMBER, carInfo.carnumber);
    sharedPreferences.setString(PrefConstants.PREF_CAR_COLOR, carInfo.carcolor);
  }

  Future<CarItem> getCarInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String carMode =
        sharedPreferences.getString(PrefConstants.PREF_CAR_MODE) ?? "";
    int carId = sharedPreferences.getInt(PrefConstants.PREF_CAR_ID) ?? 0;
    int customerId =
        sharedPreferences.getInt(PrefConstants.PREF_CAR_CUSTOMER_ID) ?? 0;
    int isDefault =
        sharedPreferences.getInt(PrefConstants.PREF_CAR_IS_DEFAULT) ?? 0;
    String carMake =
        sharedPreferences.getString(PrefConstants.PREF_CAR_MAKE) ?? "";
    String carModel =
        sharedPreferences.getString(PrefConstants.PREF_CAR_MODEL) ?? "";
    String carNumber =
        sharedPreferences.getString(PrefConstants.PREF_CAR_NUMBER) ?? "";
    String carColor =
        sharedPreferences.getString(PrefConstants.PREF_CAR_COLOR) ?? "";
    return CarItem(
        mode: carMode,
        id: carId,
        customerid: customerId,
        carmake: carMake,
        carmodel: carModel,
        carcolor: carColor,
        carnumber: carNumber,
        isdefault: isDefault);
  }

  Future<void> setSupportContacts(
      String supportMobile, String supportEmail) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString(
        PrefConstants.PREF_SUPPORT_MOBILE, supportMobile ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_SUPPORT_EMAIL, supportEmail ?? "");
  }

  Future<String> getSupportMobile() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString(PrefConstants.PREF_SUPPORT_MOBILE) ?? "";
  }

  Future<String> getSupportEmail() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString(PrefConstants.PREF_SUPPORT_EMAIL) ?? "";
  }

  Future<void> setSourceLocationDetails(double sourceLat, double sourceLong,
      String sourceAddress, String sourcePostalCode) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setDouble(PrefConstants.PREF_SOURCE_LATITUDE, sourceLat);
    sharedPreferences.setDouble(
        PrefConstants.PREF_SOURCE_LONGITUDE, sourceLong);
    sharedPreferences.setString(
        PrefConstants.PREF_SOURCE_ADDRESS, sourceAddress ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_SOURCE_POSTAL_CODE, sourcePostalCode ?? "");
  }

  Future<SourceLocation> getSourceLocationDetails() async {
    SourceLocation sourceLocation = SourceLocation();
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sourceLocation.sourceLatitude =
        sharedPreferences.getDouble(PrefConstants.PREF_SOURCE_LATITUDE);
    sourceLocation.sourceLongitude =
        sharedPreferences.getDouble(PrefConstants.PREF_SOURCE_LONGITUDE);
    sourceLocation.sourceAddress =
        sharedPreferences.getString(PrefConstants.PREF_SOURCE_ADDRESS) ?? "";
    sourceLocation.sourcePostalCode =
        sharedPreferences.getString(PrefConstants.PREF_SOURCE_POSTAL_CODE) ??
            "";
    return sourceLocation;
  }

  Future<void> setDestLocationDetails(double destLat, double destLong,
      String destAddress, String destPostalCode) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setDouble(PrefConstants.PREF_DEST_LATITUDE, destLat);
    sharedPreferences.setDouble(PrefConstants.PREF_DEST_LONGITUDE, destLong);
    sharedPreferences.setString(
        PrefConstants.PREF_DEST_ADDRESS, destAddress ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_DEST_POSTAL_CODE, destPostalCode ?? "");
  }

  Future<DestLocation> getDestLocationDetails() async {
    DestLocation destLocation = DestLocation();
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    destLocation.destLatitude =
        sharedPreferences.getDouble(PrefConstants.PREF_DEST_LATITUDE);
    destLocation.destLongitude =
        sharedPreferences.getDouble(PrefConstants.PREF_DEST_LONGITUDE);
    destLocation.destAddress =
        sharedPreferences.getString(PrefConstants.PREF_DEST_ADDRESS) ?? "";
    destLocation.destPostalCode =
        sharedPreferences.getString(PrefConstants.PREF_DEST_POSTAL_CODE) ?? "";
    return destLocation;
  }

  Future<String> getSeekerSpotQuestion() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String spotQuestion =
        sharedPreferences.getString(PrefConstants.PREF_SUPPORT_SPOT_QUESTION);
    return spotQuestion;
  }

  Future<void> setSeekerSpotQuestion(String spotQuestion) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString(
        PrefConstants.PREF_SUPPORT_SPOT_QUESTION, spotQuestion);
  }

  // Seeker Accepted Spot
  Future<void> setSpotAcceptedProviderData(ProviderData providerData) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setInt(PrefConstants.PREF_UN_PARK_USER_ID,
        providerData.userId ?? 0);
    sharedPreferences.setDouble(
        PrefConstants.PREF_NOTIFICATION_SOURCE_LATITUDE,
        providerData.sourcelat != null
            ? double.parse(providerData.sourcelat)
            : 0.0);
    sharedPreferences.setDouble(
        PrefConstants.PREF_NOTIFICATION_SOURCE_LONGITUDE,
        providerData.sourcelong != null
            ? double.parse(providerData.sourcelong)
            : 0.0);
    if (providerData.destinationlat != null &&
        providerData.destinationlat.isNotEmpty) {
      sharedPreferences.setDouble(PrefConstants.PREF_NOTIFICATION_DEST_LATITUDE,
          double.parse(providerData.destinationlat));
    } else {
      sharedPreferences.setDouble(PrefConstants.PREF_NOTIFICATION_DEST_LATITUDE, 0.0);
    }
    if (providerData.destinationlong != null &&
        providerData.destinationlong.isNotEmpty) {
      sharedPreferences.setDouble(PrefConstants.PREF_NOTIFICATION_DEST_LONGITUDE,
          double.parse(providerData.destinationlong));
    } else {
      sharedPreferences.setDouble(PrefConstants.PREF_NOTIFICATION_DEST_LONGITUDE, 0.0);
    }

    sharedPreferences.setString(
        PrefConstants.PREF_DRIVING_DURATION, providerData.drivingMinutes ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_DRIVING_DISTANCE, providerData.distance ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_SOURCE_ADDRESS, providerData.address ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_CAR_MAKE, providerData.carMake ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_CAR_MODEL, providerData.carModel ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_CAR_NUMBER, providerData.carNumber ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_CAR_COLOR, providerData.carColor ?? "");
    sharedPreferences.setInt(
        PrefConstants.PREF_SEEKER_ID, providerData.seekerId ?? 0 );
    sharedPreferences.setInt(
        PrefConstants.PREF_SPOT_ID, providerData.spotId ?? 0 );
    sharedPreferences.setString(
        PrefConstants.PREF_MESSAGE, providerData.message ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_NOTIFICATION_CODE, providerData.notificationCode ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_USER_TYPE, providerData.userType ?? "");
  }

  Future<ProviderData> getSpotAcceptedProviderData() async {
    ProviderData providerData = ProviderData();
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    providerData.userId =
            sharedPreferences.getInt(PrefConstants.PREF_UN_PARK_USER_ID) ??
        0;
    providerData.sourcelat = sharedPreferences
        .getDouble(PrefConstants.PREF_NOTIFICATION_SOURCE_LATITUDE)
        .toString();
    providerData.sourcelong = sharedPreferences
        .getDouble(PrefConstants.PREF_NOTIFICATION_SOURCE_LONGITUDE)
        .toString();
    providerData.destinationlat = sharedPreferences
        .getDouble(PrefConstants.PREF_NOTIFICATION_DEST_LATITUDE)
        .toString();
    providerData.destinationlong = sharedPreferences
        .getDouble(PrefConstants.PREF_NOTIFICATION_DEST_LONGITUDE)
        .toString();
    providerData.address =
        sharedPreferences.getString(PrefConstants.PREF_SOURCE_ADDRESS) ?? "";
    providerData.carMake =
        sharedPreferences.getString(PrefConstants.PREF_CAR_MAKE) ?? "";
    providerData.carModel =
        sharedPreferences.getString(PrefConstants.PREF_CAR_MODEL) ?? "";
    providerData.carNumber =
        sharedPreferences.getString(PrefConstants.PREF_CAR_NUMBER) ?? "";
    providerData.carColor =
        sharedPreferences.getString(PrefConstants.PREF_CAR_COLOR) ?? "";
    providerData.drivingMinutes =
        sharedPreferences.getString(PrefConstants.PREF_DRIVING_DURATION) ?? "";
    providerData.distance =
        sharedPreferences.getString(PrefConstants.PREF_DRIVING_DISTANCE) ?? "";
    providerData.seekerId =
        sharedPreferences.getInt(PrefConstants.PREF_SEEKER_ID) ?? 0;
    providerData.spotId =
        sharedPreferences.getInt(PrefConstants.PREF_SPOT_ID) ?? 0;
    providerData.message =
        sharedPreferences.getString(PrefConstants.PREF_MESSAGE) ?? "";
    providerData.notificationCode =
        sharedPreferences.getString(PrefConstants.PREF_NOTIFICATION_CODE) ?? "";
    providerData.userType =
        sharedPreferences.getString(PrefConstants.PREF_USER_TYPE) ?? "";
    return providerData;
  }

  Future<void> setProviderWaitingSeekerData(SeekerData seekerData) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
      sharedPreferences.setInt(
          PrefConstants.PREF_UN_PARK_USER_ID,
          seekerData.userId != null
              ? int.parse(seekerData.userId.toString())
              : 0);
      sharedPreferences.setDouble(
          PrefConstants.PREF_NOTIFICATION_SOURCE_LATITUDE,
          seekerData.sourceLat != null
              ? double.parse(seekerData.sourceLat)
              : 0.0);
      sharedPreferences.setDouble(
          PrefConstants.PREF_NOTIFICATION_SOURCE_LONGITUDE,
          seekerData.sourceLong != null
              ? double.parse(seekerData.sourceLong)
              : 0.0);
      if (seekerData.destinationLat != null &&
          seekerData.destinationLat.isNotEmpty) {
        sharedPreferences.setDouble(PrefConstants.PREF_NOTIFICATION_DEST_LATITUDE,
            double.parse(seekerData.destinationLat));
      } else {
        sharedPreferences.setDouble(PrefConstants.PREF_NOTIFICATION_DEST_LATITUDE, 0.0);
      }
      if (seekerData.destinationLong != null &&
          seekerData.destinationLong.isNotEmpty) {
        sharedPreferences.setDouble(PrefConstants.PREF_NOTIFICATION_DEST_LONGITUDE,
            double.parse(seekerData.destinationLong));
      } else {
        sharedPreferences.setDouble(PrefConstants.PREF_NOTIFICATION_DEST_LONGITUDE, 0.0);
      }

      sharedPreferences.setString(
          PrefConstants.PREF_DRIVING_DURATION, seekerData.drivingMinutes ?? "");
      sharedPreferences.setString(
          PrefConstants.PREF_DRIVING_DISTANCE, seekerData.distance ?? "");
      sharedPreferences.setString(
          PrefConstants.PREF_SOURCE_ADDRESS, seekerData.address ?? "");
      sharedPreferences.setString(
          PrefConstants.PREF_CAR_MAKE, seekerData.carMake ?? "");
      sharedPreferences.setString(
          PrefConstants.PREF_CAR_MODEL, seekerData.carModel ?? "");
      sharedPreferences.setString(
          PrefConstants.PREF_CAR_NUMBER, seekerData.carNumber ?? "");
      sharedPreferences.setString(
          PrefConstants.PREF_CAR_COLOR, seekerData.carColor ?? "");
      sharedPreferences.setInt(
          PrefConstants.PREF_SEEKER_ID, seekerData.seekerId ?? 0 );
    sharedPreferences.setString(
        PrefConstants.PREF_MESSAGE, seekerData.message ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_NOTIFICATION_CODE, seekerData.notificationCode ?? "");
    sharedPreferences.setString(
        PrefConstants.PREF_USER_TYPE, seekerData.userType ?? "");
  }


  Future<SeekerData> getProviderWaitingSeekerData() async {
    SeekerData seekerData = SeekerData();
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    seekerData.userId =  sharedPreferences
        .getInt(PrefConstants.PREF_UN_PARK_USER_ID);
    seekerData.sourceLat = sharedPreferences
        .getDouble(PrefConstants.PREF_NOTIFICATION_SOURCE_LATITUDE)
        .toString();
    seekerData.sourceLong = sharedPreferences
        .getDouble(PrefConstants.PREF_NOTIFICATION_SOURCE_LONGITUDE)
        .toString();
    seekerData.destinationLat = sharedPreferences
        .getDouble(PrefConstants.PREF_NOTIFICATION_DEST_LATITUDE)
        .toString();
    seekerData.destinationLong = sharedPreferences
        .getDouble(PrefConstants.PREF_NOTIFICATION_DEST_LONGITUDE)
        .toString();
    seekerData.address =
        sharedPreferences.getString(PrefConstants.PREF_SOURCE_ADDRESS) ?? "";
    seekerData.carMake =
        sharedPreferences.getString(PrefConstants.PREF_CAR_MAKE) ?? "";
    seekerData.carModel =
        sharedPreferences.getString(PrefConstants.PREF_CAR_MODEL) ?? "";
    seekerData.carNumber =
        sharedPreferences.getString(PrefConstants.PREF_CAR_NUMBER) ?? "";
    seekerData.carColor =
        sharedPreferences.getString(PrefConstants.PREF_CAR_COLOR) ?? "";
    seekerData.drivingMinutes =
        sharedPreferences.getString(PrefConstants.PREF_DRIVING_DURATION) ?? "";
    seekerData.distance =
        sharedPreferences.getString(PrefConstants.PREF_DRIVING_DISTANCE) ?? "";
    seekerData.seekerId =
        sharedPreferences.getInt(PrefConstants.PREF_SEEKER_ID) ?? 0;
    seekerData.message =
        sharedPreferences.getString(PrefConstants.PREF_MESSAGE) ?? "";
    seekerData.notificationCode =
        sharedPreferences.getString(PrefConstants.PREF_NOTIFICATION_CODE) ?? "";
    seekerData.userType =
        sharedPreferences.getString(PrefConstants.PREF_USER_TYPE) ?? "";
    print(" getProviderWaitingSeekerData sharedPreferences - ${sharedPreferences.getString(PrefConstants.PREF_MESSAGE)}");
    return seekerData;
  }

  Future<void> setNotificationTime(String notificationTime) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    print("notificationTime = $notificationTime");
    sharedPreferences.setString(
        PrefConstants.PREF_NOTIFICATION_TIME, notificationTime);
  }

  Future<String> getNotificationTime() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String notificationTime =
    sharedPreferences.getString(PrefConstants.PREF_NOTIFICATION_TIME);
    return notificationTime;
  }

  Future<void> setBackgroundLocationScreen(String screen) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    print("background location screen shared pref = $screen");
    sharedPreferences.setString(
        PrefConstants.PREF_BACKGROUND_LOCATION_SCREEN, screen);
  }

  Future<void> setSpState(String appState) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    print("appState shared pref = $appState");
    sharedPreferences.setString(
        PrefConstants.PREF_APP_STATE, appState);
  }

  Future<String> getSpState() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    await  sharedPreferences.reload();
    String appState =
    sharedPreferences.getString(PrefConstants.PREF_APP_STATE);
    print("getAppState shared pref = $appState");
    return appState ?? "0";
  }

  Future<String> getBackgroundLocationScreen() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    await  sharedPreferences.reload();
    String screen =
    sharedPreferences.getString(PrefConstants.PREF_BACKGROUND_LOCATION_SCREEN);
    print("getBackgroundLocationScreen location screen shared pref = $screen");
    return screen ?? "0";
  }


  Future<void> setIsSeekerDetailsToShow(bool isSeekerDetailsToShow) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    print("appState shared pref = $isSeekerDetailsToShow");
    sharedPreferences.setBool(
        PrefConstants.PREF_IS_SEEKER_DETAILS_TO_SHOW, isSeekerDetailsToShow);
  }

  Future<bool> getIsSeekerDetailsToShow() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    // await  sharedPreferences.reload();
    bool isSeekerDetailsToShow =
    sharedPreferences.getBool(PrefConstants.PREF_IS_SEEKER_DETAILS_TO_SHOW);
    print("getBackgroundLocationScreen location screen shared pref = $isSeekerDetailsToShow");
    return isSeekerDetailsToShow ?? false ;
  }


  Future<void> clearSeekerAndProviderNotificationData() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    sharedPreferences.setInt(
        PrefConstants.PREF_UN_PARK_USER_ID, 0);
    sharedPreferences.setDouble(
        PrefConstants.PREF_NOTIFICATION_SOURCE_LATITUDE, 0.0);
    sharedPreferences.setDouble(
        PrefConstants.PREF_NOTIFICATION_SOURCE_LONGITUDE, 0.0);
      sharedPreferences.setDouble(PrefConstants.PREF_NOTIFICATION_DEST_LATITUDE,
          0.0);
    sharedPreferences.setDouble(PrefConstants.PREF_NOTIFICATION_DEST_LONGITUDE, 0.0);

    sharedPreferences.setString(
        PrefConstants.PREF_DRIVING_DURATION,"");
    sharedPreferences.setString(
        PrefConstants.PREF_DRIVING_DISTANCE,"");
    sharedPreferences.setString(
        PrefConstants.PREF_SOURCE_ADDRESS, "");
    sharedPreferences.setString(
        PrefConstants.PREF_CAR_MAKE, "");
    sharedPreferences.setString(
        PrefConstants.PREF_CAR_MODEL, "");
    sharedPreferences.setString(
        PrefConstants.PREF_CAR_NUMBER, "");
    sharedPreferences.setString(
        PrefConstants.PREF_CAR_COLOR, "");
    sharedPreferences.setInt(
        PrefConstants.PREF_SEEKER_ID, 0);
    sharedPreferences.setString(
        PrefConstants.PREF_MESSAGE, "");
    sharedPreferences.setString(
        PrefConstants.PREF_NOTIFICATION_CODE, "");
    sharedPreferences.setString(
        PrefConstants.PREF_USER_TYPE,  "");
  }

  Future<void> setNotificationMessage(String message) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    print("appState shared pref = $message");
    sharedPreferences.setString(
        PrefConstants.PREF_MESSAGE, message);
  }

  Future<void> setNotificationCode(String notificationCode) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    print("setNotificationCode = $notificationCode");
    sharedPreferences.setString(
        PrefConstants.PREF_NOTIFICATION_CODE, notificationCode);
  }

  Future<void> setNotificationUserType(String userType) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    print("setNotificationCode = $userType");
    sharedPreferences.setString(
        PrefConstants.PREF_USER_TYPE, userType);
  }

  Future<String> getNotificationCode() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    String notificationCode =
    sharedPreferences.getString(PrefConstants.PREF_NOTIFICATION_CODE);
    print("getNotificationCode  = $notificationCode");
    return notificationCode ?? "";
  }

  Future<String> getNotificationUserType() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    String userType =
    sharedPreferences.getString(PrefConstants.PREF_USER_TYPE);
    print("getNotificationUserType  = $userType");
    return userType ?? "";
  }

  Future<String> getNotificationMessage() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    String message =
    sharedPreferences.getString(PrefConstants.PREF_MESSAGE);
    print("getNotificationMessage  = $message");
    return message ?? "";
  }

  Future<void> setIsProviderDetailsToShow(bool isProviderDetailsToShow) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    print("set pref isProviderDetailsToShow = $isProviderDetailsToShow");
    sharedPreferences.setBool(
        PrefConstants.PREF_IS_PROVIDER_DETAILS_TO_SHOW, isProviderDetailsToShow);
  }

  Future<bool> getIsProviderDetailsToShow() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    // await  sharedPreferences.reload();
    bool isProviderDetailsToShow =
    sharedPreferences.getBool(PrefConstants.PREF_IS_PROVIDER_DETAILS_TO_SHOW);
    print("get pref isProviderDetailsToShow = $isProviderDetailsToShow");
    return isProviderDetailsToShow ?? true ;
  }

  Future<void> setSeekerDuration(String seekerDuration) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    print("set pref seekerDuration = $seekerDuration");
    sharedPreferences.setString(
        PrefConstants.PREF_SEEKER_DURATION, seekerDuration);
  }

  Future<String> getSeekerDuration() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    await  sharedPreferences.reload();
    String seekerDuration =
    sharedPreferences.getString(PrefConstants.PREF_SEEKER_DURATION);
    print("get pref isProviderDetailsToShow = $seekerDuration");
    return seekerDuration ?? "";
  }

  Future<void> setIsSeekerForceCancelled(int isSeekerForceCancelled) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    print("set pref isSeekerForceCancelled = $isSeekerForceCancelled");
    sharedPreferences.setInt(
        PrefConstants.PREF_IS_SEEKER_FORCE_CANCELLED, isSeekerForceCancelled);
  }

  Future<int> getIsSeekerForceCancelled() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    await  sharedPreferences.reload();
    int isSeekerForceCancelled =
    sharedPreferences.getInt(PrefConstants.PREF_IS_SEEKER_FORCE_CANCELLED);
    print("get pref isSeekerForceCancelled = $isSeekerForceCancelled");
    return isSeekerForceCancelled ?? 0;
  }

  Future<bool> clearSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.clear();
  }
}
