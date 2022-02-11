import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/dest_locate_repo.dart';
import 'favorite_remove_event.dart';
import 'favorite_remove_state.dart';


class FavoriteRemoveBloc extends Bloc<FavoriteRemoveEvent, FavoriteRemoveState> {
  final DestLocateRepository repository;

  FavoriteRemoveBloc({@required this.repository}) : super(FavoriteRemoveEmpty());

  @override
  FavoriteRemoveState get initialState => FavoriteRemoveEmpty();

  @override
  Stream<FavoriteRemoveState> mapEventToState(FavoriteRemoveEvent event) async* {
    if (event is FavoriteRemoveClickEvent) {
      yield FavoriteRemoveLoading();
      try {
        var response =
            await repository.removeFavorite(event.favoriteRemoveRequest);
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield FavoriteRemoveSuccess(favoriteRemoveResponse : response, index: event.index);
        } else {
          yield FavoriteRemoveError(message: "${response.message}",index: event.index);
        }
      } catch (_) {
        print("exception $_");
        yield FavoriteRemoveError(
            message: "Unable to process your request right now" , index: event.index);
      }
    }
  }
}
