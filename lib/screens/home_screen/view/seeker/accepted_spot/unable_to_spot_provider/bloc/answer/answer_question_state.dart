import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/repo/answer/answer_question_response.dart';

abstract class AnswerQuestionState extends Equatable {
  const AnswerQuestionState();

  @override
  List<Object> get props => [];
}

class AnswerQuestionEmpty extends AnswerQuestionState {}

class AnswerQuestionLoading extends AnswerQuestionState {}

class AnswerQuestionError extends AnswerQuestionState {
  final String message;

  const AnswerQuestionError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class AnswerQuestionSuccess extends AnswerQuestionState {
  final AnswerQuestionResponse answerQuestionResponse;

  const AnswerQuestionSuccess({@required this.answerQuestionResponse}) : assert(answerQuestionResponse != null);

  @override
  List<Object> get props => [answerQuestionResponse];
}
