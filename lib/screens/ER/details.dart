import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class ERPotholeDetails extends StatefulWidget {
  final String colname;
  final String id;
  // final DocumentSnapshot data;
  final String address, pincode;
  final String lat, lon;
  final Timestamp time;

  const ERPotholeDetails(this.colname, this.id, this.address, this.pincode, this.lat, this.lon, this.time);
  @override
  _ERPotholeDetailsState createState() => _ERPotholeDetailsState(
      this.colname, this.id, this.address, this.pincode, this.lat, this.lon, this.time);
}

class _ERPotholeDetailsState extends State<ERPotholeDetails> {
  final String colname;
  final String id;
  final String address, pincode;
  final String lat, lon;
  final Timestamp time;

  _ERPotholeDetailsState(this.colname, this.id, this.address, this.pincode, this.lat, this.lon, this.time);
  final firestoreInstance = Firestore.instance;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    print(colname);
    return Scaffold(
        appBar: AppBar(
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
                  DataCell(Text(address)),
                ]),
                DataRow(cells: [
                  DataCell(Text("Pincode: ")),
                  DataCell(Text(pincode)),
                ]),
                DataRow(cells: [
                  DataCell(Text("Date: ")),
                  DataCell(
                    Text(Jiffy(DateTime.parse(time.toDate().toString()))
                        .yMMMMEEEEdjm),
                  ),
                ]),
                DataRow(cells: [
                  DataCell(Text("Location: ")),
                  DataCell(
                    Text(lat.toString() + ", " + lon.toString()),
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
                  DocumentReference ref = await Firestore.instance
                      .collection("fixed_potholes")
                      .add({
                    'address': address,
                    'lat': lat,
                    'lon': lon,
                    'timeStamp': Jiffy(DateTime.parse(time.toDate().toString()))
                        .yMMMMEEEEdjm,
                    'pincode': pincode,
                  });

                  try {
                    Firestore.instance
                        .collection(colname)
                        .document(id)
                        .delete();
                  } catch (e) {
                    print(e.toString());
                  }
                },
                padding: EdgeInsets.all(12),
                // color: Color(0xFF456796),
                child: Text('Fix it!',
                    style: TextStyle(
                        // color: Colors.white,
                        fontSize: 16)),
              ),
            ),
          ],
        ));
    // });
  }
}
