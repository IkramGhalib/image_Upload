import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:grocery_vendor/screens/dashboard_screen.dart';
import 'package:grocery_vendor/screens/login.dart';
import 'package:grocery_vendor/screens/login_screen.dart';
import 'package:grocery_vendor/services/drawer_services.dart';
import 'package:grocery_vendor/widgets/drawer_menu_widget.dart';
import 'package:grocery_vendor/widgets/mydrawer.dart';


class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DrawerServices _services =DrawerServices();
  GlobalKey<SliderMenuContainerState> _key =new GlobalKey<SliderMenuContainerState>();
  String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SliderMenuContainer(
          appBarColor: Colors.white,
          // appBarHeight: 100,
          key: _key,
          sliderMenuOpenSize: 250,
          title: Text(''),
          trailing: Row(
            children: [
              IconButton(onPressed: (){
                FirebaseAuth.instance.signOut();
              }, icon: Icon(CupertinoIcons.search)),
              IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.bell))

            ],
          ),
          sliderMenu: MenuWidget(
            OnItemClick: (title){
              _key.currentState.closeDrawer();
              setState(() {
                this.title=title;
              });
            },
          ),
            sliderMain:_services.drawerScreen(title)
          // sliderMain: MainScreen(),
        )
    );
  }
}