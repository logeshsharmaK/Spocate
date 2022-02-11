import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/favorite/favorite_response.dart';

abstract class FavoriteRemoveState extends Equatable {
  const FavoriteRemoveState();

  @override
  List<Object> get props => [];
}

class FavoriteRemoveEmpty extends FavoriteRemoveState {}

class FavoriteRemoveLoading extends FavoriteRemoveState {}

class FavoriteRemoveError extends FavoriteRemoveState {
  final String message;
  final int index;

  const FavoriteRemoveError({@required this.message, @required this.index}) : assert(message != null);

  List<String> get props => [message];
}

class FavoriteRemoveSuccess extends FavoriteRemoveState {
  final FavoriteResponse favoriteRemoveResponse;
  final int index;

  const FavoriteRemoveSuccess({@required this.favoriteRemoveResponse, @required this.index})
      : assert(favoriteRemoveResponse != null);

  @override
  List<Object> get props => [favoriteRemoveResponse];
}
