import 'dart:async';

import 'package:flutter/material.dart';
import 'package:govtapp/screens/Contractor/homeContractor.dart';
import 'package:govtapp/unused/erdashboard.dart';
import 'package:govtapp/screens/ER/erhome.dart';
// import 'package:govtapp/unused/pwddashboard.dart';
import 'package:govtapp/screens/PWD/pwdhome.dart';
import 'package:govtapp/screens/PWD/pwdresport.dart';
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
    SharedPreferences erward = await SharedPreferences.getInstance();
    SharedPreferences erid = await SharedPreferences.getInstance();

    var eremail = eruseremail.getString('email');
    var erwardname = erward.getString('wardname');
    var id = erid.getString('erid');

    SharedPreferences pwduseremail = await SharedPreferences.getInstance();
    SharedPreferences pwdid = await SharedPreferences.getInstance();

    var pwdemail = pwduseremail.getString('email');
    var pid = pwdid.getString('pwdid');

    SharedPreferences contfname = await SharedPreferences.getInstance();
    var fname = contfname.getString('fname');
    SharedPreferences contphone = await SharedPreferences.getInstance();
    var phone = contphone.getString('phone');
    SharedPreferences contlname = await SharedPreferences.getInstance();
    var lname = contlname.getString('lname');

    if (eremail != null && erwardname != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ERhome(id, erwardname)));
    } else if (pwdemail != null && pid != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PWDhome(pid)));
    } else if (fname != null && lname != null && phone != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeContractor(
                    fname: fname,
                    lname: lname,
                    phone: phone,
                  )));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChooseRole()));
    }
  }

  initScreen(BuildContext context) {
    return MaterialApp(
      title: "SafarGov",
      home: Scaffold(
        body: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/wallpaperdesign.png"),
                  fit: BoxFit.cover),
            ),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Text("SAFAR",
                    //   style: TextStyle(
                    //       fontSize: 30.0, fontWeight: FontWeight.bold)),
                    // Text("FOR GOV",
                    //   style: TextStyle(
                    //       fontSize: 16.0, fontWeight: FontWeight.w400)),

                    RichText(
  text: TextSpan(
    text: 'S',
    style: TextStyle(color: Colors.black, fontSize: 40.0,fontWeight: FontWeight.bold),
    children: <TextSpan>[
      TextSpan(text: 'AFAR', style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold)),
      TextSpan(text: 'G', style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
      TextSpan(text: 'OV', style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold)),
    ],
  ),
)
                  ],
                                  
                ))),
      ),
    );
  }
}
