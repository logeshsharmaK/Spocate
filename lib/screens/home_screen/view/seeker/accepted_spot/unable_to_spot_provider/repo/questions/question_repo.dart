import 'package:flutter/widgets.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'question_response.dart';

class QuestionListRepository {
  final Webservice webserviceRequest;
  QuestionResponse questionResponse;

  QuestionListRepository(
      {@required this.webserviceRequest})
      : assert(webserviceRequest != null);

  Future<QuestionResponse> getQuestionList() async {
    final response = await webserviceRequest.postAPICall(
        WebConstants.ACTION_SEEKER_QUESTION_LIST,null);
    questionResponse = QuestionResponse.fromJson(response);
    return QuestionResponse.fromJson(response);
  }
}
