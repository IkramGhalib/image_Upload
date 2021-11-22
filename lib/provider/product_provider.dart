import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductProvider extends ChangeNotifier{
  String selectedCategory ='not selected';
  String selectedSubCategory ='not selected';
  String categoryImage='';
  File image;
  String pickerError='';
  String shopName=''; //we need to bring shop name here
  String productUrl='';

  selectCategory(mainCategory,categoryImage){
      this.selectedCategory =mainCategory;
      this.categoryImage =categoryImage;
      notifyListeners();
    }
  selectSubCategory(selected){
    this.selectedSubCategory =selected;
    notifyListeners();
  }

  //shopname
  getShopName(shopName){
    this.shopName=shopName;
    notifyListeners();
  }

//  upload file
  Future<String> uploadProductImage(filePath,productName) async {
    File file = File(filePath);
    var timeStamp =Timestamp.now().microsecondsSinceEpoch;
    FirebaseStorage _storage =
        FirebaseStorage.instance;

    try {
      await _storage
          .ref('productImage/${this.shopName}/$productName$timeStamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    // now after upload file need file url path to save in database
    String downloadURL = await _storage
        .ref('productImage/${this.shopName}/$productName$timeStamp')
        .getDownloadURL();
    this.productUrl=downloadURL;
    notifyListeners();
    return downloadURL;
  }

//  product image provider
  Future<File> getProductImage() async {
    // final picker = ImagePicker();
    final tempFile =
    await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 15);
    if (tempFile != null) {
      this.image = File(tempFile.path);
    } else {
      this.pickerError = 'No Image Selected';
      print('No image selected');
      notifyListeners();
    }
    return this.image;
  }
  alertDialog({context,title,content}){
    // showCupertinoDialog(context: context,builder: (BuildContext context)){
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(child: Text('Ok'),onPressed: (){
            Navigator.pop(context);
          },)
        ],
      );
    }
    Future<void>saveProductDatatoDb(
      {productName,
      description,
      price,
      camparePrice,
      collection,
      brand,
      sku,
      weight,
        stockQty,
        lowStockQty,
        context

      }){
    var timeStamp =DateTime.now().microsecondsSinceEpoch;
    User user =FirebaseAuth.instance.currentUser;
    CollectionReference _products =FirebaseFirestore.instance.collection('products');
    try{
      _products.doc(timeStamp.toString()).set({
        'seller':{'shopName':this.shopName,'sellerUid':user.uid},
        'productName':productName,
        'description':description,
        'price':price,
        'camparePrice':camparePrice,
        'collection':collection,
        'brand':brand,
        'sku':sku,
        'category': {'mainCategory':this.selectedCategory,},
        'categoryImage':this.categoryImage,
        'Weight':weight,
        'stockQty':stockQty,
        'LowStockQty':lowStockQty,
        'published':false,
        'productId':timeStamp.toString(),
        'productImage':this.productUrl,

      });
      this.alertDialog(
        context: context,
        title: 'SAVE  DATA',
        content: 'Product Details Saved Successfully',

      );

    }
    catch(e){
      this.alertDialog(
        context: context,
        title: 'SAVE DATA',
        content: '${e.toString()}',
      );
    }
    return null;
    }
  }
