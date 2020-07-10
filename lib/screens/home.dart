import 'package:flutter/material.dart';
import 'login/erlogin.dart';
import 'login/pwdlogin.dart';

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
        color: Color(0xFF456796),
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
        color: Color(0xFF456796),
        child: Text('Public Works Deparntment',
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Pothole Detection System",
        home: WillPopScope( 
          child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                  child:
                      Column(
                          children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 100.0,
                    ),
                    Column(children: <Widget>[
                      ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 24.0, right: 24.0),
                        children: <Widget>[
                          pwdButton,
                          erButton,
                          SizedBox(height: 17.0),
                        ],
                      ),
                    ])
                  ]))),
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
