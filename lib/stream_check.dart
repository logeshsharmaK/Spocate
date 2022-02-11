import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamController<double> controller = StreamController<double>();
  StreamSubscription<double> streamSubscription;


  @override
  void initState() {
    Stream stream = controller.stream;
    stream.listen((value) {
      print('Value from controller: $value');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(
          body: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MaterialButton(
                  child: Text('Subscribe'),
                  color: Colors.yellow,
                  onPressed: () async {
                    // Stream stream = controller.stream;
                    // stream.listen((value) {
                    //   print('Value from controller: $value');
                    // });
                    //  streamSubscription = stream.listen((value) {
                    //   print('Value from controller: $value');
                    // });
                    // getDelayedRandomValue().listen((value) {
                    //   print('Value from manualStream: $value');
                    // });
                  },
                ),
                MaterialButton(
                  child: Text('Emit Value'),
                  color: Colors.blue[200],
                  onPressed: () {
                    controller.add(12);
                  },
                ),
                MaterialButton(
                  child: Text('Unsubscribe'),
                  color: Colors.red[200],
                  onPressed: () {
                    streamSubscription?.cancel();
                  },
                )
              ],
            ),
          ),
        ));
  }

  Stream<double> getDelayedRandomValue() async* {
    var random = Random();

    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield random.nextDouble();
    }
  }
}
