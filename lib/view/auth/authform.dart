import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_firebase/core/view_model/auth_viewmodel.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _username = TextEditingController();
  // bool isLoginPage = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(30),
              height: 200,
              child: Image.asset('assets/todo.png'),
            ),
            Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Form(
                  key: Provider.of<Auth_viewmodel>(context, listen: false)
                      .formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!Provider.of<Auth_viewmodel>(context,listen: false).isLoginPage)
                        TextFormField(
                          controller: _username,
                          keyboardType: TextInputType.emailAddress,
                          key: ValueKey('username'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Incorrect Username';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                  borderSide: new BorderSide()),
                              labelText: "Enter Username",
                              labelStyle: GoogleFonts.roboto()),
                        ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Incorrect Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                borderSide: new BorderSide()),
                            labelText: "Enter Email",
                            labelStyle: GoogleFonts.roboto()),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _password,
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('password'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Incorrect password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                borderSide: new BorderSide()),
                            labelText: "Enter Password",
                            labelStyle: GoogleFonts.roboto()),
                      ),
                      SizedBox(height: 10),
                      Container(
                          padding: EdgeInsets.all(5),
                          width: double.infinity,
                          height: 70,
                          child: RaisedButton(
                              child: Provider.of<Auth_viewmodel>(context,
                                          listen: false)
                                      .isLoginPage
                                  ? Text('Login',
                                      style: GoogleFonts.roboto(fontSize: 16))
                                  : Text('SignUp',
                                      style: GoogleFonts.roboto(fontSize: 16)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                Provider.of<Auth_viewmodel>(context,
                                        listen: false)
                                    .startauthentication(
                                        _email.text.toString(),
                                        _password.text.toString(),
                                        _username.text.toString(),
                                        context);
                              })),
                      SizedBox(height: 10),
                      Container(
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                Provider.of<Auth_viewmodel>(context,
                                        listen: false)
                                    .isLoginPage = !Provider.of<Auth_viewmodel>(
                                        context,
                                        listen: false)
                                    .isLoginPage;
                              });
                            },
                            child: Provider.of<Auth_viewmodel>(context,
                                        listen: false)
                                    .isLoginPage
                                ? Text(
                                    'Not a member?',
                                    style: GoogleFonts.roboto(
                                        fontSize: 16, color: Colors.white),
                                  )
                                : Text('Already a Member?',
                                    style: GoogleFonts.roboto(
                                        fontSize: 16, color: Colors.white))),
                      )
                    ],
                  ),
                ))
          ],
        ));
  }
}
