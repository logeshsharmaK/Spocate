class WordConstants {
  // App
  static const String APP_DEMO = "demo";
  static const String APP_LIVE = "live";
  static const String APP_TYPE = APP_LIVE;
  static const String PLATFORM_ANDROID = "android";
  static const String PLATFORM_IOS = "ios";
  // static const String GOOGLE_PLACES_API_KEY = 'AIzaSyA1fCASJErNUjWPPhCrXofo9WRgFNy8f5Q';
  // static const String GOOGLE_PLACES_API_KEY = 'AIzaSyAz7ow8d0PKZ8s0suw1SmXUmCHxHPbIKzk';
  // static const String GOOGLE_PLACES_API_KEY = 'AIzaSyC9CG30Z0quaHFEHIcnfI0J4XFGLxlmfd4';
  // Official Spocate App
  static const String GOOGLE_PLACES_API_KEY = 'AIzaSyBS_hNUYuRkwS6oSoRywZllQIHz0zWfhJQ';

  // Pattern Matcher
  static const Pattern PATTERN_EMAIL =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const Pattern PATTERN_MOBILE = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  static const Pattern PATTERN_ONLY_TEXT = r'[A-Z]';
  static const Pattern PATTERN_ONLY_NUMBER = r'[0-9]';

  // Splash Screen
  static const String SPLASH_APP_NAME = 'Spocate';
  static const String SPLASH_APP_LOGO_SUBTITLE = 'Your Car Spot';

  // Login Screen
  static const String LOGIN_LABEL_PHONE_OR_EMAIL = 'Enter your Mobile or Email';
  static const String LOGIN_LABEL_OTP_PHONE_OR_EMAIL =
      'A 4 digit OTP will be sent via SMS or Email to verify your given mobile number or email respectively';
  static const String LOGIN_BUTTON_CONTINUE = 'Continue';
  static const String LOGIN_BUTTON_GOOGLE = 'Sign in with Google';
  static const String LOGIN_BUTTON_FACEBOOK = 'Sign in with Facebook';
  static const String LOGIN_BUTTON_APPLE = 'Sign in with Apple';


  // OTP verification
  // static const String OTP_VERIFICATION_EMAIL =
  //     'Please enter a 4 digit OTP sent to your given email ';
  // static const String OTP_VERIFICATION_MOBILE =
  //     'Please enter a 4 digit OTP sent to your given mobile number ';
    static const String OTP_LABEL_ENTER_OTP = 'Please enter the OTP sent to ';
  static const String OTP_BUTTON_VERIFY = 'Verify';
  static const String OTP_BUTTON_RESEND = 'ReSend OTP';

  // Home screen
  static const String HOME_BUTTON_LOCATE_SPOT = 'Looking for a parking spot';
  static const String HOME_BUTTON_EXIT_SPOT = 'Leaving my parking spot';

  // Search Destination
  static const String SEARCH_DEST_BUTTON_LOCATE = 'Locate';

  // Route to Destination
  static const String ROUTE_TO_DEST_LABEL_THANKS = 'Spotting';
  static const String ROUTE_TO_DEST_LABEL_WILL_NOTIFY_SPOT_SOON = 'We will notify you of  Spot availability once you near your destination';
  static const String ROUTE_TO_DEST_BUTTON_ACCEPT = 'Accept';
  static const String ROUTE_TO_DEST_BUTTON_IGNORE = 'Ignore';

  // Add Car
  static const String ADD_CAR_LABEL_MAKE = 'Car Make*';
  static const String ADD_CAR_LABEL_MODEL = 'Car Model*';
  static const String ADD_CAR_LABEL_COLOR = 'Car Color*';
  static const String ADD_CAR_LABEL_NUMBER = 'Car Number*';
  static const String ADD_CAR_BUTTON_ADD = 'Add';

  // Questions List
  static const String QUESTIONS_LABEL_COMMENT = 'Comment';
  static const String QUESTIONS_HINT_COMMENT = 'Please enter the comment';
  static const String QUESTIONS_BUTTON_SUBMIT = 'Submit';
  static const String QUESTIONS_ANSWER_NO = 'No';
  static const String QUESTIONS_ANSWER_YES = 'Yes';

  // My cars
  static const String MY_CARS_BUTTON_CURRENT_DEFAULT = 'Default';
  static const String MY_CARS_BUTTON_SET_DEFAULT = 'Make Default';

  // Car Make
  static const String CAR_MAKE_BUTTON_APPLY = 'Apply';
  static const String CAR_MAKE_HINT_TEXT_APPLY_CAR = 'Please type your car make';
  static const String CAR_MODEL_HINT_TEXT_APPLY_CAR = 'Please type your car model';

  // Add Car
  static const String PROFILE_LABEL_NAME = 'Name';
  static const String PROFILE_LABEL_EMAIL = 'Email';
  static const String PROFILE_LABEL_MOBILE = 'Mobile';
  static const String PROFILE_BUTTON_UPDATE = 'Update';

}
