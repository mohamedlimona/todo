import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_firebase/core/services/check_connection.dart';
import 'package:todo_firebase/core/view_model/addtask_view_model.dart';
import 'package:todo_firebase/core/view_model/auth_viewmodel.dart';
import 'package:todo_firebase/core/view_model/home_viewmodel.dart';
import 'package:todo_firebase/view/auth/authscreen.dart';
import 'dart:ui';
import 'package:todo_firebase/view/screens/home.dart';

void main() => runApp(MultiProvider(
providers: [
ChangeNotifierProvider(create: (_) => Addtask_viewmodel()),
  ChangeNotifierProvider(create: (_) => Auth_viewmodel()),
  ChangeNotifierProvider(create: (_) => Home_viewmodel()),
  ChangeNotifierProvider(create: (_) => check_Internet()),
],
child:new MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
      StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, usersnapshot) {
          if (usersnapshot.hasData) {
            return Home();
          } else {
            return AuthScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.purple),
    );
  }
}
