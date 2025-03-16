// import 'dart:developer';
//
// import 'package:equatable/equatable.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tat/Beat/Areas.dart';
//
// import '../Shops.dart';
//
// part 'shopEvent.dart';
// part 'ShopState.dart';
//
// class ShopBloc extends Bloc<ShopEvent, ShopState> {
//   String shopName = "--select--";
//   Set<Shop> shop_List = {};
//   Shop? shop;
//   ShopBloc() : super(ShopLoading()) {
//     on<FetchShopsEvent>(_onFetchShopEvent);
//     on<UpdateShopEvent>(_onUpdateShopEvent);
//   }
//   _onFetchShopEvent(FetchShopsEvent event, Emitter<ShopState> emit) async {
//     log("hai");
//     emit(ShopLoading());
//     try {
//       final temp = await getShop(event.location);
//       shop_List = {};
//       shopName = "--select--";
//       shop_List = temp;
//     } catch (e) {
//       emit(ShopFetchError(message: e.toString()));
//     }
//     emit(ShopLoadComplete());
//     log("complete");
//   }
//
//   _onUpdateShopEvent(UpdateShopEvent event, Emitter<ShopState> emit) {
//     emit(ShopLoading());
//     for (int i = 0; i < shop_List.length; i++) {
//       final x = shop_List.toList()[i];
//       if (x.name == event.shop) {
//         shop = x;
//         shopName = x.name;
//         break;
//       }
//     }
//     emit(ShopLoadComplete());
//   }
// }
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tat/Beat/Areas.dart';
import 'package:tat/Firebase/NewOrder.dart';
import '../Shops.dart';

part 'shopEvent.dart';
part 'ShopState.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  String shopName = "--select--";
  Set<Shop> shopList = {};
  Set<String> locations = {};
  Shop? selectedShop;
  String selectedLocation = "--select--";

  ShopBloc() : super(ShopLoading()) {
    on<FetchShopsEvent>(_onFetchShopEvent);
    on<UpdateShopEvent>(_onUpdateShopEvent);
    on<FetchLocationsEvent>(_onFetchLocationsEvent);
    on<SelectLocationEvent>(_onSelectLocationEvent);
    on<SelectShopEvent>(_onSelectShopEvent);
    on<UpdateBalanceEvent>(_onUpdateBalanceEvent);
  }

  Future<void> _onFetchShopEvent(FetchShopsEvent event, Emitter<ShopState> emit) async {
    emit(ShopLoading());
    try {
      final temp = await getShop(event.location);
      shopList = {Shop("Shop name", 0, 0, "", "", "", "", "", "", "", ""), ...temp};
      shopName = "--select--";
      emit(ShopFetchSuccess(shopList: shopList));
    } catch (e) {
      emit(ShopFetchError(message: e.toString()));
    }
  }

  Future<void> _onFetchLocationsEvent(FetchLocationsEvent event, Emitter<ShopState> emit) async {
    try {
      final tempLocations = await Areas().GetLocations();
      locations = tempLocations;
      emit(LocationFetchSuccess(locations: locations));
    } catch (e) {
      emit(ShopFetchError(message: e.toString()));
    }
  }

  void _onSelectLocationEvent(SelectLocationEvent event, Emitter<ShopState> emit) {
    selectedLocation = event.location;
    emit(LocationSelected(location: selectedLocation));
    add(FetchShopsEvent(location: selectedLocation));
  }

  void _onSelectShopEvent(SelectShopEvent event, Emitter<ShopState> emit) {
    selectedShop = event.shop;
    shopName = selectedShop!.name;
    emit(ShopSelected(shop: selectedShop!));
  }

  void _onUpdateShopEvent(UpdateShopEvent event, Emitter<ShopState> emit) {
    for (var x in shopList) {
      if (x.name == event.shop) {
        selectedShop = x;
        shopName = x.name;
        break;
      }
    }
  }

  Future<void> _onUpdateBalanceEvent(UpdateBalanceEvent event, Emitter<ShopState> emit) async {
    try {
       NewOrder().updateBalance(event.newBalance, selectedLocation, event.shopName, event.phone);
      emit(BalanceUpdated());
    } catch (e) {
      emit(ShopFetchError(message: e.toString()));
    }
  }
}
