part of 'ShopBloc.dart';

@immutable
sealed class ShopState extends Equatable {
  @override
  List<Object> get props => [];
}

class ShopLoading extends ShopState {}

class ShopFetchSucess extends ShopState {
  Set<Shop> shop_set;
  ShopFetchSucess({required this.shop_set});
}

class ShopLoadComplete extends ShopState {}

class ShopFetchError extends ShopState {
  String message;
  ShopFetchError({required this.message});
}
