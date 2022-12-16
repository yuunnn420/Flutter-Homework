import 'dart:async';
import 'dart:convert';
import 'restaurant.dart';
import 'package:http/http.dart' as http;

class CategoryModel {
  static Future<List<Restaurant>> getRestaurant(
      String? selectedCategory) async {
    final res = await http.post(
      Uri.parse('http://172.20.10.6:30011/get_data'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String?>{
        'value': selectedCategory,
      }),
    );

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return json
          .map<Restaurant>((result) => Restaurant.fromJson(result))
          .toList();
    } else {
      throw Exception('Failed to load restaurant: ${res.body}');
    }
  }
}