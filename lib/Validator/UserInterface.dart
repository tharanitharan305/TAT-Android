import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tat/Screens/Admin.dart';
import 'package:tat/Screens/OrderScreen.dart';

class UserInterface extends StatefulWidget {
  const UserInterface({super.key});

  @override
  State<UserInterface> createState() {
    return _UserInterface();
  }
}

class _UserInterface extends State<UserInterface> {
  bool Admin = false;
  @override
  Widget build(context) {
    return SafeArea(
      child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('images/tatlogo.png'),
              fit: BoxFit.contain,
              opacity: 0.1,
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AdminScreen()));
                },
                label: const Text('Get Order'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                  elevation: 10,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                icon: const Icon(Icons.get_app_rounded),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderScreen(),
                    ),
                  );
                },
                label: const Text('Place Order'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                  elevation: 10,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                icon: const Icon(Icons.add_shopping_cart),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                label: const Text('Log out'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                  elevation: 10,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                icon: const Icon(Icons.logout),
              ),
            ],
          )),
    );
  }
}
