import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:govtapp/screens/PWD/Contractor/conservice.dart';
import 'package:govtapp/screens/PWD/fixedpotholes.dart';
import 'package:govtapp/screens/PWD/pwdmap.dart';
import 'package:govtapp/screens/PWD/pwdresport.dart';
import 'package:govtapp/screens/PWD/pwdstatistics.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:govtapp/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'dart:io';

import 'Contractor/sendReport.dart';

class PWDhome extends StatefulWidget {
  final String pwdid;

  const PWDhome(this.pwdid);
  @override
  _PWDhomeState createState() => _PWDhomeState(this.pwdid);
}

class _PWDhomeState extends State<PWDhome> {
  final String pwdid;
  _PWDhomeState(this.pwdid);

  List<DocumentSnapshot> listtravel = List();
  List<DocumentSnapshot> newlist = List();
  List<DocumentSnapshot> newlist2 = List();
  List<DocumentSnapshot> listimage = List();
  List<DocumentSnapshot> listfixed = List();
  bool isLoading = false;
  List<DocumentSnapshot> newfixed;
  List<charts.Series> seriesList;
  List<charts.Series<Countbymonth, String>> _seriesBarData;
  int c1 = 0;
  int c2 = 0;
  int c3 = 0;
  int c4 = 0;
  int c5 = 0;
  int c6 = 0;

  int f1 = 0;
  int f2 = 0;
  int f3 = 0;
  int f4 = 0;
  int f5 = 0;
  int f6 = 0;
  List<Countbymonth> countlist = List();
  List<Countbymonth> countfixed = List();
  // Timer timer;

  void initState() {
    getlist();
    // timer = Timer.periodic(Duration(seconds: 120), (Timer t) => 
    // getlist());
    super.initState();
    _generateData(countlist);

  }

  filterdata() {
    countlist = [];
    print("Filterrr");

    // for (int i = 0; i < newlist.length; i++) {
    //   if(newlist[i].data["timeStamp"] == null)
    //   {
    //   print(newlist[i].documentID);
    //   print(newlist[i].data["userid"]);
    //   // print(newlist[i].data["userid"]);
    //   }
    //   // print(newlist[i].data["timeStamp"].toString() + "sfg");
    // }

    for (int i = 0; i < newlist.length; i++) {
      if (DateTime.parse(newlist[i].data["timeStamp"].toDate().toString())
              .month ==
          DateTime.now().month) {
        c1++;
      }
      if (DateTime.parse(newlist[i].data["timeStamp"].toDate().toString())
              .month ==
          DateTime.now().month - 1) {
        c2++;
      }
      if (DateTime.parse(newlist[i].data["timeStamp"].toDate().toString())
              .month ==
          DateTime.now().month - 2) {
        c3++;
      }
      if (DateTime.parse(newlist[i].data["timeStamp"].toDate().toString())
              .month ==
          DateTime.now().month - 3) {
        c4++;
      }
      if (DateTime.parse(newlist[i].data["timeStamp"].toDate().toString())
              .month ==
          DateTime.now().month - 4) {
        c5++;
      }
      if (DateTime.parse(newlist[i].data["timeStamp"].toDate().toString())
              .month ==
          DateTime.now().month - 5) {
        c6++;
      }
    }

    countlist.add(Countbymonth(DateTime.now().month, c1));
    countlist.add(Countbymonth(DateTime.now().month - 1, c2));
    countlist.add(Countbymonth(DateTime.now().month - 2, c3));
    countlist.add(Countbymonth(DateTime.now().month - 3, c4));
    countlist.add(Countbymonth(DateTime.now().month - 4, c5));
    countlist.add(Countbymonth(DateTime.now().month - 5, c6));
    countlist = countlist.reversed.toList();

    for (int i = 0; i < newfixed.length; i++) {
      if (DateTime.parse(newfixed[i].data["timeStamp"].toDate().toString())
              .month ==
          DateTime.now().month) {
        f1++;
      }
      if (DateTime.parse(newfixed[i].data["timeStamp"].toDate().toString())
              .month ==
          DateTime.now().month - 1) {
        f2++;
      }
      if (DateTime.parse(newfixed[i].data["timeStamp"].toDate().toString())
              .month ==
          DateTime.now().month - 2) {
        f3++;
      }
      if (DateTime.parse(newfixed[i].data["timeStamp"].toDate().toString())
              .month ==
          DateTime.now().month - 3) {
        f4++;
      }
      if (DateTime.parse(newfixed[i].data["timeStamp"].toDate().toString())
              .month ==
          DateTime.now().month - 4) {
        f5++;
      }
      if (DateTime.parse(newfixed[i].data["timeStamp"].toDate().toString())
              .month ==
          DateTime.now().month - 5) {
        f6++;
      }
    }
    countfixed.add(Countbymonth(DateTime.now().month, f1));
    countfixed.add(Countbymonth(DateTime.now().month - 1, f2));
    countfixed.add(Countbymonth(DateTime.now().month - 2, f3));
    countfixed.add(Countbymonth(DateTime.now().month - 3, f4));
    countfixed.add(Countbymonth(DateTime.now().month - 4, f5));
    countfixed.add(Countbymonth(DateTime.now().month - 5, f6));

    countfixed = countfixed.reversed.toList();
  }

