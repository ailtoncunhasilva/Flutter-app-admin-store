import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingdelivery_morenope_admin/screens/product_screen.dart';

class ProductsTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('store02').getDocuments(),
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white)
          ),);
        else 
          return ListView(
            children: snapshot.data.documents.map((doc){
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(doc.data['images'][0]),
                  backgroundColor: Colors.transparent,
                ),
                title: Text(doc.data['title'], /*style: TextStyle(color: Colors.white),*/),
                trailing: Text(
                  'R\$${doc.data['price'].toStringAsFixed(2)}',
                  //style: TextStyle(color: Colors.white),
                ),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProductScreen(product: doc,))
                  );
                },
              );
            }).toList()
        );
      },
    );
  }
  toList() {}
}

/*..add(
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.add, color: Colors.blue[900]),
                ),
                title: Text('Adicionar'),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProductScreen())
                  );
                },
              )*/