import 'package:flutter/material.dart';

enum Categories {
  diary,
  fruit,
  meat,
  vegetables,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}

class Category {
  Category(this.name, this.color);
  final String name;
  final Color color;
}
