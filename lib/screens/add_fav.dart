import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFav extends StatefulWidget {

  final String data;

  const AddFav({Key? key, required this.data}) : super(key: key);

  @override
  State<AddFav> createState() => _AddFavState();
}

class _AddFavState extends State<AddFav> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    descController.text = widget.data;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.favorite_rounded, color: Colors.white, size: 30.0,),
            SizedBox(width: 20.0,),
            Text("Add a Favourite"),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0,),
                      Row(
                        children: const [
                          Text("Add a Title:", style: TextStyle(fontSize: 25.0),),
                          Spacer(),
                        ],
                      ),
                      const SizedBox(height: 20.0,),
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.title, color: Colors.black87,),
                          label: Text("Title"),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amberAccent),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amberAccent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      Row(
                        children: const [
                          Text("Your Copied Text:", style: TextStyle(fontSize: 25.0),),
                          Spacer(),
                        ],
                      ),
                      const SizedBox(height: 20.0,),
                      TextField(
                        controller: descController,
                        enabled: false,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.title, color: Colors.black87,),
                          label: Text("Copied Text"),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amberAccent, width: 0.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40.0,),
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
                        onPressed: () async {
                          if (titleController.text.isNotEmpty && descController.text.isNotEmpty) {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            DateTime now = DateTime.now();
                            List<String> tempList = [titleController.text, descController.text];
                            prefs.setStringList(now.toString(), tempList);
                            List<String> keysList = prefs.getStringList("keys") ?? [];
                            keysList.add(now.toString());
                            prefs.setStringList("keys", keysList);
                            print("Saved");
                            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                          }
                        },
                      ),
                      const SizedBox(height: 20.0,),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
