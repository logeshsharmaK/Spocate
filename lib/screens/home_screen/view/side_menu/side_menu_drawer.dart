import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/core/constants/enum_constants.dart';
import 'package:spocate/core/constants/login_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/constants/word_constants.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/routes/route_constants.dart';
import 'package:spocate/screens/home_screen/view/side_menu/logout/bloc/logout_bloc.dart';
import 'package:spocate/screens/home_screen/view/side_menu/logout/bloc/logout_event.dart';
import 'package:spocate/screens/home_screen/view/side_menu/logout/repo/logout_repo.dart';
import 'package:spocate/screens/home_screen/view/side_menu/logout/repo/logout_request.dart';
import 'package:spocate/screens/login/view/apple/apple_sign_in.dart';
import 'package:spocate/screens/login/view/google/google_sign_in.dart';
import 'package:spocate/utils/device_utils.dart';

import '../../../../core/constants/app_bar_constants.dart';
import '../../../login/view/facebook/facebook_sign_in.dart';
import 'logout/bloc/logout_state.dart';

class SideMenuDrawer extends StatefulWidget {
  const SideMenuDrawer({Key key}) : super(key: key);

  @override
  _SideMenuDrawerState createState() => _SideMenuDrawerState();
}

class _SideMenuDrawerState extends State<SideMenuDrawer> {
  String name;
  String email;
  String profilePhoto;

  LogoutBloc _logoutBloc;
  String userId;
  String deviceId;
  SharedPrefs _sharedPrefs = SharedPrefs();

