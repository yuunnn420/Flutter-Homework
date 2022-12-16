import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screen/favorite_page.dart';
import 'screen/home_page.dart';
import 'provider/favorite_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/favorite': (context) => FavoritePage(),
        },
      ),
    );
  }
}
