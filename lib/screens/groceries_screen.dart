import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:shopping_list/data/category.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_grocery_item_screen.dart';
import 'package:http/http.dart' as http;

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({super.key});

  @override
  State<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  final List<GroceryItem> groceryItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGroceryItems();
  }

  void fetchGroceryItems() async {
    var url = Uri.parse('http://10.0.2.2:5000/api/grocery_items');
    var response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      for (var item in jsonResponse) {
        var category =
            Categories.values.firstWhere((e) => e.name == item['category']);

        GroceryItem groceryItem = GroceryItem(
            id: item['id'].toString(),
            name: item['name'],
            quantity: item['quantity'],
            category: categories[category]!);

        setState(() {
          groceryItems.add(groceryItem);
        });
      }
      isLoading = false;
    }
  }

  Future<bool> deleteGroceryItem(GroceryItem groceryItem) async {
    var url = Uri.parse('http://10.0.2.2:5000/api/grocery_item');
    var response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: convert.json.encode({'id': groceryItem.id}),
    );

    if (response.statusCode == 200) {
      onDismissed(groceryItem);
    }
    return false;
  }

  void onDismissed(item) {
    setState(() {
      groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text('No data'),
    );

    if (isLoading) {
      content = Center(
        child: CircularProgressIndicator(),
      );
    }

    if (groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) => Dismissible(
          key: ValueKey(groceryItems[index].id),
          background: Container(
            color: Colors.red.withAlpha(155),
            child: Icon(Icons.delete_forever, size: 32),
          ),
          onDismissed: (direction) => deleteGroceryItem(groceryItems[index]),
          child: ListTile(
            leading: Icon(Icons.square),
            iconColor: groceryItems[index].category.color,
            title: Text(groceryItems[index].name),
            trailing: Text(
              groceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Groceries'),
        actions: [
          IconButton(
              onPressed: () async {
                GroceryItem? newGroceryItem = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NewGroceryItemScreen(),
                  ),
                );

                if (newGroceryItem != null) {
                  setState(() {
                    groceryItems.add(newGroceryItem);
                  });
                }
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: content,
    );
  }
}
