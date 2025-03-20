import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:shopping_list/data/category.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class NewGroceryItemScreen extends StatefulWidget {
  const NewGroceryItemScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewGroceryItemScreen();
  }
}

class _NewGroceryItemScreen extends State<NewGroceryItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = '';
  int? _enteredQuantity;
  Category _selectedCategory = categories[Categories.vegetables]!;
  bool _isSending = true;

  void _onSave(context) async {
    final snackbar = SnackBar(
      content: Text('Error occured'),
      action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            _onSave(context);
          }),
    );
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    _isSending = true;

    try {
      var url = Uri.parse('http://10.0.2.2:5000/api/grocery_item');
      var response = await http
          .post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: convert.json.encode(
          {
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'category': _selectedCategory.name
          },
        ),
      )
          .timeout(const Duration(seconds: 3), onTimeout: () {
        throw Exception('Request time out');
      });

      if (response.statusCode == 200) {
        Navigator.of(context).pop(
          GroceryItem(
              id: DateTime.now().toString(),
              name: _enteredName,
              quantity: _enteredQuantity!,
              category: _selectedCategory),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }

    _isSending = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add a new item'),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    label: Text(
                      'Name',
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.length > 50) {
                      return "Name must be between 1...50 character long";
                    }
                    return null;
                  },
                  onSaved: (value) => _enteredName = value!,
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              int.tryParse(value) == null ||
                              int.parse(value) < 0) {
                            return "Must be positive number";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Quantity',
                          ),
                        ),
                        onSaved: (value) =>
                            _enteredQuantity = int.parse(value!),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: DropdownButtonFormField(
                      value: _selectedCategory,
                      decoration: InputDecoration(label: Text('Category')),
                      items: categories.entries
                          .map(
                            (item) => DropdownMenuItem(
                              value: item.value,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.square,
                                    color: item.value.color,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(item.value.name),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        _selectedCategory = value!;
                      },
                    ))
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: Text('Reset'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _onSave(context);
                        },
                        child: Text('Save'))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
