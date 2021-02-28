import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home_page.dart';

class Details extends StatefulWidget {
  final int i;
  final int details;
  Details(this.details, this.i);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            height: 300,
            width: 300,
            child: bigcontainer(widget.details, widget.i),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            temp[widget.i] + '°',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            'Humidity: ' + humidity[widget.i],
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            'Pressure: ' + pressure[widget.i] + ' hPa',
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            'Wind: ' + wind[widget.i] + ' km/h',
            textAlign: TextAlign.left,
          ),
        ),
        Opacity(
          opacity: 0,
          child: DropdownButton(
            // centers column
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}

List<String> weekdayFull = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thuesday',
  'Friday',
  'Saturday',
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thuesday',
  'Friday',
  'Saturday',
  'Sunday',
];

String weatherNameStr;

weatherName(String abbr) {
  switch (abbr) {
    case 'sn':
      weatherNameStr = 'snow';
      break;
    case 'sl':
      weatherNameStr = 'sleet';
      break;
    case 'h':
      weatherNameStr = 'hail';
      break;
    case 't':
      weatherNameStr = 'thunderstorm';
      break;
    case 'hr':
      weatherNameStr = 'heavy rain';
      break;
    case 'lr':
      weatherNameStr = 'light rain';
      break;
    case 's':
      weatherNameStr = 'showers';
      break;
    case 'hc':
      weatherNameStr = 'heavy cloud';
      break;
    case 'lc':
      weatherNameStr = 'light cloud';
      break;
    case 'c':
      weatherNameStr = 'clear';
      break;
    default:
      weatherNameStr = 'none';
  }
}

bigcontainer(int day, int i) {
  weatherName(abbr[i]);
  return Container(
      height: 150,
      width: 150,
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekdayFull[day],
              style: TextStyle(fontSize: 30),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SvgPicture.network(
                'https://www.metaweather.com/static/img/weather/' +
                    abbr[i] +
                    '.svg',
                height: 100,
              ),
            ),
            Text(
              weatherNameStr,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              min[i].toString() + '°' + '/' + max[i].toString() + '°',
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
      ));
}
