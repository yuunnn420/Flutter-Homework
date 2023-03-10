import 'package:flutter/material.dart';
import '../restaurant/restaurant_card.dart';
import '../restaurant/restaurant.dart';
import '../restaurant/category_model.dart';

import 'dart:io';
import '../speech/sound_recorder.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../speech/socket_stt.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

String? selectedCategory = 'Taipei';
String recognitionLanguage = "Taiwanese";

class _HomePageState extends State<HomePage> {
  String searchString = '';
  List<String> locations = ['Taipei', 'Chiayi', 'Hwalian', 'Tainan', 'Bangkok'];
  late final Future taipeiFuture,
      chiayiFuture,
      hwalianFuture,
      tainanFuture,
      bangkokFuture;

  // get SoundRecorder
  final recorder = SoundRecorder();

  // Declare TextEditingController to get the value in TextField
  TextEditingController taiwaneseController = TextEditingController();
  TextEditingController chineseController = TextEditingController();
  TextEditingController recognitionController = TextEditingController();

  Future getFuture(String? selectedCategory) {
    if (selectedCategory == 'Taipei')
      return taipeiFuture;
    else if (selectedCategory == 'Chiayi')
      return chiayiFuture;
    else if (selectedCategory == 'Hwalian')
      return hwalianFuture;
    else if (selectedCategory == 'Tainan')
      return tainanFuture;
    else
      return bangkokFuture;
  }

  @override
  void initState() {
    super.initState();
    recorder.init();
    taipeiFuture = CategoryModel.getRestaurant('Taipei');
    chiayiFuture = CategoryModel.getRestaurant('Chiayi');
    hwalianFuture = CategoryModel.getRestaurant('Hwalian');
    tainanFuture = CategoryModel.getRestaurant('Tainan');
    bangkokFuture = CategoryModel.getRestaurant('Bangkok');
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ??????????????????????????????
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: const Text('?????????????????????App', style: TextStyle(fontSize: 30)),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favorite');
              },
              icon: const Icon(Icons.favorite),
            ),
          ]),
      body: Column(
        children: [
          buildRadio(),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Row(children: [
                Flexible(child: buildOutputField()),
                Container(child: buildRecord())
              ])),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                children: [
                  const Text(
                    'Category: ',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  DropdownButton<String>(
                    items: <String>[
                      'Taipei',
                      'Chiayi',
                      'Hwalian',
                      'Tainan',
                      'Bangkok'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      );
                    }).toList(),
                    value: selectedCategory,
                    onChanged: (String? newCategory) {
                      setState(() {
                        selectedCategory = newCategory;
                      });
                    },
                  ),
                ],
              )),
          FutureBuilder(
              future: getFuture(selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final restaurants = snapshot.data as List<Restaurant>;
                  return Expanded(
                      child: ListView.builder(
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      return restaurants
                              .elementAt(index)
                              .title
                              .contains(searchString)
                          ? RestaurantCard(
                              id: restaurants.elementAt(index).id,
                              imagePath: restaurants.elementAt(index).imagePath,
                              title: restaurants.elementAt(index).title,
                              plot: restaurants.elementAt(index).title,
                            )
                          : Container();
                    },
                  ));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }

  // build the button of recorder
  Widget buildRecord() {
    // whether is recording
    final isRecording = recorder.isRecording;
    // if recording => icon is Icons.stop
    // else => icon is Icons.mic
    final icon = isRecording ? Icons.stop : Icons.mic;
    // if recording => color of button is red
    // else => color of button is white
    final primary = isRecording ? Colors.red : Colors.white;
    // if recording => text in button is STOP
    // else => text in button is START
    final text = isRecording ? 'STOP' : 'START';
    // if recording => text in button is white
    // else => color of button is black
    final onPrimary = isRecording ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        // ?????? Icon ???????????????
        minimumSize: const Size(0, 50),
        primary: primary,
        onPrimary: onPrimary,
      ),
      icon: Icon(icon),
      label: Text(
        text,
        // ????????????????????????????????????bold?????????normal????????????
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      // ??? Icon ???????????????????????????
      onPressed: () async {
        // getTemporaryDirectory(): ????????????????????????????????????????????????????????????????????????????????????
        Directory tempDir = await path_provider.getTemporaryDirectory();
        // define file directory
        String path = '${tempDir.path}/SpeechRecognition.wav';
        // ?????????????????????????????????
        await recorder.toggleRecording(path);
        // When stop recording, pass wave file to socket
        if (!recorder.isRecording) {
          if (recognitionLanguage == "Taiwanese") {
            // if recognitionLanguage == "Taiwanese" => use Minnan model
            // setTxt is call back function
            // parameter: wav file path, call back function, model
            await Speech2Text().connect(path, setTxt, "Minnan");
            // glSocket.listen(dataHandler, cancelOnError: false);
          } else {
            // if recognitionLanguage == "Chinese" => use MTK_ch model
            await Speech2Text().connect(path, setTxt, "MTK_ch");
          }
        }
        // set state is recording or stop
        setState(() {
          recorder.isRecording;
        });
      },
    );
  }

  // set recognitionController.text function
  void setTxt(taiTxt) {
    setState(() {
      recognitionController.text = taiTxt;
      searchString = taiTxt;
    });
  }

  Widget buildOutputField() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: TextField(
        controller: recognitionController, // ?????? controller
        decoration: const InputDecoration(
          fillColor: Colors.white, // ???????????????????????????filled: true,?????????
          filled: true, // ????????????????????????true???fillColor?????????
        ),
        onChanged: (value) {
          setState(() {
            searchString = value;
          });
        },
      ),
    );
  }

  Widget buildRadio() {
    return Row(children: <Widget>[
      Flexible(
        child: RadioListTile<String>(
          // ??????????????? value
          value: 'Taiwanese',
          // Set option name???color
          title: const Text(
            'Taiwanese',
            style: TextStyle(
              fontSize: 20,
            ),
            // style: TextStyle(color: Colors.white),
          ),
          //  ??????Radio???value???groupValue??????????????? Radio ??????????????????????????????
          groupValue: recognitionLanguage,
          // ??????????????????
          activeColor: Colors.red,
          onChanged: (value) {
            setState(() {
              // ??? recognitionLanguage ?????? Taiwanese
              recognitionLanguage = "Taiwanese";
            });
          },
        ),
      ),
      Flexible(
        child: RadioListTile<String>(
          // ??????????????? value
          value: 'Chinese',
          // Set option name???color
          title: const Text(
            'Chinese',
            style: TextStyle(
              fontSize: 20,
            ),
            // style: TextStyle(color: Colors.white),
          ),
          //  ??????Radio???value???groupValue??????????????? Radio ??????????????????????????????
          groupValue: recognitionLanguage,
          // ??????????????????
          activeColor: Colors.red,
          onChanged: (value) {
            setState(() {
              // ??? recognitionLanguage ?????? Chinese
              recognitionLanguage = "Chinese";
            });
          },
        ),
      ),
    ]);
  }
}
