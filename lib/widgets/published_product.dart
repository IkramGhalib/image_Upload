import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor/services/firebase_services.dart';

class PublishedProduct extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FirebaseServices _service =FirebaseServices();
    return Container(
      child: StreamBuilder(
        stream: _service.products.where('published',isEqualTo: true).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Text('Something Wrong ...');
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          return SingleChildScrollView(
            child: DataTable(
              showBottomBorder: true,
              dataRowHeight: 60,
              headingRowColor: MaterialStateProperty.all(Colors.grey),
              columns: [
                DataColumn(label: Expanded(child: Text('Product Name')),),
                DataColumn(label: Text('Image'),),
                DataColumn(label: Text('Action'),),
              ],
              rows: _productDetails(snapshot.data),
            ),
          );
        },
      ),
    );

  }
  List<DataRow>_productDetails(QuerySnapshot snapshot){
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

                        // Expanded(child: Text('Name:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),)),
                        Expanded(child: Text(document['productName'],style: TextStyle(fontSize: 12),)),
                      ],
                    ),
                    // subtitle: Text(document['sku']),
                  ),)),
              DataCell(
                  Container(
                    child:
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(document['productImage']),
                    ),
                  )
              ),
              // DataCell(
              //     Container(child:Text((document['productImage'])),
              //     )
              // ),
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
          if(value=='unpublish'){
            _services.unpublishedProduct(
                id:data['productId']);
          }
          if(value=='delete'){
            _services.deleteProduct(
                id:data['productId']
            );
          }
        },
        itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
          const PopupMenuItem(
            value: 'unpublish',
            child: ListTile(
              leading: Icon(Icons.check),
              title: Text('Un Publish'),
            ),),
          const PopupMenuItem(
            value: 'preview',
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('preview'),
            ),),
          // const PopupMenuItem(
          //   value: 'Edit',
          //   child: ListTile(
          //     leading: Icon(Icons.edit_outlined),
          //     title: Text('Edit'),
          //   ),),
          // const PopupMenuItem(
          //   value: 'Delete',
          //   child: ListTile(
          //     leading: Icon(Icons.delete_outline),
          //     title: Text('Delete Product'),
          //   ),),

        ]);
  }
}
