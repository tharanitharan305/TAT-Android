import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../../Products/model/Product.dart';

class Order {
  Order({
    required this.product,
    required this.free,
    required this.qty,
  }) {
    qtyController = TextEditingController(text: qty.toString());
  }

  double qty;
  double free;
  Product product;
  late TextEditingController qtyController;
  setProduct(Product newProduct) {
    this.product = newProduct;
  }

  setFree(double free) {
    this.free = free;
  }

  setQuantity(double qty) {
    this.qty = qty;
  }

  @override
  String toString() {
    return "${product.toString()}-$qty-$free";
  }

  Order copyWith({
    Product? product,
    double? qty,
    double? free,
  }) {
    return Order(
      product: product ?? this.product,
      qty: qty ?? this.qty,
      free: free ?? this.free,
    );
  }

  Map<String, dynamic> toMap() {
    return {...product.toMap(), 'qty': qty, 'free': free};
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    log("from Order from Map");
    print(map.values);
    log(map.length.toString());
    return Order(
      product: Product.fromMap(map), // Convert nested product data
      qty: (map['qty'] ?? 0.0).toDouble(),
      free: (map['free'] ?? 0.0).toDouble(),
    );
  }
}
