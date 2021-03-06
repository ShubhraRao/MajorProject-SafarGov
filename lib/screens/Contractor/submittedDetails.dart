import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:govtapp/screens/PWD/pwdhome.dart';

class SubmittedDetails extends StatefulWidget {
  final String pwdid;
  final DocumentSnapshot doc;
  final List<DocumentSnapshot> listtravel;

  const SubmittedDetails({Key key, this.doc, this.listtravel, this.pwdid})
      : super(key: key);
  @override
  _DetailsComState createState() => _DetailsComState(doc, listtravel);
}

class _DetailsComState extends State<SubmittedDetails> {
  final DocumentSnapshot doc;
  final List<DocumentSnapshot> listtravel;
  List<DocumentSnapshot> newlist = List();
  int check = 0;

  _DetailsComState(this.doc, this.listtravel);

  checkforpot() {
    // newlist = [];
    print(listtravel.length);
    for (int i = 0; i < listtravel.length; i++) {
      if ((listtravel[i].data["lat"].toString().substring(0, 5) ==
                  doc.data["lat"].toString().substring(0, 5) &&
              listtravel[i].data["lon"].toString().substring(0, 5) ==
                  doc.data["lon"].toString().substring(0, 5)) ||
          listtravel[i].data["address"] == doc.data["address"]) {
        newlist.add(listtravel[i]);
        print(newlist);
        setState(() {
          check = 1;
        });
      }
    }
  }

  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print(doc.data["url"]);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0xFF11249F),
          automaticallyImplyLeading: false,
          title: Text("Details"),
        ),
        body: Column(children: <Widget>[
          Image(
            width: 200.0,
            height: 200.0,
            image: NetworkImage(doc.data["url"]),
          ),
          DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  ' ',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  '',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Contractor')),
                  DataCell(Text(doc.data["contractorName"])),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Address')),
                  DataCell(Text(doc.data["address"])),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Date and time')),
                  DataCell(
                      Text(Jiffy(doc.data["timeStamp"].toDate()).yMMMEdjm)),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Notes')),
                  DataCell(Text(doc.data["notes"])),
                ],
              ),
            ],
          ),
        ]));
  }
}
// Expanded(
//             child: Column(
//     children: <Widget>[
//       Column(
//         children: <Widget>
//         [
//           Text("ADDRESS:"),
//       Text(doc.data["address"]),
//         ]
//       ),

//       Text(doc.data["address"]),
//       Text(doc.data["address"]),
//     ],
//   ),
// ),
// Column(
//   children: <Widget>[
// Image(
//   width: 200.0,
//   height: 200.0,
//   image: NetworkImage(doc.data["url"]),)
//   ],
// )
//         ],
//       )

//     );
//   }
// }
