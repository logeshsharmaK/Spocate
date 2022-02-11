import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/add_car/repo/add_car_response.dart';
import 'package:spocate/screens/home_screen/repo/home/home_request.dart';
import 'package:spocate/screens/home_screen/repo/home/home_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/accept_spot/accept_spot_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/ignore_spot/ignore_spot_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/notification/spot_location_notification.dart';
import 'package:spocate/screens/login/repo/login_request.dart';

abstract class AcceptSpotEvent extends Equatable {
  const AcceptSpotEvent();
}
class AcceptSpotClickEvent extends AcceptSpotEvent {
  final AcceptSpotRequest acceptSpotRequest;
  final ProviderData providerData;

  const AcceptSpotClickEvent({@required this.acceptSpotRequest,this.providerData});

  @override
  List<Object> get props => [acceptSpotRequest,providerData];
}
