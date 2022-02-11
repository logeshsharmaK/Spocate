import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_extra_time/bloc/seeker_cancel_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_extra_time/bloc/seeker_cancel_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_extra_time/repo/seeker_extra_time_repo.dart';

class SeekerExtraTimeBloc extends Bloc<SeekerExtraTimeEvent, SeekerExtraTimeState> {
  final SeekerExtraTimeRepository repository;

  SeekerExtraTimeBloc({@required this.repository}) : super(SeekerExtraTimeEmpty());

  @override
  SeekerExtraTimeState get initialState => SeekerExtraTimeEmpty();

  @override
  Stream<SeekerExtraTimeState> mapEventToState(SeekerExtraTimeEvent event) async* {
    if (event is SeekerExtraTimeClickEvent) {
      yield SeekerExtraTimeLoading();
      try {
        var response = await repository.submitSeekerExtraTime(event.seekerExtraTimeRequest);
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield SeekerExtraTimeSuccess(seekerExtraTimeResponse: response);
        } else {
          yield SeekerExtraTimeError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield SeekerExtraTimeError(
            message: "Unable to process your request right now");
      }
    }
  }
}
