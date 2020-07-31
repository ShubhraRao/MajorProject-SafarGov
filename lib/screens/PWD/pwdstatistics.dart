import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:jiffy/jiffy.dart';

class ChartsDemo extends StatefulWidget {
  final List<DocumentSnapshot> newlist;
  final List<DocumentSnapshot> newfixed;

  const ChartsDemo({Key key, this.newlist, this.newfixed}) : super(key: key);

  @override
  ChartsDemoState createState() => ChartsDemoState(newlist, newfixed);
}

class ChartsDemoState extends State<ChartsDemo> {
  final List<DocumentSnapshot> newlist;
  final List<DocumentSnapshot> newfixed;
  ChartsDemoState(this.newlist, this.newfixed);
  List<charts.Series> seriesList;
  List<charts.Series<Countbymonth, String>> _seriesBarData;
  int c1=0;
  int c2=0;
  int c3=0;
  int c4=0;
  int c5=0;
  int c6=0;

  int f1=0;
  int f2=0;
  int f3=0;
  int f4=0;
  int f5=0;
  int f6=0;
  List<Countbymonth> countlist = List();
  List<Countbymonth> countfixed = List();

  // _createRandomData() {
   
  //   List<charts.Series<Countbymonth, String>> _seriesBarData;
    
  //   return [
  //     charts.Series<Countbymonth, String>(
  //       id: 'Countbymonth',
  //       domainFn: (Countbymonth potbyme, _) =>
  //             // getmonth(potbyme.month),
  //             "Jan",
  //         measureFn: (Countbymonth potbyme, _) => potbyme.count,
        
  //       data: countlist,
  //       fillColorFn: (Countbymonth countbymonth, _) {
  //         return charts.MaterialPalette.blue.shadeDefault;
  //       },
  //     ),
  //     // charts.Series<Countbymonth, String>(
  //     //   id: 'Countbymonth',
  //     //   domainFn: (Countbymonth Countbymonth, _) => Countbymonth.year,
  //     //   measureFn: (Countbymonth Countbymonth, _) => Countbymonth.Countbymonth,
  //     //   data: tabletCountbymonthData,
  //     //   fillColorFn: (Countbymonth Countbymonth, _) {
  //     //     return charts.MaterialPalette.green.shadeDefault;
  //     //   },
  //     // ),
  //     // charts.Series<Countbymonth, String>(
  //     //   id: 'Countbymonth',
  //     //   domainFn: (Countbymonth Countbymonth, _) => Countbymonth.year,
  //     //   measureFn: (Countbymonth Countbymonth, _) => Countbymonth.Countbymonth,
  //     //   data: mobileCountbymonthData,
  //     //   fillColorFn: (Countbymonth Countbymonth, _) {
  //     //     return charts.MaterialPalette.teal.shadeDefault;
  //     //   },
  //     // )
  //   ];
  // }

  // barChart() {
  //   return charts.BarChart(
  //     seriesList,
  //     animate: true,
  //     vertical: true,
  //     barGroupingType: charts.BarGroupingType.grouped,
  //     defaultRenderer: charts.BarRendererConfig(
  //       groupingType: charts.BarGroupingType.grouped,
  //       strokeWidthPx: 1.0,
  //     ),
  //     // domainAxis: charts.OrdinalAxisSpec(
  //     //   renderSpec: charts.NoneRenderSpec(),
  //     // ),
  //   );
  // }

