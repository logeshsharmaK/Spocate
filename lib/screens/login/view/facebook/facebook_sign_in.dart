import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

String fbAccessToken;

Future<UserCredential> signInWithFacebook() async {
  try {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final FacebookAuthCredential credential = FacebookAuthProvider.credential(
      loginResult.accessToken.token,
    );

    final userData = await FacebookAuth.instance.getUserData();
    print("userData = $userData");
    print("email = ${userData["email"]}");
    print("accessToken = ${credential.accessToken}");
    print("name = ${userData["name"]}");
    fbAccessToken = credential.accessToken;

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }  catch (e) {
    print("Exception facebook sign-in $e");

  }  finally {}
  return null;
}

Future<void> faceBookLogOut() async {
  await FacebookAuth.instance.logOut();
}

