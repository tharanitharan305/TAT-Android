part of 'order_bloc.dart';

@immutable
sealed class OrderState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderLoading extends OrderState {}

class OrderError extends OrderState {
  String message;
  OrderError({required this.message});
}

class OrderSucess extends OrderState {
  List<Order> orders;
  OrderSucess({required this.orders});
}

class OrderSucessOnFire extends OrderState {}
