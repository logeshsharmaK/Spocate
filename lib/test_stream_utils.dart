import 'dart:async';

import 'dart:math';

class StreamUtils {
  // // Singleton approach
  static final StreamUtils _instance = StreamUtils._internal();

  factory StreamUtils() => _instance;

  StreamUtils._internal();

  StreamController<bool> controller = StreamController<bool>();
  StreamSubscription<double> streamSubscription ;

  Future<bool> listenStream(){
    Stream stream = controller.stream;
     stream.listen((value) {
      print('Value from controller: $value');
      return Future.value(value);
    });
    return Future.value(false);
  }

  addEmit(){
    controller.add(true);
  }


  cancel(){
    streamSubscription.cancel();
  }


  Stream<double> getRandomValues() async* {
    var random = Random(2);
    yield random.nextDouble();
  }



}
