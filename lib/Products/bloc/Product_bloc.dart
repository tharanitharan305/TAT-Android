import 'dart:developer' as dev;

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tat/OrderScreen/bloc/order_bloc.dart';
import 'package:tat/companies/bloc/companyBloc.dart';
import 'package:tat/Firebase/NewOrder.dart';
import '../../OrderScreen/model/Orders.dart';
import '../model/Product.dart';

part 'Product_event.dart';
part 'Product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  Product currentProduct = Product(
    sno: 0,
    partNo: "PartNo",
    barcode: "barcode",
    productName: "productName",
    rack: "rack",
    groupName: "groupName",
    company: "--select--",
    commodity: "commodity",
    salesVat: "sales Tax",
    section: "section",
    cPrice: 0.0,
    margin: 0.0,
    mrp: 0.0,
    sPrice: 0.0,
    splPrice: 0.0,
    unit: "pcs",
    weight: 0.0,
    expiryDays: 0,
    godownTax: "Product Tax",
    supplier: "supplier",
    discound: 0.0,
    pPrice: 0.0,
  );
  List<Product> product_list = [];
  ProductBloc() : super(ProductLoading()) {
    on<UpdateProductField>(_onUpdateProductField);
    on<SaveProduct>(_onSaveProduct);
    on<FetchProductEvent>(_onFetchProductEvent);
    on<SortForTextEvent>(_onSortForTextEvent);
    on<FetchProductForOrderEvent>(_onFetchProductForOrderEvent);
  }

  void _onUpdateProductField(
      UpdateProductField event, Emitter<ProductState> emit) {
    //final currentProduct = (state as ProductLoaded).product;
    final updatedProduct = currentProduct.copyWith(
        sno: event.fieldName == "sno" ? event.value : currentProduct.sno,
        partNo:
            event.fieldName == "partNo" ? event.value : currentProduct.partNo,
        barcode:
            event.fieldName == "barcode" ? event.value : currentProduct.barcode,
        productName: event.fieldName == "productName"
            ? event.value
            : currentProduct.productName,
        rack: event.fieldName == "rack" ? event.value : currentProduct.rack,
        groupName: event.fieldName == "groupName"
            ? event.value
            : currentProduct.groupName,
        company:
            event.fieldName == "company" ? event.value : currentProduct.company,
        commodity: event.fieldName == "commodity"
            ? event.value
            : currentProduct.commodity,
        salesVat: event.fieldName == "salesVat"
            ? event.value
            : currentProduct.salesVat,
        section:
            event.fieldName == "section" ? event.value : currentProduct.section,
        cPrice: event.fieldName == "cPrice"
            ? double.parse(event.value)
            : currentProduct.cPrice,
        margin: event.fieldName == "margin"
            ? double.parse(event.value)
            : currentProduct.margin,
        mrp: event.fieldName == "mrp"
            ? double.parse(event.value)
            : currentProduct.mrp,
        sPrice: event.fieldName == "sPrice"
            ? double.parse(event.value)
            : currentProduct.sPrice,
        splPrice: event.fieldName == "splPrice"
            ? double.parse(event.value)
            : currentProduct.splPrice,
        unit: event.fieldName == "unit" ? event.value : currentProduct.unit,
        weight: event.fieldName == "weight"
            ? double.parse(event.value)
            : currentProduct.weight,
        expiryDays: event.fieldName == "expiryDays"
            ? int.parse(event.value)
            : currentProduct.expiryDays,
        godownTax: event.fieldName == "godownTax"
            ? event.value
            : currentProduct.godownTax,
        supplier: event.fieldName == "supplier"
            ? event.value
            : currentProduct.supplier,
        discound: event.fieldName == "discound"
            ? event.value
            : currentProduct.discound,
        pPrice:
            event.fieldName == "pPrice" ? event.value : currentProduct.pPrice);
    currentProduct = updatedProduct;
    // dev.log("updated ${event.fieldName} ${updatedProduct.toString()}");
    emit(ProductLoaded());
  }

  void _onSaveProduct(SaveProduct event, Emitter<ProductState> emit) {
    dev.log(event.product.toString());
  }

  _onFetchProductEvent(
      FetchProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final temp = await NewOrder().getProductByCompany(event.company);
      product_list = temp;
      dev.log("in fetch Product");
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
    dev.log("In ProductBloc: ProductFetch Sucess for ${event.company} With ${product_list.length} ");
    emit(ProductListReady(product_list: product_list));
  }

  _onSortForTextEvent(SortForTextEvent event, Emitter<ProductState> emit) {
    emit(ProductLoading());
    product_list.sort((a, b) {
      String searchText = event.searchText.toLowerCase();
      int indexA = a.productName.toLowerCase().indexOf(searchText);
      int indexB = b.productName.toLowerCase().indexOf(searchText);
      if (indexA != -1 && indexB != -1) {
        return indexA.compareTo(indexB);
      }

      if (indexA != -1) return -1;
      if (indexB != -1) return 1;
      return 0;
    });
    emit(ProductListReady(product_list: product_list));
  }

  _onFetchProductForOrderEvent(
      FetchProductForOrderEvent event, Emitter<ProductState> emit) async {
    // if (state is ProductListReady) {
    //   List<Order> orderSet = [
    //     ...(state as ProductListReady).product_list.map((e) {
    //       return Order(product: e, free: 0, qty: 0);
    //     })
    //   ];
    //   event.context.read<OrderBloc>().add(UpdateOrderList(orderSet: orderSet));
    // } else {
    //   try {
    //     final temp = await NewOrder().getProductByCompany(event.company);
    //     product_list = temp;
    //     dev.log("in fetch Product");
    //   } catch (e) {
    //     emit(ProductError(message: e.toString()));
    //   }
    //   List<Order> orderSet = [
    //     ...product_list.map((e) {
    //       return Order(product: e, free: 0, qty: 0);
    //     })
    //   ];
    //   event.context.read<OrderBloc>().add(UpdateOrderList(orderSet: orderSet));
    // }
  }
}
