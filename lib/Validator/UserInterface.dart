// // import 'package:flutter/material.dart';
// // import 'package:tat/Screens/Admin.dart';
// // import 'package:tat/OrderScreen/OrderScreen.dart';
// // import 'package:tat/Screens/ProductScreen.dart';
// // import 'package:tat/Screens/ShopScreen.dart';
// // import 'package:tat/Screens/getNew.dart';
// // import 'package:tat/Widgets/UserDrawer.dart';
// //
// // import '../Widgets/getAttendaceSheet.dart';
// // import '../Widgets/internet checker.dart';
// //
// // class UserInterface extends StatefulWidget {
// //   const UserInterface({super.key});
// //
// //   @override
// //   State<UserInterface> createState() {
// //     return _UserInterface();
// //   }
// // }
// //
// // class _UserInterface extends State<UserInterface> {
// //   bool Admin = false;
// //   @override
// //   Widget build(context) {
// //     return SafeArea(
// //       child: Scaffold(
// //         drawer: UserDrawer(),
// //         appBar: AppBar(
// //           backgroundColor: Theme.of(context).colorScheme.background,
// //           actions: [
// //             //InterNetChecker()
// //           ],
// //         ),
// //         body: Container(
// //             width: double.infinity,
// //             decoration: BoxDecoration(
// //               image: const DecorationImage(
// //                 image: AssetImage('images/tatlogo.png'),
// //                 fit: BoxFit.contain,
// //                 opacity: 0.1,
// //               ),
// //               color: Theme.of(context).colorScheme.surface,
// //             ),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 ElevatedButton.icon(
// //                   onPressed: () {
// //                     Navigator.push(context,
// //                         MaterialPageRoute(builder: (context) => AdminScreen()));
// //                   },
// //                   label: const Text('Get Order'),
// //                   style: TextButton.styleFrom(
// //                     alignment: Alignment.centerLeft,
// //                     fixedSize: Size(170, 10),
// //                     padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
// //                     elevation: 10,
// //                     backgroundColor:
// //                         Theme.of(context).colorScheme.primaryContainer,
// //                   ),
// //                   icon: const Icon(Icons.get_app_rounded),
// //                 ),
// //                 const SizedBox(
// //                   height: 10,
// //                 ),
// //                 ElevatedButton.icon(
// //                   onPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (context) => const OrderScreen(),
// //                       ),
// //                     );
// //                   },
// //                   label: const Text('Place Order'),
// //                   style: TextButton.styleFrom(
// //                     alignment: Alignment.center,
// //                     fixedSize: Size(170, 10),
// //                     padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
// //                     elevation: 10,
// //                     backgroundColor:
// //                         Theme.of(context).colorScheme.primaryContainer,
// //                   ),
// //                   icon: const Icon(Icons.add_shopping_cart),
// //                 ),
// //                 const SizedBox(
// //                   height: 10,
// //                 ),
// //                 ElevatedButton.icon(
// //                   onPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (context) => GetNew(),
// //                       ),
// //                     );
// //                   },
// //                   label: const Text('Add'),
// //                   style: TextButton.styleFrom(
// //                     alignment: Alignment.center,
// //                     fixedSize: Size(170, 10),
// //                     padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
// //                     elevation: 10,
// //                     backgroundColor:
// //                         Theme.of(context).colorScheme.primaryContainer,
// //                   ),
// //                   icon: const Icon(Icons.add_business_rounded),
// //                 ),
// //                 const SizedBox(
// //                   height: 10,
// //                 ),
// //                 ElevatedButton.icon(
// //                   onPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (context) => ShopScreen(),
// //                       ),
// //                     );
// //                   },
// //                   label: const Text('Shops'),
// //                   style: TextButton.styleFrom(
// //                     alignment: Alignment.center,
// //                     fixedSize: Size(170, 10),
// //                     padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
// //                     elevation: 10,
// //                     backgroundColor:
// //                         Theme.of(context).colorScheme.primaryContainer,
// //                   ),
// //                   icon: const Icon(Icons.add_business_rounded),
// //                 ),
// //                 const SizedBox(
// //                   height: 10,
// //                 ),
// //                 ElevatedButton.icon(
// //                   onPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (context) => ProductScreen(),
// //                       ),
// //                     );
// //                   },
// //                   label: const Text('Products'),
// //                   style: TextButton.styleFrom(
// //                     alignment: Alignment.center,
// //                     fixedSize: Size(170, 10),
// //                     padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
// //                     elevation: 10,
// //                     backgroundColor:
// //                         Theme.of(context).colorScheme.primaryContainer,
// //                   ),
// //                   icon: const Icon(Icons.fact_check_rounded),
// //                 ),
// //               ],
// //             )),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:tat/Screens/Admin.dart';
// import 'package:tat/OrderScreen/OrderScreen.dart';
// import 'package:tat/Screens/ProductScreen.dart';
// import 'package:tat/Screens/ShopScreen.dart';
// import 'package:tat/Screens/getNew.dart';
// import 'package:tat/Widgets/UserDrawer.dart';
//
// class UserInterface extends StatefulWidget {
//   const UserInterface({super.key});
//
//   @override
//   State<UserInterface> createState() => _UserInterfaceState();
// }
//
// class _UserInterfaceState extends State<UserInterface> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _screens = [
//     const AdminScreen(), // "Get Order"
//     const OrderScreen(), // "Place Order"
//     GetNew(), // "Add"
//     const ShopScreen(), // "Shops"
//     ProductScreen(), // "Products"
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         drawer: UserDrawer(),
//         body: IndexedStack(
//           index: _selectedIndex,
//           children: _screens,
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: Theme.of(context).colorScheme.primary,
//           unselectedItemColor: Colors.grey,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.get_app_rounded),
//               label: 'Orders',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.add_shopping_cart),
//               label: 'Place Order',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.add_business_rounded),
//               label: 'Add',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.store),
//               label: 'Shops',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.fact_check_rounded),
//               label: 'Products',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:tat/AdminScreen/Admin.dart';
import 'package:tat/OrderScreen/OrderScreen.dart';
import 'package:tat/Products/Widgets/ProductScreen.dart';
import 'package:tat/Screens/ShopScreen.dart';
import 'package:tat/Screens/getNew.dart';
import 'package:tat/Widgets/UserDrawer.dart';

class UserInterface extends StatefulWidget {
  const UserInterface({super.key});

  @override
  State<UserInterface> createState() => _UserInterfaceState();
}

class _UserInterfaceState extends State<UserInterface> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: UserDrawer(),
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            const AdminScreen(), // "Get Order"
            const OrderScreen(), // "Place Order"
            GetNew(), // "Add"
            const ShopScreen(), // "Shops"
            ProductScreen(), // "Products"
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.get_app_rounded),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              label: 'Place Order',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_business_rounded),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: 'Shops',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fact_check_rounded),
              label: 'Products',
            ),
          ],
        ),
      ),
    );
  }
}
