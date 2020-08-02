import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:social_share/social_share.dart';
import 'package:govtapp/screens/PWD/pwdresport.dart';

class PWDPotholeDetails extends StatefulWidget {
  final String pwdid;
  final DocumentSnapshot doc;

  const PWDPotholeDetails(this.pwdid, this.doc);
  @override
  _ERPotholeDetailsState createState() => _ERPotholeDetailsState(pwdid, doc);
}

class _ERPotholeDetailsState extends State<PWDPotholeDetails> {
  final DocumentSnapshot doc;
  final String pwdid;
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _ERPotholeDetailsState(this.pwdid, this.doc);
  final firestoreInstance = Firestore.instance;
  bool isLoading = false;
  int success = 0;

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
                        SocialShare.shareWhatsapp("Pothole Details:\n" +
                                doc.data["address"] +
                                ", (" +
                                doc.data["lat"].toString() +
                                ", " +
                                doc.data["lon"].toString() +
                                " ). Sent from SafarGov Mobile App")
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
                                "Pothole Details:\n" +
                                    doc.data["address"] +
                                    ", (" +
                                    doc.data["lat"].toString() +
                                    ", " +
                                    doc.data["lon"].toString() +
                                    " ). Sent from SafarGov Mobile App",
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

  List<DocumentSnapshot> listtravel;

  getlist() async {
    QuerySnapshot querySnapshottravel =
        await Firestore.instance.collection("location_travel").getDocuments();
    listtravel = querySnapshottravel.documents;
    if (listtravel.isNotEmpty) {
      setState(() {
        success = 2;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PWDReport(pwdid, listtravel)));
    }

    // newlist = listtravel;

    // setState(() {
    //   isLoading = true;
    // });
    // print(listtravel);
  }

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
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                  child: Icon(Icons.share),
                  onTap: () {
                    _showShareDialog();
                  }),
            )
          ],
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
              DataRow(cells: [
                  DataCell(Text("Source: ")),
                  (doc.data['source'] == "Sensor" || doc.data['Source'] == "Sensor" || doc.data['source'] == "sensor" || doc.data['Source'] == "sensor") ?
                  DataCell(Text("Travel Mode")) : 
                  DataCell(
                    (doc.data["SurveyPriority"]!=null)?
                    Text("Camera Mode (" + doc.data["SurveyPriority"].toString().toUpperCase() +" PRIORITY)"): Text("Camera Mode")) 
                ]),
                DataRow(cells: [
                  DataCell(Text("Source: ")),
                  DataCell(
                    Text(doc.data["source"]),
                  ),
                ]),
                // DataRow(cells: [
                //   DataCell(Text("Survey details: ")),
                //   (doc.data['source'] == "Sensor" || doc.data['Source'] == "Sensor" || doc.data['source'] == "sensor" || doc.data['Source'] == "sensor") ?
                //   DataCell(Text("Travel Mode")) : DataCell(Text("Camera Mode")) 
                // ]),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () async {
                    setState(() {
                      success = 3;
                    });
                    DocumentReference ref = await Firestore.instance
                        .collection("fixed_potholes")
                        .add({
                      'fixedby': pwdid,
                      'address': doc.data["address"],
                      'lat': doc.data["lat"],
                      'lon': doc.data["lon"],
                      'timeStamp': DateTime.now(),
                      'pincode': doc.data["pincode"],
                      'subLocality': doc.data["subLocality"],
                      'NumberOfReportings': doc.data["NumberOfReportings"],
                      'userid': doc.data["userid"],
                    }).then((value) {
                      setState(() {
                        success = 1;
                      });
                    });

                    try {
                      Firestore.instance
                          .collection("location_travel")
                          .document(doc.documentID)
                          .delete()
                          .then((value) {
                        getlist();
                      });
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  padding: EdgeInsets.all(12),
                  color: Color(0xFF11249F),
                  child: (success == 0)
                      ? Text('Fix it!',
                          style: TextStyle(color: Colors.white, fontSize: 16))
                      : Text("Loading ...",
                          style: TextStyle(color: Colors.white, fontSize: 16))),
            ),
          ],
        ));
    // });
  }
}