  getlist() async {
    QuerySnapshot querySnapshottravel =
        await Firestore.instance.collection("location_travel").getDocuments();
    listtravel = querySnapshottravel.documents;

    newlist = listtravel.reversed.toList();
    QuerySnapshot querySnapshotfixed =
        await Firestore.instance.collection("fixed_potholes").getDocuments();
    listfixed = querySnapshotfixed.documents;
    newfixed = listfixed;
    setState(() {
      isLoading = true;
    });
    print(listtravel);
    if (newlist[newlist.length - 1].data["timeStamp"] != null) filterdata();
  }

  _generateData(countlist) {
    _seriesBarData = List<charts.Series<Countbymonth, String>>();
    _seriesBarData.add(
      charts.Series(
        // displayName: " ",
        domainFn: (Countbymonth potbyme, _) => getmonth(potbyme.month),
        measureFn: (Countbymonth potbyme, _) => potbyme.count,
        id: 'Potholes',
        data: countlist,
        fillColorFn: (Countbymonth countbymonth, _) {
          return charts.MaterialPalette.red.shadeDefault;
        },
      ),
    );
    _seriesBarData.add(charts.Series(
      // displayName: " ",
      domainFn: (Countbymonth potbyme, _) => getmonth(potbyme.month),
      measureFn: (Countbymonth potbyme, _) => potbyme.count,
      id: 'Potholes',
      data: countfixed,
      fillColorFn: (Countbymonth countbymonth, _) {
        return charts.MaterialPalette.cyan.shadeDefault;
      },
    ));
  }

  getmonth(int d) {
    if (d == 1) {
      return "JAN";
    } else if (d == 2) {
      return "FEB";
    } else if (d == 3) {
      return "MAR";
    } else if (d == 4) {
      return "APR";
    } else if (d == 5) {
      return "MAY";
    } else if (d == 6) {
      return "JUN";
    } else if (d == 7) {
      return "JUL";
    } else if (d == 8) {
      return "AUG";
    } else if (d == 9) {
      return "SEP";
    } else if (d == 10) {
      return "OCT";
    } else if (d == 11) {
      return "NOV";
    } else if (d == 12) {
      return "DEC";
    }
  }

  
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
    return WillPopScope(
          onWillPop: () { 
           _onWillPop();
           },
          child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),

