part of 'FirebaseBloc.dart';

sealed class FirebaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddOrderToFirebaseEvent extends FirebaseEvent {
  FirebaseOrder order;
  AddOrderToFirebaseEvent({required this.order});
}

class OnUserEntersEvent extends FirebaseEvent {
  TatUser user;
  OnUserEntersEvent({required this.user});
}

class GetOrderFromFireBase extends FirebaseEvent {
  String beat;
  String date;
  GetOrderFromFireBase({required this.beat, required this.date});
}
