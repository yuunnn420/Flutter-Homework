import 'package:flutter/material.dart';
import '../provider/favorite_provider.dart';

class RestaurantCard extends StatefulWidget {
  const RestaurantCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.plot,
  }) : super(key: key);

  final String imagePath;
  final String title;
  final String plot;

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Card(
          elevation: 10,
          child: Column(
            children: [
              Flexible(
                flex: 1, //2
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                provider.toggleFavorite(widget);
                              },
                              icon: provider.isExist(widget)
                                  ? const Icon(Icons.favorite, color: Colors.red)
                                  : const Icon(Icons.favorite_border),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Row(children: [Expanded(
                      //   flex: 1,
                      //   child: Text(
                      //     widget.title, textAlign: TextAlign.left,
                      //   ),
                      // )]),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Image.network(widget.imagePath),
              )
            ],
          ),
        ),
      ),
    );
  }
}
