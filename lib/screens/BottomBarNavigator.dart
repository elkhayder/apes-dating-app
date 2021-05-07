import 'package:flutter/material.dart';

class BottomBarNavigator extends StatefulWidget {
  BottomBarNavigator({Key? key}) : super(key: key);

  @override
  _BottomBarNavigatorState createState() => _BottomBarNavigatorState();
}

class _BottomBarNavigatorState extends State<BottomBarNavigator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hello"),
      ),
    );
  }
}
