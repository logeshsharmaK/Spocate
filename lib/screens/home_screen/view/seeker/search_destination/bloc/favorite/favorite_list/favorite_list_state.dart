import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/favorite/favorite_response.dart';

abstract class FavoriteListState extends Equatable {
  const FavoriteListState();

  @override
  List<Object> get props => [];
}

class FavoriteListEmpty extends FavoriteListState {}

class FavoriteListLoading extends FavoriteListState {}

class FavoriteListError extends FavoriteListState {
  final String message;

  const FavoriteListError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class FavoriteListSuccess extends FavoriteListState {
  final FavoriteResponse favoriteResponse;

  const FavoriteListSuccess({@required this.favoriteResponse})
      : assert(FavoriteResponse != null);

  @override
  List<Object> get props => [favoriteResponse];
}
