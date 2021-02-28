import 'package:flutter/material.dart';
import '../main.dart';

class NoNetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('no internet connection'),
            IconButton(
              icon: Icon(
                Icons.autorenew_outlined,
                size: 50,
                color: Colors.red,
              ),
              onPressed: () => main(),
            )
          ],
        ),
      ),
    );
  }
}
