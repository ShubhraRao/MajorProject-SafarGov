import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:govtapp/screens/PWD/Contractor/sendtouser.dart';
import 'package:govtapp/screens/PWD/pwdmap.dart';
import 'package:govtapp/screens/PWD/pwdpotdetails.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

class SendReport extends StatefulWidget {
  final String uid;
  final List<DocumentSnapshot> doc;
  const SendReport(this.uid, this.doc);

  @override
  _SendReportState createState() => _SendReportState(uid);
}

class _SendReportState extends State<SendReport> {
  final String uid;
  List<DocumentSnapshot> listtravel = List();
  List<DocumentSnapshot> newlist = List();
  List<DocumentSnapshot> listimage = List();
  bool isLoading = false;
  List<LocalityCount> listuni = List();
  List<LocalityCount> listloc = List();
  List<LocalityCount> listpin = List();
  int all = 1;
  var _tapPosition;
  bool checkBoxValue = false;
  int whichsort = 0;
  List<String> dropdown = ['View all potholes', 'Ward', 'Pincode'];
  List<String> dropdownSort = [
    'Priority',
    'Oldest to Newest',
    'Newest to Oldest'
  ];
  List<String> filteredsort = ['Number of potholes', 'A - Z', 'Z - A'];
  String _selectedLocation;
  String _selectedSort;
  String _selectedFilteredSort;
  int locorpin = 0;
  int maporreport = 1;
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _SendReportState(this.uid);

  void initState() {
    // getlist();
    print("Print init");
    print(widget.doc);
    listtravel = widget.doc;
    newlist = listtravel;
    checknum();
    super.initState();
  }

  // getlist() async {
  // QuerySnapshot querySnapshottravel =
  //     await Firestore.instance.collection("location_travel").getDocuments();
  // listtravel = querySnapshottravel.documents;
  //   newlist = listtravel;
  //   QuerySnapshot querySnapshotimage =
  //       await Firestore.instance.collection("location_image").getDocuments();
  //   listimage = querySnapshotimage.documents;
  //   // listtravel.addAll(listimage);
  //   setState(() {
  //     isLoading = true;
  //   });
  //   print(listtravel);
  // }

  checknum() {
    for (int i = 0; i < newlist.length; i++) {
      if (newlist[i].data["NumberOfReportings"] == null) {
        print("Printingsdhgas");
        print(newlist[i].documentID);
      }
    }
  }

  checkdata(newlist) {
    List<String> list1 = List();
    List<LocalityCount> listlocret = List();
    for (int i = 0; i < newlist.length; i++) {
      list1.add(newlist[i].data["subLocality"]);
    }

    var map = Map();

    list1.forEach((element) {
      if (!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] += 1;
      }
    });

