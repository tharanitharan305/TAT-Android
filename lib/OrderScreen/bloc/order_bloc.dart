import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tat/Firebase/NewOrder.dart';
import 'package:tat/Firebase/bloc/FirebaseBloc.dart';
import 'package:tat/Firebase/models/OrderFormat.dart';
import 'package:tat/Widgets/DateTime.dart';
import 'package:tat/companies/comapnies.dart';
import 'package:uuid/uuid.dart';

import '../../Products/model/Product.dart';
import '../../Beat/Areas.dart';
import '../model/Orders.dart';
import '../../Shop/Shops.dart';
part 'order_state.dart';
part 'order_event.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  Set<String> beat_set = {};
  Set<Shop> shop_set = {};
  Set<Product> product_set = {};
  Shop? current_shop;
  String current_beat = "--select--";
  List<Order> order_set = [];
  Set<Order> ordered_set = {};
  Map<String, List<Order>> overAllList = {};
  bool ordering = false;
  final FirebaseBloc firebaseBloc;
  late StreamSubscription firebaseSubscription;
  OrderBloc({required this.firebaseBloc}) : super(OrderLoading()) {
    firebaseSubscription = firebaseBloc.stream.listen((state) {
      log("entered the firebaseBloc steam");
      if (state is FirebaseSucess) {
        log("order sucerr");
        add(OrderAddedSucessEvent());
      }
      if (state is FirebaseOrderUploadError) {
        add(OrderFailedEvent(message: state.message));
      }
      log(state.toString());
    });
    on<UpdateQuantityEvent>(_onUpdateqtyEvent);
    on<UpdateOrderList>(_onUpdateOrderSet);
    on<SetUpOverAllOrder>(_onSetUpOverAllOrder);
    on<UpdateSellingPriceEvent>(_onUpdateSellingPriceEvent);
    on<UpdateFreeEvent>(_onUpdateFreeEvent);
    on<OrderSubmitEvent>(_onOrderSubmitEvent);
    on<OrderFailedEvent>(
        (event, emit) => emit(OrderError(message: event.message)));
    on<OrderAddedSucessEvent>(_onOrderSucessOnFireEvent);
    on<OnSearchBarActivated>(_onSearchBarActivated);
  }
  _onUpdateqtyEvent(UpdateQuantityEvent event, Emitter<OrderState> emit) {
    event.product.setQuantity(double.parse(event.qty));
    ordered_set.add(event.product);
    //emit(OrderSucess(orders: List.from(ordered_set)));
  }

  _onUpdateOrderSet(UpdateOrderList event, Emitter emit) {
    emit(OrderLoading());
    log(overAllList.length.toString());
    order_set = List.from(overAllList[event.company]!);
    if (ordered_set.isNotEmpty) {
      log("adding list");
      for (int i = 0; i < ordered_set.length; i++) {
        order_set.remove(ordered_set.toList()[i]);
      }
      order_set = [...ordered_set, ...order_set];
    }
    emit(OrderSucess(orders: order_set));
    log("emitted Order Sucess with ${order_set.length}");
  }

  _onSetUpOverAllOrder(
      SetUpOverAllOrder event, Emitter<OrderState> emit) async {
    for (int i = 0; i < event.company.length; i++) {
      final list = await NewOrder().getProductByCompany(event.company[i]);
      final olist =
          list.map((e) => Order(product: e, free: 0, qty: 0)).toList();
      overAllList.putIfAbsent(event.company[i], () => olist);
    }
    log("setUp finished${overAllList.length}+${event.company.length}");
  }

  _onUpdateFreeEvent(UpdateFreeEvent event, Emitter<OrderState> emit) {
    emit(OrderLoading());
    event.product.setFree(event.free);
    emit(OrderSucess(orders: List.from(ordered_set)));
  }

  _onUpdateSellingPriceEvent(
      UpdateSellingPriceEvent event, Emitter<OrderState> emit) {
    emit(OrderLoading());
    final pro1 = event.product.product;
    final pro2 = pro1.copyWith(sPrice: event.sp, discound: event.dis * -1);
    event.product.setProduct(pro2);
    emit(OrderSucess(orders: List.from(order_set)));
  }

  _onOrderSubmitEvent(OrderSubmitEvent event, Emitter<OrderState> emit) {
    emit(OrderLoading());
    log("In OrderBloc : Started OrderSubmit Event SucessFully");
    FirebaseOrder order;
    double _total = 0.0;
    // List<Map<String, dynamic>> orderMap = [];
    // for (int i = 0; i < event.orders.length; i++) {
    //   _total += (event.orders[i].qty * event.orders[i].product.sPrice);
    //   Map<String, dynamic> map = event.orders[i].toMap();
    //   orderMap.add(map);
    // }

    order = FirebaseOrder(
        user: event.context.read<FirebaseBloc>().user!,
        orders: event.orders,
        shop: event.shop,
        beat: event.location,
        total: _total,
        uid: const Uuid().v4(),
        date: DateTimeTat().GetDate());
    log("In OrderBloc:Orders ParsedInto FirebaseOrder Sucessfully and now sending the object to Firebase blod");
    event.context
        .read<FirebaseBloc>()
        .add(AddOrderToFirebaseEvent(order: order));
  }

  _onOrderSucessOnFireEvent(
      OrderAddedSucessEvent event, Emitter<OrderState> emit) {
    ordered_set.clear();
    order_set.clear();
    log("In OrderBloc:Ordered_set and Order_set were cleared sucessfully");
    emit(OrderSucessOnFire());
  }

  _onSearchBarActivated(OnSearchBarActivated event, Emitter<OrderState> emit) {
    emit(OrderLoading());
    order_set.sort(
      (a, b) {
        String searchText = event.searchText.toLowerCase();
        int indexA = a.product.productName.toLowerCase().indexOf(searchText);
        int indexB = b.product.productName.toLowerCase().indexOf(searchText);
        if (indexA != -1 && indexB != -1) {
          return indexA.compareTo(indexB);
        }

        if (indexA != -1) return -1;
        if (indexB != -1) return 1;
        return 0;
      },
    );
    emit(OrderSucess(orders: order_set));
  }

  @override
  Future<void> close() {
    // TODO: implement close
    firebaseSubscription.cancel();
    return super.close();
  }
}
