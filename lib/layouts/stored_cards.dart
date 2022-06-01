import 'package:favourites_app/functions/check_image.dart';
import 'package:favourites_app/functions/delete_card.dart';
import 'package:favourites_app/functions/extension_list.dart';
import 'package:favourites_app/main.dart';
import 'package:favourites_app/screens/view_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;

import 'edit_card.dart';

Widget getStoredCard(String text, String description, String date, BuildContext context) {


  Widget showContent () {
    if (io.File(description).existsSync()) {
      if (getFileType(path.extension(description)) == "image") {
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
      else if (getFileType(path.extension(description)) == "video") {
        return const Icon(Icons.video_file_rounded, size: 30.0, color: Colors.deepPurpleAccent,);
      }
      else if (getFileType(path.extension(description)) == "audio") {
        return const Icon(Icons.audio_file_rounded, size: 30.0, color: Colors.amberAccent,);
      }
      else if (getFileType(path.extension(description)) == "pdf") {
        return const Icon(Icons.picture_as_pdf_rounded, size: 30.0, color: Colors.redAccent,);
      }
      else if (getFileType(path.extension(description)) == "doc") {
        return const Icon(Icons.description_rounded, size: 30.0, color: Colors.blueAccent,);
      }
      else if (getFileType(path.extension(description)) == "ppt") {
        return Icon(Icons.slideshow_rounded, size: 30.0, color: Colors.red[200],);
      }
      else {
        return const Icon(Icons.receipt_rounded, size: 30.0, color: Colors.indigoAccent,);
      }
    }
    else if (description.contains("http://") || description.contains("https://")) {
      return const Icon(Icons.web_outlined, size: 30.0, color: Colors.pinkAccent,);
    }
    else {
      print("Image doesn't exist");
      return const Icon(Icons.text_fields_rounded, size: 30.0, color: Colors.indigoAccent,);
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
    if (text.length > 20) {
      String newTitle = "...${text.substring(text.length - 20)}";
      return Text(newTitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.titilliumWeb(textStyle: const TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: "Montserrat")),);
    }
    else {
      return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.titilliumWeb(textStyle: const TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: "Montserrat")),);
    }
  }

  Future showLongPressDialog () {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Choose an action: "),
          contentPadding: const EdgeInsets.all(10.0),
          backgroundColor: Colors.teal[50],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15.0,),
              TextButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(2.0),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(50.0),
                    )
                  )
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewCard(title: text, date: date, desc: description)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: const [
                      Icon(Icons.visibility_rounded, color: Colors.teal,),
                      SizedBox(width: 15.0,),
                      Text("View", style: TextStyle(color: Colors.black, fontSize: 15.0),),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15.0,),
              TextButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(2.0),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        )
                    )
                ),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (context) => EditCard(oldTitle: text, date: date, desc: description,));
                  Navigator.push(context, route).then((_) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())));
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: const [
                      Icon(Icons.edit_rounded, color: Colors.orange,),
                      SizedBox(width: 15.0,),
                      Text("Edit", style: TextStyle(color: Colors.black, fontSize: 15.0),),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15.0,),
              TextButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(2.0),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        )
                    )
                ),
                onPressed: () {
                  deleteCard(date);
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: const [
                      Icon(Icons.delete_forever_rounded, color: Colors.redAccent,),
                      SizedBox(width: 15.0,),
                      Text("Delete", style: TextStyle(color: Colors.black, fontSize: 15.0),),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15.0,),
            ],
          ),
        )
    );
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
      showLongPressDialog();
    },
    child: Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Row(
          children: [
            Column(
              children: [
                showContent(),
              ],
            ),
            const SizedBox(width: 25.0,),
            Column(
              children: [
                checkAndLoadTitle(),
                //const SizedBox(height: 10.0,),
                // checkAndLoadText(),
                //const SizedBox(height: 5.0,),
                //Text("Created on: ${date.substring(0, 11)}", style: const TextStyle(color: Colors.grey, fontSize: 10.0),),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                showLongPressDialog();
              },
              icon: const Icon(Icons.more_vert_rounded),
            ),
          ],
        ),
      ),
    ),
  );
}