import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:get/get.dart";
import "package:get/get_core/src/get_main.dart";
import "package:google_fonts/google_fonts.dart";
import "package:tat/Products/Widgets/Product_Getter.dart";
import "package:tat/Products/bloc/Product_bloc.dart";
import "package:tat/Screens/splashScreen.dart";
import "../../Firebase/NewOrder.dart";
import "../model/Product.dart";
import "../../OrderScreen/model/Orders.dart";
import "../../companies/comapnies.dart";

class ProductScreen extends StatefulWidget {
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Set<String> companies = {};
 // List<Product> products = [];
  String company = "--select--";
  bool setup = false;
  // void setProducts(String company) async {
  //   List<Product> p = await NewOrder().getProductByCompany(company);
  //   setState(() {
  //     products = p;
  //   });
  //   print("hai");
  //   print(p.length);
  // }

  SetCompany() async {
    final tempCom = await Companies().GetCompany();
    setState(() {
      companies = tempCom;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SetCompany();
    setState(() {
      setup = true;
    });
  }

  void dispose() {
    super.dispose();
  }

  Widget productCard(Product o, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  o.productName,
                  style: GoogleFonts.lexend(),
                ),
                IconButton(onPressed: (){
                  Get.to( ProductGetter(product: o,));

                }, icon: Icon(Icons.edit))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("MRP : ${o.mrp}"),
                Spacer(),
                Text("S.p : ${o.sPrice}")
              ],
            )
          ],
        ),
      ),
    );
  }
  showSearchText() {
    return TextFormField(
      decoration: InputDecoration(
          suffixIcon: Icon(Icons.search_rounded),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      onChanged: (value) {
        context.read<ProductBloc>().add(SortForTextEvent(searchText: value));
      },
    );
  }
  Widget productList(BuildContext context,List<Product> products) {
    if (products.isEmpty) {
      return Text("NO PRODUCTS IN $company");
    } else {
      return Column(
        children: [
          showSearchText(),
          SizedBox(height: 10,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [...products.map((e) => productCard(e, context))],
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget dropCompanies() {
    if (companies.length <= 0) {
      return const Row(
        children: [
          Text("Waiting for company list..."),
          SizedBox(
            width: 10,
          ),
          CircularProgressIndicator()
        ],
      );
    }
    return DropdownButton(
        elevation: 50,
        autofocus: true,
        dropdownColor: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        value: company,
        items: companies
            .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                  key: UniqueKey(),
                ))
            .toList(),
        onChanged: (companySelected) {
          setState(() {
            company = companySelected!;

          });
          context.read<ProductBloc>().add(FetchProductEvent(company: company));
        });
  }

  Widget build(context) {
    if (setup) {
      print(companies);
      return Scaffold(
        appBar: AppBar(actions: [dropCompanies()],
          title: Text("Products"),
        ),
        body: BlocBuilder<ProductBloc,ProductState>(builder: (context, state) {
          if(state is ProductLoading){
            return SpinKitThreeBounce(color: Colors.amber,size: 20,);
          }
          else if(state is ProductListReady){
              return Center(child: productList(context, state.product_list));
          }
          return const Center(child: Text("select any Company"),);
        },)
      );
    } else {
      return Center(
        child: SplashScreen(),
      );
    }
  }
}
