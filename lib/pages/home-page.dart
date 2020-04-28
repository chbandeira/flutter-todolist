import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertodolist/pages/create-item.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
    this.title,
    this.auth,
  }) : super(key: key);

  final String title;
  final FirebaseAuth auth;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<FirebaseUser> _futureCurrentUser;

  @override
  void initState() {
    super.initState();
    refreshCurrentUser();
  }

  Future<void> refreshCurrentUser() async {
    setState(() {
      _futureCurrentUser = widget.auth.currentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: _buildDrawer(),
      body: StreamBuilder(
          stream: _fetchItems(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
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
          context,
          MaterialPageRoute(builder: (context) => CreateItem()),
        ),
        tooltip: 'New Item',
        child: Icon(Icons.add),
      ),
    );
  }

  Stream<QuerySnapshot> _fetchItems() {
    return Firestore.instance.collection("items").orderBy("name").snapshots();
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

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          FutureBuilder(
            future: _futureCurrentUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data.photoUrl ?? ''),
                  ),
                  accountName: Text(snapshot.data.displayName ?? ''),
                  accountEmail: Text(snapshot.data.email ?? ''),
                );
              }
              return Text('Loading...');
            },
          ),
          ListTile(
            leading: Icon(Icons.done_all),
            title: Text('Done all'),
            onTap: () {
              _doneAll();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.delete_sweep),
            title: Text('Delete all done'),
            onTap: () {
              _removeAllDone();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign out'),
            onTap: () {
              _signOutGoogle();
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  _doneAll() {
    Firestore.instance
        .collection('items')
        .where('done', isEqualTo: false)
        .getDocuments()
        .then((items) {
      for (var item in items.documents) {
        _checkItem(item);
      }
      Navigator.of(context).pop();
    });
  }

  _removeAllDone() async {
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
      Navigator.of(context).pop();
    });
  }

  void _signOutGoogle() async {
    await googleSignIn.signOut();
    Navigator.popUntil(
        context, ModalRoute.withName(Navigator.defaultRouteName));
  }
}
