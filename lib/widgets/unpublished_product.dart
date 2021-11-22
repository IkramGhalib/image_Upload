import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor/screens/edit_view_product.dart';
import 'package:grocery_vendor/services/firebase_services.dart';

class UnPublishedProduct extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FirebaseServices _service =FirebaseServices();
    return Container(
      child: StreamBuilder(
        stream: _service.products.where('published',isEqualTo: false).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Text('Something Wrong...');
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          return SingleChildScrollView(
            child: FittedBox(
              child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 60,
                headingRowColor: MaterialStateProperty.all(Colors.grey),
                columns: [
                  DataColumn(label: Expanded(child: Text('Product Name')),),
                  DataColumn(label: Text('Image'),),
                  DataColumn(label: Text('Info'),),
                  DataColumn(label: Text('Action'),),
                ],
                rows: _productDetails(snapshot.data,context),
              ),
            ),
          );
        },
      ),
    );

  }
  List<DataRow>_productDetails(QuerySnapshot snapshot,BuildContext context){
    List<DataRow> newList =snapshot.docs.map((DocumentSnapshot document){
      if(document!=null){
        return DataRow(
            cells: [
              DataCell(
                  Container(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(

                        children: [

                          Text('Name:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                          Expanded(child: Text(document['productName'],style: TextStyle(fontSize: 15),)),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(child: Text('SKU:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),)),
                          Text(document['sku'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),

                        ],
                      ),
                    ),)),
              DataCell(
                  Container(
                    child:
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        children: [
                          Image.network(document['productImage'],width: 50,),
                        ],
                      ),
                    ),
                  )
              ),
              DataCell(
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditViewProduct(
                    productId: document['productId'],
                  )));
                },icon: Icon(Icons.info_outline),)
                 // FlatButton(onPressed: (){
                 //   Navigator.pushNamed(context, EditViewProduct.id);
                 // },)
              ),
              DataCell(
                popUpButton(document.data()),
              ),
            ]);
      }
    }).toList();
    return newList;

  }
  Widget popUpButton(data,{BuildContext context}){
    FirebaseServices _services =FirebaseServices();
   return PopupMenuButton<String>(
     onSelected: (String value){
       if(value=='publish'){
         _services.publishedProduct(
             id:data['productId']
         );
       }
       if(value=='delete'){
         _services.deleteProduct(
             id:data['productId']
         );
       }
     },
       itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
         const PopupMenuItem(
           value: 'publish',
             child: ListTile(
               leading: Icon(Icons.check),
               title: Text('Publish'),
             ),),
         const PopupMenuItem(
           value: 'preview',
           child: ListTile(
             leading: Icon(Icons.info_outline),
             title: Text('preview'),
           ),),
         const PopupMenuItem(
           value: 'Edit',
           child: ListTile(
             leading: Icon(Icons.edit_outlined),
             title: Text('Edit'),
           ),),
         const PopupMenuItem(
           value: 'delete',
           child: ListTile(
             leading: Icon(Icons.delete_outline),
             title: Text('Delete Product'),
           ),),

   ]);
  }
}
