import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

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

            Card(
                margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                child: Padding(
                  padding:const EdgeInsets.all(8.0),
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
                      Stack(
                        children: <Widget>[
                          linechart(),
                          calories(),
                        ],
                      ),
                    ],
                  ),
                )
            ),

            /*
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
            */

          ],
        )


        /*
        Card(
          margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("Weekly Calorie Intake",
                  style: TextStyle(
                    fontSize: 18
                  )
                ),
                const SizedBox(height: 20,),
                Flexible(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 2500,
                      barTouchData: BarTouchData(
                          enabled: false,
                          touchTooltipData:  BarTouchTooltipData(
                            tooltipBgColor: Colors.transparent,
                            tooltipPadding: const EdgeInsets.all(0),
                            tooltipBottomMargin: 8,
                          )
                      ),
                      titlesData: FlTitlesData(
                        show:true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14
                          ),
                          margin: 20,
                          getTitles: (double value){
                            switch(value.toInt()){
                              case 0:
                                return 'Mn';
                              case 1:
                                return 'Te';
                              case 2:
                                return 'Wd';
                              case 3:
                                return 'Tu';
                              case 4:
                                return 'Fr';
                              case 5:
                                return 'St';
                              case 6:
                                return 'Sn';
                              default:
                                return '';
                            }
                          }
                        ),
                        leftTitles: SideTitles(showTitles: false)
                      ),
                      borderData: FlBorderData(
                        show:false
                      ),

                      barGroups: barchart(),
                    )
                  ),
                ),

              ],
            ),
          )

        ),
        Card(
            margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text("Weekly Calorie Intake",
                      style: TextStyle(
                          fontSize: 18
                      )
                  ),
                  const SizedBox(height: 20,),
                  Flexible(
                    child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 3000,
                          barTouchData: BarTouchData(
                              enabled: false,
                              touchTooltipData:  BarTouchTooltipData(
                                tooltipBgColor: Colors.transparent,
                                tooltipPadding: const EdgeInsets.all(0),
                                tooltipBottomMargin: 8,
                              )
                          ),
                          titlesData: FlTitlesData(
                              show:true,
                              bottomTitles: SideTitles(
                                  showTitles: true,
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14
                                  ),
                                  margin: 20,
                                  getTitles: (double value){
                                    switch(value.toInt()){
                                      case 0:
                                        return 'Mn';
                                      case 1:
                                        return 'Te';
                                      case 2:
                                        return 'Wd';
                                      case 3:
                                        return 'Tu';
                                      case 4:
                                        return 'Fr';
                                      case 5:
                                        return 'St';
                                      case 6:
                                        return 'Sn';
                                      default:
                                        return '';
                                    }
                                  }
                              ),
                              leftTitles: SideTitles(showTitles: false)
                          ),
                          borderData: FlBorderData(
                              show:false
                          ),

                          barGroups: barchart(),
                        )
                    ),
                  ),

                ],
              ),
            )

       ),
       */
      ],


    );
  }
}


//This class needs to get the user's calorie goals
class linechart extends StatefulWidget {
  @override
  _linechartState createState() => _linechartState();
}

class _linechartState extends State<linechart> {
  var userID;

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
    print(userID);
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection("users").document(userID).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Card(
              child: Text("Calories not found"),
            );
          }
          else{
            var calories=snapshot.data["calories"];
            return Column(
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
                            FlSpot(0, calories.toDouble()),
                            FlSpot(1, calories.toDouble()),
                            FlSpot(2,2000),//calories.toDouble()),
                            FlSpot(3,2000),//calories.toDouble()),
                            FlSpot(4,2000),//calories.toDouble()),
                            FlSpot(5,2000),//calories.toDouble()),
                            FlSpot(6,2000),//calories.toDouble()),
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
            );
          }
        });

  }
}

class MealChart{
  String weekday;
  int calories;
  Color colorvalue;

  MealChart(this.weekday, this.calories, this.colorvalue);
}

class calories extends StatefulWidget {
  @override
  _caloriesState createState() => _caloriesState();
}

class _caloriesState extends State<calories> {
  var userID;
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

    print(currentWeekday);

    if (currentWeekday == 7) {
      currentWeekday = 0;
    }
    int beginDay = currentDate.day;
    int beginMonth = currentDate.month;
    int beginYear = currentDate.year;

    print("begin: $beginYear");


