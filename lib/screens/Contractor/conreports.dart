import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:govtapp/screens/Contractor/condetails.dart';
import 'package:govtapp/screens/Contractor/contractormap.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfLib;

class ViewRecReport extends StatefulWidget {
  final String fname, lname, phone;

  const ViewRecReport({Key key, this.fname, this.lname, this.phone})
      : super(key: key);
  @override
  _ViewRecReportState createState() => _ViewRecReportState();
}

class _ViewRecReportState extends State<ViewRecReport> {
  List<DocumentSnapshot> listrep;
  List<DocumentSnapshot> listtravel;
   List<DocumentSnapshot> listbackup;
  List<DocumentSnapshot> newlist = List();

  bool isLoading = false;
  List<LocalityCount> listuni = List();
  List<LocalityCount> listloc = List();
  List<LocalityCount> listpin = List();
  int all = 1;
  int whichsort = 0;
  int locorpin = 0;
  int maporreport = 1;
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
  // bool isLoading = false;
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getlist();
    // TODO: implement initState
    super.initState();
  }

  getlist() async {
    QuerySnapshot querySnapshottravel =
        await Firestore.instance.collection("location_travel").getDocuments();
    listbackup = querySnapshottravel.documents;
    print(listbackup);

    QuerySnapshot querySnapshotreports = await Firestore.instance
        .collection("pwdToContractorReports")
        .getDocuments();
    listrep = querySnapshotreports.documents;

    // print(listrep[0].data["contractorName"])
    print(listrep[0].data["contractorName"]);
    print(widget.fname);
    print(widget.lname);
    print(listrep[0].data["phone"]);
    print(widget.phone);
    List<String> latlon = List();
    for(int i=0; i<listrep.length; i++)
    {
      
    }
    print(latlon);
    
    for (int i = 0; i < listbackup.length; i++) {
      for (int j = 0; j < listrep.length; j++) {
        latlon = listrep[j].data["reportlist"].toString().split(',');
        print(latlon);
        for (int k = 0; k < latlon.length; k++) {
          if (listrep[j].data["contractorName"].toString().trim().toLowerCase() ==
                  widget.fname.trim().toLowerCase() + " " + widget.lname.trim().toLowerCase() &&
              listrep[j].data["phone"] == widget.phone
               && latlon[k].trim()== listbackup[i].documentID.trim()
              )
               {
            newlist.add(listbackup[i]);
            
          }
        }
      }
    }

    // for(int i=0;i<newlist.length;i++)
    // {
    //   print(Jiffy(newlist[i].data["timeStamp"].toDate()).yMMMEdjm);
    // }

    listtravel  = newlist;
    setState((){
      isLoading = true;
    });
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
    Comparator<DocumentSnapshot> sortById =
        (a, b) => a.data["NumberOfReportings"].compareTo(b.data["NumberOfReportings"]);
    listn.sort(sortById);
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

  @override
  Widget build(BuildContext context) {
    listloc = checkdata(newlist);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("REPORT"),
        backgroundColor: Color(0xFF11249F),
        actions: <Widget>[
          (maporreport == 1)
              ? IconButton(
                  icon: Icon(Icons.location_on),
                  onPressed: () {
                    print("Go to map");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContractorMap(newlist, widget.fname,  widget.lname,  widget.phone)));
                  })
              : SizedBox(width: 0.0),
          (maporreport == 1)
              ? IconButton(
                  icon: Icon(Icons.picture_as_pdf),
                  onPressed: () {
                    _generatePdfAndView(context);
                  })
              : SizedBox(width: 0.0),
        ],
      ),
      body: (!isLoading) ? Center(child: CircularProgressIndicator()) : Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: DropdownButton(
                  hint: Text('FILTER',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF11249F))),
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
                              color: Color(0xFF11249F))),
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
        (all == 1)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // Padding(
                  //   padding:
                  // )
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text("Priority",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF11249F))),
                  ),
                ],
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
                          onTap: () {
                            print("Ughgahdadtapped");
                            setState(() {
                              maporreport = 1;
                              whichsort = 0;
                            });

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ConDetails(
                                        newlist[index], widget.fname, widget.lname, widget.phone)));
                          },
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(children: <Widget>[
                                  Expanded(
                                    child: Text(newlist[index].data["address"]),
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
                              Divider(color: Colors.grey),
                            ],
                          ),
                        );
                      })),
        )
      ]),
    );
  }

  _generatePdfAndView(context) async {
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);

    pdf.addPage(
      pdfLib.MultiPage(
        build: (context) => [
          pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
            <String>['Priority', 'Address', 'Location', 'Date'],
            ...newlist.map((item) => [
                  item.data["NumberOfReportings"].toString(),
                  item.data["address"],
                  item.data["lat"].toString().substring(0, 7) +
                      ", " +
                      item.data["lon"].toString().substring(0, 7),
                  Jiffy(DateTime.parse(
                          item.data["timeStamp"].toDate().toString()))
                      .yMMMMdjm,
                  
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
