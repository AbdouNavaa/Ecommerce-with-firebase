import '../../constants.dart';
import '../../screens/admin/order_details.dart';
import '../../services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/order.dart';

class OrdersScreen extends StatelessWidget {
  static String id = 'OrdersScreen';
  final Store _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('there is no orders'));
          } else {
            List<OurOrder> orders = [];
            print('Snapssss ${snapshot.data!.docs}');
            for (var doc in snapshot.data!.docs ?? []) {
              print('SnapData ${doc.data()}');
              var data = doc.data();
              orders.add(
                OurOrder(
                  documentId: doc.id,
                  address: data[kAddress],
                  totallPrice: data[kTotallPrice],
                ),
              );
            }
            return ListView.builder(
              itemBuilder:
                  (context, index) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          OrderDetails.id,
                          arguments: orders[index].documentId,
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * .2,
                        color: kSecondaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Totall Price = \$${orders[index].totallPrice}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Address is ${orders[index].address}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              itemCount: orders.length,
            );
          }
        },
      ),
    );
  }
}
