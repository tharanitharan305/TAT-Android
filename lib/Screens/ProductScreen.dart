import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:google_fonts/google_fonts.dart";
import "package:tat/Screens/splashScreen.dart";
import "../Firebase/NewOrder.dart";
import "../Products/model/Product.dart";
import "../OrderScreen/model/Orders.dart";
import "../companies/comapnies.dart";

class ProductScreen extends StatefulWidget {
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Set<String> companies = {};
  List<Product> products = [];
  String company = "--select--";
  bool setup = false;
  void setProducts(String company) async {
    List<Product> p = await NewOrder().getProductByCompany(company);
    setState(() {
      products = p;
    });
    print("hai");
    print(p.length);
  }

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
      width: MediaQuery.of(context).size.width * 0.90,
      child: Card(
        child: Column(
          children: [
            Text(
              o.productName,
              style: GoogleFonts.lexend(),
            ),
            SizedBox(
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

  Widget productList(BuildContext context) {
    if (products.length <= 0) {
      return Text("NO PRODUCTS IN $company");
    } else {
      return Column(
        children: [...products.map((e) => productCard(e, context))],
      );
    }
  }

  Widget dropCompanies() {
    if (companies.length <= 0)
      return Row(
        children: [
          Text("Waiting for company list..."),
          SizedBox(
            width: 10,
          ),
          CircularProgressIndicator()
        ],
      );
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
            setProducts(company);
          });
        });
  }

  Widget build(context) {
    if (setup) {
      print(companies);
      return Scaffold(
        appBar: AppBar(
          title: Text("Products"),
        ),
        body: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                dropCompanies(),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: SingleChildScrollView(child: productList(context)))
              ],
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: SplashScreen(),
      );
    }
  }
}
