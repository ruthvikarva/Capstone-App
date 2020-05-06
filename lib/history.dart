
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class History extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<History> {

  final db = Firestore.instance;
  String currentUser;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
    super.initState();
  }

  _asyncMethod() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid;
    {
      setState(() {
        currentUser = userId;
      });
    }
  }

  int time = new DateTime.now().millisecondsSinceEpoch;
  int day2 = new DateTime.now().millisecondsSinceEpoch + 86400000;



  Timestamp dateTime() {
    int currentWeekday = new DateTime.now().weekday;
    DateTime currentDate = new DateTime.now();
    int time = currentDate.millisecondsSinceEpoch;

    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    //print(currentWeekday);

    if (currentWeekday == 7) {
      currentWeekday = 0;
    }
    currentDate = currentDate.subtract(new Duration(days: currentWeekday));
    int beginDay = currentDate.day;
    int beginMonth = currentDate.month;
    int beginYear = currentDate.year;

    //print("begin: $beginDay");


    var dartStartDate = new DateTime(
        beginYear, beginMonth, beginDay, 0, 0, 0);
    var tsStart = Timestamp.fromDate(dartStartDate);
    //print(dartStartDate);
    //print("Timestamp: $tsStart");
    return tsStart;
  }


  @override
  Widget build(BuildContext context) {
    print(currentUser);
    return new Scaffold (
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          SizedBox(height: 0.0),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('log')
                  .where("userID", isEqualTo: currentUser)
                  .where("dateTime", isGreaterThanOrEqualTo: dateTime())
                  //.where("time", isLessThan: day2)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.hasError){
                  return Text("There has been an error. Try again");
                }
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Text("Awaiting connection");
                }
                if(snapshot.data==null || snapshot.data.documents.length==0){
                  return Card( child: Text("No meals have been entered, unable to calculate"));
                }
                if (snapshot.hasData) {
                  var documents = snapshot.data.documents;
                    for (int x = 0; x < documents.length; x++) {
                      //print(documents[x]["dateTime"]);
                      var firestoreTimestamp = documents[x]["dateTime"]
                          .toDate();
                      var dartDatetime = DateTime.parse(
                          firestoreTimestamp.toString());
                      print(dartDatetime);
                      var weekday = dartDatetime.weekday;
                      if (weekday == 7) {
                        weekday = 0;
                      }
                    }
                  return Column(
                    children: snapshot.data.documents.map((doc) {
                      return ListTile(
                        title: Text(doc.data['recipeName']),
                        subtitle: Text(doc.data['dateTime'].toDate().toString()),
                      );
                    }).toList(),
                  );
                }
                else {
                  return SizedBox();
                }
              }),
          SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );
  }
}