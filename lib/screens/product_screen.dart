import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingdelivery_morenope_admin/bloc/product_bloc.dart';
import 'package:shoppingdelivery_morenope_admin/validators/product_validator.dart';
import 'package:shoppingdelivery_morenope_admin/widgets/image_widget.dart';

class ProductScreen extends StatefulWidget {

  final DocumentSnapshot product;

  ProductScreen({this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator{

  final ProductBloc _productBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _ProductScreenState(DocumentSnapshot product) :
  _productBloc = ProductBloc(product: product);

  @override
  Widget build(BuildContext context) {

    InputDecoration _buildDecoration(String label){
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey)
      );
    }

    final _fieldStyle = TextStyle(color: Colors.white, fontSize: 16);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: Text('Editar Produto'),
        actions: <Widget>[
          //IconButton(icon: Icon(Icons.remove),
          //onPressed: (){}
          //),
          StreamBuilder<bool>(
            stream: _productBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(icon: Icon(Icons.save),
              onPressed: snapshot.data ? null : saveProduct,
              );
            }
          )
        ]
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
              stream: _productBloc.outData,
              builder: (context, snapshot) {
                if(!snapshot.hasData) return Container();
                return ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    Text(
                      'Imagem', style: TextStyle(color: Colors.grey, fontSize: 12)
                    ),
                    ImagesWidget(
                      context: context,
                      initialValue: snapshot.data['images'],
                      onSaved: _productBloc.saveImages,
                      validator: validateImages,
                    ),
                    TextFormField(
                      initialValue: snapshot.data['title'],
                      style: _fieldStyle,
                      decoration: _buildDecoration('Título'),
                      onSaved: _productBloc.saveTitle,
                      validator: validateTitle,
                    ),
                    TextFormField(
                      initialValue: snapshot.data['description'],
                      style: _fieldStyle,
                      maxLines: 6,
                      decoration: _buildDecoration('Descrição'),
                      onSaved: _productBloc.saveDescription,
                      validator: validateDescription,
                    ),
                    TextFormField(
                      initialValue: snapshot.data['price'].toStringAsFixed(2),
                      style: _fieldStyle,
                      decoration: _buildDecoration('Preço'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onSaved: _productBloc.savePrice,
                      validator: validatePrice,
                    )
                  ]
                );
              }
            )
          ),
          StreamBuilder<bool>(
            stream: _productBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IgnorePointer(
                ignoring: !snapshot.data,
                child: Container(
                  color: snapshot.data ? Colors.black54 : Colors.transparent
                ),
              );
            }
          )
        ],
      ),
    );
  }

  void saveProduct() async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(
          'Salvando alterações...',
          style: TextStyle(color: Colors.white)
          ),
          duration: Duration(minutes: 1),
          backgroundColor: Colors.blue[900]
        )
      );

      bool success = await _productBloc.saveProduct();

      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(success ?
          'Alterações salvas!' : 'Erro ao fazer alterações!',
          style: TextStyle(color: Colors.white)
          ),
          backgroundColor: Colors.blue[900]
        )
      );
    }
  }
}