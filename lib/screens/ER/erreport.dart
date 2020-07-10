import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:govtapp/screens/ER/details.dart';

class ERReport extends StatelessWidget {
  final String pincode;
  ERReport(this.pincode);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pothole Detection Application',
      home: MyHomePage(this.pincode),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String pincode;

  const MyHomePage(this.pincode);
  @override
  _MyHomePageState createState() {
    return _MyHomePageState(this.pincode);
  }
}

class LocImage {
  final String address;
  final String lat;
  final String lon;
  final String pincode;
  final Timestamp timeStamp;
  final DocumentReference reference;

  LocImage.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['address'] != null),
        assert(map['lat'] != null),
        assert(map['lon'] != null),
        assert(map['pincode'] != null),
        assert(map['timeStamp'] != null),
        address = map['address'],
        lat = map['lat'].toString(),
        lon = map['lon'].toString(),
        pincode = map['pincode'],
        timeStamp = map['timeStamp'];

  LocImage.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Loc<$address:$pincode>";
}

class LocTravel {
  final String address;
  final String lat;
  final String lon;
  final String pincode;
  final Timestamp timeStamp;
  final DocumentReference reference;

  LocTravel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['address'] != null),
        assert(map['lat'] != null),
        assert(map['lon'] != null),
        assert(map['pincode'] != null),
        assert(map['timeStamp'] != null),
        address = map['address'],
        lat = map['lat'].toString(),
        lon = map['lon'].toString(),
        pincode = map['pincode'],
        timeStamp = map['timeStamp'];

  LocTravel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Loc<$address:$pincode>";
}

class _MyHomePageState extends State<MyHomePage> {
  String travelcolname = "location_travel";
  String imagecolname = "location_image";
  final String pincode;

  _MyHomePageState(this.pincode);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pothole Report')),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical, child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    int i = 0;
    return Column(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection(travelcolname).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            
              return DataTable(
                  columns: [
                    // DataColumn(label: Text('Sl.No.')),
                    DataColumn(label: Text('Address')),
                    DataColumn(label: Text('')),
                  ],
                  rows: _buildList(
                      travelcolname, i++, context, snapshot.data.documents));
           
          },
        ),
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection(imagecolname).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            
              return DataTable(
                columns: [
                  // DataColumn(label: Text('Sl.No.')),
                  DataColumn(label: Text('Address')),
                  DataColumn(label: Text('')),
                ],
                rows: _buildList(
                    imagecolname, i++, context, snapshot.data.documents),
                headingRowHeight: 0.0,
              );
           
          },
        ),
      ],
    );
  }

  List<DataRow> _buildList(
      cname, int i, BuildContext context, List<DocumentSnapshot> snapshot) {
    // if(snapshot.)
    // print()
    // if(snapshot[i].data['pincode'].toString().trim() == pincode.trim())
    // {
    return snapshot
        .map<DataRow>((data) => _buildListItem(cname, i++, context, data))
        .toList();
    // }
    // else
    // {
    //   return SizedBox(width: 0.0);
    // }
  }

  _buildListItem(cname, int i, BuildContext context, DocumentSnapshot data) {
    final record = LocTravel.fromSnapshot(data);
    // print(data["address"]);

    // for(int i=0; i<data.data.length; i++)
    // {
    // print("Pincode is: " + pincode);
    print(data["pincode"].trim());

    return DataRow(cells: [
      // DataCell(Text(i.toString())),
      DataCell(GestureDetector(
        child: Text(record.address),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ERPotholeDetails(
                      cname,
                      record.reference.documentID,
                      record.address,
                      record.pincode,
                      record.lat,
                      record.lon,
                      record.timeStamp)));
        },
      )),
      // DataCell(Text(record.pincode)),
      DataCell(GestureDetector(
        child: Icon(Icons.arrow_right),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ERPotholeDetails(
                      cname,
                      record.reference.documentID,
                      record.address,
                      record.pincode,
                      record.lat,
                      record.lon,
                      record.timeStamp)));
        },
      ))
    ]);
  }
}
