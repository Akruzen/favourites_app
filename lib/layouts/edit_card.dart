import 'package:favourites_app/functions/set_new_title.dart';
import 'package:flutter/material.dart';

class EditCard extends StatefulWidget {

  final String oldTitle;
  final String date;
  final String desc;

  const EditCard({Key? key, required this.oldTitle, required this.date, required this.desc}) : super(key: key);

  @override
  State<EditCard> createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {

  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    titleController.text = widget.oldTitle;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orangeAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.edit_rounded, color: Colors.white, size: 30.0,),
            SizedBox(width: 20.0,),
            Text("Edit Card"),
          ],
        ),
      ),
      backgroundColor: Colors.teal[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.title, color: Colors.black87,),
                          label: Text("Title"),
                          labelStyle: TextStyle(color: Colors.teal),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amberAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amberAccent),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amberAccent),
                          ),
                        ),
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
                        icon: const Icon(Icons.thumb_up_alt_rounded, color: Colors.white,),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0),
                          child: Text("Save!"),
                        ),
                        onPressed: () {
                          if (titleController.text.isNotEmpty) {
                            setNewTitle(titleController.text, widget.desc, widget.date);
                            Navigator.pop(context);
                          }
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
