import 'package:shared_preferences/shared_preferences.dart';

class IdService {
  late int entryId;
  late int userId;

  IdService() {
    SharedPreferences
        .getInstance()
        .then((value) {
          entryId = value.getInt("entryId") ?? 0;
          userId = value.getInt("userId") ?? 0;
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
    userId++;
    SharedPreferences
        .getInstance()
        .then((value) {
      value.setInt("userId", userId);
    });

    return userId;
  }
}