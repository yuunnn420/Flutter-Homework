import 'package:flutter/material.dart';
import '../screen/home_page.dart';
import '../provider/favorite_provider.dart';
import '../speech/socket_tts.dart';
import '../speech/sound_player.dart';

class RestaurantCard extends StatefulWidget {
  const RestaurantCard({
    Key? key,
    required this.id,
    required this.imagePath,
    required this.title,
    required this.plot,
  }) : super(key: key);

  final String id;
  final String imagePath;
  final String title;
  final String plot;

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

typedef ColorCallback = void Function(Color color);

class _RestaurantCardState extends State<RestaurantCard> {
  final player = SoundPlayer();

  @override
  void initState() {
    super.initState();
    player.init();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

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
                              icon: const Icon(
                                Icons.search, // Flutter 內建的搜尋 icon
                              ),
                              onPressed: () async {
                                String strings = widget.title;
                                // 如果為空則 return
                                if (strings.isEmpty) return;
                                // connect to text2speech socket
                                if (recognitionLanguage == 'Taiwanese') {
                                  await Text2Speech()
                                      .connect(play, strings, "taiwanese");
                                } else {
                                  await Text2Speech()
                                      .connect(play, strings, "chinese");
                                }
                              },
                            ),
                            IconButton(
                              onPressed: () async {
                                provider.toggleFavorite(widget);
                              },
                              icon: provider.isExist(widget)
                                  ? const Icon(Icons.favorite,
                                      color: Colors.red)
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

  Future play(String pathToReadAudio) async {
    await player.play(pathToReadAudio);
    setState(() {
      player.init();
      player.isPlaying;
    });
  }
}
