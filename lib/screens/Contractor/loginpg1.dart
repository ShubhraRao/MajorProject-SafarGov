import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:govtapp/screens/Contractor/homeContractor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPg1 extends StatefulWidget {
  @override
  _LoginPg1State createState() => _LoginPg1State();
}

class _LoginPg1State extends State<LoginPg1> {
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _otpController = new TextEditingController();
  List<DocumentSnapshot> conuser = List();
  int check = 0;
  String vid;
  String fname, mobnumber, lname;
  FirebaseAuth _auth = FirebaseAuth.instance;
  int sent = 0;
  String error = '';
  Widget wid = SizedBox(
    width: 0.0,
  );
  @override
  void initState() {
    getList();

    super.initState();
  }

  getList() async {
    QuerySnapshot querySnapshotuser =
        await Firestore.instance.collection("users_contractor").getDocuments();
    conuser = querySnapshotuser.documents;
    // mobnumber = conuser[0].data["phone"];
    // fname = conuser[0].data["fname"];
    // lname = conuser[0].data["lname"];
  }

  checkifexists(mob) {
    for (int i = 0; i < conuser.length; i++) {
      if (conuser[i].data["phone"] == mob) {
        print("Yes");
        setState(() {
          mobnumber = conuser[i].data["phone"];
          fname = conuser[i].data["fname"];
          lname = conuser[i].data["lname"];

          check = 1;
        });
        return true;
      }
    }
    print("No");
    return false;
  }

  // sendotp() {
  //   _auth.verifyPhoneNumber(
  //       phoneNumber: "+91 " + _phoneController.text,
  //       timeout: Duration(seconds: 120),
  //       verificationCompleted: (AuthCredential credential) async {
  //         // Navigator.of(context).pop();

  //         AuthResult result = await _auth.signInWithCredential(credential);
  //         FirebaseUser user = result.user;
  //       },
  //       verificationFailed: (AuthException exception) {
  //         print(exception.message);
  //       },
  //       codeSent: (String verificationId, [int forceResendingToken]) {
  //         Text("ENTER OTP");
  //         setState(() {
  //           vid = verificationId;
  //           sent = 1;
  //         });
  //       },
  //       codeAutoRetrievalTimeout: null);
  // }

  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;

          if (user != null) {
            // Navigator.push(context, MaterialPageRoute(
            //   builder: (context) => HomeScreen(user: user,)
            // ));
            print("Homee");
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          setState(() {
            wid = Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey[200])),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey[300])),
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: "OTP"),
                  controller: _otpController,
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  final code = _otpController.text.trim();
                  AuthCredential credential = PhoneAuthProvider.getCredential(
                      verificationId: verificationId, smsCode: code);
                  SharedPreferences contfname =
                      await SharedPreferences.getInstance();
                  contfname.setString('fname', fname);

                  SharedPreferences contlname =
                      await SharedPreferences.getInstance();
                  contlname.setString('lname', lname);

                  SharedPreferences contphone =
                      await SharedPreferences.getInstance();
                  contphone.setString('phone', mobnumber);
                  AuthResult result =
                      await _auth.signInWithCredential(credential);

                  FirebaseUser user = result.user;

                  if (user != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeContractor(
                                fname: fname, lname: lname, phone: mobnumber)));
                    print("Goo");
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                color: Color(0xFF11249F),
                padding: EdgeInsets.all(0.0),
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ]);
          });
        },
        codeAutoRetrievalTimeout: null);
  }
  // showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape:  RoundedRectangleBorder(
  //       borderRadius: BorderRadius.all(Radius.circular(32.0))),
  //         title: Text("ENTER OTP"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             TextField(
  //               controller: _otpController,
  //             ),
  //   ],
  // ),
  // actions: <Widget>[
  //   FlatButton(
  //     child: Text("Confirm"),
  //     textColor: Colors.white,
  //     color: Colors.blue,
  //     onPressed: () async {
  // final code = _otpController.text.trim();
  // AuthCredential credential =
  //     PhoneAuthProvider.getCredential(
  //         verificationId: verificationId, smsCode: code);
  // SharedPreferences contfname =
  //     await SharedPreferences.getInstance();
  // contfname.setString('fname', fname);

  // SharedPreferences contlname =
  //     await SharedPreferences.getInstance();
  // contlname.setString('lname', lname);

  // SharedPreferences contphone =
  //     await SharedPreferences.getInstance();
  // contphone.setString('phone', mobnumber);
  // AuthResult result =
  //     await _auth.signInWithCredential(credential);

  // FirebaseUser user = result.user;

  // if (user != null) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => HomeContractor(
  //               fname: fname,
  //               lname: lname,
  //               phone: mobnumber)));
  //   print("Goo");
  //         } else {
  //           print("Error");
  //         }
  //       },
  //     )
  // ],
  // );
  //         }
  // )];

  // getotp() {
  //   if (sent != 1) {
  //     sendotp();
  //   }

  //   return Column(
  //     children: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.all(20.0),
  //   child: TextFormField(
  //     keyboardType: TextInputType.number,
  //     decoration: InputDecoration(
  //         enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(8)),
  //             borderSide: BorderSide(color: Colors.grey[200])),
  //         focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(8)),
  //             borderSide: BorderSide(color: Colors.grey[300])),
  //         filled: true,
  //         fillColor: Colors.grey[100],
  //         hintText: "OTP"),
  //     controller: _otpController,
  //   ),
  // ),
  //       RaisedButton(
  //         onPressed: () async {
  //           final code = _otpController.text.trim();
  //           AuthCredential credential = PhoneAuthProvider.getCredential(
  //               verificationId: vid, smsCode: code);

  //           AuthResult result = await _auth.signInWithCredential(credential);

  //           FirebaseUser user = result.user;
  //           if (user != null) {
  //             SharedPreferences contfname =
  //                 await SharedPreferences.getInstance();
  //             contfname.setString('fname', fname);

  //             SharedPreferences contphone =
  //                 await SharedPreferences.getInstance();
  //             contphone.setString('phone', mobnumber);

  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => ContractorHome()));
  //           }
  //         },
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(80.0),
  //         ),
  //         color: Colors.blue,
  //         padding: EdgeInsets.all(0.0),
  //         child: Text("LOGIN", style: TextStyle(color: Colors.white)),
  //       )
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
        appBar: AppBar(
          backgroundColor: Color(0xFF11249F),
          // automaticallyImplyLeading: false,
          title: Text("Login"),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey[200])),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey[300])),
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: "Mobile Number"),
                  controller: _phoneController,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              wid,
              (check == 0)
                  ? RaisedButton(
                      onPressed: () {
                        if (checkifexists(_phoneController.text)) {
                          loginUser(_phoneController.text, context);
                        } else {
                          setState(() {
                            error = "This user does not exist.";
                          });
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      color: Color(0xFF11249F),
                      padding: EdgeInsets.all(0.0),
                      child: Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : SizedBox(width: 0.0),
              // (check == 1) ?
              // getotp() : SizedBox(width: 0.0),
              FlatButton(
                onPressed: () {
                  checkifexists("8867901072");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeContractor(
                              fname: fname, lname: lname, phone: mobnumber)));
                },
                child: Text("Skip"),
              )
            ]));
  }
}
