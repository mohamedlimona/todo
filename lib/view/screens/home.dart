import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_firebase/core/services/check_connection.dart';
import 'package:todo_firebase/core/services/database_helper.dart';
import 'package:todo_firebase/core/view_model/home_viewmodel.dart';
import 'package:todo_firebase/models/task.dart';
import 'package:todo_firebase/view/auth/authscreen.dart';
import 'add_task.dart';
import 'description.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseHelper _dbHelper = new DatabaseHelper();
  String uid = '';
  @override
  void initState() {
    getuid();
    super.initState();
  }

  Future getuid() async {

      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
       setState(() {
         uid = user.uid;
       });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),

      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future: _dbHelper.getTasks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting&&snapshot.data==null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
            List  <Task> docs = snapshot.data;
Provider.of<Home_viewmodel>(context).async_data(context);
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {


                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Description(
                                    title: docs[index].title,
                                    description: docs[index].description,
                                  )));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Color(0xff121211),
                          borderRadius: BorderRadius.circular(10)),
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(docs[index].title,
                                        style:
                                            GoogleFonts.roboto(fontSize: 20))),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                        docs[index].time))
                              ]),
                          Container(
                              child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                  ),
                                  onPressed: () async {
                                 await   _dbHelper.deleteTask(docs[index].timestamp);

                                    await Firestore.instance
                                        .collection('tasks')
                                        .document(uid)
                                        .collection('mytasks')
                                        .document(docs[index].timestamp)
                                        .delete();
                                    setState(() {
                                      docs.remove(docs[index].timestamp);
                                    });
                                  }
                                  ))
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        // color: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddTask()));
          }),
    );
  }
}
