part of 'AdminBloc.dart';

sealed class AdminState extends Equatable {
  List<Object?> get props => [];
}

class OrderLoading extends AdminState {}

class OrderGotSucess extends AdminState {
  List<FirebaseOrder> orders;
  OrderGotSucess({required this.orders});
}

class OrderGotError extends AdminState {
  String message;
  OrderGotError({required this.message});
}
