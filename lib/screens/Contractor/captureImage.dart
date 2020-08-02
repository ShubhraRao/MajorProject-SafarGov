import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:govtapp/screens/Contractor/homeContractor.dart';
import 'package:govtapp/screens/home.dart';
import 'package:govtapp/splashscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CaptureImage extends StatefulWidget {
  final String fname, lname, mobnumber;

  const CaptureImage({Key key, this.fname, this.lname, this.mobnumber})
      : super(key: key);
  @override
  _CaptureImageState createState() => _CaptureImageState();
}

class _CaptureImageState extends State<CaptureImage> {
  TextEditingController desc = TextEditingController();
  Placemark place;

  File _image;
  DateTime date;
  String lat = "";
  String lon = "";
  String pin = "";
  String locData = "";
  String currentAddress = "";
  int a = 0;
  bool isLoading = false;

  final databaseReference = Firestore.instance;

  Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      // ignore: deprecated_member_use
      image = await ImagePicker.pickImage(
          source: ImageSource.camera, maxHeight: 400, maxWidth: 400);
    }

    setState(() {
      _image = image;
    });
  }

  getLoc() async {
    // setState(() {
    //   isLoading = true;
    // });
    setState(() {
      isLoading = true;
    });
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);

    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    place = placemark[0];

    lat = "${position.latitude}";
    lon = "${position.longitude}";
    pin = "${place.postalCode}";
    locData = "(${position.latitude}, ${position.longitude})";
    currentAddress =
        "${place.subThoroughfare}, ${place.subLocality}, ${place.thoroughfare}, ${place.administrativeArea}, ${place.locality}, ${place.country}, ${place.postalCode}";
    date = DateTime.now();
    setState(() {
      a = 1;
    });
    print(locData);
    print(currentAddress);
    // if(currentAddress!=null)
    // {
    
    // }
  }

  showimage() {
    if (a != 1) getLoc();
    return (a != 1)
        ? SizedBox(width: 0.0)
        : (!isLoading)
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(shrinkWrap: true, children: <Widget>[
                      // Image.file(_image,
                      //     height: 200.0, width: MediaQuery.of(context).size.width),

                      ListTile(
                          title: Text(locData), subtitle: Text("Location")),
                      ListTile(
                          title: Text(currentAddress),
                          subtitle: Text("Address")),
                      ListTile(
                          title: Text(Jiffy(DateTime.now()).yMMMEdjm),
                          subtitle: Text("Date and time")),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 8),
                          child: Text("Notes (if any):",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(19.0),
                        child: TextField(
                          controller: desc,
                          decoration: InputDecoration(
                              // labelText: 'Details of the appointment',
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                              border: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(25.0)
                                  )),
                          keyboardType: TextInputType.multiline,
                          minLines: 4,
                          maxLines: null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: FlatButton(
                          color: Color(0xFF11249F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0),
                            // side: BorderSide(color: Colors.black)
                          ),
                          onPressed: () {
                            uploaddetails();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              'SUBMIT',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),

                  // SizedBox(height: 50.0)
                ],
              );
  }

  uploaddetails() async {
    var time = DateTime.now();
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('FixedPotholeImages/$time');
        print("Storing");
    final StorageUploadTask task = firebaseStorageRef.putFile(_image);
    var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
    databaseReference.collection("fixedReport").add({
      'contractorName': widget.fname.trim() + " " + widget.lname.trim(),
      'phone': widget.mobnumber,
      'fixed':"false",
      'lat': lat,
      'lon': lon,
      'timeStamp': date,
      'pincode': place.postalCode,
      'address': currentAddress,
      'thoroughfare': place.thoroughfare,
      'subThoroughfare': place.subThoroughfare,
      'subLocality': place.subLocality,
      'subAdministrativeArea': place.subAdministrativeArea,
      'placename': place.name,
      'locality': place.locality,
      'administrativeArea': place.administrativeArea,
      'url': downloadUrl.toString(),
      'notes': desc.text,
    }).then((_) {
      // print("success!");
      // setState(() {
      //   confirm = 0;
      // });

      showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Thank you!"),
              content: new Text("Your report has been successfully submitted."),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeContractor(
                                  fname: widget.fname,
                                  lname: widget.lname,
                                  phone: widget.mobnumber,
                                )));
                  },
                ),
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFF11249F),
        title: Text("SafarGov"),
        automaticallyImplyLeading: false,
        
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     getImage(true);
      //   },
      //   tooltip: 'Capture Image',
      //   backgroundColor: Color(0xFF89216B),
      //   child: Icon(Icons.camera_alt),
      // ),
      body:
          // SingleChildScrollView(
          //       scrollDirection: Axis.vertical,
          //       child:
          //   Column(
          // children: <Widget>[
          //   (_image == null) ? Text("") : showimage(),
          (_image == null)
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      Image(
                          width: 220,
                          height: 220,
                          image: AssetImage('assets/images/camtestpot.png')),
                      FlatButton(
                        color: Color(0xFF11249F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0),
                          // side: BorderSide(color: Colors.black)
                        ),
                        onPressed: () {
                          getImage(true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'CAPTURE IMAGE',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      )
                    ]))
              : showimage(),
      // Align(
      //     alignment: Alignment.bottomCenter,
      //     child: FlatButton(
      //         onPressed: () {
      //           getImage(true);
      //         },
      //         child:  Text("CAPTURE IMAGE")
      // )),
      // SizedBox(
      //   height: 40.0
      // )
      //     ],
      //   // )
      // ),
    );
  }
}
