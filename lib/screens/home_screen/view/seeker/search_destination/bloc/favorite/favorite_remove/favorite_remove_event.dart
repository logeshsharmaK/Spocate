import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/favorite/favorite_remove_request/favorite_remove_request.dart';

abstract class FavoriteRemoveEvent extends Equatable {
  const FavoriteRemoveEvent();
}

class FavoriteRemoveClickEvent extends FavoriteRemoveEvent {
  final FavoriteRemoveRequest favoriteRemoveRequest;
  final int index;

  const FavoriteRemoveClickEvent({@required this.favoriteRemoveRequest, @required this.index});

  @override
  List<Object> get props => [favoriteRemoveRequest];
}
