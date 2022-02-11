import 'dart:async';

class StreamUtils {
  // Singleton approach
  static final StreamUtils _instance = StreamUtils._internal();

  factory StreamUtils() => _instance;

  StreamUtils._internal();

  var listenForNetwork = StreamController<bool>.broadcast();

  Stream<bool> listerStreamData() {
    // listenForNetwork.add(true);
    return listenForNetwork.stream.asBroadcastStream();
  }

  void addStreamData(){
    listenForNetwork.add(true);
  }
}