        // bottomNavigationBar: _buildBottomBar(),
        body: (!isLoading) ? Center(child: CircularProgressIndicator()) : _buildBody(context),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
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
      title: Text('PWD Dashboard'),
      elevation: 0,
      actions: <Widget>[
        GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(28.0))),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                      title: Text('Warning'),
                      content: Text('Are you sure you want to log out?'),
                      actions: [
                        FlatButton(
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () async {
                              SharedPreferences pwduseremail =
                                  await SharedPreferences.getInstance();

                              SharedPreferences pwdid =
                                  await SharedPreferences.getInstance();

                              pwduseremail.remove('email');
                              pwdid.remove('pwdid');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SplashScreen()),
                              );
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
                      ],
                    );
                  });
            },
            child: Icon(Icons.exit_to_app)),
        SizedBox(width: 10),
      ],
    );
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
            height: 150.0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(children: <Widget>[
                          Text(listtravel.length.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 55.0,
                                  fontWeight: FontWeight.w400)),
                          SizedBox(height: 10.0),
                          Text("Total potholes\nreported",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ]),
                        Column(children: <Widget>[
                          Text(listfixed.length.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 55.0,
                                  fontWeight: FontWeight.w400)),
                          SizedBox(height: 10.0),
                          Text("Total potholes\nfixed",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ])
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChartsDemo(newlist: newlist, newfixed: listfixed)));
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 160.0,
                child: _buildChart(context, countlist),
              ),
            )),
        ListTile(
          leading: Icon(Icons.assignment, color: Colors.black),
          title: Text("REPORTED POTHOLES",
              style: TextStyle(fontWeight: FontWeight.bold)),
          // subtitle: Text("Report of all potholes"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PWDReport(pwdid, newlist)));
          },
        ),
        ListTile(
          leading: Icon(Icons.build, color: Colors.black),
          title: Text("FIXED POTHOLES",
              style: TextStyle(fontWeight: FontWeight.bold)),
          // subtitle: Text("Report of all potholes"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PWDFixedReport(pwdid,listfixed)));
          },
        ),
        ListTile(
            leading: Icon(Icons.account_circle, color: Colors.black),
            title: Text("CONTRACTOR SERVICES",
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        //  PWDContractorServices(listtravel: newlist)
                        // SendReport(pwdid, newlist)
                        ViewServices(pwdid, newlist),
                  ));
            }),
        ListTile(
          leading: Icon(Icons.location_on, color: Colors.black),
          title: Text("MAP", style: TextStyle(fontWeight: FontWeight.bold)),
          // subtitle: Text("Report of all potholes"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PWDViewMap(pwdid, newlist)));
          },
        ),
        
       
        // ExpansionTile(
        //   title:  Text("Contractor"),
        //   children: <Widget>[
        //     ListTile(
        //       // leading: ,
        //       title: Text("CREATE ACCOUNT"),
        //       onTap:(){
        //         Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => RegisterCont(pwdid: pwdid)));
        //       }
        //     ),
        //     ListTile(
        //       // leading: ,
        //       title: Text("VIEW REPORTINGS"),
        //       onTap:(){}
        //     ),
        //   ],
        // )
        // ListTile(
        //   leading: Icon(Icons.insert_chart, color: Colors.black),
        //   title: Text("STATISTICS", style: TextStyle(fontWeight: FontWeight.bold)),
        //   // subtitle: Text("Report of all potholes"),
        //   onTap: () {
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => ChartsDemo(newlist: newlist, newfixed: listfixed)));
        //   },
        // ),
      ],
    );
  }

  Widget _buildChart(BuildContext context, List<Countbymonth> potholes) {
    countlist = potholes;
    _generateData(countlist);
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Last 6 months',
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.brightness_1,
                                  size: 10.0, color: Colors.red),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Potholes\nreported",
                                    style: TextStyle(fontSize: 10.0)),
                              )
                            ],
                          ),
                          SizedBox(width: 10.0),
                          Row(
                            children: <Widget>[
                              Icon(Icons.brightness_1,
                                  size: 10.0, color: Colors.cyan),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Potholes\nfixed",
                                    style: TextStyle(fontSize: 10.0)),
                              )
                            ],
                          ),
                        ]),
                  ]),

              // Align(alignment: Alignment.centerRight,
              // child: ),
              // SizedBox(
              //   height: 10.0,
              // ),
              Expanded(
                child: charts.BarChart(
                  _seriesBarData,
                  barGroupingType: charts.BarGroupingType.grouped,
                  animate: true,
                  animationDuration: Duration(seconds: 2),
                ),
              ),
              // Align(
              //     alignment: Alignment.centerRight,
              //     child: Icon(Icons.arrow_forward))
            ],
          ),
        ),
      ),
    );
  }
    void dispose() {
    // timer?.cancel();
    super.dispose();
  }
}
