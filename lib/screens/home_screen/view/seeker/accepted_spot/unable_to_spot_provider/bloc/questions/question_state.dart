import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/repo/questions/question_response.dart';



abstract class QuestionListState extends Equatable {
  const QuestionListState();

  @override
  List<Object> get props => [];
}

class QuestionListEmpty extends QuestionListState {}

class QuestionListLoading extends QuestionListState {}

class QuestionListError extends QuestionListState {
  final String message;

  const QuestionListError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class QuestionListSuccess extends QuestionListState {
  final QuestionResponse questionResponse;

  const QuestionListSuccess({@required this.questionResponse}) : assert(questionResponse != null);

  @override
  List<Object> get props => [questionResponse];
}
