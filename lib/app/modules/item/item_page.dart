import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertodolist/app/modules/item/repositories/item_repository.dart';

class ItemPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _itemTextController = TextEditingController();
  final _itemRepository = Modular.get<ItemRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Item'),
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: TextFormField(
                    controller: _itemTextController,
                    decoration: InputDecoration(labelText: 'Item description'),
                    validator: (value) {
                      if (value.isEmpty) return 'Type some text for the item';
                      return null;
                    },
                  ),
                ),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _itemRepository.saveItem(
          _formKey,
          _itemTextController,
        ),
        label: Text('Save Item'),
        icon: Icon(Icons.save),
      ),
    );
  }
}
