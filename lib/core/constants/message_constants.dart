class MessageConstants {

  static const String APP_NAME =
      "Spocate";

  // Global
  static const String MESSAGE_INTERNET_CHECK =
      "Please check your Internet Connection";
  static const String MESSAGE_LOCATION_CHECK =
      "Please enable your device location";
  static const String MESSAGE_WEBSERVICE_EXCEPTION =
      "Unable to process your request right now, Please try again later!";
  static const String MESSAGE_NO_DATA_FOUND = "No Data Found!";
  static const String MESSAGE_NO_TRANSACTION_FOUND = "No Transaction";
  static const String SHOW_LOADING = "Loading...";
  static const String MESSAGE_LOCATION_REJECTED_ALWAYS_TITLE = "Enable Location";
  static const String MESSAGE_LOCATION_REJECTED_ALWAYS = "Spocate App must need location permission, kindly enable from App Settings";
  static const String TOKEN_CHANGED = "Token changed";


  // Login
  static const String MESSAGE_LOGIN_EMPTY_EMAIL_OR_MOBILE = "Please enter the valid email or mobile";
  static const String MESSAGE_LOGIN_EMPTY_EMAIL= "Please enter the valid email";
  static const String MESSAGE_LOGIN_EMPTY_MOBILE_NUMBER= "Please enter the valid mobile number";
  static const String MESSAGE_LOGIN_INVALID_CREDENTIALS = "Please enter the valid credentials";
  static const String MESSAGE_LOGIN_USERNAME_EMPTY = "Please enter your Username";
  static const String MESSAGE_LOGIN_PASSWORD_EMPTY = "Please enter your Password";
  static const String MESSAGE_LOGIN_PUSH_TOKEN_EMPTY = "Please wait for a moment to generate device token! and try again later";

  // OTP Verification
  static const String MESSAGE_OTP_EMPTY_OTP= "OTP should not be empty";
  static const String MESSAGE_OTP_INVALID_OTP= "Please enter the valid OTP";
  static const String MESSAGE_OTP_SENT_SUCCESSFULLY= "OTP sent successfully";

  // Add/Edit Car, Car List, Home Screen
  static const String MESSAGE_CAR_MAKE_EMPTY = "Car Make should not be empty";
  static const String MESSAGE_CAR_MODEL_EMPTY = "Car Model should not be empty";
  static const String MESSAGE_CAR_COLOR_EMPTY = "Car Color should not be empty";
  static const String MESSAGE_CAR_NUMBER_EMPTY = "Car Number should not be empty";

  // Car Make
  static const String MESSAGE_CAR_MAKE_APPLY_EMPTY = "Please fill the car make field";
  static const String MESSAGE_CAR_MODEL_APPLY_EMPTY = "Please fill the car model field";

  // Profile
  static const String MESSAGE_PROFILE_NAME_EMPTY = "Name should not be empty";
  static const String MESSAGE_PROFILE_EMAIL_EMPTY = "Email should not be empty";
  static const String MESSAGE_PROFILE_MOBILE_EMPTY = "Mobile should not be empty";

  // Home Screen | Update Destination
  static const String MESSAGE_SOURCE_LAT_EMPTY = "Source Latitude should not be empty";
  static const String MESSAGE_SOURCE_LONG_EMPTY = "Source Longitude should not be empty";
  static const String MESSAGE_SOURCE_ADDRESS_EMPTY = "Source Address should not be empty";
  static const String MESSAGE_SOURCE_PIN_EMPTY = "Source Pin should not be empty";
  static const String MESSAGE_DESTINATION_LAT_EMPTY = "Destination Latitude should not be empty";
  static const String MESSAGE_DESTINATION_LONG_EMPTY = "Destination Latitude should not be empty";
  static const String MESSAGE_DESTINATION_ADDRESS_EMPTY = "Destination Latitude should not be empty";
  static const String MESSAGE_DESTINATION_PIN_EMPTY = "Destination Latitude should not be empty";
  static const String MESSAGE_WILL_FIND_SPOT_WHILE_YOU_DRIVE = "While you drive let us find a parking SPOT near your destination";
  static const String MESSAGE_ALREADY_LOGGED_IN_ANOTHER_DEVICE = "Seems you are already logged in another device, Please login again";
  static const String MESSAGE_WAIT_FOR_LOCATION_FETCH = "We are fetching your current location, Please wait";

  // Search Destination
  static const String MESSAGE_DEST_SEARCH_EMPTY = "Destination Address should not be empty";
  static const String MESSAGE_RECENT_PLACES = "Recent Places";
  static const String MESSAGE_FAVOURITE_PLACES = "Favourite Places";

  // Home Screen | UnPark Location
  static const String MESSAGE_SOURCE_LOCATION_EMPTY = "Source Location should not be empty";
  static const String MESSAGE_HOME_USER_NOT_UN_PARKED = "Seems you are already allocated to the Spot, Kindly exit the parking spot to proceed look for parking";
  static const String MESSAGE_HOME_NOTIFICATION_FOR_SEEKER_FORCE_CANCELLED = "We did not got any response from you, So we are considering you cancelled the trip";

  // Route To Dest Screen | Accept / Reject Spot
  static const String MESSAGE_SPOT_LOCATED_TITLE = "YOUR SPOT LOCATED!";
  // static const String MESSAGE_SPOT_LOCATED_MESSAGE = "Spot Located";
  static const String MESSAGE_SPOT_DEST_DISTANCE_ONE = "Your spot for parking is ";
  static const String MESSAGE_SPOT_DEST_DISTANCE_TWO = " from the destination";
  static const String MESSAGE_SPOT_ACCEPT_IN_30= "Accept with in 30 seconds before losing it";
  static const String MESSAGE_SORRY_UNABLE_TO_SPOT = "Sorry for the inconvenience, you reached your destination but we couldn't find a spot for you!";

  // Spot Located Screen | Have you spotted your provider - Yes/No
  static const String MESSAGE_THANK_YOU_PARKING = "Thank you for Parking!!!";
  static const String MESSAGE_SORRY_UNABLE_TO_PARK = "Sorry for the inconvenience";

  // Spot Accepted
  static const String MESSAGE_SEEKER_NOTIFICATION_SPOT_REACHED = "Have you spot the provider?";
  static const String MESSAGE_SEEKER_NOTIFICATION_EXTENDED_TIME = "Seems you did not reached the Spot yet,Provider might wait for you and credits charged accordingly. Do you want continue?";

  // Home - Provider confirm waiting
  static const String MESSAGE_PROVIDER_NO_SEEKER_FOUND = "Thank you, No seeker found around this place";
  static const String MESSAGE_PROVIDER_DECIDES_WAITING = "Would you like to wait for someone to pick this spot?";
  static const String MESSAGE_SEEKER_NO_CREDITS = "Seems you have no credits, Please purchase some credits to look for parking spot!";

  // Question Screen | Form submitted
  static const String MESSAGE_THANK_YOU_FOR_FEEDBACK = "Thank you for your valuable feedback";

  // Wait Screen | Provider wait for Seeker screen
  static const String ALERT_PROVIDER_TO_WAIT = "Another car is on the way to park on your spot. Appreciate it if you wait for a few minutes";
  static const String ALERT_IS_PROVIDER_SEE_SEEKER = "Can you see the spot?";

  static const String UNPARK_MESSAGE_ONBOARDING = "Thanks you for Un Parking!!!";

  // We are using this message for notification message compare, any changes on this will lead not showing the alert from notification
  // static const String PROVIDER_NOTIFICATION_SEEKER_ON_WAY = "Car is on the way to park in your spot. Would you like to wait for few minutes?";
  // static const String PROVIDER_NOTIFICATION_SEEKER_CANCELLED_FOUND_NO_SEEKER = "Seeker cancelled the trip, also no other seekers are available for now. Sorry for the inconvenience";
  // static const String PROVIDER_NOTIFICATION_SEEKER_CANCELLED_FOUND_ANOTHER_SEEKER = "Seeker cancelled the trip, anyway we found another seeker for you. Would you like to continue waiting?";
  // static const String PROVIDER_NOTIFICATION_SEEKER_REACHED = "Have you spot your seeker?";

  // My Cars
  static const String MESSAGE_MY_CAR_DELETE_CONFIRMATION = 'Are you sure, Do you want to Delete this car?';
  static const String MESSAGE_MY_CAR_SET_DEFAULT_CONFIRMATION = 'Are you sure, Do you want to set this car as default?';
  static const String MESSAGE_MY_CAR_DELETE_NOT_ALLOWED = "You are not allowed to delete this car, at least you must have one car for spot allocation.";

  // Support
  static const String MESSAGE_SUPPORT_CONTACT_PHONE = "For any support and inquiries, Please contact our Help desk at ";
  static const String MESSAGE_SUPPORT_CONTACT_EMAIL = " or email to ";

  // Seeker Waiting for Provider to confirm that he spotted the seeker
  static const String MESSAGE_SEEKER_WAITING_SPOTTED_SUCCESS = "You have successfully spotted the provider!";
  static const String MESSAGE_SEEKER_WAITING_PROVIDER_TO_CONFIRM = "Please wait for the provider to confirm";
  static const String MESSAGE_SEEKER_WAITING_PROVIDER_CONFIRMED = "Your provider confirmed the spot for you to take";
  static const String MESSAGE_SEEKER_WAITING_TITLE_WAITING= "Waiting";
  static const String MESSAGE_SEEKER_WAITING_TITLE_SUCCESS= "Success";

  // Logout
  static const String LOGOUT_BODY = "Are you sure, Do you want to Logout?";

  // Confirmation
  static const String MESSAGE_SPOT_CONFIRMED = "Spot Confirmed";

  // Seeker Notification code
  static const String SEEKER_NOTIFICATION_1_SPOT_LOCATED = "1";
  static const String SEEKER_NOTIFICATION_2_SPOT_CONFIRMED = "2";
  static const String SEEKER_NOTIFICATION_3_PROVIDER_CANCELLED_THE_TRIP = "3";
  static const String SEEKER_NOTIFICATION_4_PROVIDER_ACCEPTED_EXTRA_TIME = "4";
  static const String SEEKER_NOTIFICATION_5_PROVIDER_IGNORE_EXTRA_TIME = "5";
  static const String SEEKER_NOTIFICATION_0_SPOT_REACHED = "0";
  static const String SEEKER_NOTIFICATION_6_EXTENDED_TIME = "6";

  // Seeker UserType
  static const String SEEKER_NOTIFICATION_USER_TYPE = "Seeker";


  // Provider
  static const String PROVIDER_NOTIFICATION_1_SEEKER_ON_WAY = "1";
  static const String PROVIDER_NOTIFICATION_2_SEEKER_REACHED = "2";
  static const String PROVIDER_NOTIFICATION_3_SEEKER_CANCELLED_FOUND_NO_SEEKER = "3";
  static const String PROVIDER_NOTIFICATION_4_SEEKER_CANCELLED_FOUND_ANOTHER_SEEKER = "4";
  static const String PROVIDER_NOTIFICATION_5_SEEKER_ASKING_FOR_EXTRA_TIME = "5";

  // Seeker UserType
  static const String PROVIDER_NOTIFICATION_USER_TYPE = "Provider";
}