  @override
  void initState() {
    filterdata();
    super.initState();
    _generateData(countlist);
    // seriesList = _createRandomData();
  }
  filterdata() {
    countlist = [];
      print("Filterrr");
      for (int i = 0; i < newlist.length; i++) {
        if (DateTime.parse(newlist[i].data["timeStamp"].toDate().toString()).month ==
            DateTime.now().month) {
              c1++;
        }
        if (DateTime.parse(newlist[i].data["timeStamp"].toDate().toString()).month ==
            DateTime.now().month - 1) {
              
              c2++;
        }
        if (DateTime.parse(newlist[i].data["timeStamp"].toDate().toString()).month ==
            DateTime.now().month - 2) {
              
              c3++;
        }
        if (DateTime.parse(newlist[i].data["timeStamp"].toDate().toString()).month ==
            DateTime.now().month - 3) {
              
              c4++;
        }
        if (DateTime.parse(newlist[i].data["timeStamp"].toDate().toString()).month ==
            DateTime.now().month - 4) {
              
              c5++;
        }
        if (DateTime.parse(newlist[i].data["timeStamp"].toDate().toString()).month ==
            DateTime.now().month - 5) {
              
              c6++;
        }
      }
      countlist.add(Countbymonth(DateTime.now().month, c1));
    countlist.add(Countbymonth(DateTime.now().month - 1, c2));
    countlist.add(Countbymonth(DateTime.now().month - 2, c3));
    countlist.add(Countbymonth(DateTime.now().month - 3, c4));
    countlist.add(Countbymonth(DateTime.now().month - 4, c5));
    countlist.add(Countbymonth(DateTime.now().month - 5, c6));


    for (int i = 0; i < newfixed.length; i++) {
        if (DateTime.parse(newfixed[i].data["timeStamp"].toDate().toString()).month ==
            DateTime.now().month) {
              f1++;
        }
        if (DateTime.parse(newfixed[i].data["timeStamp"].toDate().toString()).month ==
            DateTime.now().month - 1) {
              
              f2++;
        }
        if (DateTime.parse(newfixed[i].data["timeStamp"].toDate().toString()).month ==
            DateTime.now().month - 2) {
              
              f3++;
        }
        if (DateTime.parse(newfixed[i].data["timeStamp"].toDate().toString()).month ==
            DateTime.now().month - 3) {
              
              f4++;
        }
        if (DateTime.parse(newfixed[i].data["timeStamp"].toDate().toString()).month ==
            DateTime.now().month - 4) {
              
              f5++;
        }
        if (DateTime.parse(newfixed[i].data["timeStamp"].toDate().toString()).month ==
            DateTime.now().month - 5) {
              
              f6++;
        }
      }
    countfixed.add(Countbymonth(DateTime.now().month, f1));
    countfixed.add(Countbymonth(DateTime.now().month - 1, f2));
    countfixed.add(Countbymonth(DateTime.now().month - 2, f3));
    countfixed.add(Countbymonth(DateTime.now().month - 3, f4));
    countfixed.add(Countbymonth(DateTime.now().month - 4, f5));
    countfixed.add(Countbymonth(DateTime.now().month - 5, f6));
    }

    getmonth(int d){
      if(d==1){return "JAN";}
      else if(d==2){return "FEB";}
      else if(d==3){return "MAR";}
      else if(d==4){return "APR";}
      else if(d==5){return "MAY";}
      else if(d==6){return "JUN";}
      else if(d==7){return "JUL";}
      else if(d==8){return "AUG";}
      else if(d==9){return "SEP";}
      else if(d==10){return "OCT";}
      else if(d==11){return "NOV";}
      else if(d==12){return "DEC";}
    }

    

_generateData(countlist) {
      _seriesBarData = List<charts.Series<Countbymonth, String>>();
      _seriesBarData.add(
        charts.Series(
          // displayName: " ",
          domainFn: (Countbymonth potbyme, _) =>
              getmonth(potbyme.month),
          measureFn: (Countbymonth potbyme, _) => potbyme.count,
          id: 'Potholes',
          data: countlist,
          fillColorFn: (Countbymonth countbymonth, _) {
          return charts.MaterialPalette.red.shadeDefault;
        },
        ),
        
        
      );
      _seriesBarData.add(
        charts.Series(
          // displayName: " ",
          domainFn: (Countbymonth potbyme, _) =>
              getmonth(potbyme.month),
          measureFn: (Countbymonth potbyme, _) => potbyme.count,
          id: 'Potholes',
          data: countfixed,
          fillColorFn: (Countbymonth countbymonth, _) {
          return charts.MaterialPalette.cyan.shadeDefault;
        },
        ));
    }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      //   flexibleSpace: Container(
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topRight,
      //       end: Alignment.bottomLeft,
      //       colors: [
      //         Color(0xFF3383CD),
      //         Color(0xFF11249F),
      //       ],
      //     ),
      //   ),
      // ),
      backgroundColor: Color(0xFF11249F),
        title: Text("STATISTICS"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: _buildChart(context, countlist),
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<Countbymonth> potholes) {
    countlist = potholes;
    _generateData(countlist);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Last 6 months',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.BarChart(
                  _seriesBarData,
                  barGroupingType: charts.BarGroupingType.grouped,
                  // defaultRenderer: new charts.BarRendererConfig(
                  //     cornerStrategy: const charts.ConstCornerStrategy(60)),
                  animate: true,
                  animationDuration: Duration(seconds: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Countbymonth {
  final int month;
  final int count;

  Countbymonth(this.month, this.count);
}

// class Countbymonth {
//   final int month;
//   final int count;

//   Countbymonth(this.month, this.count);
// }
