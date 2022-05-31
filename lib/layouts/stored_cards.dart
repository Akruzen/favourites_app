import 'package:favourites_app/functions/check_image.dart';
import 'package:favourites_app/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as io;

import 'edit_card.dart';

Widget getStoredCard(String text, String description, String date, BuildContext context) {


  Widget showContent () {
    if (io.File(description).existsSync()) {
      print("Image exists");
      return Container(
        height: 80.0,
        width: 80.0,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: loadImage(description),
            )
        ),
      );
    }
    else {
      print("Image doesn't exist");
      return const Icon(Icons.text_fields_rounded);
      // return Text(description);
    }
  }

  Widget checkAndLoadText () {
    if (!io.File(description).existsSync()) {
      return Text(description, maxLines: 1, overflow: TextOverflow.ellipsis,);
    }
    return const Text("No Description");
  }

  return GestureDetector(
    onTap: () async {
      if (io.File(description).existsSync()) {
        OpenFile.open(description);
      }
      else if (description.contains("http://") || description.contains("https://")) {
        try {
          Uri uri = Uri.parse(description);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
          else {
            throw "Could not launch uri";
          }
        } catch (e, s) {
          print(s);
        }
      }
    },
    onLongPress: () {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Choose an action: "),
          contentPadding: const EdgeInsets.all(10.0),
          backgroundColor: Colors.teal[50],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {},
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: const [
                        Icon(Icons.visibility_rounded, color: Colors.orange,),
                        SizedBox(width: 15.0,),
                        Text("View", style: TextStyle(color: Colors.black, fontSize: 15.0),),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5.0,),
              TextButton(
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (context) => EditCard(oldTitle: text, date: date, desc: description,));
                  Navigator.push(context, route).then((_) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: const [
                        Icon(Icons.edit_rounded, color: Colors.orange,),
                        SizedBox(width: 15.0,),
                        Text("Edit", style: TextStyle(color: Colors.black, fontSize: 15.0),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      );
    },
    child: Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Column(
              children: [
                showContent(),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Text(text, style: const TextStyle(color: Colors.black, fontSize: 25.0), maxLines: 1,),
                const SizedBox(height: 10.0,),
                checkAndLoadText(),
                const SizedBox(height: 5.0,),
                Text("Created on: $date", style: const TextStyle(color: Colors.grey, fontSize: 10.0),),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}