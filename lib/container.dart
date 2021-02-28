import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home_page.dart';

container(int day, int i, Function onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
        color: Colors.greenAccent,
        height: 150,
        width: 150,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                weekday[day],
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.network(
                  'https://www.metaweather.com/static/img/weather/' +
                      abbr[i] +
                      '.svg',
                  height: 50,
                ),
              ),
              Text(min[i].toString() + '°' + '/' + max[i].toString() + '°')
            ],
          ),
        )),
  );
}
