import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' as io;

import '../functions/check_image.dart';
import '../functions/custom_snackbar.dart';

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
