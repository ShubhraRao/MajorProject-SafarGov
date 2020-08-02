import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:govtapp/screens/PWD/pwdpotdetails.dart';

  
class FixedViewMap extends StatelessWidget {
  final String pwdid;
  final List<DocumentSnapshot> doc;
  const FixedViewMap(this.pwdid, this.doc);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SafarGov",
      debugShowCheckedModeBanner: false,
      home: ViewMapPage(this.pwdid, this.doc),
    );
  }
}

class ViewMapPage extends StatefulWidget {
  final String pwdid;
  final List<DocumentSnapshot> doc;
  const ViewMapPage(this.pwdid, this.doc);
  @override
  _ViewMapPageState createState() => _ViewMapPageState(this.pwdid, this.doc);
}

class _ViewMapPageState extends State<ViewMapPage> {
  final String pwdid;
  final List<DocumentSnapshot> doc;
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Marker> allMarkers = [];
  double lat, lon;
  double lat1, lon1;
  String travelcname = "location_travel";
  String imagecname = "location_image";

  GoogleMapController _controller;


  _ViewMapPageState(this.pwdid, this.doc);

  @override
  void initState() {
    super.initState();
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
                  child: Text(doc.data["address"], textAlign: TextAlign.center),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PWDPotholeDetails(
                                        pwdid, doc)));
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

  getLat() {
    for (int i = 0; i < doc.length; i++) {
        print(doc[i].data['pincode']);
        lat1 = parseDouble(doc[i].data['lat']);
        lon1 = parseDouble(doc[i].data['lon']);

        allMarkers.add(Marker(
            markerId: MarkerId(i.toString()),
            draggable: true,
            onTap: () {
              CameraPosition(target: LatLng(lat1, lon1), zoom: 26.0);
              print("Alert!");
              _showDialog(doc[i]);
              
            },
            position: LatLng(lat1, lon1)));
      
    }
    // print(allMarkers);
  }

  getLon() {
    for (int i = 0; i < doc.length; i++) {
        print(doc[i].data['pincode']);
        lat1 = parseDouble(doc[i].data['lat']);
        lon1 = parseDouble(doc[i].data['lon']);

        allMarkers.add(Marker(
            markerId: MarkerId(i.toString()),
            draggable: true,
            onTap: () {
              
              CameraPosition(target: LatLng(lat1, lon1), zoom: 26.0);
              _showDialog(doc[i]);

            },
            position: LatLng(lat1, lon1)));
    
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


  @override
  Widget build(BuildContext context) {
    if (doc != null) {
      print("AAadsadadd");
      getLat();
      getLon();
    }
    // getLat();
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: Text('Maps'),
      // ),
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(12.9716, 77.5946), zoom: 11.0),
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
