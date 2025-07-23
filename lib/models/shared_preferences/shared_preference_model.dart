import 'package:shared_preferences/shared_preferences.dart';
import 'package:reflexionary_frontend/models/shared_preferences/preferences_key.dart';

class SharedPreferenceModel{
  late SharedPreferences sharedPreferences;

  // Obtain the shared pref keys
  List preferencesKey = PreferencesKey().preferencesKey;

  //=======================USER LOGIN STATUS=========================================
  // Set user login states i.e. user has logged in or out
  void setUserLoginStatus(bool userStatus) async{
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(preferencesKey[0], userStatus);
  }

  // Retrieve user login status
  Future<bool?> retrieveUserLoginStatus() async{
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(preferencesKey[0]);
  }
  //================================================================================

  //=======================PUSH NOTIFICATION STATUS================================
  // Set push notification status
  void setPushNotificationStatus(bool pushNotificationStatus) async{
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(preferencesKey[1], pushNotificationStatus);
  }

  // retrieve push notification status
  Future<bool?> retrievePushNotificationStatus() async{
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(preferencesKey[1]);
  }
  //===============================================================================

  //=========================EMAIL NOTIFICATION STATUS=============================
  // Set email notification status
  void setEmailNotificationStatus(bool emailNotificationStatus) async{
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(preferencesKey[2], emailNotificationStatus);
  }

  // retrieve email notification status
  Future<bool?> retrieveEmailNotificationStatus() async{
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(preferencesKey[2]);
  }
  //===============================================================================

  //=============================NEWS AND UPDATES==================================
  // Set newsAndUpdates notification status
  void setNewsAndUpdatesNotificationStatus(bool newsAndUpdatesNotificationStatus) async{
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(preferencesKey[3], newsAndUpdatesNotificationStatus);
  }

  // retrieve newsAndUpdates notification status
  Future<bool?> retrieveNewsAndUpdatesNotificationStatus() async{
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(preferencesKey[3]);
  }
  //===============================================================================
}