import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/repo/answer/answer_question_request.dart';

abstract class AnswerQuestionEvent extends Equatable {
  const AnswerQuestionEvent();
}

class AnswerQuestionClickEvent extends AnswerQuestionEvent {
  final AnswerQuestionRequest answerQuestionRequest;

  const AnswerQuestionClickEvent({@required this.answerQuestionRequest});

  @override
  List<Object> get props => [answerQuestionRequest];
}
