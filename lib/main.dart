import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO list',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'TODO list'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.assignment_turned_in),
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection("items")
              .orderBy("name")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return ListView.separated(
                itemBuilder: (context, index) {
                  DocumentSnapshot item = snapshot.data.documents[index];
                  bool isDone = item['done'];
                  return ListTile(
                    leading: isDone
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.remove_circle_outline),
                    title: Text(
                      item['name'],
                      style: TextStyle(
                        fontSize: 18,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    onTap: () => _checkItem(item),
                    onLongPress: () => _deleteItem(item, context),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: snapshot.data.documents.length);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreateItem())),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _checkItem(DocumentSnapshot item) async {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snap = await transaction.get(item.reference);
      await transaction.update(snap.reference, {'done': !snap['done']});
    });
  }

  _deleteItem(DocumentSnapshot item, BuildContext context) async {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snap = await transaction.get(item.reference);
      await transaction.delete(snap.reference);
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('${snap['name']} was deleted')),
      );
    });
  }
}

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
