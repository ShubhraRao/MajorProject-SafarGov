import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'details.dart';

class GetReport extends StatefulWidget {
  final String ward, erid;
  final List<DocumentSnapshot> list;

  const GetReport(this.ward, this.erid, this.list);
  @override
  _GetReportState createState() => _GetReportState(ward, erid, list);
}

class _GetReportState extends State<GetReport> {
  final String ward, erid;
  final List<DocumentSnapshot> list;

  List<DocumentSnapshot> listtravel = List();
  List<DocumentSnapshot> listimage = List();
  List<DocumentSnapshot> newlist = List();
  List<DocumentSnapshot> backuplist = List();
  bool isLoading = false;
  var lastweek, lastday;
  int countweek = 0;
  int countday = 0;
  List<String> dropdownSort = [
    'Priority',
    'Oldest to Newest',
    'Newest to Oldest'
  ];
  String _selectedSort;
  int aa = 0;

  _GetReportState(this.ward, this.erid, this.list);
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    // getlist();

    lastweek = DateTime.now().subtract(new Duration(days: 7));
    lastday = DateTime.now().subtract(const Duration(days: 1));
    setState(() {
      listtravel = list;
      filterlist();
    });

    super.initState();
  }

  var databaseReference = Firestore.instance;

  // getlist() {
  //   print("Sending");
  //   for (int i = 0; i < list.length; i++) {
  //     databaseReference
  //         .collection("location_travel")
  //         .document(list[i].documentID)
  //         .updateData({
  //       'erSeen': "NO",
  //     }).then((value) => print("Dome"));
  //   }
  // }

  // getlist() async {
  //   QuerySnapshot querySnapshottravel =
  //       await Firestore.instance.collection("location_travel").getDocuments();
  //   listtravel = querySnapshottravel.documents;
  //   // QuerySnapshot querySnapshotimage =
  //   //     await Firestore.instance.collection("location_image").getDocuments();
  //   // var listimage = querySnapshotimage.documents;
  //   // listtravel.addAll(listimage);
  //   setState(() {
  //     isLoading = true;
  //   });
  // }

  sortbypriority(listn) {
    Comparator<DocumentSnapshot> sortById = (a, b) =>
        a.data["NumberOfReportings"].compareTo(b.data["NumberOfReportings"]);
    listn.sort(sortById);

    print(listn[0].data["timeStamp"]);
    return listn;
  }

  sortbydate(listn) {
    Comparator<DocumentSnapshot> sortById =
        (a, b) => a.data["timeStamp"].compareTo(b.data["timeStamp"]);
    listn.sort(sortById);
    print(listn);
    print(listn[0].data["timeStamp"].toDate());
    return listn;
  }

  filterlist() {
    newlist.clear();
    print("filtering");
    print(listtravel);
    for (int i = 0; i < listtravel.length; i++) {
      if (listtravel[i].data["subLocality"].toString().trim().toLowerCase() ==
          ward.trim().toLowerCase()) {
        newlist.add(listtravel[i]);
      }
    }
    print(newlist);
    // newlist;
    // print(listtravel.length);
    // print(newlist.length);

    // for (int i = 0; i < newlist.length; i++) {
    //   if (newlist[i].data["timeStamp"].toDate().isAfter(lastweek)) {
    //     countweek++;
    //   }
    //   if (newlist[i].data["timeStamp"].toDate().isAfter(lastday)) {
    //     countday++;
    //   }
    // }
  }

  void showalert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(22.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: 12.0, right: 12.0, top: 30.0, bottom: 30.0),
                  child: Text("Last 24 hours: " + countday.toString()),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 12.0, right: 12.0, top: 8.0, bottom: 30.0),
                  child: Text("Last 7 days: " + countweek.toString()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // List<DocumentSnapshot> data;

  _generatePdfAndView(context) async {
    //  final record = LocModel.fromSnapshot(newlist[0]);

    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    // newlist.forEach((element) { })
    // var newmap = newlist.ma

    pdf.addPage(
      pdfLib.MultiPage(
        build: (context) => [
          pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
            <String>[
              'Priority' + "\t",
              'Location',
              'Address',
              'Date',
              'Source' + "\t"
            ],
            ...newlist.map((item) => [
                  item.data["NumberOfReportings"].toString() + "\t",
                  item.data["lat"].toString().substring(0, 7) +
                      ", " +
                      item.data["lon"].toString().substring(0, 7),
                  item.data["address"],
                  Jiffy(DateTime.parse(
                          item.data["timeStamp"].toDate().toString()))
                      .yMMMMdjm,
                  (item.data['source'] == "Sensor" ||
                          item.data['Source'] == "Sensor" ||
                          item.data['source'] == "sensor" ||
                          item.data['Source'] == "sensor")
                      ? "Travel"
                      : "Image"
                ])
            // <List<String>>[ <String>[
            //   newlist.map((item) => [item.data["address"], [item.data["pincode"]], ],).toString()
            //  ]
          ]),
        ],
      ),
    );
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    print(date);
    String name = now.toString().split(" ")[0].split("-")[0] +
        now.toString().split(" ")[0].split("-")[1] +
        now.toString().split(" ")[0].split("-")[2];

    final String dir = (await getExternalStorageDirectory()).path;
    final String path = '$dir/PotholeReport_$name.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
    print(path);
    print("Success");
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text("PDF downloaded in " + path)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: SizedBox(width: 0.0),
        backgroundColor: Color(0xFF11249F),
        title: Text("Report"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () {
                // showalert();
                _generatePdfAndView(context);
              }),
          // IconButton(
          //     icon: Icon(Icons.assignment),
          //     onPressed: () {
          //       showalert();
          //       // _generatePdfAndView(context);
          //     }),
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: DropdownButton(
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('SORT',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF11249F))),
                  ),
                  value: _selectedSort,
                  onChanged: (newSortValue) {
                    setState(() {
                      _selectedSort = newSortValue;
                    });
                  },
                  items: dropdownSort.map((sortval) {
                    return DropdownMenuItem(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Text(sortval,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFF11249F))),
                      ),
                      value: sortval,
                      onTap: () {
                        if (sortval == "Priority") {
                          setState(() {
                            aa = 1;
                            // newlist = listtravel;
                            newlist = sortbypriority(newlist);
                            newlist = newlist.reversed.toList();
                            // all = 1;
                          });
                        } else if (sortval == "Oldest to Newest") {
                          setState(() {
                            aa = 2;
                            // newlist = listtravel;
                            // newlist = sortbydate(newlist);
                            // all = 1;
                            // newlist.clear();
                            print(newlist[0].data["timeStamp"].toDate());
                          });
                        } else if (sortval == "Newest to Oldest") {
                          setState(() {
                            aa = 3;
                            // newlist = listtravel;
                            newlist = sortbydate(newlist);
                            newlist = newlist.reversed.toList();

                            print(newlist[0].data["timeStamp"].toDate());
                            // all = 1;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 12.0, 12.0),
                child: Text(
                  "Priority",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ClipRRect(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ListView.builder(
                      itemCount: newlist.length,
                      itemBuilder: (context, index) {
                        print("Sett");
                        print(aa);
                        if (aa == 2) {
                          newlist = sortbydate(newlist);
                        } else if (aa == 3) {
                          newlist = sortbydate(newlist);
                          newlist = List.from(newlist.reversed);
                        } else if (aa == 1) {
                          newlist = sortbypriority(newlist);
                          newlist = List.from(newlist.reversed);
                        }

                        print(newlist[0].data["timeStamp"].toDate());
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ERPotholeDetails(
                                          erid, newlist[index])));
                            },
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: (newlist[index]
                                          .data["erSeen"] == "YES") ?
                                  Icon(Icons.check, color:Colors.blue, size: 16.0) : Icon(Icons.brightness_1, color:Colors.red, size: 9.0)
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(newlist[index].data["address"]),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      newlist[index]
                                          .data["NumberOfReportings"]
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0)),
                                ),
                              ],
                            ));
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
