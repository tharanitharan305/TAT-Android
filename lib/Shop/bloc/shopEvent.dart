// part of 'ShopBloc.dart';
//
// @immutable
// sealed class ShopEvent extends Equatable {
//   List<Object> get props => [];
// }
//
// class FetchShopsEvent extends ShopEvent {
//   String location;
//   FetchShopsEvent({required this.location});
// }
//
// class UpdateShopEvent extends ShopEvent {
//   String shop;
//   UpdateShopEvent({required this.shop});
// }
part of 'ShopBloc.dart';


@immutable
sealed class ShopEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchShopsEvent extends ShopEvent {
  final String location;
  FetchShopsEvent({required this.location});

  @override
  List<Object> get props => [location];
}

class UpdateShopEvent extends ShopEvent {
  final String shop;
  UpdateShopEvent({required this.shop});

  @override
  List<Object> get props => [shop];
}

class FetchLocationsEvent extends ShopEvent {}

class SelectLocationEvent extends ShopEvent {
  final String location;
  SelectLocationEvent({required this.location});

  @override
  List<Object> get props => [location];
}

class SelectShopEvent extends ShopEvent {
  final Shop shop;
  SelectShopEvent({required this.shop});

  @override
  List<Object> get props => [shop];
}

class UpdateBalanceEvent extends ShopEvent {
  final double newBalance;
  final String shopName;
  final String phone;

  UpdateBalanceEvent({
    required this.newBalance,
    required this.shopName,
    required this.phone,
  });

  @override
  List<Object> get props => [newBalance, shopName, phone];
}
