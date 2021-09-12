import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_firebase/core/services/check_connection.dart';
import 'package:todo_firebase/core/services/database_helper.dart';
import 'package:todo_firebase/models/task.dart';

class Home_viewmodel extends ChangeNotifier {
  async_data(BuildContext context) async {
    await Provider.of<check_Internet>(context, listen: false)
        .check_Connection()
        .then((value) async {
      if (value == true) {
        List<Task> localtasks;
        DatabaseHelper().getTasks().then((value) async {
          final FirebaseUser user = await FirebaseAuth.instance.currentUser();

          await Firestore.instance
              .collection('tasks')
              .document(user.uid)
              .collection('mytasks')
              .getDocuments()
              .then((snapshot) {
            if (snapshot.documents.length < value.length) {
              value.forEach((i) async {
                await Firestore.instance
                    .collection('tasks')
                    .document(user.uid)
                    .collection('mytasks')
                    .document(i.timestamp)
                    .setData({
                  'title': i.title,
                  'description': i.description,
                  'time': i.time,
                  'timestamp': i.timestamp
                });
              });
            }
          });
        });
      } else {
        print("no net");
      }
    });
  }
}