  @override
  void initState() {
    final LogoutRepository repository =
        LogoutRepository(webservice: Webservice());
    _logoutBloc = LogoutBloc(repository: repository);
    _getUserDetail();
    _getDeviceId();
    _getSocialInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MultiBlocListener(
        child: _buildDrawerView(),
        listeners: [
          BlocListener<LogoutBloc, LogoutState>(
              cubit: _logoutBloc,
              listener: (context, state) {
                _blocLogoutListener(context, state);
              }),
        ],
      ),
    );
  }

  Widget _buildDrawerView() {
    return ListView(
      children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          accountName: Text(name ?? "",
              style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          accountEmail: Text(
            email ?? "",
            style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15),
            maxLines: 2,
          ),
          currentAccountPicture: CircleAvatar(
            radius: 50.0,
            backgroundColor: Colors.white,
            child: profilePhoto != null && profilePhoto.isNotEmpty
                ? ClipOval(child : Image.network(profilePhoto))
    /*ClipRRect(
    borderRadius:BorderRadius.circular(30),child : Image.network(profilePhoto))*/
                : Icon(
                    Icons.account_circle_rounded,
                    size: SizeConstants.SIZE_64,
                    color: Colors.black87,
                  ),
          ),
        ),
        _buildSideMenuItem(
            Icon(
              Icons.home,
              color: Colors.black,
            ),
            AppBarConstants.APP_BAR_HOME,
            RouteConstants.ROUTE_HOME_SCREEN),
        Divider(),
        _buildSideMenuItem(
            Icon(Icons.account_circle_rounded, color: Colors.black),
            AppBarConstants.APP_BAR_PROFILE,
            RouteConstants.ROUTE_PROFILE),
        Divider(),
        _buildSideMenuItem(
            Icon(Icons.account_balance_wallet, color: Colors.black),
            AppBarConstants.APP_BAR_MY_CREDITS,
            RouteConstants.ROUTE_MY_CREDITS),
        Divider(),
        _buildSideMenuItem(Icon(Icons.directions_car_sharp, color: Colors.black),
            AppBarConstants.APP_BAR_MY_CARS, RouteConstants.ROUTE_MY_CARS),
        Divider(),
        _buildSideMenuItem(Icon(Icons.support_agent, color: Colors.black),
            AppBarConstants.APP_BAR_SUPPORT, RouteConstants.ROUTE_SUPPORT),
        Divider(),
        _buildSideMenuItem(Icon(Icons.logout, color: Colors.black),
            AppBarConstants.APP_BAR_LOGOUT, ""),
        Divider(),
      ],
    );
  }

  _buildSideMenuItem(Icon icon, String title, String navRoute) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
      onTap: () async {
        if (navRoute == "") {
          var dialogAction = await AppWidgets.showCustomDialogYesNo(context,
               MessageConstants.LOGOUT_BODY);
          if (dialogAction == DialogAction.Yes) {
            var logoutRequest = LogoutRequest(
                userId: userId, deviceId: await DeviceUtils.getDeviceID());
            _logoutBloc.add(LogoutClickEvent(logoutRequest: logoutRequest));
          }
        } else {
          Navigator.pushReplacementNamed(context, navRoute);
        }
      },
    );
  }

  Future<void> _getUserDetail() async {
    await _sharedPrefs.getUserId().then((userIdValue) {
      userId = userIdValue;
      print("userId => $userId");
    });
  }

  Future<void> _getSocialInfo() async {
    await _sharedPrefs.getProfileData().then((socialInfo) {
      setState(() {
        name = socialInfo.name.isNotEmpty
            ? socialInfo.name
            : socialInfo.isEmail == "0"
                ? socialInfo.phoneNumber
                : socialInfo.email.split("@")[0];
        email = socialInfo.email;
        profilePhoto = socialInfo.profilePhoto;
      });
      print("name => ${socialInfo.name}");
      print("email => ${socialInfo.email}");
      print("profilePhoto => ${socialInfo.profilePhoto}");
      print("phoneNumber => ${socialInfo.phoneNumber}");
      print("email => ${socialInfo.email.split("@")[0]}");
    });
  }

  Future<void> _getDeviceId() async {
    await DeviceUtils.getDeviceID()
        .then((deviceIdValue) => deviceId = deviceIdValue);
  }

  _blocLogoutListener(BuildContext context, LogoutState state) {
    if (state is LogoutEmpty) {}
    if (state is LogoutLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is LogoutError) {
      print("LogoutError ");
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is LogoutSuccess) {
      print("LogoutSuccess ");
      AppWidgets.hideProgressBar();
      _socialLogout();
    }
  }

  _socialLogout() async {
    await _sharedPrefs.getLoginType().then((loginType) {
      print("getLoginType ");
      switch (loginType) {
        case LoginType.LOGIN_TYPE_GOOGLE:
          {
            print("LOGIN_TYPE_GOOGLE ${LoginType.LOGIN_TYPE_GOOGLE}");

            GoogleSignInApi.logOut().then((googleSignOut) {
              _sharedPrefs.clearSharedPreferences().then((value) {
                if (value) {
                  _navigateRespectiveScreens();
                }
              });
            });
          }
          break;

        case LoginType.LOGIN_TYPE_FACEBOOK:
          {
            print("LOGIN_TYPE_FACEBOOK ${LoginType.LOGIN_TYPE_FACEBOOK}");

            faceBookLogOut().then((value) {
              _sharedPrefs.clearSharedPreferences().then((value) {
                if (value) {
                  _navigateRespectiveScreens();
                }
              });
            });
          }
          break;

        case LoginType.LOGIN_TYPE_APPLE:
          {
            print("LOGIN_TYPE_APPLE ${LoginType.LOGIN_TYPE_APPLE}");

            appleLogOut().then((value) {
              _sharedPrefs.clearSharedPreferences().then((value) {
                if (value) {
                  _navigateRespectiveScreens();
                }
              });
            });
          }
          break;
        case LoginType.LOGIN_TYPE_PHONE_NUMBER_OR_EMAIL:
          {
            print(
                "LOGIN_TYPE_PHONE_NUMBER_OR_EMAIL ${LoginType.LOGIN_TYPE_PHONE_NUMBER_OR_EMAIL}");
            _sharedPrefs.clearSharedPreferences().then((value) {
              if (value) {
                _navigateRespectiveScreens();
              }
            });
          }
          break;
      }
    });
  }

  _navigateRespectiveScreens() {
    Navigator.pushNamedAndRemoveUntil(
        context, RouteConstants.ROUTE_LOGIN, (route) => false);
  }
}
