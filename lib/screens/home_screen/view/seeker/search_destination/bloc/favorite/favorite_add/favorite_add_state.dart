import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/favorite/favorite_response.dart';

abstract class FavoriteAddState extends Equatable {
  const FavoriteAddState();

  @override
  List<Object> get props => [];
}

class FavoriteAddEmpty extends FavoriteAddState {}

class FavoriteAddLoading extends FavoriteAddState {}

class FavoriteAddError extends FavoriteAddState {
  final String message;
  final int index;

  const FavoriteAddError({@required this.message,@required this.index}) : assert(message != null);

  List<String> get props => [message];
}

class FavoriteAddSuccess extends FavoriteAddState {
  final FavoriteResponse favoriteAddResponse;
  final int index;

  const FavoriteAddSuccess({@required this.favoriteAddResponse, @required this.index})
      : assert(FavoriteResponse != null);

  @override
  List<Object> get props => [favoriteAddResponse];
}
