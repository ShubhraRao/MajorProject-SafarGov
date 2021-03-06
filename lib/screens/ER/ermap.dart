import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'details.dart';
// import 'package:potholedetection/screens/try2.dart';

class ERViewMap extends StatelessWidget {
  final String ward;
  final String erid;
  const ERViewMap(this.erid, this.ward);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SafarGov",
      debugShowCheckedModeBanner: false,
      home: ViewMapPage(this.erid, this.ward),
    );
  }
}

class ViewMapPage extends StatefulWidget {
  final String ward;
  final String erid;

  const ViewMapPage(this.erid, this.ward);
  @override
  _ViewMapPageState createState() => _ViewMapPageState(this.erid, this.ward);
}

class _ViewMapPageState extends State<ViewMapPage> {
  final String ward;
  final String erid;
  bool isLoading = false;
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Marker> allMarkers = [];
  double lat, lon;
  double lat1, lon1;
  String travelcname = "location_travel";
  // String imagecname = "location_image";

  GoogleMapController _controller;
  // QuerySnapshot querySnapshot;
  QuerySnapshot querySnapshot1;

  _ViewMapPageState(this.erid, this.ward);

  @override
  void initState() {
    super.initState();
    // getLocImage().then((results) {
    //   setState(() {
    //     querySnapshot = results;
    //     // print(querySnapshot.documents);
    //   });
    // });

   

    getLocTravel().then((results1) {
      setState(() {
        querySnapshot1 = results1;
        setState(() {
          isLoading= true;
        });
        // print(querySnapshot1.documents);
      });
    });
  }

   void _showDialog(DocumentSnapshot doc) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
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
                  
                  Padding(
                    padding: EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 30.0, bottom: 30.0),
                    child: Text(doc.data["address"],
                        
                        textAlign: TextAlign.center),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ERPotholeDetails(erid, doc)));
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
                        "View Details",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

  // getLat() {
  //   for (int i = 0; i < querySnapshot.documents.length; i++) {
  //     if (querySnapshot.documents[i].data['pincode'] == pincode) {
  //       print(querySnapshot.documents[i].data['pincode']);
  //       lat1 = parseDouble(querySnapshot.documents[i].data['lat']);
  //       lon1 = parseDouble(querySnapshot.documents[i].data['lon']);

  //       allMarkers.add(Marker(
  //           markerId: MarkerId(i.toString()),
  //           draggable: true,
  //           onTap: () {
  //             print("Alert!");
  //             _showDialog(querySnapshot.documents[i]);
  //             CameraPosition(target: LatLng(lat1, lon1), zoom: 16.0);
  //           },
  //           position: LatLng(lat1, lon1)));
  //     }
  //   }
  //   // print(allMarkers);
  // }

  getLon() {
    print("Happening");
    print(ward);
    for (int i = 0; i < querySnapshot1.documents.length; i++) {
      print(querySnapshot1.documents[i].data['subLocality']);
      if (querySnapshot1.documents[i].data['subLocality'].toString().trim().toLowerCase() == ward.trim().toLowerCase()) {
        print(querySnapshot1.documents[i].data['subLocality']);
        lat1 = parseDouble(querySnapshot1.documents[i].data['lat']);
        lon1 = parseDouble(querySnapshot1.documents[i].data['lon']);
print("Happening");
        allMarkers.add(Marker(
            markerId: MarkerId(i.toString()),
            draggable: true,
            onTap: () {
              _showDialog(querySnapshot1.documents[i]);

              CameraPosition(target: LatLng(lat1, lon1), zoom: 16.0);
            },
            position: LatLng(lat1, lon1)));
      }
    }
    print(allMarkers);
  }

  double parseDouble(dynamic value) {
    try {
      if (value is String) {
        return double.parse(value);
      } else if (value is double) {
        return value;
      } else {
        return 0.0;
      }
    } catch (e) {
      // return null if double.parse fails
      return null;
    }
  }

  // getLocImage() async {
  //   return await Firestore.instance.collection(imagecname).getDocuments();
  // }

  getLocTravel() async {
    return await Firestore.instance
        .collection(travelcname)
        .getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    // if (querySnapshot != null) {
    //   print("AAadsadadd");
    //   // getLat();
    //   getLon();
    // }
    // getLat();
    if(isLoading)
    getLon();
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: Text('Maps'),
      // ),
      body: (!isLoading) ? Center(child: CircularProgressIndicator()) : Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(lat1, lon1), zoom: 14.0),
            markers: Set.from(allMarkers),
            onMapCreated: mapCreated,
          ),
        ),
      ]),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
}
