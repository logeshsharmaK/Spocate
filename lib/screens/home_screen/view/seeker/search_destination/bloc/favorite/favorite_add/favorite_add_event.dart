import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/favorite/favorite_add_request/favorite_request.dart';

abstract class FavoriteAddEvent extends Equatable {
  const FavoriteAddEvent();
}

class FavoriteAddClickEvent extends FavoriteAddEvent {
  final FavoriteRequest favoriteRequest;
  final int index;

  const FavoriteAddClickEvent({@required this.favoriteRequest, @required this.index});

  @override
  List<Object> get props => [favoriteRequest];
}
