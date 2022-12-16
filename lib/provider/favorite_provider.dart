import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../restaurant/restaurant_card.dart';

class FavoriteProvider extends ChangeNotifier {
  List<RestaurantCard> _favoriteRestaurants = [];
  List<RestaurantCard> get words => _favoriteRestaurants;

  void toggleFavorite(RestaurantCard word) {
    final isExist = _favoriteRestaurants.contains(word);
    if (isExist) {
      _favoriteRestaurants.remove(word);
    } else {
      _favoriteRestaurants.add(word);
    }
    notifyListeners();
  }

  bool isExist(RestaurantCard word) {
    final isExist = _favoriteRestaurants.contains(word);
    return isExist;
  }

  void clearFavorite() {
    _favoriteRestaurants = [];
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