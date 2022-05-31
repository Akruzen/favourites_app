import 'dart:async';

import 'package:favourites_app/layouts/edit_card.dart';
import 'package:favourites_app/layouts/stored_cards.dart';
import 'package:favourites_app/screens/add_fav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: "Montserrat"),
    home: const HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile>? _sharedFiles;
  String? _sharedText;
  List<Widget> storedCards = [];
  String data = "Null";

  bool _isSnackBarActive = false;

  void showCustomSnackBar (String message) {
    if (!_isSnackBarActive) {
      _isSnackBarActive = true;
      final snackBar = SnackBar(
        content: Text(message),
        action: SnackBarAction(label: "Got it", onPressed: () {},),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((SnackBarClosedReason reason) {_isSnackBarActive = false;});
    }
  }

  void addToList (String text) {
    print("Inside function");
    var now = DateTime.now();
    setState((){
      storedCards.add(getStoredCard(_sharedText ?? "Add Title", "www.google.co.in", now.toString(), context));
    });
    print(storedCards);
  }

  void showCards() async {
    storedCards.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String dateKey in prefs.getStringList("keys") ?? []) {
      List<String> cardParams = prefs.getStringList(dateKey) ?? ["Null", "Null"];
      storedCards.add(getStoredCard(cardParams[0], cardParams[1], dateKey, context));
    }
  }

  @override
  void initState() {
    super.initState();
    showCards();
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      _sharedFiles = value;
      String path = _sharedFiles?.map((f) => f.path).join(",") ?? "";
      print("Shared Image in memory: ${_sharedFiles?.map((f) => f.path).join(",") ?? ""}");
      print("Printing to String when app in memory: $path");
      if (value.isNotEmpty) {
        Route route = MaterialPageRoute(builder: (context) => AddFav(data: path));
        Navigator.pushReplacement(context, route);
      }
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      _sharedFiles = value;
      String path = _sharedFiles?.map((f) => f.path).join(",") ?? "";
      print("Shared Image app is closed: ${_sharedFiles?.map((f) => f.path).join(",") ?? ""}");
      print("Printing to String when app closed: $path");
      if (value.isNotEmpty) {
        Route route = MaterialPageRoute(builder: (context) => AddFav(data: path));
        Navigator.pushReplacement(context, route);
      }
    });

    /******************************************************************************************/

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
          if (value.isNotEmpty && value != "") {
            var now = DateTime.now();
            setState(() {
              data = value;
              // storedCards.add(getStoredCard(value, "www.google.co.in", now.toString()));
            });
            _sharedText = value;
            print("Shared in memory text: $_sharedText");
            print(storedCards.toString());
            Route route = MaterialPageRoute(builder: (context) => AddFav(data: value));
            Navigator.pushReplacement(context, route);
          }
        }, onError: (err) {
          print("getLinkStream error: $err");
        });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value != null || value != "") {
        var now = DateTime.now();
        setState(() {
          data = value ?? "Null";
          /*storedCards.add(getStoredCard(value ?? "Add a title", "www.google.co.in", now.toString()));*/
        });
        _sharedText = value;
        print("Shared when closed text: $_sharedText");
        print(storedCards.toString());
      }
      if (value != null) {
        Route route = MaterialPageRoute(builder: (context) => AddFav(data: value));
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          color: Colors.blue[100],
          borderOnForeground: true,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: Colors.blue[200], size: 25.0,),
                const Spacer(),
                const Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 30.0),
                const SizedBox(width: 20.0,),
                Text("FavoSave", style: GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 25.0)),),
                const Spacer(),
                Icon(Icons.circle, color: Colors.blue[200], size: 25.0,)
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.orange,
        icon: Icons.arrow_upward_rounded,
        activeIcon: Icons.arrow_downward_rounded,
        spaceBetweenChildren: 10.0,
        overlayColor: Colors.indigoAccent,
        useRotationAnimation: true,
        children: [
          SpeedDialChild(
            labelWidget: const Text("Refresh Page", style: TextStyle(color: Colors.black),),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
              },
              backgroundColor: Colors.teal,
              child: const Icon(Icons.refresh_rounded, color: Colors.white,),
            ),
          ),
          SpeedDialChild(
            labelWidget: const Text("Clear All", style: TextStyle(color: Colors.black),),
            child: FloatingActionButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                setState(() {
                  storedCards.clear();
                  showCustomSnackBar("Done. All Lists cleared");
                });
              },
              heroTag: "ClearAll",
              backgroundColor: Colors.pinkAccent,
              child: const Icon(Icons.clear_rounded, color: Colors.white,),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.teal[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...storedCards,
              /*ElevatedButton(
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (context) => const EditCard());
                  Navigator.push(context, route);
                },
                child: const Text("Go to edit"),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}

