// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../splashscreen.dart';
// import '../screens/ER/ermap.dart';
// import '../screens/ER/newreport.dart';

// class ERDashboard extends StatefulWidget {
//   final String erid, pincode;

//   const ERDashboard(this.pincode, this.erid);
//   @override
//   _ERDashboardState createState() => _ERDashboardState(this.pincode, this.erid);
// }

// class _ERDashboardState extends State<ERDashboard> {
//   final String pincode, erid;

//   _ERDashboardState(this.pincode, this.erid);
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
//                     // ERReport(this.pincode)
//                     GetReport(pincode, erid)),
//           );
//         },
//         padding: EdgeInsets.all(12),
//         color: Color(0xFF11249F),
//         child: Text('View Report',
//             style: TextStyle(color: Colors.white, fontSize: 16)),
//       ),
//     );

//     final viewMap = Padding(
//       padding: EdgeInsets.symmetric(vertical: 16.0),
//       child: RaisedButton(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(24),
//         ),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => ERViewMap(erid, pincode)),
//           );
//         },
//         padding: EdgeInsets.all(12),
//         color: Color(0xFF11249F),
//         child: Text('View Map',
//             style: TextStyle(color: Colors.white, fontSize: 16)),
//       ),
//     );

//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: "SafarGov",
//         home: WillPopScope(
//           child: Scaffold(
//               appBar: AppBar(
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 colors: [
//                   Color(0xFF3383CD),
//                   Color(0xFF11249F),
//                 ],
//               ),
//             ),
//           ),
//           title: Text("Safar.gov"),
        
//                 // title: Text(""),
//                 actions: <Widget>[
//                   IconButton(
//                       icon: Icon(Icons.exit_to_app),
//                       onPressed: () async {
//                         SharedPreferences eruseremail =
//                             await SharedPreferences.getInstance();
//                         SharedPreferences erpincode =
//                             await SharedPreferences.getInstance();
//                         SharedPreferences erid =
//                             await SharedPreferences.getInstance();

//                         eruseremail.remove('email');
//                         erpincode.remove('pincode');
//                         erid.remove('erid');
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => SplashScreen()),
//                         );
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
