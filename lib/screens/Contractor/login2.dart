import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:govtapp/screens/Contractor/homeContractor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginCon2 extends StatefulWidget {
  @override
  _LoginCon2State createState() => _LoginCon2State();
}

class _LoginCon2State extends State<LoginCon2> {
  String phoneNo;
  String smsCode;
  String verificationId;
  @override
  void initState() {
    getList();

    super.initState();
  }

  List<DocumentSnapshot> conuser = List();
  String fname, mobnumber, lname;
  int check = 0;

  getList() async {
    QuerySnapshot querySnapshotuser =
        await Firestore.instance.collection("users_contractor").getDocuments();
    conuser = querySnapshotuser.documents;
    // mobnumber = conuser[0].data["phone"];
    // fname = conuser[0].data["fname"];
    // lname = conuser[0].data["lname"];
  }

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Signed in');
      });
    };

    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential phoneAuthCredential) {
      print('verified');
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91" + this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter OTP'),
            content: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: Text('Done'),
                onPressed: () {
                  FirebaseAuth.instance.currentUser().then((user) async {
                    if (user != null) {
                      SharedPreferences contfname =
                          await SharedPreferences.getInstance();
                      contfname.setString('fname', fname);

                      SharedPreferences contlname =
                          await SharedPreferences.getInstance();
                      contlname.setString('lname', lname);

                      SharedPreferences contphone =
                          await SharedPreferences.getInstance();
                      contphone.setString('phone', mobnumber);
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeContractor(fname: fname, lname: lname, phone: mobnumber)));
                    } else {
                      Navigator.of(context).pop();
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
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

  signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user =
        await _auth.signInWithCredential(credential).then((user) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => DashboardPage(uid: user.user.uid)),
      // );
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFe6f5fc),
      appBar: new AppBar(
        backgroundColor: Color(0xFF11249F),
        title: new Text('Login'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.arrow_right, color: Color(0xFF11249F)),
          onPressed: () {
            Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeContractor(fname: "Praveen", lname: "Desai", phone: "7259780569")));
          },)
        ],
      ),
      body: new Center(
        child: Container(
            padding: EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Enter Phone number'),
                  onChanged: (value) {
                    this.phoneNo = value;
                  },
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                  color: Color(0xFF11249F),
                    onPressed: () {
                      if (checkifexists(phoneNo)) {
                        verifyPhone();
                      }
                    },
                    child: Text('Verify'),
                    textColor: Colors.white,
                    elevation: 7.0,
                    )
              ],
            )),
      ),
    );
  }
}
