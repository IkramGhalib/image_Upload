import 'package:flutter/material.dart';
import 'package:grocery_vendor/screens/add_newproduct_screen.dart';
import 'package:grocery_vendor/widgets/published_product.dart';
import 'package:grocery_vendor/widgets/unpublished_product.dart';


class ProductScreen extends StatelessWidget {
  static const String id ='product screen';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children:[
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
                        child: Row(
                          children: [
                            Text('Product'),
                            SizedBox(width: 10,),
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              maxRadius: 8,
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('20',style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    FlatButton.icon(onPressed: (){
                      Navigator.pushNamed(context, AddNewProduct.id);
                    },
                        color: Colors.green,
                      icon: Icon(Icons.add,color: Colors.white,),
                        label: Text('Add New',style: TextStyle(color: Colors.white),))
                  ],
                ),
              ),
            ),
            TabBar(
                indicatorColor: Colors.grey,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
              Tab(text: 'PUBLISHED',),
              Tab(text: 'UN PUBLISHED',),
            ]),
            
            Expanded(
              child: Container(
                child: TabBarView(
                    children: [
                      PublishedProduct(),
                      UnPublishedProduct(),
                      // Center(child: Text('Published Items'),),
                      // Center(child: Text('Un Published Items'),)

                ]),
              ),
            )


          ],
        ),
      ),
    );
  }
}