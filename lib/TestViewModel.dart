import 'package:flutter/material.dart';

class TestViewModel with ChangeNotifier {

  List<int> _data = [];
  List<int> get data => _data;


  void setPayload(int data) {
    _data.add(data);
    notifyListeners();
  }

  void clearPayload(){
    _data.clear();
  }
}