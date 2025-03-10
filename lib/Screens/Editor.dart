import 'package:flutter/material.dart';

import '../Shop/Shops.dart';
import '../Widgets/OrderPreview.dart';
import '../OrderScreen/model/Orders.dart';
import '../OrderScreen/OrderScreen.dart';

class OrderEditor extends StatefulWidget {
  OrderEditor(
      {super.key,
      required this.productList,
      required this.shop,
      required this.area,
      required this.context,
      required this.upload});
  Set<Order> productList;
  Shop shop;
  String area;
  BuildContext context;
  final Function(List<Order>, BuildContext, Shop, String) upload;
  @override
  State<OrderEditor> createState() => _OrderEditorState();
}

class _OrderEditorState extends State<OrderEditor> {
  Set<Order> _changed = {};
  _changeButtonOnPressed(Order order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  _changeFree(order);
                },
                child: Text("Free")),
            TextButton(
                onPressed: () {
                  _changeSellingPrice(order);
                },
                child: Text("Selling Price"))
          ],
        );
      },
    );
  }

  _changeFree(Order order) {
    Navigator.pop(context);
    final key = GlobalKey<FormState>();
    double free = 0;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("ADDING FREE.."),
          content: Form(
            key: key,
            child: TextFormField(
              onSaved: (value) {
                setState(() {
                  free = double.parse(value!);
                });
              },
              validator: (value) {
                if (value == null) return "Enter Free value ";
                try {
                  int.parse(value);
                } catch (e) {
                  return "Enter a Number";
                }
                if (int.parse(value) > 100) return "There is a limit";
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (key.currentState!.validate()) {
                    key.currentState!.save();
                    order.setFree(free);
                    Navigator.pop(context);
                  }
                },
                child: const Text("ADD"))
          ],
        );
      },
    );
  }

  _changeSellingPrice(Order order) {
    Navigator.pop(context);
    final key = GlobalKey<FormState>();
    double sp = 0;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Changing SP"),
          content: Form(
            key: key,
            child: TextFormField(
              onSaved: (value) {
                setState(() {
                  sp = double.parse(value!);
                });
              },
              validator: (value) {
                if (value == null) return "Enter SP value ";
                try {
                  int.parse(value);
                } catch (e) {
                  return "Enter a Number";
                }
                if (int.parse(value) <= 0) return "There is a limit";
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (key.currentState!.validate()) {
                    key.currentState!.save();
                    order.setProduct(order.product.copyWith(sPrice: sp));
                    Navigator.pop(context);
                  }
                },
                child: const Text("Change"))
          ],
        );
      },
    );
  }

  _onQuantityChanged(
      value, TextEditingController _quantityTextController, Order order) {
    if (value! != null) {
      try {
        print(value.runtimeType);
        double.parse(value);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("ENTER A NUMBER"),
          ),
        );
        _quantityTextController.clear();
      }
    }
    if (double.parse(value) >= 0) {
      order.setQuantity(double.parse(value));
      setState(() {
        //_changed.add(order);
      });
    }
  }

  Widget _productViewCard(Order order) {
    final _quantityTextController =
        TextEditingController(text: order.qty.toString());
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(order.product.productName),
            Row(
              children: [
                Text("S.P: ${order.product.sPrice.toString()}, "),
                Text("MRP:${order.product.mrp.toString()}, "),
                Text("FREE: ${order.free}, "),
                Flexible(child: Text("QTY: ${order.qty}")),
                if (order.qty > 0)
                  IconButton(
                      onPressed: () {
                        _changeButtonOnPressed(order);
                      },
                      icon: const Icon(Icons.change_circle_rounded)),
              ],
            ),
            TextField(
              controller: order.qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Quantity"),
              onChanged: (value) {
                _onQuantityChanged(value, _quantityTextController, order);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _productListView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...widget.productList.map(
            (e) {
              return _productViewCard(e);
            },
          ).toList()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("EDITOR"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _productListView(),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.arrow_circle_up_rounded),
          onPressed: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => OrderPreview(
                context: widget.context,
                orders: widget.productList.toList(),
                shop: widget.shop,
                location: '',
                upload: widget.upload,
              ),
            );
            // NewOrder().putOrder(_selectedOrderSet, _shopName, _area, "");
          },
        ),
      ),
    );
  }
}
