import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:govtapp/screens/Contractor/captureImage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:social_share/social_share.dart';

class ConDetails extends StatefulWidget {
  final String fname, lname, phone;
  final DocumentSnapshot doc;

  const ConDetails(this.doc, this.fname, this.lname, this.phone);
  @override
  _ConDetailsState createState() => _ConDetailsState(doc);
}

class _ConDetailsState extends State<ConDetails> {
  final DocumentSnapshot doc;
  // final String pwdid;
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _ConDetailsState(this.doc);
  final firestoreInstance = Firestore.instance;
  bool isLoading = false;
  int success = 0;

  

  @override
  Widget build(BuildContext context) {
    // print(colname);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          // flexibleSpace: Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topRight,
          //       end: Alignment.bottomLeft,
          //       colors: [
          //         Color(0xFF3383CD),
          //         Color(0xFF11249F),
          //       ],
          //     ),
          //   ),
          // ),
          backgroundColor: Color(0xFF11249F),
          title: Text("Details"),
          
        ),
        body: Column(
          children: <Widget>[
            DataTable(
              columns: [
                DataColumn(label: Text("DETAILS")),
                DataColumn(label: SizedBox(height: 0.0))
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text("Address: ")),
                  DataCell(Text(doc.data["address"])),
                ]),
                DataRow(cells: [
                  DataCell(Text("Priority: ")),
                  DataCell(Text(doc.data["NumberOfReportings"].toString())),
                ]),
                DataRow(cells: [
                  DataCell(Text("Pincode: ")),
                  DataCell(Text(doc.data["pincode"])),
                ]),
                DataRow(cells: [
                  DataCell(Text("Date: ")),
                  DataCell(
                    Text(Jiffy(DateTime.parse(
                            doc.data["timeStamp"].toDate().toString()))
                        .yMMMMEEEEdjm),
                  ),
                ]),
                DataRow(cells: [
                  DataCell(Text("Location: ")),
                  DataCell(
                    Text(doc.data["lat"].toString() +
                        ", " +
                        doc.data["lon"].toString()),
                  ),
                ]),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: RaisedButton(
                color: Color(0xFF11249F),
                child: Text("CAPTURE IMAGE OF FIXED POTHOLE", style: TextStyle(color: Colors.white),),
                elevation: 7.0,
                onPressed: () {
                  getloc();
                }
              ),
            )
          ],
        ));
    // });
  }

  getloc() async{
    showDialog(
      barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
            
              title: new Text("Getting your location"),
              content: Container(
                height: 40.0,
                child: Column(
                  children: <Widget>[
                  CircularProgressIndicator()
                  ]),
              ),
              
            );
          });
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    var place = placemark[0];
    var currentAddress =
        "${place.subThoroughfare}, ${place.subLocality}, ${place.thoroughfare}, ${place.administrativeArea}, ${place.locality}, ${place.country}, ${place.postalCode}";
    print(currentAddress);
    print(doc.data["address"]);
    if((position.latitude.toString().substring(0,5) == doc.data["lat"].toString().substring(0,5) && position.longitude.toString().substring(0,5) == doc.data["lon"].toString().substring(0,5)) || currentAddress == doc.data["address"])
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> CaptureImage(fname: widget.fname, lname: widget.lname, mobnumber: widget.phone)));
    }
    else{
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Oops!"),
              content: Text("It looks like you are not close enough to this location! Move closer to capture an image."),
              
            );
          });
    }
  }
}
