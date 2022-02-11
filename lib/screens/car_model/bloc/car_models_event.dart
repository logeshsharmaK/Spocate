

import 'package:meta/meta.dart';

abstract class CarModelListEvent {
  const CarModelListEvent();
}

class CarModelListInitEvent extends CarModelListEvent {
  final String makeName;

  const CarModelListInitEvent({@required this.makeName});

  @override
  List<Object> get props => [makeName];
}
