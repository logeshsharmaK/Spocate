import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/dest_locate_repo.dart';
import 'favorite_list_event.dart';
import 'favorite_list_state.dart';


class FavoriteListBloc extends Bloc<FavoriteListEvent, FavoriteListState> {
  final DestLocateRepository repository;

  FavoriteListBloc({@required this.repository}) : super(FavoriteListEmpty());

  @override
  FavoriteListState get initialState => FavoriteListEmpty();

  @override
  Stream<FavoriteListState> mapEventToState(FavoriteListEvent event) async* {
    if (event is FavoriteListClickEvent) {
      yield FavoriteListLoading();
      try {
        var response =
            await repository.getFavoriteList(event.favoriteListRequest);
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield FavoriteListSuccess(favoriteResponse: response);
        } else {
          yield FavoriteListError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield FavoriteListError(
            message: "Unable to process your request right now");
      }
    }
  }
}
