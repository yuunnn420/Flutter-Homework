import 'package:flutter/material.dart';
import '../provider/favorite_provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final favoriteRestaurants = provider.favoriteRestaurants;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(fontSize: 30)),
      ),
      body: favoriteRestaurants.isEmpty
          ? const Center(
          child: Text("Add restaurant to display here.",
              style: TextStyle(fontSize: 20)))
          : ListView.builder(
        itemCount: favoriteRestaurants.length,
        itemBuilder: (context, index) {
          return favoriteRestaurants[index];
        },
      ),
    );
  }
}
