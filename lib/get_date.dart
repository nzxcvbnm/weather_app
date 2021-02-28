import 'package:flutter/material.dart';
import 'home_page.dart';

class GetDate extends StatelessWidget {
  var dayOfTheWeek;
  @override
  Widget build(BuildContext context) {
    var dayOfTheWeek = DateTime.now().weekday - 1;
    return HomePage(dayOfTheWeek);
  }
}
