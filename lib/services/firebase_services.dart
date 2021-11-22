import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices{

  CollectionReference category =FirebaseFirestore.instance.collection('category');
  CollectionReference products =FirebaseFirestore.instance.collection('products');

  Future<String>publishedProduct({id}){
    return products.doc(id).update({
      'published':true,

    });
  }

  Future<String>unpublishedProduct({id}){
    return products.doc(id).update({
      'published':false,

    });
  }
  Future<String>deleteProduct({String id}){
    return products.doc(id).delete();
  }
}