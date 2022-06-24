import 'package:flutter/material.dart';
import 'package:inventory_second/Interface/User_interface.dart';

class MainProvider extends ChangeNotifier {
  User? currentUser;
  setUser(User? user) {
    this.currentUser = user;
    notifyListeners();
  }

  getUser() {
    return this.currentUser;
  }
}
