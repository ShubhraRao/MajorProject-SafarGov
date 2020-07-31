import 'package:cloud_firestore/cloud_firestore.dart';

class LocModel {
  final String address;
  final String lat;
  final String lon;
  final String pincode;
  final Timestamp timeStamp;
  final DocumentReference reference;

  LocModel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['address'] != null),
        assert(map['lat'] != null),
        assert(map['lon'] != null),
        assert(map['pincode'] != null),
        assert(map['timeStamp'] != null),
        address = map['address'],
        lat = map['lat'].toString(),
        lon = map['lon'].toString(),
        pincode = map['pincode'],
        timeStamp = map['timeStamp'];

  LocModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Loc<$address:$pincode>";
}