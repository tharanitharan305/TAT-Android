// part of 'ShopBloc.dart';
//
// @immutable
// sealed class ShopState extends Equatable {
//   @override
//   List<Object> get props => [];
// }
//
// class ShopLoading extends ShopState {}
//
// class ShopFetchSucess extends ShopState {
//   Set<Shop> shop_set;
//   ShopFetchSucess({required this.shop_set});
// }
//
// class ShopLoadComplete extends ShopState {}
//
// class ShopFetchError extends ShopState {
//   String message;
//   ShopFetchError({required this.message});
// }
part of 'ShopBloc.dart';



@immutable
sealed class ShopState extends Equatable {
  @override
  List<Object> get props => [];
}

class ShopLoading extends ShopState {}

class ShopFetchSuccess extends ShopState {
  final Set<Shop> shopList;
  ShopFetchSuccess({required this.shopList});

  @override
  List<Object> get props => [shopList];
}

class ShopFetchError extends ShopState {
  final String message;
  ShopFetchError({required this.message});

  @override
  List<Object> get props => [message];
}

class ShopLoadComplete extends ShopState {}

class LocationFetchSuccess extends ShopState {
  final Set<String> locations;
  LocationFetchSuccess({required this.locations});

  @override
  List<Object> get props => [locations];
}

class LocationSelected extends ShopState {
  final String location;
  LocationSelected({required this.location});

  @override
  List<Object> get props => [location];
}

class ShopSelected extends ShopState {
  final Shop shop;
  ShopSelected({required this.shop});

  @override
  List<Object> get props => [shop];
}

class BalanceUpdated extends ShopState {}

