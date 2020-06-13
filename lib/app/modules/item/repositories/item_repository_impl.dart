import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertodolist/app/modules/item/repositories/item_repository.dart';

class ItemRepositoryImpl implements ItemRepository {
  @override
  checkItem(item) {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snap = await transaction.get(item.reference);
      await transaction.update(snap.reference, {'done': !snap['done']});
    });
  }

  @override
  deleteItem(item, BuildContext context) {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snap = await transaction.get(item.reference);
      await transaction.delete(snap.reference);
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('${snap['name']} was deleted')),
      );
    });
  }

  @override
  Stream fetchItems() {
    return Firestore.instance.collection("items").orderBy("name").snapshots();
  }

  @override
  doneAll() {
    Firestore.instance
        .collection('items')
        .where('done', isEqualTo: false)
        .getDocuments()
        .then((items) {
      for (var item in items.documents) {
        checkItem(item);
      }
      Modular.to.pop();
    });
  }

  @override
  removeAllDone() async {
    Firestore.instance
        .collection('items')
        .where('done', isEqualTo: true)
        .getDocuments()
        .then((items) {
      for (var item in items.documents) {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snap = await transaction.get(item.reference);
          await transaction.delete(snap.reference);
        });
      }
      Modular.to.pop();
    });
  }

  @override
  saveItem(globalKey, itemTextEditingController) {
    if (globalKey.currentState.validate()) {
      var document = Firestore.instance.collection('items').document();
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(document, {
          'name': itemTextEditingController.text.replaceRange(0, 1,
              itemTextEditingController.text.substring(0, 1).toUpperCase()),
          'done': false
        });
      });
      Modular.to.pop();
    }
  }
}
