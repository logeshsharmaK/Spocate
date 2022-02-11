import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/repo/answer/answer_question_repo.dart';

import 'answer_question_event.dart';
import 'answer_question_state.dart';


class AnswerQuestionBloc
    extends Bloc<AnswerQuestionEvent, AnswerQuestionState> {
  final AnswerQuestionRepo repository;

  AnswerQuestionBloc({@required this.repository})
      : super(AnswerQuestionEmpty());

  @override
  AnswerQuestionState get initialState => AnswerQuestionEmpty();

  @override
  Stream<AnswerQuestionState> mapEventToState(
      AnswerQuestionEvent event) async* {
    if (event is AnswerQuestionClickEvent) {
      yield AnswerQuestionLoading();
      try {
        var response =
            await repository.submitAnswerForQuestion(event.answerQuestionRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield AnswerQuestionSuccess(answerQuestionResponse: response);
        } else {
          yield AnswerQuestionError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield AnswerQuestionError(
            message: "Unable to process your request right now");
      }
    }
  }
}
