import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:govtapp/screens/PWD/pwdhome.dart';

class RegisterCont extends StatefulWidget {
  final String pwdid;
  RegisterCont({Key key, this.pwdid}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterCont> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController phoneInputController;

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    phoneInputController = new TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF11249F),
          automaticallyImplyLeading: false,
          // flexibleSpace: Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topRight,
          //       end: Alignment.bottomLeft,
          //       colors: [
          //         Color(0xFFDA4453),
          //         Color(0xFF89216B),
          //       ],
          //     ),
          //   ),
          // ),
          title: Text("Create account"),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(labelText: 'First Name*'),
                    controller: firstNameInputController,
                    validator: (value) {
                      if (value.length < 3) {
                        return "Please enter a valid first name.";
                      }
                    },
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(labelText: 'Last Name*'),
                      controller: lastNameInputController,
                      validator: (value) {
                        if (value.length < 3) {
                          return "Please enter a valid last name.";
                        }
                      }),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Mobile number*'),
                      controller: phoneInputController,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.length < 10 || value.length > 10) {
                          return "Please enter a valid phone number.";
                        }
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 40.0,
                    width: 300.0,
                    child: RaisedButton(
                      onPressed: () {
                       
                        if (_registerFormKey.currentState.validate()) {
                           var rng = new Random();
                        var code = rng.nextInt(900000) + 100000;
                        String cid = firstNameInputController.text.trim().substring(0,3).toUpperCase()+code.toString() + "CON";
                        print(cid);
                          Firestore.instance
                              .collection("users_contractor")
                              .add({
                                "fname": firstNameInputController.text,
                                "lname": lastNameInputController.text,
                                "phone": phoneInputController.text,
                                "createdBy": widget.pwdid,
                                "conId": cid,
                              })
                              .then((result) => {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(28.0))),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 20.0, 20.0, 0.0),
                                            title: Row(children: <Widget>[
                                              Icon(Icons.check_circle,
                                                  color: Colors.green),
                                              Text('\tSuccess')
                                            ]),
                                            content: Text(
                                              'Account created successfully.',
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text("CLOSE"),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PWDhome(widget
                                                                  .pwdid)));

                                                  firstNameInputController
                                                      .clear();
                                                  lastNameInputController
                                                      .clear();
                                                  phoneInputController.clear();
                                                },
                                              )
                                            ],
                                          );
                                        })
                                  })
                              .catchError((err) => print(err));
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            // gradient: LinearGradient(
                            //   colors: [Color(0xff89216B), Color(0xffDA4453)],
                            //   begin: Alignment.centerLeft,
                            //   end: Alignment.centerRight,
                            // ),
                            color: Color(0xFF11249F),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Container(
                          // width: 400.0,
                          constraints:
                              BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Create account",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ))));
  }
}
