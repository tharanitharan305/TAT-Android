import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tat/Beat/Areas.dart';

import '../Shops.dart';

part 'shopEvent.dart';
part 'ShopState.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  String shopName = "--select--";
  Set<Shop> shop_List = {};
  Shop? shop;
  ShopBloc() : super(ShopLoading()) {
    on<FetchShopsEvent>(_onFetchShopEvent);
    on<UpdateShopEvent>(_onUpdateShopEvent);
  }
  _onFetchShopEvent(FetchShopsEvent event, Emitter<ShopState> emit) async {
    log("hai");
    emit(ShopLoading());
    try {
      final temp = await getShop(event.location);
      shop_List = {};
      shopName = "--select--";
      shop_List = temp;
    } catch (e) {
      emit(ShopFetchError(message: e.toString()));
    }
    emit(ShopLoadComplete());
    log("complete");
  }

  _onUpdateShopEvent(UpdateShopEvent event, Emitter<ShopState> emit) {
    emit(ShopLoading());
    for (int i = 0; i < shop_List.length; i++) {
      final x = shop_List.toList()[i];
      if (x.name == event.shop) {
        shop = x;
        shopName = x.name;
        break;
      }
    }
    emit(ShopLoadComplete());
  }
}
