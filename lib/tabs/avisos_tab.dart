import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class AvisosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('statusStore')
              .document('statusLoja02')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Status da loja',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: LiteRollingSwitch(
                            value: true,
                            textOn: 'Aberto',
                            textOff: 'Fechado',
                            colorOn: Colors.green,
                            colorOff: Colors.red,
                            iconOn: Icons.done,
                            iconOff: Icons.close,
                            textSize: 18,
                            onChanged: (bool position) {
                              if (position == true) {
                                Firestore.instance
                                    .collection('statusStore')
                                    .document('statusLoja02')
                                    .updateData({'status': true});
                              } else {
                                Firestore.instance
                                    .collection('statusStore')
                                    .document('statusLoja02')
                                    .updateData({'status': false});
                              }
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          snapshot.data['avisos'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
