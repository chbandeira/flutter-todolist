import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertodolist/app/core/utils/constants.dart';
import 'package:fluttertodolist/app/core/utils/route_names.dart';
import 'package:fluttertodolist/app/modules/home/components/home_drawer.dart';
import 'package:fluttertodolist/app/modules/item/repositories/item_repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _itemRepository = Modular.get<ItemRepository>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.title),
      ),
      drawer: HomeDrawer(),
      body: StreamBuilder(
          stream: _itemRepository.fetchItems(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return ListView.separated(
                itemBuilder: (context, index) {
                  var item = snapshot.data.documents[index];
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
                    onTap: () => _itemRepository.checkItem(item),
                    onLongPress: () =>
                        _itemRepository.deleteItem(item, context),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: snapshot.data.documents.length);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Modular.to.pushNamed(RouteNames.item),
        tooltip: 'New Item',
        child: Icon(Icons.add),
      ),
    );
  }
}
