part of 'order_bloc.dart';

@immutable
sealed class OrderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateQuantityEvent extends OrderEvent {
  Order product;
  String qty;
  UpdateQuantityEvent({required this.product, required this.qty});
  @override
  List<Object> get props => [];
}

class UpdateSellingPriceEvent extends OrderEvent {
  Order product;
  double sp;
  double dis;
  UpdateSellingPriceEvent(
      {required this.product, required this.sp, required this.dis});
}

class UpdateFreeEvent extends OrderEvent {
  Order product;
  double free;
  UpdateFreeEvent({required this.product, required this.free});
}

class UpdateOrderList extends OrderEvent {
  String company;
  UpdateOrderList({required this.company});
}

class SetUpOverAllOrder extends OrderEvent {
  List<String> company;
  SetUpOverAllOrder({required this.company});
}

class OrderSubmitEvent extends OrderEvent {
  String location;
  Shop shop;
  List<Order> orders;
  BuildContext context;
  OrderSubmitEvent(
      {required this.location,
      required this.shop,
      required this.orders,
      required this.context});
}

class OrderFailedEvent extends OrderEvent {
  String message;
  OrderFailedEvent({required this.message});
}

class OrderAddedSucessEvent extends OrderEvent {}

class OnSearchBarActivated extends OrderEvent {
  String searchText;
  OnSearchBarActivated({required this.searchText});
}
