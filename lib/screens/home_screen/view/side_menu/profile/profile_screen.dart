import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/constants/word_constants.dart';
import 'package:spocate/core/widgets/app_styles.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/home_screen/repo/home/home_response.dart';
import 'package:spocate/screens/home_screen/view/side_menu/profile/repo/profile_repo.dart';
import 'package:spocate/screens/home_screen/view/side_menu/profile/repo/profile_request.dart';
import 'package:spocate/screens/login/repo/social/social_info.dart';
import 'package:spocate/utils/app_utils.dart';
import '../../../../../data/local/shared_prefs/shared_prefs.dart';
import '../../../../login/repo/social/social_info.dart';
import '../side_menu_drawer.dart';
import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _mobileTextController = TextEditingController();

  ProfileBloc _profileBloc;
  SocialInfo userSocialInfo;
  String userId;


  @override
  void initState() {
    print("initState ProfileScreen");
    final ProfileRepository repository =
        ProfileRepository(webservice: Webservice());
    _profileBloc = ProfileBloc(repository: repository);
    _getUserId();
    _getUserDetails();
    // _getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.showAppBar(AppBarConstants.APP_BAR_PROFILE),
      drawer: SideMenuDrawer(),
      body: MultiBlocListener(
        child: _buildProfileView(),
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
              cubit: _profileBloc,
              listener: (context, state) {
                _blocProfileListener(context, state);
              }),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16,
                top: SizeConstants.SIZE_16,
                right: SizeConstants.SIZE_16),
            child: Text(
              WordConstants.PROFILE_LABEL_NAME,
              style: AppStyles.textLabelStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16,
                top: SizeConstants.SIZE_8,
                right: SizeConstants.SIZE_16),
            child: TextFormField(
              style: TextStyle(fontSize: SizeConstants.SIZE_18),
              controller: _nameTextController,
                 decoration: AppStyles.textInputDecorationStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16,
                top: SizeConstants.SIZE_16,
                right: SizeConstants.SIZE_16),
            child: Text(
              WordConstants.PROFILE_LABEL_EMAIL,
              style: AppStyles.textLabelStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16,
                top: SizeConstants.SIZE_8,
                right: SizeConstants.SIZE_16),
            child: TextFormField(
              style: TextStyle(fontSize: SizeConstants.SIZE_18),
              controller: _emailTextController,
              decoration: AppStyles.textInputDecorationStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16,
                top: SizeConstants.SIZE_16,
                right: SizeConstants.SIZE_16),
            child: Text(
              WordConstants.PROFILE_LABEL_MOBILE,
              style: AppStyles.textLabelStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16,
                top: SizeConstants.SIZE_8,
                right: SizeConstants.SIZE_16),
            child: TextFormField(
              style: TextStyle(fontSize: SizeConstants.SIZE_18),
              controller: _mobileTextController,
              decoration: AppStyles.textInputDecorationStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                SizeConstants.SIZE_32,
                SizeConstants.SIZE_64,
                SizeConstants.SIZE_32,
                SizeConstants.SIZE_32),
            child: ElevatedButton(
              child: Text(
                WordConstants.PROFILE_BUTTON_UPDATE,
                style: AppStyles.buttonFillTextStyle(),
              ),
              style: AppStyles.buttonFillStyle(),
              onPressed: () {
                _onSaveAction(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  _onSaveAction(BuildContext context) {
        if (_nameTextController.text == "") {
        AppWidgets.showSnackBar(context,MessageConstants.MESSAGE_PROFILE_NAME_EMPTY);
      } else if (_emailTextController.text == "") {
        AppWidgets.showSnackBar(context, MessageConstants.MESSAGE_PROFILE_EMAIL_EMPTY);
      } else if (_mobileTextController.text == "") {
        AppWidgets.showSnackBar(context, MessageConstants.MESSAGE_PROFILE_MOBILE_EMPTY);
      } else {
        var profileRequest = ProfileRequest(
            userId: userId,
            name: _nameTextController.text,
            email: _emailTextController.text,
            mobileNumber: _mobileTextController.text);
        _profileBloc.add(ProfileClickEvent(profileRequest: profileRequest));
      }
  }

  Future<void> _getUserDetails() async {
    await SharedPrefs().getProfileData().then((socialProfile){
      userSocialInfo = socialProfile;

      /*
      * isSocial = 1 is refers to users logged in with their facebook, google or apple sign-in
      * */
      if(userSocialInfo.isSocial==1){
        _nameTextController.text = userSocialInfo.name ?? "";
        _emailTextController.text =userSocialInfo.email?? "";
        _mobileTextController.text = userSocialInfo.isEmail == "0" ? userSocialInfo.phoneNumber : "";
      }else if (userSocialInfo.isSocial == 0) {
        /*  1.if the users is not logged in as social log-in then this block will execute
        * */
       var name = userSocialInfo.isEmail == "1" ?  userSocialInfo?.email?.split('@')[0] : userSocialInfo.name ;
       var phoneNumber = userSocialInfo.isEmail == "0" ? userSocialInfo.phoneNumber : "" ;

       /*
       * when ever the user update their profiles in profile screen isUpdate is set to 1 in the shared
       * pref then below condition will execute
       * */
        if(userSocialInfo?.isUpdated == 1){
          _nameTextController.text =  userSocialInfo?.name ;
          _emailTextController.text =  userSocialInfo?.email ;
          _mobileTextController.text =  userSocialInfo?.phoneNumber ;
        }else{
          _nameTextController.text =  name ;
          _emailTextController.text =  userSocialInfo?.email ;
          _mobileTextController.text =  phoneNumber ;
        }
      }

    });
  }

  Future<void> _getUserId() async {
    await SharedPrefs().getUserId().then((userIdValue) {
      userId = userIdValue;
      print("userId => $userId");
    });
  }

  _blocProfileListener(BuildContext context, ProfileState state) {
    if (state is ProfileEmpty) {}
    if (state is ProfileLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is ProfileError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is ProfileSuccess) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.profileResponse.message);
      _updateUserInfo();
    }
  }

  Future<void> _updateUserInfo() async {
    await SharedPrefs().updateUserInfo(UserInfo(
        id: int.parse(userId),
        name: _nameTextController.text,
        email: _emailTextController.text,
        mobile: _mobileTextController.text));

    await SharedPrefs().updateProfileData(SocialInfo(
      name: _nameTextController.text,
      email: _emailTextController.text,
      phoneNumber:  _mobileTextController.text,
      isUpdated: 1
    ));

  }
}
