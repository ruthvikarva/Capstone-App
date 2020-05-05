
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_event.dart';
import 'package:intl/intl.dart';


class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meal History',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MealCalendarPage(),
      routes: {
        "add_event": (_) => AddEventPage(),
      },
    );
  }
}
class MealCalendarPage extends StatefulWidget {
  @override
  _MealCalendarPageState createState() => _MealCalendarPageState();
}

class _MealCalendarPageState extends State<MealCalendarPage> {

  CalendarController _controller;
  //DateTime mealDate;
  String mealDate;
  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
  Timestamp myTimeStamp;

  int time;

  int startAtTimestamp;
  var lower;
  var higher;

  int test;
  final db = Firestore.instance;
  String currentUser;



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
    super.initState();
    _controller = CalendarController();
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

  Widget getInfo(int startTime) {
    startTime = startTime;
    print(startTime);
    return StreamBuilder<QuerySnapshot>(
        stream: db.collection('log')
            .where("UserID", isEqualTo: currentUser)
            .where("time", isGreaterThan: 0)
            .snapshots(),
        // ignore: missing_return
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            print('here $startAtTimestamp');
            return Column(
              children: snapshot.data.documents.map((doc) {
                return ListTile(
                  title: Text(
                      doc.data['time'].toString()), //.toDate().toString()
                );
              }).toList(),
            );
          }
          else {
            return SizedBox();
          }
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              initialCalendarFormat: CalendarFormat.week,
              calendarStyle: CalendarStyle(
                  todayColor: Colors.orange,
                  selectedColor: Theme
                      .of(context)
                      .primaryColor,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (date, events) {
                //print(date.toIso8601String());
                mealDate = formatter.format(date);
                startAtTimestamp = date.millisecondsSinceEpoch;
                time = startAtTimestamp;
                test = startAtTimestamp + 86400000;
                print('startAtTimestamp: $startAtTimestamp');
                print('test: $test');
                //print(mealDate.runtimeType);
                print(mealDate);
                print(startAtTimestamp.runtimeType);

                print("DATE:::::");
                print(DateTime.now().millisecondsSinceEpoch);
                //print(time);
                //getInfo(startAtTimestamp);
                //RaisedButton()
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) =>
                    Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                todayDayBuilder: (context, date, events) =>
                    Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
              ),
              calendarController: _controller,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: db.collection('log')
                    .where("UserID", isEqualTo: currentUser)
                    .where("time", isGreaterThanOrEqualTo: time)
                    .where('time', isLessThan: test)
                    .snapshots(),
                // ignore: missing_return
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.documents.map((doc) {
                        return ListTile(
                          title: Text(doc.data['time']
                              .toString()), //.toDate().toString()
                        );
                      }).toList(),
                    );
                  }
                  else {
                    return SizedBox();
                  }
                }
            )
          ],
        ),
      ),
    );
  }
}



