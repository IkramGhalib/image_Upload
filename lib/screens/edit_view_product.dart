import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor/provider/product_provider.dart';
import 'package:grocery_vendor/services/firebase_services.dart';
import 'package:grocery_vendor/widgets/category_list.dart';
import 'package:provider/provider.dart';


class EditViewProduct extends StatefulWidget {
  static const String id ='product-view-screen';
  final String productId;

  EditViewProduct({this.productId});


  @override
  _EditViewProductState createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  FirebaseServices _services =FirebaseServices();
  List _collection = ['Featured Product', 'Best Selling', 'Recently Added'];

  String dropdownValue;
  final _formkey =GlobalKey<FormState>();
  var _brandText =TextEditingController();
  var _skuText =TextEditingController();
  var _productNameText =TextEditingController();
  var _weightText =TextEditingController();
  var _priceText=TextEditingController();
  var _comparePriceText=TextEditingController();
  var _descriptionText=TextEditingController();
  DocumentSnapshot doc;
  double discount;
  String image;
  File _image;
  bool _visible=false;
  var _categoryTextController =TextEditingController();
  var _stockTextController =TextEditingController();
  var _lowStockTextController=TextEditingController();


  @override
  void initState() {
    getProductDetails();
    super.initState();
  }
  Future<void>getProductDetails() async{
    _services.products.doc(widget.productId).get().then((DocumentSnapshot document) {
      if(document.exists){
        setState(() {
          doc=document;
          _brandText.text=document['brand'];
          _skuText.text=document['sku'];
          _productNameText.text=document['productName'];
          _weightText.text=document['Weight'];
          _priceText.text=document['price'].toString();
          _comparePriceText.text =document['camparePrice'].toString();
          discount=(int.parse(_comparePriceText.text)-double.parse(_priceText.text)/int.parse(_comparePriceText.text)*100);
          image = document['productImage'];
          _descriptionText.text=document['description'];
          _categoryTextController.text=document['category']['mainCategory'];
          dropdownValue=document['collection'];
          _stockTextController.text=document['stockQty'].toString();
          _lowStockTextController.text=document['LowStockQty'].toString();

        });

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider =Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: doc==null?Center(child: CircularProgressIndicator()):Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200,
                        height: 30,
                        child: AbsorbPointer(
                          absorbing: true,
                          child: TextFormField(
                            controller: _brandText,
                            decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 30,right: 30),
                            hintText: 'Brand',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            fillColor: Colors.green)
                          ),
                        ),

                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('SKU :'),
                          Container(
                            width: 100,
                              child: TextFormField(
                                  controller: _skuText,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero
                                  ),
                              ),
                          ),
                        ],
                      )
                    ],
                  ),
                  TextFormField(
                    controller: _productNameText,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 30,
                    child: TextFormField(
                      controller: _weightText,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80,
                        child: TextFormField(
                          controller: _priceText,
                          decoration: InputDecoration(

                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                              prefixText: '\Rs:',
                          ),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        width: 100,
                        child: TextFormField(
                          controller: _comparePriceText,
                          decoration: InputDecoration(

                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            prefixText: '\Rs:',
                          ),
                          style: TextStyle(fontSize: 15,decoration: TextDecoration.lineThrough),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.red
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8,right: 8),
                          child: Text('${discount.toStringAsFixed(0)}% OFF',style: TextStyle(color: Colors.white),),
                        ),
                      ),

                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _image!=null?Image.file(_image,height: 300,):Image.network(image,height: 300),
                  ),
                  Text('About Product ',style: TextStyle(fontSize: 20),),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: null,
                      controller: _descriptionText,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(color: Colors.grey),
                      decoration: InputDecoration(
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20,bottom: 10),
                  child: Row(

                  ),),
                  SizedBox(
                    width: 10,
                  ),
                  TextFormField(
                    validator: (value){
                      if(value.isEmpty){
                        return 'Enter Category';
                      }
                      setState(() {
                        _visible=true;
                      });
                      return null;
                    },
                    controller: _categoryTextController,
                    decoration: InputDecoration(
                      labelText: 'Not Selected',
                      labelStyle: TextStyle(color: Colors.green)
                    ),
                  ),

                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder:
                                (BuildContext context) {
                              return CategoryList();
                            }).whenComplete(() {
                          setState(() {
                            _categoryTextController.text =
                                _provider.selectedCategory;
                          });
                        });
                      },
                      icon: Icon(Icons.edit)),
                  Container(
                      child: Row(
                        children: [
                          Text(
                            'Collection',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          DropdownButton<String>(
                              hint: Text('Select Collection'),
                              value: dropdownValue,
                              icon: Icon(Icons.arrow_drop_down),
                              onChanged: (String value) {
                                setState(() {
                                  dropdownValue = value;
                                });
                              },
                              items: _collection
                                  .map<DropdownMenuItem<String>>(
                                      (value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList())
                        ],
                      )),
                  TextFormField(
                    controller: _stockTextController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText:
                        'Inventory Low Stock Quantity',
                        labelStyle:
                        TextStyle(color: Colors.grey),
                        enabledBorder:
                        UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .grey[300]))),
                  ),
                  TextFormField(
                    controller: _lowStockTextController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText:
                        'Inventory Low Stock Quantity',
                        labelStyle:
                        TextStyle(color: Colors.grey),
                        enabledBorder:
                        UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .grey[300]))),
                  )


                ],
              )
            ],
          ),
        ),
      ),
    );
  }


}
