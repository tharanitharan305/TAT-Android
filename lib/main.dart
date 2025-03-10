import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tat/AdminScreen/bloc/AdminBloc.dart';
import 'package:tat/Beat/bloc/BeatBloc.dart';
import 'package:tat/Firebase/Authentication.dart';
import 'package:tat/Firebase/NewOrder.dart';
import 'package:tat/Firebase/bloc/FirebaseBloc.dart';
import 'package:tat/Firebase/models/User.dart';
import 'package:tat/OrderScreen/bloc/order_bloc.dart';
import 'package:tat/Products/bloc/Product_bloc.dart';
import 'package:tat/Validator/UserInterface.dart';
import 'package:tat/Widgets/Jobs.dart';
import 'package:tat/Widgets/infinite.dart';
import 'Shop/bloc/ShopBloc.dart';
import 'companies/bloc/companyBloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => BeatBloc(),
    ),
    BlocProvider(
      create: (context) => ShopBloc(),
    ),
    BlocProvider(
      create: (context) => CompanyBloc(),
    ),
    BlocProvider(
      create: (context) => ProductBloc(),
    ),
    BlocProvider(
      create: (context) => FirebaseBloc(),
    ),
    BlocProvider(
      create: (context) =>
          OrderBloc(firebaseBloc: context.read<FirebaseBloc>()),
    ),
    BlocProvider(
      create: (context) =>
          AdminBloc(firebaseBloc: context.read<FirebaseBloc>()),
    ),
  ], child: App()));
}

class App extends StatelessWidget {
  App({super.key});

  final ThemeData premiumTheme = ThemeData(
    useMaterial3: true, // Modern UI enhancements
    brightness: Brightness.light,
    primaryColor: Color(0xFFFF6600), // Talabat Orange
    scaffoldBackgroundColor: Colors.white, // Clean Milk White Background

    colorScheme: ColorScheme.light(
      primary: Color(0xFFFF6600), // Talabat Premium Orange
      secondary: Color(0xFFFFA726), // Slightly lighter orange for accents
      surface: Colors.white, // White surfaces
      background: Colors.white, // Pure white background
      onPrimary: Colors.white, // Text/icons on primary orange
      onSecondary: Colors.white, // Text/icons on secondary orange
      onSurface: Color(0xFF333333), // Dark text/icons for contrast
    ),

    // 🟠 AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFFF6600), // Talabat Orange
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    // 🔘 Button Styles
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFF6600), // Talabat Orange
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // White outline
          ),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          elevation: 5,
          iconColor: Colors.white),
    ),

    // 🔲 Card Theme
    cardTheme: CardTheme(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 6,
    ),

    // 📄 Text Styling
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFFFF6600), // Talabat Orange Accent
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        color: Color(0xFF333333), // Dark contrast for readability
      ),
    ),

    // 🏷 Dropdown & Input Fields
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.2)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFFF6600), width: 2),
      ),
      hintStyle: TextStyle(color: Color(0xFF999999)),
      labelStyle: TextStyle(color: Color(0xFF666666)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    // NewOrder().live();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TAT',
      theme: premiumTheme,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              context.read<FirebaseBloc>().add(OnUserEntersEvent(
                  user: TatUser(
                      userName: user.displayName ?? "User",
                      userEmail: user.email ?? "email",
                      location: null,
                      daysOfPresent: 0,
                      jobType: Jobs.All_Rounder,
                      overAllSales: 0)));
              return const UserInterface();
            } else {
              return const Authentication();
            }
          }),
    );
  }
}
