import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_firebase/view/screens/home.dart';

class Auth_viewmodel extends ChangeNotifier{
 bool isLoginPage=false;
  final formkey = GlobalKey<FormState>();

  startauthentication(String email, String password, String username,BuildContext context) {
    final validity = formkey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (validity) {
      formkey.currentState.save();
      submitform(email, password, username,context);
    }
  }

  submitform(String email, String password, String username, BuildContext context) async {
    final auth = FirebaseAuth.instance;
    AuthResult authResult;
    try {
      if (isLoginPage) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => Home()));
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user.uid;
        await Firestore
            .instance
            .collection('users')
            .document(uid)
            .setData({'username': username, 'email': email});
        notifyListeners();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => Home()));
      }
    } on PlatformException catch (err) {
      var message = 'An error occured';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
    } catch (err) {
      print(err);
    }
  }


}