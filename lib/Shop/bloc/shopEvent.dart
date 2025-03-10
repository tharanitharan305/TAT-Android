part of 'ShopBloc.dart';

@immutable
sealed class ShopEvent extends Equatable {
  List<Object> get props => [];
}

class FetchShopsEvent extends ShopEvent {
  String location;
  FetchShopsEvent({required this.location});
}

class UpdateShopEvent extends ShopEvent {
  String shop;
  UpdateShopEvent({required this.shop});
}
