import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/dest_locate_repo.dart';
import 'favorite_add_event.dart';
import 'favorite_add_state.dart';


class FavoriteAddBloc extends Bloc<FavoriteAddEvent, FavoriteAddState> {
  final DestLocateRepository repository;

  FavoriteAddBloc({@required this.repository}) : super(FavoriteAddEmpty());

  @override
  FavoriteAddState get initialState => FavoriteAddEmpty();

  @override
  Stream<FavoriteAddState> mapEventToState(FavoriteAddEvent event) async* {
    if (event is FavoriteAddClickEvent) {
      yield FavoriteAddLoading();
      try {
        var response =
            await repository.addFavorite(event.favoriteRequest);
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield FavoriteAddSuccess(favoriteAddResponse: response,index: event.index);
        } else {
          yield FavoriteAddError(message: "${response.message}",index: event.index);
        }
      } catch (_) {
        print("exception $_");
        yield FavoriteAddError(
            message: "Unable to process your request right now",index: event.index);
      }
    }
  }
}
