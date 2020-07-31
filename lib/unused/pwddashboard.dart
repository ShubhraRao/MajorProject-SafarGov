// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:govtapp/screens/PWD/fixedpotholes.dart';
// import 'package:govtapp/screens/PWD/pwdmap.dart';
// import 'package:govtapp/screens/PWD/pwdresport.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:govtapp/screens/home.dart';

// class PWDashboard extends StatefulWidget {
//   final String pwdid;

//   const PWDashboard(this.pwdid);
//   @override
//   _ERDashboardState createState() => _ERDashboardState(this.pwdid);
// }

// class _ERDashboardState extends State<PWDashboard> {
//   final String pwdid;
//   List<DocumentSnapshot> listtravel = List();
//   List<DocumentSnapshot> newlist = List();
//   List<DocumentSnapshot> listimage = List();

//   _ERDashboardState(this.pwdid);
//   @override
//   Widget build(BuildContext context) {
//     final viewReport = Padding(
//       padding: EdgeInsets.symmetric(vertical: 16.0),
//       child: RaisedButton(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(24),
//         ),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     PWDReport(pwdid)),
//           );
//         },
//         padding: EdgeInsets.all(12),
//         color: Color(0xFF456796),
//         child: Text('View Report',
//             style: TextStyle(color: Colors.white, fontSize: 16)),
//       ),
//     );


//         final fixedReport = Padding(
//       padding: EdgeInsets.symmetric(vertical: 16.0),
//       child: RaisedButton(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(24),
//         ),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     PWDFixedReport(pwdid)),
//           );
//         },
//         padding: EdgeInsets.all(12),
//         color: Color(0xFF456796),
//         child: Text('Fixed Potholes',
//             style: TextStyle(color: Colors.white, fontSize: 16)),
//       ),
//     );

//     final viewMap = Padding(
//       padding: EdgeInsets.symmetric(vertical: 16.0),
//       child: RaisedButton(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(24),
//         ),
//         onPressed: () async {
//           QuerySnapshot querySnapshottravel = await Firestore.instance
//               .collection("location_travel")
//               .getDocuments();
//           listtravel = querySnapshottravel.documents;
//           newlist = listtravel;
//           QuerySnapshot querySnapshotimage = await Firestore.instance
//               .collection("location_image")
//               .getDocuments();
//           listimage = querySnapshotimage.documents;
//           // listtravel.addAll(listimage);
//           print(listtravel);
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => PWDViewMap(pwdid, newlist)),
//           );
//         },
//         padding: EdgeInsets.all(12),
//         color: Color(0xFF456796),
//         child: Text('View Map',
//             style: TextStyle(color: Colors.white, fontSize: 16)),
//       ),
//     );

//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: "Pothole Detection System",
//         home: WillPopScope(
//           child: Scaffold(
//               appBar: AppBar(
//                 backgroundColor: Color(0xFF456796),
//                 actions: <Widget>[
//                   IconButton(
//                       icon: Icon(Icons.exit_to_app),
//                       onPressed: () async {
                        // SharedPreferences eruseremail =
                        //     await SharedPreferences.getInstance();
                        // SharedPreferences erpincode =
                        //     await SharedPreferences.getInstance();
                        // SharedPreferences erid =
                        //     await SharedPreferences.getInstance();

                        // eruseremail.remove('email');
                        // erpincode.remove('pincode');
                        // erid.remove('erid');
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => ChooseRole()),
                        // );
//                       })
//                 ],
//               ),
//               backgroundColor: Colors.white,
//               body: SafeArea(
//                   child: Column(children: <Widget>[
//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 SizedBox(
//                   height: 100.0,
//                 ),
//                 Column(children: <Widget>[
//                   ListView(
//                     shrinkWrap: true,
//                     padding: EdgeInsets.only(left: 24.0, right: 24.0),
//                     children: <Widget>[
//                       viewReport,
//                       viewMap,
//                       fixedReport,
//                       SizedBox(height: 17.0),
//                     ],
//                   ),
//                 ])
//               ]))),
//           onWillPop: () => showDialog<bool>(
//             context: context,
//             builder: (c) => AlertDialog(
//               title: Text('Warning'),
//               content: Text('Are you sure you want to leave?'),
//               actions: [
//                 FlatButton(
//                   child: Text('Yes'),
//                   onPressed: () => Navigator.pop(c, true),
//                 ),
//                 FlatButton(
//                   child: Text('No'),
//                   onPressed: () => Navigator.pop(c, false),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
