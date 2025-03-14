import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_grocery_item_screen.dart';

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({super.key});

  @override
  State<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  final List<GroceryItem> groceryItems = [];

  void onDismissed(item) {
    setState(() {
      groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Groceries'),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => NewGroceryItemScreen(),
                  ),
                )
                    .then(
                  (value) {
                    setState(() {
                      groceryItems.add(value);
                    });
                  },
                );
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: groceryItems.isEmpty
          ? Center(
              key: ValueKey(true),
              child: Text('No data'),
            )
          : ListView.builder(
              itemCount: groceryItems.length,
              itemBuilder: (context, index) => Dismissible(
                key: ValueKey(groceryItems[index]),
                background: Container(
                  color: Colors.red.withAlpha(155),
                  child: Icon(Icons.delete_forever, size: 32),
                ),
                onDismissed: (direction) => onDismissed(groceryItems[index]),
                child: ListTile(
                  leading: Icon(Icons.square),
                  iconColor: groceryItems[index].category.color,
                  title: Text(groceryItems[index].name),
                  trailing: Text(
                    groceryItems[index].quantity.toString(),
                  ),
                ),
              ),
            ),
    );
  }
}
