import 'package:favourites_app/functions/check_image.dart';
import 'package:favourites_app/functions/delete_card.dart';
import 'package:favourites_app/main.dart';
import 'package:favourites_app/screens/view_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    else if (description.contains("http://") || description.contains("https://")) {
      return const Icon(Icons.web_outlined, size: 40.0, color: Colors.pinkAccent,);
    }
    else {
      print("Image doesn't exist");
      return const Icon(Icons.text_fields_rounded, size: 40.0, color: Colors.indigoAccent,);
      // return Text(description);
    }
  }

  Widget checkAndLoadText () {
    if (description.length > 15) {
      String newDesc = "...${description.substring(description.length - 15)}";
      return Text(newDesc, maxLines: 1, overflow: TextOverflow.ellipsis,);
    }
    else {
      return Text(description, maxLines: 1, overflow: TextOverflow.ellipsis,);
    }
  }

  Widget checkAndLoadTitle () {
    if (text.length > 10) {
      String newTitle = "...${text.substring(text.length - 10)}";
      return Text(newTitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.titilliumWeb(textStyle: const TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: "Montserrat")),);
    }
    else {
      return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.titilliumWeb(textStyle: const TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: "Montserrat")),);
    }
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
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewCard(title: text, date: date, desc: description)));
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
              const SizedBox(height: 5.0,),
              TextButton(
                onPressed: () {
                  deleteCard(date);
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
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
                        Icon(Icons.delete_forever_rounded, color: Colors.orange,),
                        SizedBox(width: 15.0,),
                        Text("Delete", style: TextStyle(color: Colors.black, fontSize: 15.0),),
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
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
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
                checkAndLoadTitle(),
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