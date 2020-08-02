import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:social_share/social_share.dart';

class ERPotholeDetails extends StatefulWidget {
  final String erid;
  final DocumentSnapshot doc;

  const ERPotholeDetails(this.erid, this.doc);
  @override
  _ERPotholeDetailsState createState() => _ERPotholeDetailsState(erid, doc);
}

class _ERPotholeDetailsState extends State<ERPotholeDetails> {
  final DocumentSnapshot doc;
  final String erid;

  _ERPotholeDetailsState(this.erid, this.doc);
  final firestoreInstance = Firestore.instance;
  bool isLoading = false;

  var databaseReference= Firestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    databaseReference
          .collection("location_travel")
          .document(doc.documentID)
          .updateData({
        'erSeen': "YES",
      }).then((value) => print("Dome"));
    super.initState();
  }

  void _showShareDialog() {
    showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Container(
                width: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Share details",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        SocialShare.shareWhatsapp("Pothole Details:\n" +doc.data["address"] + ", (" + doc.data["lat"].toString() +", " + doc.data["lon"].toString()+" ). Sent from SafarGov Mobile App")
                            .then((data) {
                          print(data);
                        });
                      }, 
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset('assets/images/whatsapp.png',
                                height: 20, width: 20),
                          ),
                          Text("Share on WhatsApp"),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    GestureDetector(
                      onTap: () {
                        SocialShare.shareSms(
                                "Pothole Details:\n" +doc.data["address"] + ", (" + doc.data["lat"].toString() +", " + doc.data["lon"].toString()+" ). Sent from SafarGov Mobile App",
                                url: "",
                                trailingText: "")
                            .then((data) {
                          print(data);
                        });
                        print("Um");
                      },
                      child: Row(
                        children: <Widget>[
                          Image.asset('assets/images/message.jpg',
                              height: 50, width: 50),
                          Text("Share on Message"),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.0)
                    // Divider(
                    //   color: Colors.grey,
                    // ),
                    
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    // print(colname);
    return Scaffold(
        appBar: AppBar(
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
                  DataCell(Text("Ward: ")),
                  DataCell(Text(doc.data["subLocality"])),
                ]),
                DataRow(cells: [
                  DataCell(Text("Pincode: ")),
                  DataCell(Text(doc.data["pincode"])),
                ]),
                DataRow(cells: [
                  DataCell(Text("Date: ")),
                  DataCell(
                    Text(Jiffy(DateTime.parse(doc.data["timeStamp"].toDate().toString()))
                        .yMMMMEEEEdjm),
                  ),
                ]),
                DataRow(cells: [
                  DataCell(Text("Location: ")),
                  DataCell(
                    Text(doc.data["lat"].toString() + ", " + doc.data["lon"].toString()),
                  ),
                ]),
                DataRow(cells: [
                  DataCell(Text("Source: ")),
                  DataCell(
                    Text(doc.data["source"]),
                  ),
                ]),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: () async {
                  _showShareDialog();
                },
                padding: EdgeInsets.all(12),
                color: Color(0xFF11249F),
                child: Text('Share details',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16)),
              ),
            ),
          ],
        ));
    // });
  }
}
