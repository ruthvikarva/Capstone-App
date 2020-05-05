import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flip_card/flip_card.dart';


class ProfileGoals extends StatefulWidget {

  @override
  _ProfileGoalsState createState() => _ProfileGoalsState();
}

class _ProfileGoalsState extends State<ProfileGoals> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            MicroNutrients(),
            Card(
                margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                child: Padding(
                  padding:const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 10,),
                      const Text("Weekly Calorie Intake",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      const SizedBox(height: 20,),
                      CalorieChartWeek(),
                    ],
                  ),
                )
            ),


            Card(
              margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    MacroNutrientChart()
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

class MicroNutrients extends StatefulWidget {
  @override
  _MicroNutrientsState createState() => _MicroNutrientsState();
}

class _MicroNutrientsState extends State<MicroNutrients> {
  var userID;
  var sodium;
  final maxSodium=1500;
  final maxCholesterol=300;
  var cholesterol;
  var calorieGoal;
  Timestamp dateTime() {
    DateTime currentDate = new DateTime.now();

    //print(currentWeekday);
    int beginDay = currentDate.day;
    int beginMonth = currentDate.month;
    int beginYear = currentDate.year;

    print("begin: $beginDay");


    var dartStartDate = new DateTime(
        beginYear, beginMonth, beginDay, 0, 0, 0);
    var tsStart = Timestamp.fromDate(dartStartDate);
    print(dartStartDate);
    //print("Timestamp: $tsStart");
    return tsStart;
  }
  void getUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userID=user.uid;
    setState(() {
      userID=user.uid;
    });
  }

  void initState() {
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("nutrition").where("userID", isEqualTo: userID).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasError){
            return Text("There has been an error. Try again");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Text("Awaiting connection");
          }
          if(snapshot.data==null || snapshot.data.documents.length==0){
            return Card( child: Text("No meals have been entered, unable to calculate"));
          }
          else{
            return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("nutrition")
                    .where("userID", isEqualTo: userID)
                    .where("dateTime", isGreaterThanOrEqualTo: dateTime()).snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot2) {
                  if(snapshot2.hasError){
                    return Text("There has been an error. Try again");
                  }
                  if(snapshot2.connectionState==ConnectionState.waiting){
                    return Text("Awaiting connection");
                  }
                  if(snapshot2.data==null || snapshot2.data.documents.length==0){
                    return Card( child: Text("No meals have been entered, unable to calculate"));
                  }
                  else{
                    sodium=snapshot2.data.documents[0]["sodium"];
                    cholesterol=snapshot2.data.documents[0]["cholesterol"];

                    var sodiumPer=sodium/maxSodium;
                    var cholPer=cholesterol/maxCholesterol;

                    if(sodiumPer>1){
                      sodiumPer=1.0;
                    }
                    if(cholPer>1){
                      cholPer=1.0;
                    }
                    return StreamBuilder<DocumentSnapshot>(
                        stream: Firestore.instance.collection("users").document(userID).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot snapshot3){
                          if(snapshot3.hasError){
                            return Text("There has been an error. Try again");
                          }
                          if(snapshot3.connectionState==ConnectionState.waiting){
                            return Text("Awaiting connection");
                          }
                          if(snapshot3.data==null){
                            return Card( child: Text("No meals have been entered, unable to calculate"));
                          }
                          else{
                            calorieGoal=snapshot3.data["calories"];
                            return Column(
                              children: <Widget>[
                                Card(
                                  margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Center(
                                          child:Text("Daily Sodium Intake",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        new CircularPercentIndicator(
                                          radius: 150.0,
                                          lineWidth: 20.0,
                                          percent: sodiumPer,
                                          animation: true,
                                          animationDuration: 1200,
                                          center: Text("$sodium mg",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          footer: Text("Recommended Sodium Intake: 1500 mg or less"),
                                          animateFromLastPercent: true,
                                          progressColor: Color((){
                                            if(sodiumPer>0 && (sodiumPer<=.25)){
                                              return 4289912795;
                                            }
                                            else if(sodiumPer>.25 && (sodiumPer<.75)){
                                              return 4294956544;
                                            }
                                            else{
                                              return 4294907716;
                                            }
                                          }()),
                                          circularStrokeCap: CircularStrokeCap.round,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Center(
                                          child:Text("Daily Cholesterol Consumption",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        new CircularPercentIndicator(
                                          radius: 150.0,
                                          lineWidth: 20.0,
                                          percent: cholPer,
                                          animation: true,
                                          animationDuration: 1200,
                                          center: Text("$cholesterol mg",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          footer: Text("Recommended Cholesterol Consumption: 300 mg or less"),
                                          animateFromLastPercent: true,
                                          progressColor: Color((){
                                            if(cholPer>0 && (cholPer<=.25)){
                                              return 4289912795;
                                            }
                                            else if(cholPer>.25 && (cholPer<.75)){
                                              return 4294956544;
                                            }
                                            else{
                                              return 4294907716;
                                            }
                                          }()),
                                          circularStrokeCap: CircularStrokeCap.round,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        });
                  }
                });
          }
        });
  }
}



//-----------------------------------------------------------------------------

class MealChart{
  String weekday;
  int calories;
  Color colorvalue;

  MealChart(this.weekday, this.calories, this.colorvalue);
}

class CalorieChartWeek extends StatefulWidget {
  @override
  _CalorieChartWeekState createState() => _CalorieChartWeekState();
}

class _CalorieChartWeekState extends State<CalorieChartWeek> {
  var userID;
  var calorieGoal;
  List<MealChart> weekMeals = [
    new MealChart("Sun", 0, Color(0xFF42A5F5)),
    new MealChart("Mon", 0, Color(0xFF990099)),
    new MealChart("Tue", 0, Color(0xFF109618)),
    new MealChart("Wed", 0, Color(0xFFFDBE19)),
    new MealChart("Thu", 0, Color(0xFFFF9900)),
    new MealChart("Fri", 0, Color(0xFFDC3912)),
    new MealChart("Sat", 0, Color(0xFFDC3912)),
  ];

  Timestamp dateTime() {
    int currentWeekday = new DateTime.now().weekday;
    DateTime currentDate = new DateTime.now();

    //print(currentWeekday);

    if (currentWeekday == 7) {
      currentWeekday = 0;
    }
    currentDate=currentDate.subtract(new Duration(days: currentWeekday));
    int beginDay = currentDate.day;
    int beginMonth = currentDate.month;
    int beginYear = currentDate.year;

    //print("begin: $beginDay");


    var dartStartDate = new DateTime(
        beginYear, beginMonth, beginDay, 0, 0, 0);
    var tsStart = Timestamp.fromDate(dartStartDate);
    print(dartStartDate);
    //print("Timestamp: $tsStart");
    return tsStart;
  }

  void getUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userID=user.uid;
    setState(() {
      userID=user.uid;
    });
  }

  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("nutrition").where("userID", isEqualTo: userID).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasError){
            return Text("There has been an error. Try again");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Text("Awaiting connection");
          }
          if(snapshot.data==null){
            return Card( child: Text("No meals have been entered, unable to calculate"));
          }
          else{
            return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("nutrition")
                    .where("userID", isEqualTo: userID)
                    .where("dateTime", isGreaterThanOrEqualTo: dateTime()).snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot2){
                  if(snapshot2.hasError){
                    return Text("There has been an error. Try again");
                  }
                  if(snapshot2.connectionState==ConnectionState.waiting){
                    return Text("Awaiting connection");
                  }
                  if(snapshot2.data==null || snapshot2.data.documents.length==0){
                    return Card( child: Text("No meals have been entered, unable to calculate"));
                  }
                  else{
                    var documents = snapshot2.data.documents;
                    for (int x = 0; x < documents.length; x++) {
                      //print(documents[x]["dateTime"]);
                      var firestoreTimestamp = documents[x]["dateTime"].toDate();
                      var dartDatetime = DateTime.parse(
                          firestoreTimestamp.toString());
                      print(dartDatetime);
                      var weekday = dartDatetime.weekday;
                      if (weekday == 7) {
                        weekday = 0;
                      }
                      weekMeals[weekday].calories = documents[x]["calories"];
                    }
                    return StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance.collection("users").document(userID).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot3){
                        if(snapshot3.hasError){
                          return Text("There has been an error. Try again");
                        }
                        if(snapshot3.connectionState==ConnectionState.waiting){
                          return Text("Awaiting connection");
                        }
                        if(snapshot3.data==null){
                          return Card( child: Text("No meals have been entered, unable to calculate"));
                        }
                        else{
                          calorieGoal=snapshot3.data["calories"];
                          return Stack(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    child: LineChart(
                                      LineChartData(
                                        minX: 0,
                                        minY: 0,
                                        maxX: 6,
                                        maxY: 3500,
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        gridData: FlGridData(
                                          show: false,
                                        ),
                                        titlesData: FlTitlesData(
                                          bottomTitles: SideTitles(
                                            showTitles: true,
                                            textStyle: TextStyle(
                                                color: Colors.transparent,
                                                fontSize: 14
                                            ),
                                          ),
                                          leftTitles: SideTitles(
                                            showTitles:true,
                                            interval: 500,
                                            textStyle: TextStyle(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        lineBarsData:[
                                          LineChartBarData(
                                            spots: [
                                              FlSpot(0, calorieGoal.toDouble()),
                                              FlSpot(1, calorieGoal.toDouble()),
                                              FlSpot(2, calorieGoal.toDouble()),
                                              FlSpot(3,calorieGoal.toDouble()),
                                              FlSpot(4,calorieGoal.toDouble()),
                                              FlSpot(5,calorieGoal.toDouble()),
                                              FlSpot(6,calorieGoal.toDouble()),
                                            ],
                                            dashArray: [5,5],
                                            isCurved: true,
                                            barWidth: 2,
                                            dotData: FlDotData(
                                              show: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Flexible(
                                      child: BarChart(
                                          BarChartData(
                                            alignment: BarChartAlignment.spaceAround,
                                            maxY: 3500,
                                            barTouchData: BarTouchData(
                                                enabled: false,
                                                touchTooltipData:  BarTouchTooltipData(
                                                  tooltipBgColor: Colors.transparent,
                                                  tooltipPadding: const EdgeInsets.all(0),
                                                  tooltipBottomMargin: 5,
                                                )
                                            ),
                                            gridData: FlGridData(
                                              show: false,
                                            ),
                                            titlesData: FlTitlesData(
                                              show:true,
                                              bottomTitles: SideTitles(
                                                  showTitles: true,
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14
                                                  ),
                                                  getTitles: (double value){
                                                    switch(value.toInt()){
                                                      case 0:
                                                        return weekMeals[0].weekday;
                                                      case 1:
                                                        return weekMeals[1].weekday;
                                                      case 2:
                                                        return weekMeals[2].weekday;
                                                      case 3:
                                                        return weekMeals[3].weekday;
                                                      case 4:
                                                        return weekMeals[4].weekday;
                                                      case 5:
                                                        return weekMeals[5].weekday;
                                                      case 6:
                                                        return weekMeals[6].weekday;
                                                      default:
                                                        return "";
                                                    }
                                                  }
                                              ),
                                              leftTitles: SideTitles(
                                                showTitles:true,
                                                interval: 500,
                                                getTitles: (double value) {
                                                  return value.toInt().toString();
                                                },
                                              ),
                                            ),
                                            borderData: FlBorderData(
                                                show:false
                                            ),
                                            barGroups: barChart(weekMeals),
                                          )
                                      ),
                                    )
                                  ]
                              ),


                            ],
                          );
                        }
                      },
                    );
                  }
                });
          }
        });

  }
}

//-----------------------------------------------------------------------------

class MacroNutrientChart extends StatefulWidget {
  @override
  _MacroNutrientChartState createState() => _MacroNutrientChartState();
}

class _MacroNutrientChartState extends State<MacroNutrientChart> {
  var userID;
  var calorieGoal;
  bool showNutri= false;
  int carbs;
  int protein;
  int sugars;
  int satfat;
  int fat;

  Timestamp dateTime() {
    DateTime currentDate = new DateTime.now();

    //print(currentWeekday);

    int beginDay = currentDate.day;
    int beginMonth = currentDate.month;
    int beginYear = currentDate.year;

    //print("begin: $beginDay");


    var dartStartDate = new DateTime(
        beginYear, beginMonth, beginDay, 0, 0, 0);
    var tsStart = Timestamp.fromDate(dartStartDate);
    print("Start: $dartStartDate");
    //print("Timestamp: $tsStart");
    return tsStart;
  }

  void getUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      userID=user.uid;
    });
  }

  void initState() {
    super.initState();
    getUser();
  }


  @override
  Widget build(BuildContext context) {
    print("user: $userID");
    print("goal: $calorieGoal");
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("nutrition").where("userID", isEqualTo: userID).snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text("There has been an error. Try again");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Text("Awaiting connection");
          }
          if(snapshot.data==null){
            return Card( child: Text("No meals have been entered, unable to calculate"));
          }
          else{
            return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("nutrition").where("userID", isEqualTo: userID)
                    .where("dateTime", isGreaterThanOrEqualTo: dateTime()).snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot2) {
                  if(snapshot2.hasError){
                    return Text("There has been an error. Try again");
                  }
                  if(snapshot2.connectionState==ConnectionState.waiting){
                    return Text("Awaiting connection");
                  }
                  if(snapshot2.data==null || snapshot2.data.documents.length==0){
                    return Card( child: Text("No meals have been entered, unable to calculate"));
                  }
                  else{
                    var documents = snapshot2.data.documents;
                    protein=documents[0]["protein"];
                    sugars=documents[0]["sugar"];
                    carbs=documents[0]["carbohydrates"]-sugars;
                    satfat=documents[0]["saturatedFat"];
                    fat=documents[0]["fat"]-(satfat);
                    return StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance.collection("users").document(userID).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot3){
                        if(snapshot3.hasError){
                          return Text("There has been an error. Try again");
                        }
                        if(snapshot3.connectionState==ConnectionState.waiting){
                          return Text("Awaiting connection");
                        }
                        if(snapshot3.data==null){
                          return Card( child: Text("No meals have been entered, unable to calculate"));
                        }
                        else{
                          calorieGoal=snapshot3.data["calories"];

                          return Column(
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              FlipCard(
                                direction: FlipDirection.HORIZONTAL,
                                speed: 1500,
                                front: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Text("My Daily Nutrition",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),

                                    PieChart(
                                        PieChartData(
                                            borderData: FlBorderData(
                                                show:false
                                            ),
                                            sectionsSpace: 2,
                                            centerSpaceRadius: 50,
                                            sections: [
                                              //Carbs
                                              PieChartSectionData(
                                                color: const Color(0xFF1E92EB),
                                                value: (carbs)/((calorieGoal*.5)/4),
                                                title: "${(((carbs)/((calorieGoal*.5)/4))*100).toStringAsFixed(1)} %",
                                                radius: 60,
                                              ),
                                              //sugars
                                              PieChartSectionData(
                                                color: const Color(0xFF4DC2F5),
                                                value: (sugars)/((calorieGoal*.25)/4),
                                                title: "${(((sugars)/((calorieGoal*.25)/4))*100).toStringAsFixed(1)} %",
                                                radius: 60,
                                              ),
                                              //total fat
                                              PieChartSectionData(
                                                color: const Color(0xFFEF5848),
                                                value: (fat)/((calorieGoal*.3)/9),
                                                title: "${(((fat)/((calorieGoal*.3)/9))*100).toStringAsFixed(1)} %",
                                                radius: 60,
                                              ),
                                              //saturatedfat
                                              PieChartSectionData(
                                                color: const Color(0xFFEF9048),
                                                value: (satfat)/((calorieGoal*.07)/9),
                                                title: "${(((satfat)/((calorieGoal*.07)/9))*100).toStringAsFixed(1)} %",
                                                radius: 60,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFF9B48EF),
                                                value: (protein)/((calorieGoal*.2)/4),
                                                title: "${(((protein)/((calorieGoal*.2)/4))*100).toStringAsFixed(1)}%",
                                                radius: 60,
                                              ),
                                            ]
                                        )
                                    ),
                                  ],
                                ),
                                back: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Text("Your Daily Nutrition Goal",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),

                                    PieChart(
                                        PieChartData(
                                            borderData: FlBorderData(
                                                show:false
                                            ),
                                            sectionsSpace: 2,
                                            centerSpaceRadius: 50,
                                            sections: [
                                              //Carbs
                                              PieChartSectionData(
                                                color: const Color(0xFF1E92EB),
                                                value: .25,
                                                title: "25%",
                                                radius: 60,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFF4DC2F5),
                                                value: .25,
                                                title: "25%",
                                                radius: 60,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFEF5848),
                                                value: .22,
                                                title: "22%",
                                                radius: 60,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFEF9048),
                                                value: .07,
                                                title: "7%",
                                                radius: 60,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFF9B48EF),
                                                value: .20,
                                                title: "20%",
                                                radius: 60,
                                              ),
                                            ]
                                        )
                                    ) ,
                                  ],
                                ),

                              ),
                              Stack(
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const <Widget>[
                                      Legend(
                                        color: Color(0xFF1E92EB),
                                        descr: "Other Carbohydrates",
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Legend(
                                        color: Color(0xFF4DC2F5),
                                        descr: "Sugars (Carbohydrate)",
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Legend(
                                        color: Color(0xFFEF5848),
                                        descr: "Fats",
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Legend(
                                        color: Color(0xFFEF9048),
                                        descr: "Saturated Fats",
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Legend(
                                        color: Color(0xFF9B48EF),
                                        descr: "Protein",
                                      ),
                                    ],
                                  ),

                                ],
                              )


                            ],

                          );
                        }
                      },
                    );

                  }
                });
          }
        });
  }
}

