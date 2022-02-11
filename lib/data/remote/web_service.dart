import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'web_exceptions.dart';

class Webservice {

  // Singleton approach
  static final Webservice _instance = Webservice._internal();
  factory Webservice() => _instance;
  Webservice._internal();

  Map<String, String> postHeaders = {
    'Content-Type': 'application/json; charset=UTF-8'
  };

  Map<String, String> getHeaders = {
    "Accept": "application/json"
  };

  Future<dynamic> postAPICall(String action, dynamic param) async {

    var responseJson;
    var requestJson = jsonEncode(param);
    print("Webservice action $action");
    print("Webservice requestJson $requestJson");

    try {
      final response =  await http.post(Uri.parse(action),headers: postHeaders,
          body: requestJson);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postAPICallOnlyAction(String action) async {

    var responseJson;
    print("Webservice action $action");

    try {
      final response =  await http.post(Uri.parse(action),headers: postHeaders);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getAPICall(String action) async {

    var responseJson;
    // var requestJson = jsonEncode(param);
    print("Webservice action $action");
    // print("Webservice requestJson $requestJson");

    try {
      final response =  await http.get(Uri.parse(action),headers: getHeaders);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        print("Webservice response ${response.body.toString()}");
        var responseJson = json.decode(response.body.toString());
        print("Webservice responseJson $responseJson");
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }

}