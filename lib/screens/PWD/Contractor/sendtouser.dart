import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:govtapp/screens/PWD/pwdhome.dart';

class SendToUser extends StatefulWidget {
  final String pwdid;
  final List selectedrep;

  const SendToUser({Key key, this.selectedrep, this.pwdid}) : super(key: key);
  @override
  _SendToUserState createState() => _SendToUserState(selectedrep);
}

class _SendToUserState extends State<SendToUser> {
  final List selectedrep;
  List<DocumentSnapshot> contusers = List();
  List<DocumentSnapshot> reportlist = List();
  bool isLoading = false;

  _SendToUserState(this.selectedrep);
  final databaseReference = Firestore.instance;

  void initState() {
    getList();
    super.initState();
  }

  getList() async {
    QuerySnapshot querySnapshotreport = await Firestore.instance
        .collection("pwdToContractorReports")
        .getDocuments();
    reportlist = querySnapshotreport.documents;

    QuerySnapshot querySnapshotuser =
        await Firestore.instance.collection("users_contractor").getDocuments();
    contusers = querySnapshotuser.documents;
    setState(() {
      isLoading = true;
    });
  }

  uploadreport(DocumentSnapshot user) {
    List newlist = List();
    int there = 0;
    String updatedocid;
    // print(reportlist[i].data["reportlist"]);
    for (int i = 0; i < reportlist.length; i++) {
      if (reportlist[i].data["phone"] == user.data["phone"]) {
        newlist.addAll(reportlist[i].data["reportlist"]);
        newlist.addAll(selectedrep);
        setState(() {
          there = 1;
          updatedocid = reportlist[i].documentID;
        });
        break;
      } else {
        there = 0;
      }
    }
    if (there == 1) {
      databaseReference
          .collection("pwdToContractorReports")
          .document(updatedocid)
          .updateData({
        'reportlist': newlist,
        'pwdid': widget.pwdid,
        'timeStamp': DateTime.now()
      }).then((_) {
        showDialog(
          barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                title: new Text("Success"),
                content:
                    new Text("Your report has been sent successfully."),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PWDhome(widget.pwdid)));
                    },
                  ),
                ],
              );
            });
      });
    } else {
      databaseReference.collection("pwdToContractorReports").add({
        'contractorName': user.data["fname"] + " " + user.data["lname"],
        'phone': user.data["phone"],
        'timeStamp': DateTime.now(),
        'pwdid':
            widget.pwdid, 
            // 'PWD234',
        'reportlist': selectedrep.toString(),
      }).then((_) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                title: new Text("Success"),
                content:
                    new Text("Your report has been successfully submitted."),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PWDhome(widget.pwdid)));
                    },
                  ),
                ],
              );
            });
      });
    }
  }

  _confirmdialog(DocumentSnapshot contuser) {
    showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
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
                        "Confirm",
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
                  Padding(
                    padding: EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 30.0, bottom: 30.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "You are about to send ",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: selectedrep.length.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: " reports to"),
                                  TextSpan(
                                      text: contuser.data["fname"] +
                                          " " +
                                          contuser.data["lname"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ". Are you sure you want to continue?"),
                                ],
                              ),
                            ),
                          )
                        ]),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      uploadreport(contuser);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: Text(
                        "Send report",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
//             title: Container(
//               color: Colors.blue,
//               child: Text("Confirm")),
//             content:

//             actions: <Widget>[
//               FlatButton(
//                 child: Text("YES"),
//                 onPressed: (){},
//               ),
//               FlatButton(
//                 child: Text("NO"),
//                 onPressed: (){
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFF11249F),
            automaticallyImplyLeading: false,
            title: Text("CONTRACTORS")),
        body: (!isLoading)
            ? Center(child: CircularProgressIndicator())
            : Column(children: <Widget>[
                Expanded(
                    child: Container(
                        child: ListView.builder(
                            shrinkWrap: false,
                            itemCount: contusers.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(Icons.send),
                                title: Text(contusers[index].data["fname"] +
                                    " " +
                                    contusers[index].data["lname"], style: TextStyle(fontWeight: FontWeight.bold),),
                                subtitle:
                                    Text(contusers[index]
                                      .data["conId"] + " | " + contusers[index]
                                      .data["phone"]
                                      .toString()),
                                onTap: () {
                                  _confirmdialog(contusers[index]);
                                },
                              );
                            })))
              ]));
  }
}
