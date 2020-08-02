import 'dart:io';

import 'package:flutter/material.dart';
import 'package:govtapp/screens/Contractor/captureImage.dart';
import 'package:govtapp/screens/Contractor/conreports.dart';
import 'package:govtapp/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeContractor extends StatefulWidget {
  final String fname, lname, phone;

  const HomeContractor({Key key, this.fname, this.lname, this.phone})
      : super(key: key);
  @override
  _HomeContractorState createState() =>
      _HomeContractorState(fname, lname, phone);
}

class _HomeContractorState extends State<HomeContractor> {
  final String fname, lname, phone;
  _HomeContractorState(this.fname, this.lname, this.phone);

   Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Warning'),
        content: new Text('Are you sure you want to exit SafarGov?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => exit(0),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }
  
  @override
  Widget build(BuildContext context) {
    print(fname + lname + phone);
    return WillPopScope(
        onWillPop: () {
          _onWillPop();
        },
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
            backgroundColor: Color(0xFF11249F),
            automaticallyImplyLeading: false,
            title: Text("HOME"),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                      child: Icon(Icons.exit_to_app),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(28.0))),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 20.0, 20.0, 0.0),
                                  title: Text('Warning'),
                                  content:
                                      Text('Are you sure you want to log out?'),
                                  actions: [
                                    FlatButton(
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        onPressed: () async {
                                          SharedPreferences contfname =
                                              await SharedPreferences
                                                  .getInstance();
                                          contfname.remove('fname');

                                          SharedPreferences contphone =
                                              await SharedPreferences
                                                  .getInstance();
                                          contphone.remove('phone');

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SplashScreen()));
                                        }),
                                    FlatButton(
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ]);
                            });
                      }))
            ],
          ),
          body: _buildBody(context),
        ));
  }

  Widget _buildBody(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF3383CD),
                    Color(0xFF11249F),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              height: 155.0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Text("WELCOME", style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w400, color: Colors.white)),
                    SizedBox(height: 20.0,),
                    Text(fname + " " + lname, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
                  child: ListView(
            children: <Widget>[
              
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("CAPTURE IMAGE", style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CaptureImage(fname: fname, lname: lname, mobnumber: phone,)));
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment),
                  title: Text("VIEW REPORTS", style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewRecReport(
                                fname: widget.fname,
                                lname: widget.lname,
                                phone: widget.phone)));
                  }),
              //     ListTile(
              //   leading: Icon(Icons.camera_alt),
              //   title: Text("SUBMITTED REPORT", style: TextStyle(fontWeight: FontWeight.bold)),
              //   onTap: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => CaptureImage()));
              //   },
              // ),
                //   ListTile(
                // leading: Icon(Icons.location_on),
                //   title: Text("MAPS", style: TextStyle(fontWeight: FontWeight.bold)),
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => ContractorMap(newlist, widget.fname,  widget.lname,  widget.phone)));
                //   }),
            ],
          )))
        ]);
  }
}