    print(map);
    map.forEach((k, v) => listlocret.add(LocalityCount(k, v)));
    print(listlocret);
    return listlocret;
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  _showMenu(DocumentSnapshot doc) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      position: RelativeRect.fromRect(
          _tapPosition & Size(60, 60), Offset.zero & overlay.size),
      // position: RelativeRect.fromLTRB(100, 200, 10, 200),
      context: context,
      items: [
        PopupMenuItem(
          child: GestureDetector(
              onTap: () {
                
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PWDPotholeDetails(uid, doc)));
              },
              child: Text("View details")),
        ),
      ],
      elevation: 8.0,
    );
  }

  checkpincode(newlist) {
    List<String> listpin1 = List();
    List<LocalityCount> listpincoderet = List();
    for (int i = 0; i < newlist.length; i++) {
      listpin1.add(newlist[i].data["pincode"]);
    }
    var map = Map();
    listpin1.forEach((element) {
      if (!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] += 1;
      }
    });
    print(map);
    map.forEach((k, v) => listpincoderet.add(LocalityCount(k, v)));
    print(listpincoderet);
    return listpincoderet;
  }

  sortbypriority(listn) {
    Comparator<DocumentSnapshot> sortById = (a, b) =>
        a.data["NumberOfReportings"].compareTo(b.data["NumberOfReportings"]);
    listn.sort(sortById);
    print(listn);
    return listn;
  }

  sortbydate(listn) {
    Comparator<DocumentSnapshot> sortById =
        (a, b) => a.data["timeStamp"].compareTo(b.data["timeStamp"]);
    listn.sort(sortById);
    return listn;
  }

  sortbycount(listn) {
    Comparator<LocalityCount> sortById = (a, b) => a.count.compareTo(b.count);
    listn.sort(sortById);
    return listn;
  }

  sortbyalpha(listn) {
    Comparator<LocalityCount> sortById =
        (a, b) => a.locality.compareTo(b.locality);
    listn.sort(sortById);
    return listn;
  }

  getlocfilteredlist(String sublocality) {
    List<DocumentSnapshot> retlist = List();
    for (int i = 0; i < newlist.length; i++) {
      print(newlist[i].data["subLocality"]);
      if (newlist[i].data["subLocality"] == sublocality) {
        retlist.add(newlist[i]);
      }
    }
    return retlist;
  }

  getpinfilteredlist(String pincode) {
    List<DocumentSnapshot> retlist = List();
    for (int i = 0; i < newlist.length; i++) {
      print(newlist[i].data["pincode"]);
      if (newlist[i].data["pincode"] == pincode) {
        retlist.add(newlist[i]);
      }
    }
    return retlist;
  }

  List _selecteCategorys = List();
  Map<String, dynamic> categories1;

  void _onCategorySelected(bool selected, categoryId) {
    if (selected == true) {
      setState(() {
        _selecteCategorys.add(categoryId);
        print("Selected");
        print(_selecteCategorys);
      });
    } else if (selected == false) {
      setState(() {
        _selecteCategorys.remove(categoryId);
        print("Selected");
        print(_selecteCategorys);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    listloc = checkdata(newlist);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("REPORT"),
        backgroundColor: Color(0xFF11249F),
        // actions: <Widget>[
        //   (maporreport == 1)
        //       ? IconButton(
        //           icon: Icon(Icons.location_on),
        //           onPressed: () {
        //             print("Go to map");
        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => PWDViewMap(uid, newlist)));
        //           })
        //       : SizedBox(width: 0.0),
        //   (maporreport == 1)
        //       ? IconButton(
        //           icon: Icon(Icons.picture_as_pdf),
        //           onPressed: () {
        //             _generatePdfAndView(context);
        //           })
        //       : SizedBox(width: 0.0),
        // ],
      ),
      body: Column(children: <Widget>[
        Container(
          color: Color(0xFF6bb0ff),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: DropdownButton(
                    hint: Text('FILTER',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    value: _selectedLocation,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedLocation = newValue;
                      });
                    },
                    items: dropdown.map((location) {
                      return DropdownMenuItem(
                        child: new Text(location,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                        value: location,
                        onTap: () {
                          if (location == "Ward") {
                            setState(() {
                              maporreport = 0;
                              whichsort = 1;
                              locorpin = 1;
                              newlist = listtravel;
                              listloc = checkdata(newlist);
                              all = 0;
                              listuni = listloc;
                            });
                          } else if (location == "Pincode") {
                            setState(() {
                              maporreport = 0;
                              whichsort = 1;
                              locorpin = 2;
                              newlist = listtravel;
                              listpin = checkpincode(newlist);
                              all = 0;
                              listuni = listpin;
                            });
                          } else if (location == "View all potholes") {
                            setState(() {
                              whichsort = 0;
                              newlist = listtravel;
                              all = 1;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
                (whichsort == 0)
                    ? DropdownButton(
                        hint: Text('SORT',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF11249F))),
                        value: _selectedSort,
                        onChanged: (newSortValue) {
                          setState(() {
                            _selectedSort = newSortValue;
                          });
                        },
                        items: dropdownSort.map((sortval) {
                          return DropdownMenuItem(
                            child: new Text(sortval,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF11249F))),
                            value: sortval,
                            onTap: () {
                              if (sortval == "Priority") {
                                setState(() {
                                  // newlist = listtravel;
                                  newlist = sortbypriority(newlist);
                                  newlist = newlist.reversed.toList();
                                  all = 1;
                                });
                              } else if (sortval == "Oldest to Newest") {
                                setState(() {
                                  // newlist = listtravel;
                                  newlist = sortbydate(newlist);
                                  all = 1;
                                });
                              } else if (sortval == "Newest to Oldest") {
                                setState(() {
                                  // newlist = listtravel;
                                  newlist = sortbydate(newlist);
                                  newlist = newlist.reversed.toList();
                                  all = 1;
                                });
                              }
                            },
                          );
                        }).toList(),
                      )
                    : DropdownButton(
                        hint: Text('SORT',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF11249F))),
                        value: _selectedFilteredSort,
                        onChanged: (newSortValue) {
                          setState(() {
                            _selectedFilteredSort = newSortValue;
                          });
                        },
                        items: filteredsort.map((sortval) {
                          return DropdownMenuItem(
                            child: new Text(sortval,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF11249F))),
                            value: sortval,
                            onTap: () {
                              if (sortval == "Number of potholes") {
                                setState(() {
                                  maporreport = 0;
                                  newlist = listtravel;
                                  listuni = sortbycount(listuni);
                                  listuni = listuni.reversed.toList();
                                });
                              } else if (sortval == "A - Z") {
                                setState(() {
                                  maporreport = 0;
                                  newlist = listtravel;
                                  listuni = sortbyalpha(listuni);
                                });
                              } else if (sortval == "Z - A") {
                                setState(() {
                                  maporreport = 0;
                                  newlist = listtravel;
                                  listuni = sortbyalpha(listuni);
                                  listuni = listuni.reversed.toList();
                                });
                              }
                            },
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
        ),
        (all == 1)
            ? Container(
                color: Color(0xFFe6f1ff),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 11.0),
                      child: Row(children: <Widget>[
                        new Checkbox(
                            value: checkBoxValue,
                            activeColor: Colors.blue,
                            onChanged: (bool newValue) {
                              setState(() {
                                if (newValue == true) {
                                  for (int i = 0; i < newlist.length; i++) {
                                    _selecteCategorys
                                        .add(newlist[i].documentID);
                                  }
                                  checkBoxValue = newValue;
                                } else if (newValue == false) {
                                  _selecteCategorys.removeRange(
                                      0, _selecteCategorys.length);

                                  checkBoxValue = newValue;
                                  print(_selecteCategorys);
                                }
                              });
                            }),
                        Text(
                          'Select All',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text("Priority",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF11249F))),
                    ),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text("No. of potholes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF11249F))),
                  ),
                ],
              ),
        Expanded(
          child: Container(
              child: (all == 0)
                  ? ListView.builder(
                      itemCount: listuni.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            print("Tapped!");
                            if (locorpin == 1) {
                              setState(() {
                                maporreport = 1;
                                whichsort = 0;
                                all = 1;
                                newlist =
                                    getlocfilteredlist(listuni[index].locality);
                              });
                            } else if (locorpin == 2) {
                              setState(() {
                                maporreport = 1;
                                whichsort = 0;
                                all = 1;
                                newlist =
                                    getpinfilteredlist(listuni[index].locality);
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(child: Text(listuni[index].locality)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(listuni[index].count.toString(),
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          ),
                        );
                      })
                  : ListView.builder(
                      itemCount: newlist.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTapDown: _storePosition,
                          onLongPress: () {
                            _showMenu(newlist[index]);
                          },
                          child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _selecteCategorys
                                .contains(newlist[index].documentID),
                            onChanged: (bool selected) {
                              // setState(() {
                              _onCategorySelected(
                                  selected, newlist[index].documentID);
                              // });
                            },
                            title: Row(children: <Widget>[
                              Expanded(
                                child: Text(
                                   newlist[index].data["address"],
                                    // newlist[index].data["placename"] +
                                    //     ", " +
                                    //     newlist[index].data["thoroughfare"] +
                                    //     ", " +
                                    //     newlist[index].data["subLocality"],
                                    style: TextStyle(fontSize: 12.0)),
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                  newlist[index]
                                      .data["NumberOfReportings"]
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0))
                            ]),
                          ),
                        );
                        // return GestureDetector(
                        //   onTap: () {
                        //     print("Ughgahdadtapped");
                        //     setState(() {
                        //       maporreport = 1;
                        //       whichsort = 0;
                        //     });

                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => PWDPotholeDetails(
                        //                 uid, newlist[index])));
                        //   },
                        //   child: Column(
                        //     children: <Widget>[
                        //       Padding(
                        //         padding: const EdgeInsets.all(10.0),
                        //         child: Row(children: <Widget>[
                        //           Expanded(
                        //             child: Text(newlist[index].data["address"]),
                        //           ),
                        //           SizedBox(width: 10.0),
                        //           Text(
                        //               newlist[index]
                        //                   .data["priority"]
                        //                   .toString(),
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.bold,
                        //                   fontSize: 18.0))
                        //         ]),
                        //       ),
                        //       Divider(color: Colors.grey),
                        //     ],
                        //   ),
                        // );
                        // ListTile(
                        //     title: Text(newlist[index].data["address"]),
                        //     subtitle: Text(newlist[index].data["priority"].toString())
                        // Text(Jiffy(DateTime.parse(newlist[index]
                        //         .data["timeStamp"]
                        //         .toDate()
                        //         .toString()))
                        //     .yMMMMEEEEdjm)
                        //     );
                      })),
        ),
        (all != 0)
            ? Container(
                color: Color(0xFF11249F),
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                    color: Color(0xFF11249F),
                    child: Text(
                        "SEND REPORT (" +
                            _selecteCategorys.length.toString() +
                            ")",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SendToUser(
                                    pwdid: uid, 
                                    selectedrep: _selecteCategorys)));
                    }),
              )
            : SizedBox(width: 0.0),
      ]),
    );
  }

  _generatePdfAndView(context) async {
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);

    pdf.addPage(
      pdfLib.MultiPage(
        build: (context) => [
          pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
            <String>['Priority', 'Address', 'Location', 'Date', 'Source'],
            ...newlist.map((item) => [
                  item.data["NumberOfReportings"].toString(),
                  item.data["address"],
                  item.data["lat"].toString().substring(0, 7) +
                      ", " +
                      item.data["lon"].toString().substring(0, 7),
                  Jiffy(DateTime.parse(
                          item.data["timeStamp"].toDate().toString()))
                      .yMMMMdjm,
                  (item.data['url'] != null) ? "Image" : "Sensor"
                ])
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
}

class LocalityCount {
  final String locality;
  final int count;

  LocalityCount(this.locality, this.count);
}
