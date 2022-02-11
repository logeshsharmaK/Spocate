import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_cancel/bloc/seeker_cancel_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_cancel/bloc/seeker_cancel_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_cancel/repo/seeker_cancel_repo.dart';
import 'package:spocate/utils/notification_utils.dart';

class SeekerCancelBloc extends Bloc<SeekerCancelEvent, SeekerCancelState> {
  final SeekerCancelRepository repository;

  SeekerCancelBloc({@required this.repository}) : super(SeekerCancelEmpty());

  @override
  SeekerCancelState get initialState => SeekerCancelEmpty();

  @override
  Stream<SeekerCancelState> mapEventToState(SeekerCancelEvent event) async* {
    if (event is SeekerCancelClickEvent) {
      yield SeekerCancelLoading();
      try {
        var response = await repository.submitSeekerCancel(event.seekerCancelRequest);
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          if(event.isSeekerForceCancelled == 1){
            NotificationUtils().showNotificationWithTitleBody(
                1005,
                MessageConstants.APP_NAME,
                MessageConstants.MESSAGE_HOME_NOTIFICATION_FOR_SEEKER_FORCE_CANCELLED,
                false);
            SharedPrefs().setIsSeekerForceCancelled(event.isSeekerForceCancelled);
          }
          yield SeekerCancelSuccess(seekerCancelResponse: response);
        } else {
          yield SeekerCancelError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield SeekerCancelError(
            message: "Unable to process your request right now");
      }
    }
  }
}
