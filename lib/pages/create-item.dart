import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateItem extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _itemTextController = TextEditingController();
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
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _itemTextController,
                    decoration: InputDecoration(labelText: 'Item description'),
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Please enter some text to the item';
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Save Item'),
                        color: Theme.of(context).primaryColor,
                        onPressed: () => _saveItem(context),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  _saveItem(context) {
    if (_formKey.currentState.validate()) {
      var document = Firestore.instance.collection('items').document();
      Firestore.instance.runTransaction((transaction) async {
        await transaction
            .set(document, {'name': _itemTextController.text, 'done': false});
      });
      Navigator.of(context).pop();
    }
  }
}
