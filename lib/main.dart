import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';

import 'error_screen.dart';
import 'container.dart';
import 'details.dart';

void main() {
  int day = DateTime.now().weekday - 1;
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, home: Scaffold(body: HomePage(day))));
}

List<String> min = List();
List<String> max = List();
List<String> temp = List();
List<String> humidity = List();
List<String> pressure = List();
List<String> wind = List();
List<String> abbr = List();
List<String> weekday = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
];

class HomePage extends StatefulWidget {
  int day;
  HomePage(this.day);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool darkMode = false;
  changeMode() {
    if (!darkMode) {
      setState(() {
        darkMode = true;
      });
    } else {
      setState(() {
        darkMode = false;
      });
    }
  }

  Location location = Location();
  bool _locationEnabled;
  checkPermission() async {
    _locationEnabled = await location.serviceEnabled();
    if (!_locationEnabled) {
      _locationEnabled = await location.requestService();
      if (_locationEnabled) {
        return;
      }
    }
  }

  LocationData _locationData;
  Future getData() async {
    _locationData = await location.getLocation();
    String long = _locationData.longitude.toString();
    String lat = _locationData.latitude.toString();
    String url = 'https://www.metaweather.com/api/location/search/?lattlong=' +
        lat +
        ',' +
        long;
    var res = await http.get(url);
    var list = jsonDecode(res.body.toString());

    Map<String, dynamic> map = list[0];
    city = 'weather for ' + map['title'];
    woeid = map['woeid'].toString();

    String url2 = 'https://www.metaweather.com/api/location/' + woeid;
    var res2 = await http.get(url2);
    Map<String, dynamic> map2 = jsonDecode(res2.body.toString());
    var list2 = map2['consolidated_weather'];

    for (int i = 0; i < 6; i++) {
      humidity.add(list2[i]['humidity'].toString());
      pressure.add(list2[i]['air_pressure'].round().toString());
      wind.add(list2[i]["wind_speed"].round().toString());
      abbr.add(list2[i]['weather_state_abbr']);
      min.add(list2[i]['min_temp'].round().toString());
      max.add(list2[i]['max_temp'].round().toString());
      temp.add(list2[i]['the_temp'].round().toString());
    }
  }

  String woeid;
  String city = 'city';

  int details;
  int index;

  @override
  void initState() {
    details = widget.day;
    index = 0;
    super.initState();
  }

  updateShower(int i, int j) {
    setState(() {
      details = i;
      index = j;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    checkPermission();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkMode ? ThemeData.dark() : ThemeData.light(),
      home: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              floatingActionButton: refreshButton(),
              body: SafeArea(
                child: isPortrait
                    ? Stack(
                        children: [
                          cityName(),
                          changeModeIcon(),
                          Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: Details(details, index),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 150,
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    container(widget.day, 0,
                                        () => updateShower(widget.day, 0)),
                                    container(widget.day + 1, 1,
                                        () => updateShower(widget.day + 1, 1)),
                                    container(widget.day + 2, 2,
                                        () => updateShower(widget.day + 2, 2)),
                                    container(widget.day + 3, 3,
                                        () => updateShower(widget.day + 3, 3)),
                                    container(widget.day + 4, 4,
                                        () => updateShower(widget.day + 4, 4)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : ListView(
                        children: [
                          cityName(),
                          changeModeIcon(),
                          Details(details, index),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 150,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                container(widget.day, 0,
                                    () => updateShower(widget.day, 0)),
                                container(widget.day + 1, 1,
                                    () => updateShower(widget.day + 1, 1)),
                                container(widget.day + 2, 2,
                                    () => updateShower(widget.day + 2, 2)),
                                container(widget.day + 3, 3,
                                    () => updateShower(widget.day + 3, 3)),
                                container(widget.day + 4, 4,
                                    () => updateShower(widget.day + 4, 4)),
                              ],
                            ),
                          )
                        ],
                      ),
              ),
            );
          } else {
            return ErrorScreen(() => getData());
          }
        },
      ),
    );
  }

  cityName() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            city,
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }

  refreshButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 160, right: 10),
      child: FloatingActionButton(
        onPressed: () => getData(),
        child: Icon(
          Icons.refresh,
          color: Colors.amber,
        ),
      ),
    );
  }

  changeModeIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
              color: Colors.amber,
              iconSize: 30,
              icon: darkMode ? Icon(Icons.brightness_1) : Icon(Icons.bedtime),
              onPressed: changeMode),
        ),
      ],
    );
  }
}
