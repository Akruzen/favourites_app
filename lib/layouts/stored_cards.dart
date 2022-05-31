import 'package:favourites_app/screens/main.dart';
import 'package:flutter/material.dart';

import 'edit_card.dart';

Widget getStoredCard(String text, String description, String date, BuildContext context) {
  return GestureDetector(
    onLongPress: () {
      Route route = MaterialPageRoute(builder: (context) => EditCard(oldTitle: text, date: date, desc: description,));
      Navigator.push(context, route).then((_) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())));
    },
    child: Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(text, style: const TextStyle(color: Colors.black, fontSize: 25.0),),
            const SizedBox(height: 10.0,),
            Text(description),
            const SizedBox(height: 5.0,),
            Text("Created on: $date", style: const TextStyle(color: Colors.grey, fontSize: 10.0),),
          ],
        ),
      ),
    ),
  );
}