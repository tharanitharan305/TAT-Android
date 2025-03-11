import 'dart:developer';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tat/Beat/bloc/BeatBloc.dart' as beat;
import 'package:tat/Firebase/NewOrder.dart';
import 'package:tat/Firebase/bloc/FirebaseBloc.dart';
import 'package:tat/OrderScreen/bloc/order_bloc.dart';
import 'package:tat/Products/bloc/Product_bloc.dart';
import 'package:tat/Screens/splashScreen.dart';
import 'package:tat/Beat/Areas.dart';
import 'package:tat/Shop/bloc/ShopBloc.dart';
import 'package:tat/Widgets/Dropdowntat.dart';
import 'package:tat/Widgets/OrderPreview.dart';
import 'package:tat/OrderScreen/model/Orders.dart';
import 'package:tat/Shop/Shops.dart';
import 'package:tat/companies/bloc/companyBloc.dart';
import 'package:tat/companies/comapnies.dart';

import '../Products/model/Product.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  txtStyle() => TextStyle(fontWeight: FontWeight.bold);
  getOrderBloc(context) => context.read<OrderBloc>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (context.read<beat.BeatBloc>().beat_List.isEmpty) {
      context.read<beat.BeatBloc>().add(beat.FetchBeatEvent());
    }
    fetchAndSetupCompanies();
  }

  uploadToFirebase(
    List<Order> orders,
    BuildContext context,
    Shop shop,
    String location,
  ) {
    log("In Order upload to Firebase");
    context.read<OrderBloc>().add(OrderSubmitEvent(
        location: location, shop: shop, orders: orders, context: context));
    Navigator.pop(context);
  }

  Future<void> fetchAndSetupCompanies() async {
    final companyBloc = context.read<CompanyBloc>();

    if (companyBloc.company_List.isEmpty) {
      // Wait for the company list to be fetched
      await Future.delayed(
          Duration(milliseconds: 500)); // Small delay for stability
      companyBloc.add(FetchCompanyEvent());

      // Listen for CompanyBloc updates
      companyBloc.stream.listen((state) {
        if (state is CompanyFetchSucess) {
          log("✅ Company fetch successful. Setting up orders...");
          context
              .read<OrderBloc>()
              .add(SetUpOverAllOrder(company: state.company_set.toList()));
        }
      });
    }
  }

  Widget _productViewCard(Order order) {
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
                Text("FREE: ${order.free.toInt()}, "),
                if (order.qty > 0)
                  Text("Dis: ${order.product.discound.toInt()}, "),
                Flexible(child: Text("QTY: ${order.qty}")),
                if (order.qty > 0)
                  IconButton(
                      onPressed: () {
                        final freeController =
                            TextEditingController(text: 0.toString());
                        final spController = TextEditingController(
                            text: order.product.sPrice.toString());
                        double discont() =>
                            ((double.parse(spController.value.text) -
                                    order.product.sPrice) /
                                order.product.sPrice) *
                            100;
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.20,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                          hintText: "FREE"),
                                      controller: freeController,
                                      keyboardType: TextInputType.number,
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                          hintText: "Selling Price"),
                                      controller: spController,
                                      keyboardType: TextInputType.number,
                                    ),
                                    Text(
                                        "DISCOUND: ${(discont() * -1).toInt()}%")
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      final sp =
                                          double.parse(spController.value.text);
                                      final free = double.parse(
                                          freeController.value.text);
                                      if (sp > 0 &&
                                          order.product.sPrice != sp) {
                                        context.read<OrderBloc>().add(
                                            UpdateSellingPriceEvent(
                                                product: order,
                                                sp: sp,
                                                dis: discont()));
                                      }
                                      if (free > 0 && order.free != free) {
                                        context.read<OrderBloc>().add(
                                            UpdateFreeEvent(
                                                product: order, free: free));
                                      }

                                      Navigator.pop(context);
                                    },
                                    child: const Text("change")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("cancel"))
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.change_circle_rounded)),
              ],
            ),
            TextField(
              controller: order.qtyController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Quantity',
                hintText: 'Enter quantity',
                suffixText: order.product.unit,
              ),
              onChanged: (value) {
                final quantity = double.tryParse(value);
                if (quantity != null && quantity >= 1) {
                  context.read<OrderBloc>().add(UpdateQuantityEvent(
                      product: order, qty: quantity.toString()));
                  setState(() {});
                }
              },
            )
          ],
        ),
      ),
    );
  }

  beatShow() {
    return BlocBuilder<beat.BeatBloc, beat.BeatState>(
      builder: (context, state) {
        final bloc = context.read<beat.BeatBloc>();
        if (state is beat.BeatLoading) {
          return CircularProgressIndicator();
        } else if (state is beat.BeatLoadComplete) {
          return DropdownTat(
              dropdownValue: bloc.beat,
              set: bloc.beat_List,
              onChanged: (value) {
                log(bloc.beat);
                bloc.add(beat.UpdateBeatEvent(beat: value!));
                setState(() {});
                Future.delayed(
                  Duration.zero,
                  () => initiateShopBloc(bloc.beat),
                );
              });
        } else if (state is beat.BeatFetchError) {
          return Center(
            child: Text(state.message),
          );
        }
        return Text("$state");
      },
    );
  }

  initiateShopBloc(String location) {
    context.read<ShopBloc>().add(FetchShopsEvent(location: location));
  }

  initiateCompanyBloc(String company) {
    context.read<OrderBloc>().add(UpdateOrderList(company: company));
    log("in inicompany");
    print(context.read<OrderBloc>().ordered_set);
  }

  showShop() {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        final bloc = context.read<ShopBloc>();
        if (state is ShopLoading) {
          return CircularProgressIndicator();
        } else if (state is ShopLoadComplete) {
          log(bloc.shop_List.length.toString());
          return DropdownTatShop(
              dropdownValue: bloc.shopName,
              set: bloc.shop_List,
              onChanged: (value) {
                bloc.add(UpdateShopEvent(shop: value!));
                setState(() {});
              });
        } else if (state is ShopFetchError) {
          return Center(
            child: Text(state.message),
          );
        }
        return const Center(
          child: Text("SELECT THE BEAT"),
        );
      },
    );
  }

  showCompanies() {
    return BlocBuilder<CompanyBloc, CompanyState>(
      builder: (context, state) {
        final bloc = context.read<CompanyBloc>();
        if (state is CompanyLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CompanyFetchSucess) {
          return DropdownTat(
              dropdownValue: bloc.company,
              set: state.company_set,
              onChanged: (value) {
                bloc.add(UpdateCompanyEvent(company: value!));
                initiateCompanyBloc(value);
                setState(() {});
              });
        }
        return Text("Company State $state");
      },
    );
  }

  showSearchText() {
    return TextFormField(
      decoration: InputDecoration(
          suffixIcon: Icon(Icons.search_rounded),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      onChanged: (value) {
        context.read<OrderBloc>().add(OnSearchBarActivated(searchText: value));
      },
    );
  }

  showProduct() {
    log("in showProduct");
    return BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      final bloc = context.read<OrderBloc>();
      List<Order> orderList = [];
      if (state is OrderSucess) {
        orderList = state.orders.toList();
      }
      if (state is OrderSucessOnFire) {
        return const Center(child: Text("Order sucess"));
      }
      if (state is OrderError) {
        return Center(child: Text(state.message));
      }
      if (orderList.isNotEmpty) {
        return Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              ...orderList
                  .map(
                    (e) => _productViewCard(e),
                  )
                  .toList()
            ],
          ),
        ));
      }
      return const Center(
        child: Text("No Products Available in this Company "),
      );
    });
  }

  buildUi() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Flexible(
                    child: Text(
                  "SHOP NAME :  ",
                  style: txtStyle(),
                )),
                showShop()
              ],
            ),
          ),
          Row(
            children: [
              Text(
                "COMPANY :  ",
                style: txtStyle(),
              ),
              showCompanies()
            ],
          ),
          showSearchText(),
          showProduct()
        ],
      ),
    );
  }

  getLocatoion() => context.read<beat.BeatBloc>().beat;
  getShopBloc() => context.read<ShopBloc>().shop;
  getOdredList() => context.read<OrderBloc>().ordered_set;
  Widget build(context) {
    //final bloc = context.read<OrderBloc>();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: (getLocatoion() == "--select--" || getShopBloc() == null)
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (context) => OrderPreview(
                        context: context,
                        orders: getOdredList().toList(),
                        shop: getShopBloc(),
                        location: getLocatoion(),
                        upload: uploadToFirebase,
                      ),
                    );
                  },
            child: const Icon(Icons.shopping_cart_checkout_rounded)),
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            actions: [
              Text(
                "BEAT:  ",
                style: txtStyle(),
              ),
              beatShow()
            ]),
        body: buildUi());
  }
}
