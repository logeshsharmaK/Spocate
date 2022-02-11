import 'package:flutter/widgets.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';

import 'answer_question_response.dart';


class AnswerQuestionRepo {
  final Webservice webserviceRequest;
  AnswerQuestionResponse answerQuestionResponse;

  AnswerQuestionRepo(
      {@required this.webserviceRequest})
      : assert(webserviceRequest != null);

  Future<AnswerQuestionResponse> submitAnswerForQuestion(dynamic answerSubmitRequest) async {
    final response = await webserviceRequest.postAPICall(
        WebConstants.ACTION_ANSWER_SUBMIT,answerSubmitRequest);
    answerQuestionResponse = AnswerQuestionResponse.fromJson(response);
    return AnswerQuestionResponse.fromJson(response);
  }
}
