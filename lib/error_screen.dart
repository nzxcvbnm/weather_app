import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final Function getData;
  ErrorScreen(this.getData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Error!'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: RaisedButton(
                  onPressed: () => getData(),
                  child: Text(
                    'retry',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
