import 'dart:convert';

import 'package:flutter/services.dart';

class Category {
  int id;
  String name;
  List<Category> subCategories;
  bool lastParent;
  Category({
    required this.id,
    required this.name,
    required this.subCategories,
    required this.lastParent,
  });
  
  static Future<List<Category>> get mockListCategory async {
    final String response = await rootBundle.loadString('assets/category.json');
    final data = await json.decode(response);

    List<Category> categories = [];

    (data["categories"] as List).forEach((category) {
      categories.add(Category.fromMap(category));
    });

    return categories;
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subCategories': subCategories.map((x) => x.toMap()).toList(),
      'lastParent': lastParent,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      subCategories: List<Category>.from(map['subCategories']?.map((x) => Category.fromMap(x))),
      lastParent: map['lastParent'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) => Category.fromMap(json.decode(source));
}
