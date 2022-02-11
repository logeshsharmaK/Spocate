import 'package:flutter/material.dart';

class PayloadPasser with ChangeNotifier {

  Map<String, String> _payload = <String, String>{};
  Map<String, String> get payload => _payload;


  void setPayload(Map<String, String> data) {
   _payload.addAll(data);
    notifyListeners();
  }

  void clearPayload(){
    _payload.clear();
  }
}