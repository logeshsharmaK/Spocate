import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/favorite/favorite_list/favorite_list_request.dart';

abstract class FavoriteListEvent extends Equatable {
  const FavoriteListEvent();
}

class FavoriteListClickEvent extends FavoriteListEvent {
  final FavoriteListRequest favoriteListRequest;

  const FavoriteListClickEvent({@required this.favoriteListRequest});

  @override
  List<Object> get props => [favoriteListRequest];
}
