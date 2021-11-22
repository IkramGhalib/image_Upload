import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_vendor/provider/product_provider.dart';
import 'package:grocery_vendor/widgets/category_list.dart';
import 'package:provider/provider.dart';

class AddNewProduct extends StatefulWidget {
  static const String id = 'addnewproduct-scrren';

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();
  List _collection = ['Featured Product', 'Best Selling', 'Recently Added'];

  String dropdownValue;
  var _categoryTextController = TextEditingController();
  var _subcategoryTextController = TextEditingController();
  var _camparePriceTextController = TextEditingController();
  var _brandTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  var _stockQtyTextController = TextEditingController();

  File _image;
  bool _visible = false;
  bool _track = false;
  String productName;
  String description;
  double price;
  double camparePrice;
  String sku;
  String weight;
  // int stockQty;

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 2,
      initialIndex: 1,//keep initinal index keep text not to clear
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          child: Text('Product/ Add'),
                        ),
                      ),
                      FlatButton.icon(
                          onPressed: () {
                            if(_formKey.currentState.validate()){
                              if(_image!=null){
                                //image should be selected
                                //image upload to firestore
                                EasyLoading.show(status: 'Saving data...');
                                _provider.uploadProductImage(_image.path, productName).then((Url){
                                  if(Url!=null){
                                    //upload product  data to firestore
                                    EasyLoading.dismiss();
                                    _provider.saveProductDatatoDb(
                                      context: context,
                                      productName: productName,
                                      description: description,
                                      price: price,
                                      camparePrice: int.parse(_camparePriceTextController.text),
                                      collection: dropdownValue,
                                      brand: _brandTextController.text,
                                      sku: sku,
                                      weight: weight,
                                      lowStockQty: int.parse(_lowStockTextController.text),

                                      stockQty: int.parse(_stockQtyTextController.text),
                                    );
                                    _formKey.currentState.reset();
                                    _camparePriceTextController.clear();
                                    _subcategoryTextController.clear();
                                    _categoryTextController.clear();
                                    dropdownValue=null;
                                    _track=false;
                                    _image=null;
                                    _visible=false;
                                    _brandTextController.clear();

                                    // EasyLoading.dismiss();
                                  }else{
                                    //upload failed
                                    _provider.alertDialog(
                                        context: context,
                                        title: 'Image Upload ',
                                        content: 'Failed to upload product image'
                                    );
                                  }
                                });
                              }else{
                                //image not selected
                                _provider.alertDialog(
                                  context: context,
                                  title: 'Product Image',
                                  content: 'Product Image not Selected'
                                );
                              }
                            }
                          },
                          color: Colors.green,
                          icon: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
              ),
              TabBar(
                indicatorColor: Colors.grey,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'General'),
                  Tab(text: 'Inventory'),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    child: TabBarView(children: [
                      ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  validator:(value){
                                    if(value.isEmpty){
                                      return 'Enter Product name';
                                    }
                                    setState(() {
                                      productName=value;

                                    });
                                    return null;
                                    },
                                  decoration: InputDecoration(
                                      labelText: 'Product Name*',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]))),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 2,
                                  maxLength: 500,
                                  validator:(value){
                                    if(value.isEmpty){
                                      return 'Enter Description';
                                    }
                                    setState(() {
                                      description=value;

                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'About Product*',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: InkWell(
                                    onTap: () {
                                      _provider.getProductImage().then((image) {
                                        setState(() {
                                          _image = image;
                                        });
                                      });
                                    },
                                    child: SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: Card(
                                        child: Center(
                                          child: _image == null
                                              ? Text('Select Image')
                                              : Image.file(_image),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator:(value){
                                    if(value.isEmpty){
                                      return 'Enter Selling Price';
                                    }
                                    setState(() {
                                      price=double.parse(value);

                                    });
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Price*',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]))),
                                ),
                                //Compare Price*
                                TextFormField(
                                  controller: _camparePriceTextController,
                                  validator:(value){
                                    if(value.isEmpty){
                                      return 'Enter Compared Price';
                                    }
                                    if(price>double.parse(value)){
                                      return 'Compared price should be higher than price';
                                    }
                                    setState(() {
                                      camparePrice=double.parse(value);

                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Compare Price*',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]))),
                                ),
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
                                //Brand*'
                                TextFormField(
                                  controller: _brandTextController,
                                  decoration: InputDecoration(
                                      labelText: 'Brand*',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]))),
                                ),
                                //Not Selected
                                TextFormField(
                                  validator: (value){
                                    if(value.isEmpty){
                                      return 'SKU';
                                    }
                                    setState(() {
                                      sku=value;
                                    });
                                    return null;
                                  },

                                  decoration: InputDecoration(
                                      labelText: 'SKU',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Category',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      //Not Selected
                                      Expanded(
                                        child: AbsorbPointer(
                                          absorbing: true, //this will block user to manually category name
                                          child: TextFormField(
                                            validator: (value){
                                              if(value.isEmpty){
                                                return 'Enter Category name';
                                              }
                                              setState(() {
                                                _visible=true;
                                              });
                                              return null;
                                            },
                                            controller: _categoryTextController,
                                            decoration: InputDecoration(
                                                labelText: 'Not Selected',
                                                labelStyle:
                                                    TextStyle(color: Colors.grey),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey[300]))),
                                          ),
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
                                          icon: Icon(Icons.edit))
                                    ],
                                  ),
                                ),

                                Visibility(
                                  visible: _visible,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, bottom: 10),
                                    child: Row(
                                      children: [
                                        Text('SubCategory',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: AbsorbPointer(
                                            absorbing: true,
                                            child: TextFormField(
                                              validator: (value){
                                                if(value.isEmpty){
                                                  return 'Select Sub Category Name';
                                                }
                                                return null;
                                              },
                                              controller:_subcategoryTextController,
                                              decoration: InputDecoration(
                                                  labelText: 'Not Selected',
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .grey[300]))),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _visible = true;
                                              });
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return SubCategoryList();
                                                  }).whenComplete(() {
                                                setState(() {
                                                  _subcategoryTextController
                                                          .text =_provider.selectedSubCategory;
                                                  _visible = true;
                                                });
                                              });
                                            },
                                            icon: Icon(Icons.edit))
                                      ],
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value){
                                    if(value.isEmpty){
                                      return 'Enter Weight/Kg';
                                    }
                                    setState(() {
                                      weight=value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Weight e.g: kg, grams, dozen',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]))),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SwitchListTile(
                                title: Text('Track Inventory'),
                                subtitle: Text(
                                  'Switch to inventory track',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                activeColor: Colors.green,
                                value: _track,
                                onChanged: (selected) {
                                  setState(() {
                                    _track = !_track;
                                  });
                                }),
                            Visibility(
                              visible: _track,
                              child: SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _stockQtyTextController,
                                          validator: (value){
                                            if(_track){
                                              if(value.isEmpty){
                                                return 'Enter Stock Quantity*';
                                              }

                                            }
                                            return null;
                                            },
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Inventory Quantity',
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
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
