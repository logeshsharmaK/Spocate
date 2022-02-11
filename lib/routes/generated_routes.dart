import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spocate/core/constants/enum_constants.dart';
import 'package:spocate/routes/route_constants.dart';
import 'package:spocate/screens/add_car/view/add_car.dart';
import 'package:spocate/screens/car_color/view/car_colors_list.dart';
import 'package:spocate/screens/car_make/repo/car_makes_response.dart';
import 'package:spocate/screens/car_make/view/car_makes.dart';
import 'package:spocate/screens/car_model/view/car_models.dart';
import 'package:spocate/screens/home_screen/view/home_screen.dart';
import 'package:spocate/screens/home_screen/view/provider/view/provider_waiting.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/view/spot_accepted.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/view/question_list.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/view/route_to_destination.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/view/search_destination.dart';
import 'package:spocate/screens/home_screen/view/seeker/spotted_provider_thanks/seeker_waiting.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/credit_purchase/view/credit_purchase.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/payment_status/view/payment_status.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/transactions/view/transactions.dart';
import 'package:spocate/screens/home_screen/view/side_menu/profile/profile_screen.dart';
import 'package:spocate/screens/home_screen/view/side_menu/support/support.dart';
import 'package:spocate/screens/login/view/login.dart';
import 'package:spocate/screens/login/view/otp/view/otp_verification.dart';
import 'package:spocate/screens/splash/splash_screen.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/view/my_cars_for_change_car.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/view/my_cars.dart';

class GeneratedRoutes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      // New User Login Flow
      case RouteConstants.ROUTE_SPLASH:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case RouteConstants.ROUTE_LOGIN:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RouteConstants.ROUTE_OTP_VERIFICATION:
        return MaterialPageRoute(builder: (context) => OTPVerification());
      case RouteConstants.ROUTE_ADD_CAR:
        if (args is AddCarNavFrom) {
          return MaterialPageRoute(
            builder: (context) => AddCar(
              data: args,
            ),
          );
        }
        return _routeNotFound();
      case RouteConstants.ROUTE_CAR_MAKE_LIST:
        return MaterialPageRoute(builder: (context) => CarMakeList());
      case RouteConstants.ROUTE_CAR_MODEL_LIST:
        if (args is CarMake) {
          return MaterialPageRoute(
            builder: (context) => CarModelList(
              data: args,
            ),
          );
        }
        return _routeNotFound();
      case RouteConstants.ROUTE_CAR_COLOR_LIST:
        return MaterialPageRoute(builder: (context) => CarColorList());

      // Side Menu Drawer Flow
      case RouteConstants.ROUTE_HOME_SCREEN:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case RouteConstants.ROUTE_PROFILE:
        return MaterialPageRoute(builder: (context) => ProfileScreen());
      case RouteConstants.ROUTE_MY_CREDITS:
        return MaterialPageRoute(builder: (context) => TransactionsScreen());
      case RouteConstants.ROUTE_CREDIT_PURCHASE:
        return MaterialPageRoute(builder: (context) => CreditPurchase());
        case RouteConstants.ROUTE_PAYMENT_STATUS:
        return MaterialPageRoute(builder: (context) => PaymentStatus(purchaseDetail: args,));
      case RouteConstants.ROUTE_MY_CARS:
        return MaterialPageRoute(builder: (context) => MyCars());
      case RouteConstants.ROUTE_SUPPORT:
        return MaterialPageRoute(builder: (context) => Support());

      // Seeker Flow
      case RouteConstants.ROUTE_SEARCH_DESTINATION:
        return MaterialPageRoute(builder: (context) => SearchDestination(sourceLocation: args,));
      case RouteConstants.ROUTE_MY_CARS_FOR_CHANGE_CAR:
        return MaterialPageRoute(builder: (context) => MyCarsForChangeCar());
      case RouteConstants.ROUTE_ROUTE_TO_DESTINATION:
        return MaterialPageRoute(builder: (context) => RouteToDestination(sourceAndDest: args,));
      case RouteConstants.ROUTE_ROUTE_TO_SPOT:
        return MaterialPageRoute(builder: (context) => SpotAccepted());
      case RouteConstants.ROUTE_QUESTIONS_LIST:
        return MaterialPageRoute(builder: (context) => QuestionList());
      case RouteConstants.ROUTE_SEEKER_WAIT_PROVIDER_CONFIRMATION:
        return MaterialPageRoute(builder: (context) => SeekerWaiting());

      // Provider Flow
      case RouteConstants.ROUTE_WAIT_FOR_SEEKER:
        return MaterialPageRoute(builder: (context) => ProviderWaiting(sourceLocation: args,));
      default:
        return _routeNotFound();
    }
  }

  static Route<dynamic> _routeNotFound() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        body: Center(
          child: Text("Page not found!"),
        ),
      );
    });
  }
}