    var dart_start_date = new DateTime(
        beginYear, beginMonth, beginDay, 0, 0, 0);
    var ts_start = Timestamp.fromDate(dart_start_date);
    print(dart_start_date);
    print("Timestamp: $ts_start");
    //2. get user
    return ts_start;
  }

  void getUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userID=user.uid;
    setState(() {
      userID=user.uid;
    });
  }

  void initState() {
    getUser();
    print(userID);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("nutrition").where("userID", isEqualTo: userID).snapshots(),
        builder: (context, snapshot){
          if((!snapshot.hasData)){ //|| documents.length==0){
            print(userID);
            return Card(
              child: Text("No meals have been entered. Unable to calculate!"),
            );
          }
          else{
            return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("nutrition")
                    .where("userID", isEqualTo: userID)
                    .where("dateTime", isGreaterThanOrEqualTo: dateTime()).snapshots(),
                builder: (context, snapshot) {
                  print("userID: $userID");
                  if(snapshot.hasData) {
                    var documents = snapshot.data.documents;
                    for (int x = 0; x < documents.length; x++) {
                      print(documents[x]["dateTime"]);
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
                    return Column(
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
                    );
                  }

                  else{
                    return Card(
                      child: Text("No meals have been entered. Unable to calculate"),
                    );
                  }
                });
          }

        });

  }
}


class MacroNutrientChart extends StatefulWidget {
  @override
  _MacroNutrientChartState createState() => _MacroNutrientChartState();
}

class _MacroNutrientChartState extends State<MacroNutrientChart> {
  var userID;
  var calorieGoal;
  Timestamp dateTime() {
    int currentWeekday = new DateTime.now().weekday;
    DateTime currentDate = new DateTime.now();
    if (currentWeekday == 7) {
      currentWeekday = 0;
    }
    int beginDay = currentDate.day;
    int beginMonth = currentDate.month;
    int beginYear = currentDate.year;



    var dart_start_date = new DateTime(
        beginYear, beginMonth, beginDay, 0, 0, 0);
    var ts_start = Timestamp.fromDate(dart_start_date);
    print(dart_start_date);
    //print("Timestamp: $ts_start");
    //2. get user
    return ts_start;
  }

  void getUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      userID=user.uid;
    });
    Firestore.instance.collection('users').document(userID).get().then((DocumentSnapshot document){
      print("document_build:$document");
      setState(() {
        calorieGoal=document.data["calories"];
      });
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
          if(!snapshot.hasData){ //|| documents.length==0){
            print(userID);
            return Card(
              child: Text("No meals have been entered. Unable to calculate!"),
            );
          }
          else{
            return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("nutrition").where("userID", isEqualTo: userID)
                    .where("dateTime", isGreaterThanOrEqualTo: dateTime()).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData & snapshot.data.documents.isNotEmpty) {
                    //print("MACRONUTRIENTS--------------");
                    //print("length: ${documents.length}");
                    var documents = snapshot.data.documents;
                    int sodium=0;
                    int carbs=0;
                    int protein=0;
                    int sugars=0;
                    int cholesterol=0;
                    int satfat=0;
                    int tranfat=0;
                    for (int x = 0; x < documents.length; x++) {
                      print(documents[x]["dateTime"]);
                      var firestoreTimestamp = documents[x]["dateTime"].toDate();
                      var dartDatetime = DateTime.parse(
                          firestoreTimestamp.toString());
                      print(dartDatetime);
                      var weekday = dartDatetime.weekday;
                      if (weekday == 7) {
                        weekday = 0;
                      }
                      sodium+=documents[x]["sodium"];
                      carbs+=documents[x]["carbohydrates"];
                      protein+=documents[x]["protein"];
                      sugars+=documents[x]["sugar"];
                      cholesterol+=documents[x]["cholesterol"];
                      tranfat+=documents[x]["transFat"];
                      satfat+=documents[x]["saturatedFat"];
                    }
                    //section(sodium);
                    return Row(
                      /*
                      children: <Widget>[
                        PieChart(
                          PieChartData(
                            borderData: FlBorderData(
                              show:true
                            ),
                            sections: [
                              //Fats
                              PieChartSectionData(
                                color: const Color(0xff0293ee),
                                value: (calorieGoal*.3)/9
                              )
                            ]
                          )
                        ),

                      ],
                      */
                    );
                  }

                  else{
                    return Card(
                      child: Text("No meals have been entered. Unable to calculate"),
                    );
                  }
                });
          }
        });
  }
}






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


