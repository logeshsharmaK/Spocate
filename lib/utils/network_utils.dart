import 'dart:async';

import 'package:connectivity/connectivity.dart';

class NetworkUtils {
  // Singleton approach
  static final NetworkUtils _instance = NetworkUtils._internal();

  factory NetworkUtils() => _instance;

  NetworkUtils._internal();

  // StreamController<bool> listenForNetwork = StreamController<bool>();
  var listenForNetwork = StreamController<bool>.broadcast();

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Stream<bool> listenNetworkChanges() {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        print("Connected");
        listenForNetwork.add(true);
      } else {
        print("No Internet");
        listenForNetwork.add(false);
      }
    });
    return listenForNetwork.stream.asBroadcastStream();
  }
}
