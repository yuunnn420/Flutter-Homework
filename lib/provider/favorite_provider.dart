import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../restaurant/restaurant_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../restaurant/restaurant.dart';
import '../screen/home_page.dart';

class FavoriteProvider extends ChangeNotifier {
  late final List<Restaurant> fav;
  late List<RestaurantCard> favoriteRestaurants;

  Future<void> loadValue() async {
    final res_fav = await http.post(
      Uri.parse('http://34.80.56.204:5000/get_data'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String?>{
        'value': 'Favorite',
      }),
    );

    if (res_fav.statusCode == 200) {
      final json = jsonDecode(res_fav.body);
      final res = json
          .map<Restaurant>((result) => Restaurant.fromJson(result))
          .toList();
      fav = res as List<Restaurant>;
    } else {
      throw Exception('Failed to load favorite restaurant: ${res_fav.body}');
    }

    favoriteRestaurants = [];
    for (int i = 0; i < fav.length; i++) {
      favoriteRestaurants.add(RestaurantCard(
        id: fav[i].id,
        imagePath: fav[i].imagePath,
        title: fav[i].title,
        plot: fav[i].title,
      ));
    }
    notifyListeners();
  }

  FavoriteProvider() {
    loadValue();
  }

  void toggleFavorite(RestaurantCard card) async {
    if (isExist(card)) {
      for (int i = 0; i < favoriteRestaurants.length; i++)
        if (favoriteRestaurants[i].id == card.id)
          favoriteRestaurants.remove(favoriteRestaurants[i]);
      notifyListeners();
      await http.post(
        Uri.parse('http://34.80.56.204:5000/rm_fav'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{'id': card.id}),
      );
    } else {
      favoriteRestaurants.add(card);
      notifyListeners();
      await http.post(
        Uri.parse('http://34.80.56.204:5000/add_fav'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String?>{'id': card.id, 'location': selectedCategory}),
      );
    }
  }

  bool isExist(RestaurantCard card) {
    for (int i = 0; i < favoriteRestaurants.length; i++) {
      if (favoriteRestaurants[i].id == card.id) {
        return true;
      }
    }
    return false;
  }

  void clearFavorite() {
    favoriteRestaurants = [];
    notifyListeners();
  }

  static FavoriteProvider of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<FavoriteProvider>(
      context,
      listen: listen,
    );
  }
}
