import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingdelivery_morenope_admin/bloc/user_bloc.dart';

class OrderHeader extends StatelessWidget {

  final DocumentSnapshot order;

  OrderHeader(this.order);
  
  @override
  Widget build(BuildContext context) {

    final _userBloc = BlocProvider.of<UserBloc>(context);
    final _user = _userBloc.getUser(order.data['clienteId']);

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${_user['name']}', style: TextStyle(fontWeight: FontWeight.bold),),
              Text('${_user['adress']}'),
              Text('${_user['phone']}'),
              Divider(),
              /*Text(
                'OBSERVAÇÕES DO CLIENTE:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(order.data['observações'])*/
            ],
          ),
        ),
        /*Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text('Produtos: R\$${order.data['productsDalenaPrice'].toStringAsFixed(2)}', 
            style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Total: R\$${order.data['totalPrice'].toStringAsFixed(2)}', 
            style: TextStyle(fontWeight: FontWeight.bold))
          ],
        )*/
      ],
    );
  }
}