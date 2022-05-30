import 'package:shared_preferences/shared_preferences.dart';

void setNewTitle (String newTitle, String desc, String date) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("Received date: $date");
  for (String keyDate in prefs.getStringList("keys") ?? []) {
    if (keyDate == date) {
      print("Date matches");
      List<String> newList = [newTitle, desc];
      prefs.setStringList(keyDate, newList);
    }
  }
}