import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'models/paid_market_orders_model.dart';
import 'models/product_model.dart';

class MarketMethods {
  CollectionReference productRef = FirebaseFirestore.instance
      .collection('market')
      .doc('products')
      .collection('allProducts');

  CollectionReference productOrdersRef =
      FirebaseFirestore.instance.collection('marketOrders');

  final CollectionReference shopCollection =
      FirebaseFirestore.instance.collection('shopOwnersData');

  CollectionReference productCategoriesRef = FirebaseFirestore.instance
      .collection('market')
      .doc('categories')
      .collection('productsList');

  Future saveProductToServer({@required ProductModel productModel}) async {
    var dateParse = DateTime.parse(DateTime.now().toString());
    FirebaseFirestore db = FirebaseFirestore.instance;
    var batch = db.batch();

    try {
      print('saving');

      await shopCollection
          .where('shopName', isEqualTo: productModel.productShopName)
          .get()
          .then((doc) {
        print(doc.docs);

        /// get first document. note they can only be one shop with a particular name
        /// so this will always return a list of one document snapshot. So ill just take the
        /// first one
        DocumentSnapshot document = doc.docs[0];

        /// Now will can perform our batch write
        batch.set(
          shopCollection.doc(document.id),
          {"numberOfProducts": FieldValue.increment(1)},
          SetOptions(merge: true),
        );
      });

      batch.set(
        productRef.doc(productModel.id),
        productModel.toMap(),
      );

      await batch.commit();
      print('saved');
      Fluttertoast.showToast(msg: 'Saved To Database');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }

  Future updateOrder(
      {@required PaidOrderModel paidOrder, @required String id}) async {
    bool doneWith = false;
    try {
      print('saving');
      print(id);
      print('saving');

      paidOrder.orders.forEach((element) {
        Map data = element;
        String status = data['deliveryStatus'];
        if (status == 'Delivered To Buyer') {
          doneWith = true;
        } else {
          doneWith = false;
        }
        print(doneWith);
      });

      await productOrdersRef.doc(id).update({
        'orders': paidOrder.orders,
        'doneWith': doneWith,
      });
      print('Updated!!');
      Fluttertoast.showToast(msg: 'Updated!!');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }

  Future updateProduct({
    @required String name,
    @required String id,
    @required int price,
  }) async {
    print(id);
    try {
      print('saving');
      await productRef.doc(id).update({
        'productName': name,
        'productPrice': price,
      });
      print('Updated!!');
      Fluttertoast.showToast(msg: 'Updated!!');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }

  Future deleteProduct({@required String id}) async {
    print(id);
    try {
      print('Deleted');
      await productRef.doc(id).delete();
      print('Deleted!!');
      Fluttertoast.showToast(msg: 'Deleted!!');
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: '$err');
    }
  }

  Future<void> makePartneredShop({@required String shopName}) async {
    try {
      await shopCollection
          .where('shopName', isEqualTo: shopName)
          .get()
          .then((shop) async {
        print(shop.docs.length);

        /// since there can be only one shop with a particular name "shop.docs"
        /// will return an array of one element. So we'll just take the first
        String shopId = shop.docs[0].id;

        await shopCollection.doc(shopId).update({
          'isPartner': true,
        });

        Fluttertoast.showToast(msg: 'Done');
      });
    } catch (e, s) {
      print(e);
      print(s);
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Future<void> undoPartneredShop({@required String shopName}) async {
    try {
      await shopCollection
          .where('shopName', isEqualTo: shopName)
          .get()
          .then((shop) async {
        print(shop.docs.length);

        /// since there can be only one shop with a particular name "shop.docs"
        /// will return an array of one element. So we'll just take the first
        String shopId = shop.docs[0].id;

        await shopCollection.doc(shopId).update({
          'isPartner': false,
        });

        Fluttertoast.showToast(msg: 'Undo Done');
      });
    } catch (e, s) {
      print(e);
      print(s);
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }
}
