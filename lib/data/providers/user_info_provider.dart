import 'package:flutter/material.dart';

class UserInfoProvider extends ChangeNotifier {
  UserInfoProvider({
    this.userId = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    
  });

  String userId;
  String firstName;
  String lastName;
  String email;


  void updateUserId({required String value}) {
    userId = value;
    notifyListeners();
  }

  void updateFirstName({required String value}) {
    firstName = value;
    notifyListeners();
  }

  void updateLastName({required String value}) {
    lastName = value;
    notifyListeners();
  }

  void updateEmail({required String value}) {
    email = value;
    notifyListeners();
  }


  Map<String, dynamic> getUserInfo() {
    return {
      'userId': userId,
      'userFirstName': firstName,
      'userLastName': lastName,
      'userEmail': email,
    };
  } 

}