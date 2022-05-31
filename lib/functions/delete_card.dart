import 'package:shared_preferences/shared_preferences.dart';

void deleteCard (String date) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  for (String keyDate in prefs.getStringList("keys") ?? []) {
    if (keyDate == date) {
      try {
        List<String> dateKeyList = prefs.getStringList("keys") ?? [];
        if (dateKeyList.contains(keyDate)) {
          print("Keydate $keyDate is removed");
          dateKeyList.remove(keyDate);
        }
        prefs.setStringList("keys", dateKeyList);
        prefs.remove(keyDate);
      } catch (e, s) {
        print("Error in removing key from date list: $s");
      }
    }
  }
}