import 'package:chat_app/Screens/login_page.dart';
import 'package:chat_app/Screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Authenticate extends StatelessWidget {
  Authenticate({Key? key}) : super(key: key);


  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    if(_auth.currentUser != null){
      return const MainScreen();
    }else{
      return const LoginPage();
    }
  }
}
