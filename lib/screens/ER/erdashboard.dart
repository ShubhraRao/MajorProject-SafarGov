import 'package:flutter/material.dart';

import 'ermap.dart';
import 'erreport.dart';

class ERDashboard extends StatefulWidget {
  final String pincode;

  const ERDashboard(this.pincode);
  @override
  _ERDashboardState createState() => _ERDashboardState(this.pincode);
}

class _ERDashboardState extends State<ERDashboard> {
  final String pincode;

  _ERDashboardState(this.pincode);
  @override
  Widget build(BuildContext context) {
    
    final viewReport = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => 
            ERReport(this.pincode)),
          );
        },
        padding: EdgeInsets.all(12),
        color: Color(0xFF456796),
        child: Text('View Report',
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );

    final viewMap = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => 
            ERViewMap(pincode)
            ),
          );
        },
        padding: EdgeInsets.all(12),
        color: Color(0xFF456796),
        child: Text('View Map',
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
                          viewReport,
                          viewMap,
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
