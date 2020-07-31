import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:govtapp/screens/PWD/Contractor/createAcc.dart';
import 'package:govtapp/screens/PWD/Contractor/pwdcontractorservice.dart';
import 'package:govtapp/screens/PWD/Contractor/sendReport.dart';
import 'package:govtapp/screens/PWD/Contractor/deleteAcc.dart';
import 'package:govtapp/screens/PWD/pwdhome.dart';


class ViewServices extends StatefulWidget {
  final String pwdid;
  final List<DocumentSnapshot> newlist;

  const ViewServices(this.pwdid, this.newlist);
  @override
  _ViewServicesState createState() => _ViewServicesState();
}

class _ViewServicesState extends State<ViewServices> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: () {  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PWDhome(widget.pwdid))); },
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF11249F),
          automaticallyImplyLeading: false,
          title: Text("CONTRACTOR SERVICES", style: TextStyle( fontSize: 16.0)),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text("Create account", style: TextStyle(fontWeight: FontWeight.bold),),
                      onTap: () {
                       Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  RegisterCont(pwdid: widget.pwdid)));
                      },
                    ),
                    Divider(color: Colors.grey),
                    ListTile(
                      leading: Icon(Icons.delete_forever),
                      title: Text("Delete account", style: TextStyle(fontWeight: FontWeight.bold),),
                      onTap: () {
                       Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeleteAccount()));
                      }
                    ),
                    Divider(color: Colors.grey),
                    ListTile(
                      leading: Icon(Icons.send),
                      title: Text("Send report", style: TextStyle(fontWeight: FontWeight.bold),),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  SendReport(widget.pwdid, widget.newlist)));
                      }
                    ),
                    Divider(color: Colors.grey),
                    ListTile(
                      leading: Icon(Icons.view_list),
                      title: Text("View received reports", style: TextStyle(fontWeight: FontWeight.bold),),
                      onTap: () {
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  PWDContractorServices(pwdid: widget.pwdid, listtravel: widget.newlist,)));
                      }
                    ),
                    Divider(color: Colors.grey),
                  ],
                ),
              )
            )
          ]
        )
        
      ),
    );
  }
}