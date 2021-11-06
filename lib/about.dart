import 'package:flutter/material.dart';

class About extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About Us'),),
      body: Center(
        child: Column(
          children: <Widget>[_aboutus()],
        ),
      ),
    );
  }
}

_aboutus() => Container(
  color: Colors.white,
  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
  child: Text("Basic FLUTTER CRUD WITH ROUTE NAVIGATIONS, THIS IS MY FIRST CRUD FLUTTER"),
);