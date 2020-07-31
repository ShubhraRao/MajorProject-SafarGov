import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:govtapp/screens/PWD/Contractor/createAcc.dart';
import 'package:govtapp/screens/PWD/Contractor/getcondetails.dart';

class PWDContractorServices extends StatefulWidget {
  final List<DocumentSnapshot> listtravel;
  final String pwdid;

  const PWDContractorServices({Key key, this.pwdid, this.listtravel}) : super(key: key);

  @override
  _PWDContractorServicesState createState() => _PWDContractorServicesState();
}

class _PWDContractorServicesState extends State<PWDContractorServices> {
  List<DocumentSnapshot> contusers = List();
  List<DocumentSnapshot> contrep = List();
  bool isLoading = false;
   List<FixedCount> usercount = List();

  void initState() {
    getList();
    super.initState();
  }

  getList() async {
    QuerySnapshot querySnapshotuser =
        await Firestore.instance.collection("users_contractor").getDocuments();
    contusers = querySnapshotuser.documents;

    QuerySnapshot querySnapshotrep =
        await Firestore.instance.collection("fixedReport").getDocuments();
    contrep = querySnapshotrep.documents;
    List<String> users = List();
    List<String> usersbackup = List();   


    for (int i = 0; i < contusers.length; i++) {
      users.add(contusers[i].data["fname"] + " " +contusers[i].data["lname"]);
    }

    for (int i = 0; i < contrep.length; i++) {
      usersbackup.add(contrep[i].data["contractorName"]);
    }
    print(users);
    // usersbackup = usersbackup.add(value)
    var map = Map();
    usersbackup.forEach((element) {
      if (!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] += 1;
      }
    });

    print(map);
    map.forEach((k, v) => usercount.add(FixedCount(k, v)));
    print(usercount);
    // usersuniq = users.toSet().toList();
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF11249F),
          automaticallyImplyLeading: false,
          title: Text("Choose contractor"),
        ),
        body: (!isLoading)
            ? Center(child: CircularProgressIndicator())
            : Column(children: <Widget>[
                
                Expanded(
                    child: Container(
                        child: ListView.builder(
                            itemCount: usercount.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: <Widget>[
                                  ListTile(
                                      title: Text(
                                          usercount[index].user, style: TextStyle(
                                            fontWeight: FontWeight.bold
                                          ),),
                                      subtitle:(usercount[index].count>1) ? Text(usercount[index].count.toString() + " REPORTS") : Text(usercount[index].count.toString() + " REPORT"),
                                      onTap: () {
                                         Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => 
                                        GetConDetail(pwdid: widget.pwdid, list: contrep, listtravel: widget.listtravel)));
                                      }),
                                  Divider(
                                    color: Colors.grey,
                                  )
                                ],
                              );
                            })))
              ]));
  }
}

class FixedCount {
  final String user;
  final int count;

  FixedCount(this.user, this.count);
}
