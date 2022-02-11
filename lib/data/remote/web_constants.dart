class WebConstants {
  // Standard Comparison Values
  static const int STATUS_CODE_SUCCESS = 200;
  static const String STATUS_VALUE_DISTANCE_OK = "OK";
  static const String STATUS_VALUE_DISTANCE_INVALID_REQUEST = "INVALID_REQUEST";
  static const String STATUS_VALUE_DISTANCE_REQUEST_DENIED= "REQUEST_DENIED";
  static const String STATUS_VALUE_SUCCESS = "Success";
  static const String STATUS_VALUE_FAILED = "False";

  // Car List Success
  static const String STATUS_CAR_VALUE_SUCCESS = "Response returned successfully";

  // Base URL
  static const String BASE_URL_LIVE = "http://113.193.25.21:710/api";
  static const String BASE_URL_UAT= "http://113.193.25.21:710/api";

  // Webservice
  static const String BASE_URL_COMMON = BASE_URL_UAT;
  static const String PASS_CODE = "Sk1TU2VjcmV0S2V5OTg1Mg==";

  // Login
  static const String ACTION_LOGIN = BASE_URL_COMMON + "/Login/Login";
  static const String LOGIN_WITH_EMAIL = "1";
  static const String LOGIN_WITH_PHONE = "0";

  // OTP Verification
  static const String ACTION_OTP_VERIFY = BASE_URL_COMMON + "/Login/Verification";

  // Add Car
  static const String ACTION_ADD_CAR = BASE_URL_COMMON + "/Customer/InsertUpdateCarDetails";
  static const String ADD_CAR_MODE_ADD = "Add";
  static const String ADD_CAR_MODE_UPDATE = "Edit";

  // Car My Color List
  static const String ACTION_CAR_COLOR_LIST = BASE_URL_COMMON + "/Customer/GetCarMasterList";

  // Home Screen - Get Details
  static const String ACTION_HOME_DETAILS = BASE_URL_COMMON + "/Login/DashboardDetails";

  //////////////////////////////////// External Webservices /////////////////////////////////

  // Car Makes List
  static const String ACTION_CARS_LIST = "https://vpic.nhtsa.dot.gov/api/vehicles/getallmakes?format=json";

  // Car Models List
  static const String ACTION_CARS_MODEL_LIST =  "https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformake/";
  static const String ACTION_CARS_MODEL_LIST_QUERY =  "?format=json";

  // Travel Distance and Time from Google Distance Matrix
  static const String ACTION_TRAVEL_TIME_AND_DISTANCE= "https://maps.googleapis.com/maps/api/distancematrix/json?key=AIzaSyC9CG30Z0quaHFEHIcnfI0J4XFGLxlmfd4&units=imperial";
  static const String PARAM_TRAVEL_TIME_AND_DISTANCE_1_ORIGIN =  "&origins="; // 13.073105313834224
  static const String PARAM_TRAVEL_TIME_AND_DISTANCE_2_DEST =  "&destinations="; // 80.22705613103712
  static const String PARAM_TRAVEL_TIME_AND_DISTANCE_3_MODE =  "&mode="; // driving, walking, bicycling

  static const String DISTANCE_MODE_DRIVING =  "driving"; // 12.900816783823423,80.22705613103712
  static const String DISTANCE_MODE_WALKING =  "walking"; // 12.900816783823423,80.22705613103712
  static const String DISTANCE_MODE_BICYCLING =  "bicycling"; // 12.900816783823423,80.22705613103712


  //////////////////////////////////// SIDE MENU /////////////////////////////////

  // Profile
  static const String ACTION_PROFILE = BASE_URL_COMMON + "/Customer/UpdateProfile";

  // My cars
  static const String ACTION_MY_CARS = BASE_URL_COMMON + "/Customer/GetCarList";
  static const String ACTION_MY_CAR_DELETE = BASE_URL_COMMON + "/Customer/DeleteCarDetails";

  // Credit Purchase
  static const String ACTION_CREDIT_PURCHASE = BASE_URL_COMMON + "/Admin/GetPackage";

  // Transactions
  static const String ACTION_TRANSACTION = BASE_URL_COMMON + "/Admin/GetTransactions";
  static const String ACTION_TRANSACTION_TYPE_ALL = "All";
  static const String ACTION_TRANSACTION_TYPE_SPENT = "Spent";
  static const String ACTION_TRANSACTION_TYPE_EARNED = "Earned";
  static const String ACTION_TRANSACTION_TYPE_CREDIT_PURCHASE = "Credit Purchase";


  //////////////////////////////////// SEEKER /////////////////////////////////
  // Search Destination - Locate
  static const String ACTION_DEST_LOCATE = BASE_URL_COMMON + "/Parking/UpdateDestination";

  // Route to Destination - Update Location
  // Update Location from route to destination screen so that the provider can see the seeker location
  // Also the same will be used for spot allocation
  static const String ACTION_UPDATE_CURRENT_LOCATION = BASE_URL_COMMON + "/Parking/UpdateLocation";

  // Route to Destination - Accept Location
  static const String ACTION_ACCEPT_SPOT = BASE_URL_COMMON + "/Parking/Accept";

  // Route to Destination - Ignore Location
  static const String ACTION_IGNORE_SPOT = BASE_URL_COMMON + "/Parking/Ignore";

  // Accepted Screen - Seeker Spotted the Provider- Yes or No
  static const String ACTION_SEEKER_SPOTTED_PROVIDER= BASE_URL_COMMON + "/Parking/SpotSeekerYesNo";

  // Seeker Not able to park Question list
  static const String ACTION_SEEKER_QUESTION_LIST = BASE_URL_COMMON + "/Parking/GetParkingReason";

  // Seeker Not able to part Answer Submit
  static const String ACTION_ANSWER_SUBMIT= BASE_URL_COMMON + "/Parking/SubmitParkingReason";

  // Seeker Cancel request
  static const String ACTION_SEEKER_CANCEL= BASE_URL_COMMON + "/Parking/SeekerCancel";

  // Get Favorite
  static const String ACTION_GET_FAVORITE = BASE_URL_COMMON + "/Parking/GetFavouriteLocation";

  // Add Favorite
  static const String ACTION_ADD_FAVORITE = BASE_URL_COMMON + "/Parking/AddFavouriteLocation";

  // Delete Favorite
  static const String ACTION_DELETE_FAVORITE = BASE_URL_COMMON + "/Parking/DeleteFavouriteLocation";

  // Remove Seeker
  static const String ACTION_REMOVE_SEEKER = BASE_URL_COMMON + "/Parking/DeleteSeeker";

  // Seeker Extra Time
  static const String ACTION_SEEKER_EXTRA_TIME = BASE_URL_COMMON + "/Parking/RequestExtraTime";


  //////////////////////////////////// PROVIDER /////////////////////////////////

  // Home Screen - UnPark
  static const String ACTION_HOME_UN_PARK= BASE_URL_COMMON + "/Parking/UnPark";

  // Home Screen - UnPark and confirm with provider whether he is ready to wait or not
  static const String ACTION_HOME_PROVIDER_DECISION_CONFIRM= BASE_URL_COMMON + "/Parking/WaitYesNo";

  // Provider Waiting - Wait for seeker
  static const String ACTION_PROVIDER_WAIT_FOR_SEEKER= BASE_URL_COMMON + "/Parking/Wait";

  // Provider leave the spot instead waiting for seeker
  static const String ACTION_PROVIDER_LEAVING_SPOT= BASE_URL_COMMON + "/Parking/Leave";

  // Waiting Screen - Provider Spotted the Seeker - Yes or No
  static const String ACTION_PROVIDER_SPOTTED_SEEKER= BASE_URL_COMMON + "/Parking/SpotProviderYesNo";

  // Waiting Screen - Refresh Seeker location in provider view
  static const String ACTION_REFRESH_SEEKER_LOCATION_FOR_PROVIDER= BASE_URL_COMMON + "/Parking/GetUserInfo";

  // Seeker Cancelled and Provider got notification and perform whether he wait for new seeker or not
  static const String ACTION_SEEKER_CANCELLED_PROVIDER_WAIT= BASE_URL_COMMON + "/Parking/ProviderWaitYesNo";

  // Provider Cancel request
  static const String ACTION_PROVIDER_CANCEL= BASE_URL_COMMON + "/Parking/ProviderCancel";

  // Logout
  static const String ACTION_LOGOUT = BASE_URL_COMMON + "/Login/Logout";

  // Provider Accept Extra Time
  static const String ACTION_PROVIDER_ACCEPT_EXTRA_TIME = BASE_URL_COMMON + "/Parking/ProviderAcceptExtraTime";

  // Provider Ignore Extra Time
  static const String ACTION_PROVIDER_IGNORE_EXTRA_TIME = BASE_URL_COMMON + "/Parking/ProviderIgnoreExtraTime";

}