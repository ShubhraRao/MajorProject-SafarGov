import 'package:flutter/material.dart';
import 'package:govtapp/screens/Contractor/captureImage.dart';
import 'Contractor/login2.dart';
import 'ER/erlogin.dart';
import 'PWD/pwdlogin.dart';

class ChooseRole extends StatefulWidget {
  @override
  _ChooseRoleState createState() => _ChooseRoleState();
}

class _ChooseRoleState extends State<ChooseRole> {
  @override
  Widget build(BuildContext context) {
    
    final erButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => 
            ERLoginPage()),
          );
        },
        padding: EdgeInsets.all(12),
        color:Color(0xFF11249F),
        child: Text('Elected Representative',
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );

    final pwdButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => 
            PWDLoginPage()),
          );
        },
        padding: EdgeInsets.all(12),
        color: Color(0xFF11249F),
        child: Text('Public Works Deparntment',
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );

    final contractorBtn = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => 
            // LoginPg1()),
            LoginCon2())
          );
        },
        padding: EdgeInsets.all(12),
        color: Color(0xFF11249F),
        child: Text('Contractor',
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "SafarGov",
        home: WillPopScope( 
          child: Scaffold(
            appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF3383CD),
                  Color(0xFF11249F),
                ],
              ),
            ),
          ),
          title: RichText(
  text: TextSpan(
    text: 'S',
    style: TextStyle(color: Colors.white, fontSize: 25.0),
    children: <TextSpan>[
      TextSpan(text: 'AFAR', style: TextStyle(fontSize: 16.0)),
      TextSpan(text: 'G', style: TextStyle(fontSize: 25.0)),
      TextSpan(text: 'OV', style: TextStyle(fontSize: 16.0)),
    ],
  ),
)
        ),
              backgroundColor: Colors.white,
              body:DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/wallpaperdesign.png"),
                  fit: BoxFit.cover),
            ),
            child:  SafeArea(
                  child:
                      Column(
                          children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 150.0,
                    ),
                    Column(children: <Widget>[
                      ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 24.0, right: 24.0),
                        children: <Widget>[
                          erButton,
                          pwdButton,
                          contractorBtn,
                          SizedBox(height: 17.0),
                        ],
                      ),
                    ])
                  ])))),
          onWillPop: () => showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
              title: Text('Warning'),
              content: Text('Are you sure you want to leave?'),
              actions: [
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () => Navigator.pop(c, true),
                ),
                FlatButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(c, false),
                ),
              ],
            ),
          ),
        ));
  }
}
