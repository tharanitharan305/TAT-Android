import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Widgets/Orders.dart';

class NewOrder {
  void putOrder(Set<Orders> order, String ShopName, String Locations) async {
    final user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance.collection(Locations).add({
      'Ordered time': Timestamp.now(),
      'Shopname': ShopName,
      'Ordered by': user.email,
      'Orders': order.map(
        (e) {
          String quantity = e.Quantity.toString();
          if (quantity.endsWith("0")) return null;
          return "${e.Products}-${e.Quantity}";
        },
      ),
    });
  }
}
