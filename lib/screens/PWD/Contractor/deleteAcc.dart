import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteAccount extends StatefulWidget {
  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  List<DocumentSnapshot> listusers;
  bool isLoading = false;
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getList();
    super.initState();
  }

  getList() async {
    QuerySnapshot querySnapshottravel =
        await Firestore.instance.collection("users_contractor").getDocuments();
    listusers = querySnapshottravel.documents;
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF11249F),
          title: Text("Delete account"),
        ),
        body: (!isLoading)
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Expanded(
                      child: Container(
                          child: ListView.builder(
                              itemCount: listusers.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    listusers[index].data["fname"] +
                                        " " +
                                        listusers[index].data["lname"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(listusers[index]
                                      .data["conId"] + " | " + listusers[index]
                                      .data["phone"]
                                      .toString()),
                                  trailing: IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  28.0))),
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(20.0,
                                                          20.0, 20.0, 0.0),
                                                  title: Row(children: <Widget>[
                                                    Icon(Icons.delete_sweep,
                                                        color: Colors.red),
                                                    Text('\tWarning')
                                                  ]),
                                                  content: Text(
                                                    'You are about to delete ' +
                                                        listusers[index]
                                                            .data["fname"] +
                                                        " " +
                                                        listusers[index]
                                                            .data["lname"] +
                                                        '\'s account forever. Press yes to confirm.',
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                        child: Text("Yes"),
                                                        onPressed: () {
                                                          Firestore.instance
                                                              .collection(
                                                                  "users_contractor")
                                                              .document(listusers[
                                                                      index]
                                                                  .documentID)
                                                              .delete()
                                                              .then((value) {
                                                            getList();
                                                            Navigator.pop(context);
                                                            _scaffoldKey
                                                                .currentState
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text("Successfully deleted!")));
                                                          });
                                                        }),
                                                    FlatButton(
                                                      child: Text("No"),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    
                                                  ]);
                                            });
                                      },
                                      icon: Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                      )),
                                );
                              })))
                ],
              ));
  }
}
