import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;

import '../functions/check_image.dart';
import '../functions/custom_snackbar.dart';
import '../functions/extension_list.dart';

class ViewCard extends StatefulWidget {

  final String title;
  final String date;
  final String desc;

  const ViewCard({Key? key, required this.title, required this.date, required this.desc}) : super(key: key);

  @override
  State<ViewCard> createState() => _ViewCardState();
}

class _ViewCardState extends State<ViewCard> {

  Widget showContent () {
    if (io.File(widget.desc).existsSync()) {
      if (getFileType(path.extension(widget.desc)) == "image") {
        print("Image exists");
        return Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: loadImage(widget.desc),
              )
          ),
        );
      }
      else if (getFileType(path.extension(widget.desc)) == "video") {
        return const Icon(Icons.video_file_rounded, size: 60.0, color: Colors.deepPurpleAccent,);
      }
      else if (getFileType(path.extension(widget.desc)) == "audio") {
        return const Icon(Icons.audio_file_rounded, size: 60.0, color: Colors.amberAccent,);
      }
      else if (getFileType(path.extension(widget.desc)) == "pdf") {
        return const Icon(Icons.picture_as_pdf_rounded, size: 60.0, color: Colors.redAccent,);
      }
      else if (getFileType(path.extension(widget.desc)) == "doc") {
        return const Icon(Icons.description_rounded, size: 60.0, color: Colors.blueAccent,);
      }
      else if (getFileType(path.extension(widget.desc)) == "ppt") {
        return Icon(Icons.slideshow_rounded, size: 60.0, color: Colors.red[200],);
      }
    }
    return Text(widget.desc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.visibility_rounded, color: Colors.white, size: 30.0,),
            SizedBox(width: 20.0,),
            Text("View Card"),
          ],
        ),
      ),
      backgroundColor: Colors.teal[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(widget.title, style: GoogleFonts.titilliumWeb(textStyle: const TextStyle(color: Colors.black, fontSize: 20.0),)),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 5.0,),
                      Row(
                        children: [
                          Text("Created on: ${widget.date.substring(0, 10)}, at ${widget.date.substring(11, 16)}", style: const TextStyle(color: Colors.blueGrey, fontSize: 15.0),),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 15.0,),
                      Row(
                        children: [
                          showContent(),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 30.0,),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.orange),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.copy_rounded, color: Colors.white,),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
                          child: Text("Copy content to Clipboard"),
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: widget.desc));
                          // Fluttertoast.showToast(msg: "Content copied!");
                          showCustomSnackBar("Content copied to clipboard.", context);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
