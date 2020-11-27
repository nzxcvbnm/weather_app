import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:developer';

import 'error_screen.dart';
import 'container.dart';
import 'details.dart';
import 'nonetscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  int numOfCurrentWeekday = DateTime.now().weekday - 1;

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: HomePage(numOfCurrentWeekday))));
}

class HomePage extends StatefulWidget {
  final int numOfCurrentWeekday;
  HomePage(this.numOfCurrentWeekday);
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

  bool internetConnected = false;

  checkNet() async {
    if (!internetConnected) {
      var res = await (Connectivity().checkConnectivity());
      if (res == ConnectivityResult.mobile) {
        setInternetConnected();
      } else if (res == ConnectivityResult.wifi) {
        log("Connected to WiFi");
        setInternetConnected();
      } else {
        log("Unable to connect. Please Check Internet Connection");
      }
    }
  }

  setInternetConnected() {
    log("Connected to WiFi");
    setState(() {
      internetConnected = true;
    });
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
    details = widget.numOfCurrentWeekday;
    index = 0;
    super.initState();
  }

  updateShower(int i, int j) {
    setState(() {
      details = i;
      index = j;
    });
  }

  List<Widget> listOfContainers = List();

  createListOfContainers() {
    if (listOfContainers.length >= 5) return;
    for (int i = 0; i < 5; i++) {
      listOfContainers.add(container(widget.numOfCurrentWeekday + i, i,
          () => updateShower(widget.numOfCurrentWeekday + i, i)));
    }
  }

  @override
  Widget build(BuildContext context) {
    checkNet();
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    checkPermission();
    return internetConnected
        ? MaterialApp(
            theme: darkMode ? ThemeData.dark() : ThemeData.light(),
            home: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return progressIndicator();
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  createListOfContainers();
                  return Scaffold(
                    floatingActionButton: refreshButton(),
                    body: SafeArea(
                        child: isPortrait ? verticalView() : horizontalView()),
                  );
                } else {
                  return ErrorScreen(() => getData());
                }
              },
            ),
          )
        : NoNetScreen();
  }

  progressIndicator() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  verticalView() {
    return Stack(
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
                  children: listOfContainers),
            ),
          ],
        ),
      ],
    );
  }

  horizontalView() {
    return ListView(
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
              children: listOfContainers),
        )
      ],
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
