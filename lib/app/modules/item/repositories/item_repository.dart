import 'package:flutter/material.dart';

abstract class ItemRepository {
  Stream<dynamic> fetchItems();
  checkItem(item);
  deleteItem(item, BuildContext context);
  doneAll();
  removeAllDone();
  saveItem(globalKey, itemTextEditingController);
}
