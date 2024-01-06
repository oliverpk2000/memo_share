import 'package:shared_preferences/shared_preferences.dart';

class IdService {
  int entryId = 0;
  int userId = 0;

  Future<void> init() async {
    await SharedPreferences
        .getInstance()
        .then((value) {
      entryId = value.getInt("entryId") ?? 0;
      userId = value.getInt("userId") ?? 0;
      print("Hello");
    });
  }

  int newEntryId() {
   entryId++;
   SharedPreferences
       .getInstance()
       .then((value) {
        value.setInt("entryId", entryId);
   });

   return entryId;
  }

  newUserId() {
    print("Hello 2");
    userId++;
    SharedPreferences
        .getInstance()
        .then((value) {
      value.setInt("userId", userId);
    });

    return userId;
  }

  removeUserId() {
    userId--;
    SharedPreferences
        .getInstance()
        .then((value) {
      value.setInt("userId", userId);
    });
  }
}