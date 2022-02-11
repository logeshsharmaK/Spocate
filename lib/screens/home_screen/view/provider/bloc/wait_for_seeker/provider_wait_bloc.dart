import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_repo.dart';

import 'provider_wait_event.dart';
import 'provider_wait_state.dart';

class ProviderWaitBloc extends Bloc<ProviderWaitEvent, ProviderWaitState> {
  final ProviderRepository repository;

  ProviderWaitBloc({@required this.repository}) : super(ProviderWaitEmpty());

  @override
  ProviderWaitState get initialState => ProviderWaitEmpty();

  @override
  Stream<ProviderWaitState> mapEventToState(ProviderWaitEvent event) async* {
    if (event is ProviderWaitClickEvent) {
      yield ProviderWaitLoading();
      try {
        var response = await repository
            .submitWaitForSeeker(event.providerWaitingRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield ProviderWaitSuccess(providerWaitResponse: response);
        } else {
          yield ProviderWaitError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield ProviderWaitError(
            message: "Unable to process your request right now");
      }
    }
  }
}
