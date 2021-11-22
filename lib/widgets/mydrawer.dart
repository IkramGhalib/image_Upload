import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor/screens/dashboard_screen.dart';
import 'package:grocery_vendor/screens/product_screen.dart';

class MyDrawer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.zero,
        color: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.green[400]),
                  accountEmail: Text("IkramGhalib@gmail.com"),
                  accountName: Text("Ikram"),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/login.png"),
                  ),
                )),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, MainScreen.id);
              },
              leading: Icon(Icons.dashboard_customize_outlined,color: Colors.black,),
              title: Text(
                "Dashboard",
                style: TextStyle(color: Colors.black),
              ),
            ),

            ListTile(
              onTap: () {
                print("Drawer2 button clicked");
              },
              leading: Icon(Icons.shopping_bag_outlined,color: Colors.black,),
              title: Text(
                "Product",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ProductScreen.id);
              },
              leading: Icon(Icons.card_giftcard,color: Colors.black,),
              title: Text(
                "Coupons",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                print("Drawer button clicked");
              },
              leading: Icon(Icons.list_alt_outlined,color: Colors.black,),
              title: Text(
                "Orders",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                print("Drawer button clicked");
              },
              leading: Icon(Icons.stacked_bar_chart,color: Colors.black,),
              title: Text(
                "Reports",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                print("Drawer button clicked");
              },
              leading: Icon(Icons.settings,color: Colors.black,),
              title: Text(
                "Sitting",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, MainScreen.id);
              },
              leading: Icon(CupertinoIcons.back,color: Colors.black,),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
          // padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}