import '../OrderScreen/model/Orders.dart';

class OrderFormat {
  List<Order> ViewFormat(List<String> items) {
    List<Order> fromBase = [];
    for (int i = 0; i < items.length - 1; i++) {
      if (items[i] != null) {
        // Order o = Order(
        //     productName: items[i].split("-")[0],
        //     selling_price: items[i].split("-")[1],
        //     mrp: items[i].split("-")[4],
        //     qty: items[i].split("-")[2].toString(),
        //     free: items[i].split("-")[3], );
        // fromBase.add(o);
      }
    }
    return fromBase;
  }
}
