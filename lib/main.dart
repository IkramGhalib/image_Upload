import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor/provider/auth_provider.dart';
import 'package:grocery_vendor/provider/product_provider.dart';
import 'package:grocery_vendor/screens/add_newproduct_screen.dart';
import 'package:grocery_vendor/screens/dashboard_screen.dart';
import 'package:grocery_vendor/screens/edit_view_product.dart';
import 'package:grocery_vendor/screens/login.dart';
import 'package:grocery_vendor/screens/login_screen.dart';
import 'package:grocery_vendor/screens/product_screen.dart';
import 'package:grocery_vendor/screens/register_screen.dart';
import 'package:grocery_vendor/screens/home_screen.dart';
import 'package:grocery_vendor/screens/resetPassword_screen.dart';
import 'package:grocery_vendor/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => AuthProvider(),
        ),
        Provider(
          create: (_) => ProductProvider(),
        ),

      ],
      child: MyApp(),
    ),
  );

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green, fontFamily: 'Lato'),

      // home: SplashScreen(),
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ResetPassword.id: (context) => ResetPassword(),
        Login.id: (context) => Login(),
        MainScreen.id: (context) => MainScreen(),
        ProductScreen.id: (context) => ProductScreen(),
        AddNewProduct.id: (context) => AddNewProduct(),
        EditViewProduct.id: (context) => EditViewProduct(),
      },
    );
  }
}
