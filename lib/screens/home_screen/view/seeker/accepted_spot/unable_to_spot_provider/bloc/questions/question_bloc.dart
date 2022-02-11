import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/repo/questions/question_repo.dart';
import 'question_event.dart';
import 'question_state.dart';

class QuestionBloc extends Bloc<QuestionListEvent, QuestionListState> {
  final QuestionListRepository repository;

  QuestionBloc({@required this.repository}) : super(QuestionListEmpty());

  @override
  QuestionListState get initialState => QuestionListEmpty();

  @override
  Stream<QuestionListState> mapEventToState(QuestionListEvent event) async* {

    if (event is QuestionItemsEvent) {
      yield QuestionListLoading();
      try {
        var response =
            await repository.getQuestionList();

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield QuestionListSuccess(questionResponse: response);
        } else {
          yield QuestionListError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield QuestionListError(
            message: "Unable to process your request right now");
      }
    }
  }
}
