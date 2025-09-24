import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/add_to_cart_req.dart';
import '../models/order_registration_req.dart';

abstract class OrderFirebaseService {
  Future<Either> addToCart(AddToCartReq addToCartReq);
  Future<Either> getCartProducts();
  Future<Either> removeCartProduct(String id);
  Future<Either> orderRegistration(OrderRegistrationReq order);
  Future<Either> getUserOrders();
  Future<Either> getOrders();
  Future<Either> changeOrderStatus(String id, String status);
  Future<void> deleteOrder(String id);
}

class OrderFirebaseServiceImpl extends OrderFirebaseService {
  @override
  Future<Either> addToCart(AddToCartReq addToCartReq) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Cart')
          .add(addToCartReq.toMap());
      return const Right('Add to cart was successfully');
    } catch (e) {
      return const Left('Please try again.');
    }
  }

  @override
  Future<Either> getCartProducts() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var returnedData =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user!.uid)
              .collection('Cart')
              .get();

      List<Map> products = [];
      for (var item in returnedData.docs) {
        var data = item.data();
        data.addAll({'id': item.id});
        products.add(data);
      }
      return Right(products);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> removeCartProduct(String id) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Cart')
          .doc(id)
          .delete();
      return const Right('Product removed successfully');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> orderRegistration(OrderRegistrationReq order) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var user1 =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user!.uid)
              .get();
      var User = user1.data();
      final newOrder = OrderRegistrationReq(
        products: order.products,
        createdDate: order.createdDate,
        itemCount: order.itemCount,
        totalPrice: order.totalPrice,
        shippingAddress: order.shippingAddress,
        code: order.code,
        orderStatus: order.orderStatus,
        userId: user!.uid, // <-- Ajoute l'ID ici
        userName: User!['firstName'],
      );
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Orders')
          .add(order.toMap());

      await FirebaseFirestore.instance
          .collection('Orders')
          .add(newOrder.toMap());
      for (var item in order.products) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('Cart')
            .doc(item.id)
            .delete();
      }

      return const Right('Order registered successfully');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getOrders() async {
    try {
      var returnedData =
          await FirebaseFirestore.instance.collection('Orders').get();
      print('returnedData: $returnedData');
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getUserOrders() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var returnedData =
          await FirebaseFirestore.instance
              .collection('Orders')
              .where('userId', isEqualTo: user!.uid)
              .get();
      // print('returnedData: ${returnedData.docs.map((e) => e.data()).toList()}');
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either<String, String>> changeOrderStatus(
    String id,
    String selectedStatus,
  ) async {
    try {
      // 1. Récupérer la commande depuis Firestore
      final query =
          await FirebaseFirestore.instance
              .collection('Orders')
              .where('code', isEqualTo: id)
              .limit(1)
              .get();

      if (query.docs.isNotEmpty) {
        final docId = query.docs.first.id;
        final docRef = FirebaseFirestore.instance
            .collection('Orders')
            .doc(docId);

        // final docRef = FirebaseFirestore.instance.collection('Orders').doc(id);
        final docSnapshot = await docRef.get();

        if (!docSnapshot.exists) {
          return const Left('Order not found');
        }

        // 2. Lire l’ancien orderStatus
        final data = docSnapshot.data()!;
        final List<dynamic> oldStatusList = data['orderStatus'];

        // 3. Trouver l’index du statut sélectionné
        final index = oldStatusList.indexWhere(
          (item) => item['title'] == selectedStatus,
        );
        if (index == -1) return const Left('Status not found');

        // 4. Construire la nouvelle liste avec done: true jusqu’à l’index
        final List<Map<String, dynamic>> newStatusList = [];
        for (int i = 0; i < oldStatusList.length; i++) {
          newStatusList.add({
            'title': oldStatusList[i]['title'],
            'createdDate': oldStatusList[i]['createdDate'],
            'done': i <= index,
          });
        }

        // 5. Mettre à jour dans Firestore
        await docRef.update({'orderStatus': newStatusList});

        return const Right('Order status changed successfully');
      } else {
        return const Left('Aucune commande trouvée avec ce code');
      }
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<void> deleteOrder(String id) async {
    final query =
        await FirebaseFirestore.instance
            .collection('Orders')
            .where('code', isEqualTo: id)
            .limit(1)
            .get();
    if (query.docs.isNotEmpty) {
      final docId = query.docs.first.id;
      final docRef = FirebaseFirestore.instance.collection('Orders').doc(docId);
      await docRef.delete();
    } else {}

    // return FirebaseFirestore.instance.collection('Orders').doc(id).delete();
  }
}
