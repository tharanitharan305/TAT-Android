import 'package:tat/Widgets/Elite.dart';
import 'package:tat/Widgets/Tata.dart';
import 'package:tat/Widgets/Unibic.dart';
import 'package:tat/Widgets/comapnies.dart';

import 'Orders.dart';

class OrderFormat {
  Set<Orders> getCompany(companies company) {
    Set<Orders> products;
    switch (company) {
      case companies.Elite:
        products = Elite().products;
        break;
      case companies.Tata:
        products = Tata().products;
        break;
      case companies.Unibic:
        products = Unibic().products;
        break;
    }

    return products;
  }

  List<Orders> getasOrder(Set<String> product) {
    List<Orders>? Order;
    for (int i = 0; i < product.length; i++) {
      Order!.add(Orders(Products: product.elementAt(i), Quantity: '0'));
    }
    return Order!;
  }

  filterOrder(Set<Orders> order) {
    var filterOrders = order.map((e) {
      if (e.Quantity != '0') return e;
    }).toSet();
    print(filterOrders.map((e) => "${e!.Products} ${e.Quantity}"));
    return filterOrder;
  }
}
