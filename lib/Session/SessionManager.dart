// ignore_for_file: file_names

import 'package:ny_shop/Models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  late SharedPreferences? sharedPreferences;
  User? user;

  SessionManager._privateConstructor();
  static final SessionManager _instance = SessionManager._privateConstructor();
  factory SessionManager() {
    return _instance;
  }

  getSessionManager() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  createSession(User user) {
    this.user = user;
    sharedPreferences!.setStringList('user', user.toList());
  }

  loadSession() async {
    List<String> userData = sharedPreferences!.getStringList('user')!;
    user = User(
      userData[0],
      userData[1] == '' ? null : userData[1],
      userData[2] == '' ? null : userData[2],
      userData[3] == '' ? null : userData[3],
      userData[4] == '' ? null : userData[4],
      userData[5] == '' ? null : userData[5],
      userData[6] == '' ? null : userData[6],
      userData[7] == '' ? null : userData[7],
    );
  }

  bool notFirstTime() {
    return sharedPreferences!.containsKey('notFirstTime'); //true if there
  }

  changeStatus() {
    sharedPreferences!.setString('notFirstTime', true.toString());
  }

  bool isLoggedIn() {
    return sharedPreferences!.containsKey('user');
  }

  createPreferredTheme(bool theme) {
    sharedPreferences!.setString('theme', theme.toString());
  }

  bool loadPreferredTheme() {
    return sharedPreferences!.get('theme') == 'true';
  }

  createPreferredLanguage(String lang) {
    sharedPreferences!.setString('lang', lang);
  }

  String? loadPreferredLanguage() {
    return sharedPreferences!.getString('lang');
  }

  logout() {
    user = null;
    sharedPreferences!.remove('user');
  }

  void changeUserInfo(String? phoneNumber, String? latitude, String? longitude,
      String? address) {
    user?.phoneNumber = phoneNumber != null && phoneNumber != ''
        ? phoneNumber
        : user?.phoneNumber;
    user?.latitude =
        latitude != null && latitude != '' ? latitude : user?.latitude;
    user?.longitude =
        longitude != null && longitude != '' ? longitude : user?.longitude;
    user?.address = address != null && address != '' ? address : user?.address;

    sharedPreferences!.setStringList('user', user!.toList());
    List<String> userData = sharedPreferences!.getStringList('user')!;
    user = User(
      userData[0],
      userData[1] == '' ? null : userData[1],
      userData[2] == '' ? null : userData[2],
      userData[3] == '' ? null : userData[3],
      userData[4] == '' ? null : userData[4],
      userData[5] == '' ? null : userData[5],
      userData[6] == '' ? null : userData[6],
      userData[7] == '' ? null : userData[7],
    );
  }

//ToDo: Future V2
// bool needyIsBookmarked(String id) {
//   if (sharedPreferences.containsKey('Bookmarks')) {
//     List<String> bookmarks = sharedPreferences.getStringList('Bookmarks');
//     return bookmarks.contains(id);
//   }
//   return false;
// }

//ToDo: Future V2
// void addNeedyToBookmarks(String id) {
//   if (sharedPreferences.containsKey('Bookmarks')) {
//     List<String> bookmarks = sharedPreferences.getStringList('Bookmarks');
//     if (bookmarks.contains(id))
//       bookmarks.remove(id);
//     else
//       bookmarks.add(id);
//     print(bookmarks);
//     sharedPreferences.setStringList('Bookmarks', bookmarks);
//     return;
//   }
//   sharedPreferences.setStringList('Bookmarks', [id]);
// }

//ToDo: Future V2
// bool hasAnyBookmarked() {
//   print('bookMarks ${sharedPreferences.getStringList('Bookmarks')}');
//   if (sharedPreferences.getStringList('Bookmarks') == null) return false;
//   return sharedPreferences.getStringList('Bookmarks').isNotEmpty;
// }
//
// List<String> getBookmarkedNeedies() {
//   return sharedPreferences.getStringList('Bookmarks');
// }
}
