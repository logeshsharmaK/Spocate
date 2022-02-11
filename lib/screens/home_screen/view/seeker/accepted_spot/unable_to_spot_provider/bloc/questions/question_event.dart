import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class QuestionListEvent extends Equatable {
  const QuestionListEvent();
}

class QuestionItemsEvent extends QuestionListEvent {

  const QuestionItemsEvent();

  @override
  List<Object> get props => [];
}
