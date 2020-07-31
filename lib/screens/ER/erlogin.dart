import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:govtapp/unused/erdashboard.dart';
import 'package:govtapp/screens/ER/erhome.dart';
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
  TextEditingController wardInputController;
  QuerySnapshot querySnapshot;
  String error="";

  // final databaseReference = Firestore.instance;

  getLocImage() async {
    print("Getting");
    return await Firestore.instance.collection('users_er').getDocuments();
  }

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    wardInputController = new TextEditingController();

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
            
            if (querySnapshot.documents[i].data['wardname'].toString().trim().toLowerCase() ==
                wardInputController.text.trim().toLowerCase()) {
              print("Correct");

              SharedPreferences eruseremail = await SharedPreferences.getInstance();
              eruseremail.setString('email', querySnapshot.documents[i].data['email']);

              SharedPreferences erward = await SharedPreferences.getInstance();
              erward.setString('wardname', querySnapshot.documents[i].data['wardname'].toString().trim());

              SharedPreferences erid = await SharedPreferences.getInstance();
              erid.setString('erid', querySnapshot.documents[i].data['erid'].toString().trim());
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ERhome(querySnapshot.documents[i].data['erid'].toString(), wardInputController.text.trim())));
            }
          } else {
            //TODO: Show error
            print("Wrong pw");
            setState(() {
              error="Invalid credentials";
            });
          }
        } else {
          print("Wrong email");
          setState(() {
              error="Invalid credentials";
            });
        }
      }
    } else {
      print("QS is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe6f5fc),
        appBar: AppBar(
          backgroundColor: Color(0xFF11249F),
          title: Text("Login"),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _loginFormKey,
              child: Column(
                children: <Widget>[
                  Text(error, style: TextStyle(color: Colors.red)),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email*'),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Password*'),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        labelText: 'Ward Name*'),
                    // keyboardType: TextInputType.number,
                    controller: wardInputController,
                    
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: Text("Login"),
                    color: Color(0xFF11249F),
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
