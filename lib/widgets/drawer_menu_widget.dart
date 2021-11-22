import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor/provider/product_provider.dart';
import 'package:provider/provider.dart';

class MenuWidget extends StatefulWidget {
  final Function(String) OnItemClick;
  const MenuWidget({Key key,this.OnItemClick}) :super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  User user =FirebaseAuth.instance.currentUser;
  var vendorData;

  @override
  void initState() {
    getVendorData();
    super.initState();
  }

  Future<DocumentSnapshot>getVendorData()async{
    var result =await FirebaseFirestore.instance.collection('vendors').doc(user.uid).get();
    setState(() {
      vendorData=result;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    _provider.getShopName(vendorData!=null?vendorData.data()['shopName']:'');
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30,),
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: vendorData!=null?NetworkImage(vendorData.data()['imageUrl']):null,
            ),
          ),
          SizedBox(height:20),
          Text(vendorData!=null?vendorData.data()['shopName']:'Shop Name',style: TextStyle(color: Colors.black,
          fontSize: 20, fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
          sliderItem('Dashboard',Icons.dashboard_customize_outlined),
          sliderItem('Product',Icons.shopping_bag_outlined),
          // sliderItem('Coupons',Icons.card_giftcard),
          // sliderItem('My Order',Icons.list_alt_outlined),
          // sliderItem('Reports',Icons.stacked_bar_chart),
          // sliderItem('Sitting',Icons.settings),
          sliderItem('Logout',Icons.logout)
        ],
      ),
    );
  }

  Widget sliderItem(String title, IconData icons)=>InkWell(

    child: Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]

          )
        )
      ),
      child:SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Icon(icons,color: Colors.black,size: 18,),
              SizedBox(width: 10,),
              Text(title, style: TextStyle(color: Colors.black, fontSize: 12),)

            ],
          ),
        ),
      )
    ),
    onTap:(){
      widget.OnItemClick(title);
      // print(title);
    }
  );
}
