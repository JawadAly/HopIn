import 'package:flutter/material.dart';

class UserInfoProvider extends ChangeNotifier {
  UserInfoProvider({
    this.userId = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.receiveEmailUpdates = false,
  });

  String userId;
  String firstName;
  String lastName;
  String email;
  String password;
  bool receiveEmailUpdates;

  void updateUserId({required String value}) async {
    userId = value;
    notifyListeners();
  }

  void updateFirstName({required String value}) async {
    firstName = value;
    notifyListeners();
  }

  void updateLastName({required String value}) async {
    lastName = value;
    notifyListeners();
  }

  void updateEmail({required String value}) async {
    email = value;
    notifyListeners();
  }

  void updatePassword({required String value}) async {
    password = value;
    notifyListeners();
  }

  printInfo() {
    print(firstName);
    print(lastName);
    print(email);
    print(password);
  }

  getUserInfo() {
    Map<String, dynamic> userInfo = {
      'userId': userId,
      'userFirstName': firstName,
      'userLastName': lastName,
      'userEmail': email,
      'receiveEmailUpdates': receiveEmailUpdates,
    };
    return userInfo;
  }
}
