import 'package:flutter/material.dart';
import 'package:sqlite_crud/models/employee.dart';

class ViewUsers extends StatefulWidget {
  ViewUsers({this.employee});

  List<Employee> employee = [];
  @override
  _ViewUsersState createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View All Users'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[_viewUsers()],
        ),
      ),
    );
  }

  _viewUsers() => Expanded(
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.red,
                      size: 40.0,
                    ),
                    title: Text(
                      widget.employee[index].name.toUpperCase(),
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(widget.employee[index].address),
                    trailing: Text("Age: " +
                      widget.employee[index].age,
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider()
                ],
              );
            },
            itemCount: widget.employee.length,
          ),
        ),
      );
}