class Legend extends StatelessWidget {
  final Color color;
  final String descr;
  final double size;
  final Color descrColor;

  const Legend({
    Key key,
    this.color,
    this.descr,
    this.size = 16,
    this.descrColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          descr,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: descrColor),
        ),
      ],
    );
  }
}





//------------------------------------------------------------------------------
/*
void totalDayCalories() async{
  //1. Get the date for the meal consumption
  int currentDate=DateTime.now().day;
  int currentYear=DateTime.now().year;
  int currentMonth=DateTime.now().month;

  DateTime beginDate=new DateTime(currentYear, currentMonth, currentDate, 0, 0, 0);
  DateTime endDate=new DateTime(currentYear, currentMonth, currentDate, 23, 59, 59);

  print("begin: $beginDate");
  print("end: $endDate");

  //2. Get the meals for that day
  //get user
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  String userID=user.uid;
  //print("ID: $userID");

 //get log from userID
  QuerySnapshot querySnapshot= await Firestore.instance.collection("log")
      .where("userID", isEqualTo: userID).getDocuments();
  var document= querySnapshot.documents;

  //3. Get the user meals for the day
  List<String> meals= List<String>();
  document.forEach((DocumentSnapshot documentSnapshot) {
    var firestore_timestamp=documentSnapshot.data["dateTime"].toDate();
    var dart_datetime= DateTime.parse(firestore_timestamp.toString());

    print("${documentSnapshot.documentID} : $dart_datetime");
    if(dart_datetime.isAfter(beginDate) & dart_datetime.isBefore(endDate)){
      meals.add(documentSnapshot.data["recipeID"]);
    }

  });
  print("Meals list $meals");

  //4. Calculate calories

  int calories=0;
  CollectionReference collectionReference= Firestore.instance.collection("recipe");
  meals.forEach((String recipeID) {
    print("Recipe: $recipeID");
    collectionReference.document(recipeID).get().then((DocumentSnapshot dSnap) {
      String recipeCalories=dSnap.data["calories"].toString();
      calories+=int.parse(recipeCalories);
      print("Calories $calories");
    }).whenComplete(() {
      print(calories);
      nutritionCollection(userID, calories);
    });
  });


}


void nutritionCollection(String userID, int calories) async{
  QuerySnapshot qSnapshot= await Firestore.instance.collection("nutrition")
      .where("userID", isEqualTo: userID).getDocuments();
  var doc= qSnapshot.documents;
  String date= "${DateFormat.yMd().format(DateTime.now())}";
  print(date);
  bool found=false;
  String docID;
  print("NUTRITION------------------");
  doc.forEach((DocumentSnapshot dSnap) {
    var documentDate=dSnap.data["date"];
    print(dSnap.data);
    if(date==documentDate){
      found=true;
      docID=dSnap.documentID;

    }
  });

  if (found){
    print("here");
    Firestore.instance.collection("nutrition").document(docID)
        .updateData({"calories": calories});
  }
  else{
    Firestore.instance.collection("nutrition").document()
        .setData({
      "userID": userID,
      "date": date,
      "calories": calories
    });
  }
}
*/

List<BarChartGroupData> barChart(List<MealChart> meals){
  var data=meals;
  var len=data.length;
  List<BarChartGroupData> bc=new List<BarChartGroupData>();
  int toolTipChecker=1;

  for(int i=0; i<len; i++){
    if(data[i].calories!=0){
      toolTipChecker=0;
    }
    else{
      toolTipChecker=1;
    }
    bc.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: data[i].calories.toDouble(),
              color: data[i].colorvalue,
              width: 15,
            )],
          showingTooltipIndicators:[toolTipChecker],
        )
    );
  }

  return bc;

}



