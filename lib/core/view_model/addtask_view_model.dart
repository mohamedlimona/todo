import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase/core/services/database_helper.dart';
import 'package:todo_firebase/models/task.dart';
import 'package:todo_firebase/view/screens/home.dart';

class Addtask_viewmodel extends ChangeNotifier {

  Future addtasktofirebase(String title, String desc,DateTime time) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    String uid = user.uid;

    await Firestore.instance
        .collection('tasks')
        .document(uid)
        .collection('mytasks')
        .document(time.toString())
        .setData({
      'title': title,
      'description': desc,
      'time': time.toString(),
      'timestamp': time
    });
    Fluttertoast.showToast(msg: 'Data Added');
    notifyListeners();
  }

  Future addto_db({String title, String desc,BuildContext context}) async {
    var time = DateTime.now();
    DatabaseHelper _dbHelper = new DatabaseHelper();


      Task _newTask = Task(title: title, description: desc, time:DateFormat.yMd().add_jm().format(time) ,timestamp:time.toString() );
      await _dbHelper.insertTask(_newTask);
      // await  addtasktofirebase(title,desc,time);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Home()));
      notifyListeners();


  }
}
