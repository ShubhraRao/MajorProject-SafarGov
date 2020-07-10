import 'dart:async';

import 'package:flutter/material.dart';
import 'package:govtapp/screens/ER/erdashboard.dart';
import 'package:govtapp/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 2);
    return new Timer(duration, route);
  }

  route() async {
    print("Urghhh");

    SharedPreferences eruseremail = await SharedPreferences.getInstance();
    SharedPreferences erpincode = await SharedPreferences.getInstance();


    var eremail = eruseremail.getString('email');
    var erpin = erpincode.getString('pincode');

    if (eremail != null && erpin != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ERDashboard(erpin)));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChooseRole()));
    }
  }

  initScreen(BuildContext context) {
    return MaterialApp(
        title: "Pothole Detection Application",
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Container(
                //   child: Image.asset("assets/icons/logo8.png"),
                // ),
                // Padding(padding: EdgeInsets.only(top: 20.0)),
                CircularProgressIndicator()
              ],
            ),
          ),
        ));
  }
}
