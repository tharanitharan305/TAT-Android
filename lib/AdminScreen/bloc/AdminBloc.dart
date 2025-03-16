import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tat/Firebase/bloc/FirebaseBloc.dart';
import 'package:tat/Firebase/models/OrderFormat.dart';
import 'package:tat/Widgets/DateTime.dart';

part 'AdminEvent.dart';
part 'AdminState.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  FirebaseBloc firebaseBloc;
  String date = DateTimeTat().GetDate();
  late StreamSubscription firebaseSubscription;
  AdminBloc({required this.firebaseBloc}) : super(OrderLoading()) {
    firebaseSubscription = firebaseBloc.stream.listen(
      (state) {
        if (state is FirebaseLoading) {
          add(FirebaseEventLoading());
        }
        if (state is FirebaseError) {
          log("Error passed to AdminBloc");
          add(FirebaseEventError(message: state.message));
        }
        if (state is FirebaseGotOrders) {
          log("list of orders emitted from admin bloc with length : ${state.order.length}");
          add(ConvertOrderFromFireEvent(order: state.order));
        }
      },
    );
    on<FirebaseEventLoading>(
      (event, emit) => emit(OrderLoading()),
    );
    on<FirebaseEventError>(
      (event, emit) => emit(OrderGotError(message: event.message)),
    );
    on<ConvertOrderFromFireEvent>(
      (event, emit) => emit(OrderGotSucess(orders: event.order)),
    );
    on<UpdateDateEvent>(_onUpdateDateEvent);
    on<FetchListOfOrdersEvent>(_onFetchOrderFromFirebaseEvent);
  }
  _onUpdateDateEvent(UpdateDateEvent event, Emitter<AdminState> emit) {
    date = event.date;
    //AdminBloc(firebaseBloc: firebaseBloc).add(FetchListOfOrdersEvent(beat: ))
  }

  _onFetchOrderFromFirebaseEvent(
      FetchListOfOrdersEvent event, Emitter<AdminState> emit) {
    emit(OrderLoading());
    firebaseBloc.add(GetOrderFromFireBase(beat: event.beat, date: date));
  }
}
