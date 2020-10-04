import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingdelivery_morenope_admin/widgets/order_header.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot order;

  final states = [
    '',
    'Em preparação',
    'Em transporte',
    'Aguardando Entrega',
    'Entregue'
  ];

  OrderTile(this.order);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(order.documentID),
          initiallyExpanded: order.data['status'] != 4,
          title: Text(
            '#${order.documentID.substring(order.documentID.length - 7, order.documentID.length)} - '
            '${states[order.data['status']]}',
            style: TextStyle(
                color: order.data['status'] != 4
                    ? Colors.grey[850]
                    : Colors.green),
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  OrderHeader(order),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: order.data['productsDelicia'].map<Widget>((p) {
                      return ListTile(
                        title: Text(p['product']['title']),
                        trailing: Text(
                          p['quantity'].toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                  Text(
                    'OBSERVAÇÕES DO CLIENTE:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(order.data['observações']),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                          'Produtos: R\$${order.data['productsDeliciaPrice'].toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          'Total: R\$${order.data['totalPrice'].toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Firestore.instance
                                .collection('users')
                                .document(order['clienteId'])
                                .collection('ordersDelicia')
                                .document(order.documentID)
                                .delete();
                            order.reference.delete();
                          },
                          textColor: Colors.red,
                          child: Text('Excluir')),
                      FlatButton(
                          onPressed: order.data['status'] > 1
                              ? () {
                                  order.reference.updateData(
                                      {'status': order.data['status'] - 1});
                                }
                              : null,
                          textColor: Colors.grey[850],
                          child: Text('Regredir')),
                      FlatButton(
                          onPressed: order.data['status'] < 4
                              ? () {
                                  order.reference.updateData(
                                      {'status': order.data['status'] + 1});
                                }
                              : null,
                          textColor: Colors.green,
                          child: Text('Avançar'))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
