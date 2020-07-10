import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:govtapp/screens/ER/erdashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ERLoginPage extends StatefulWidget {
  ERLoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<ERLoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController pinInputController;
  QuerySnapshot querySnapshot;

  // final databaseReference = Firestore.instance;

  getLocImage() async {
    print("Getting");
    return await Firestore.instance.collection('users_er').getDocuments();
  }

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    pinInputController = new TextEditingController();

    getLocImage().then((results) {
      setState(() {
        querySnapshot = results;
      });
    });

    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  checkdata() async {
    if (querySnapshot != null) {
      for (int i = 0; i < querySnapshot.documents.length; i++) {
        if (querySnapshot.documents[i].data['email'] ==
            emailInputController.text) {
          if (querySnapshot.documents[i].data['useless'] ==
              pwdInputController.text) {
            print(pwdInputController.text);
            print(pinInputController.text);
            print(querySnapshot.documents[i].data['pincode']);
            if (querySnapshot.documents[i].data['pincode'].toString().trim() ==
                pinInputController.text.trim()) {
              print("Correct");

              SharedPreferences eruseremail = await SharedPreferences.getInstance();
              eruseremail.setString('email', querySnapshot.documents[i].data['email']);

              SharedPreferences erpincode = await SharedPreferences.getInstance();
              erpincode.setString('pincode', querySnapshot.documents[i].data['pincode'].toString().trim());


              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ERDashboard(pinInputController.text.trim())));
            }
          } else {
            //TODO: Show error
            print("Wrong pw");
          }
        } else {
          print("Wrong email");
        }
      }
    } else {
      print("QS is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF31427d),
          title: Text("Login"),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _loginFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email*', hintText: "john.doe@gmail.com"),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Password*', hintText: "********"),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Pincode*', hintText: "560001"),
                    keyboardType: TextInputType.number,
                    controller: pinInputController,
                    validator: pwdValidator,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: Text("Login"),
                    color: Color(0xFF31427d),
                    textColor: Colors.white,
                    onPressed: () {
                      print("check");
                      checkdata();
                    },
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ))));
  }
}
