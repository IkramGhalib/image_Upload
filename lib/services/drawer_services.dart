import 'package:flutter/cupertino.dart';
import 'package:grocery_vendor/screens/dashboard_screen.dart';
import 'package:grocery_vendor/screens/product_screen.dart';

class DrawerServices{
  Widget drawerScreen(title){
    if(title=='Dashboard'){
      return MainScreen();

    }
    if(title=='Product'){
      return ProductScreen();

    }
    if(title=='Coupons'){
      return ProductScreen();

    }
  }
}