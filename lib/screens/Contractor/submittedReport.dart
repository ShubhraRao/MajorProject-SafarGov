import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:govtapp/screens/Contractor/submittedDetails.dart';
// import 'package:govtapp/screens/PWD/Contractor/showdets.dart';
import 'package:jiffy/jiffy.dart';

class SubmittedReport extends StatefulWidget {
  final String pwdid;
  final List<DocumentSnapshot> list;
  final List<DocumentSnapshot> listtravel;

  const SubmittedReport({Key key, this.list, this.listtravel, this.pwdid})
      : super(key: key);
  @override
  _GetConDetailState createState() => _GetConDetailState(list);
}

class _GetConDetailState extends State<SubmittedReport> {
  final List<DocumentSnapshot> list;

  _GetConDetailState(this.list);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFF11249F),
            automaticallyImplyLeading: false,
            title: Text("Report")),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(list[index].data["address"]),
                        subtitle: Text(
                            Jiffy(list[index].data["timeStamp"].toDate())
                                .yMMMEdjm),
                        trailing: (list[index].data["fixed"] == "true")
                            ? Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                  children: <Widget>[
                                    Icon(Icons.check_circle, color: Colors.green),
                                    Text("Fixed"),
                                  ],
                                ),
                            )
                            :
                            // SizedBox(width:0.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                  children: <Widget>[
                                    Icon( 
                                      Icons.build,
                                      color: Colors.brown,
                                    ),
                                    Text("PENDING", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0))
                                  ],
                                ),
                            ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SubmittedDetails(
                                        pwdid: widget.pwdid,
                                        doc: list[index],
                                        listtravel: widget.listtravel,
                                      )));
                        },
                      );
                    }),
              ),
            )
          ],
        ));
  }
}
