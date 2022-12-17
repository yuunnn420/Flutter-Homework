import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../restaurant/restaurant_card.dart';

class FavoriteProvider extends ChangeNotifier {
  List<RestaurantCard> _favoriteRestaurants = [];
  List<RestaurantCard> get favoriteRestaurants => _favoriteRestaurants;

  void toggleFavorite(RestaurantCard card) {
    final isExist = _favoriteRestaurants.contains(card);
    if (isExist) {
      _favoriteRestaurants.remove(card);
    } else {
      _favoriteRestaurants.add(card);
    }
    notifyListeners();
  }

  bool isExist(RestaurantCard card) {
    final isExist = _favoriteRestaurants.contains(card);
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