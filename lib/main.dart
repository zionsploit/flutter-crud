import 'package:flutter/material.dart';
import 'package:sqlite_crud/about.dart';
import 'package:sqlite_crud/models/employee.dart';
import 'package:sqlite_crud/utils/database_helper.dart';
import 'package:sqlite_crud/view.dart';

void main() {
  runApp(MyApp());
}

const darkViolet = Color(0xff40147a);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMPLOYEE LIST',
      theme: ThemeData(
        primaryColor: darkViolet,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'EMPLOYEE LIST'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _ctrlName = TextEditingController();
  final _ctrlAge = TextEditingController();
  final _ctrlEmail = TextEditingController();
  final _ctrlAddress = TextEditingController();

  Employee _employee = Employee();
  List<Employee> _employees = [];

  DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshEmployeeList();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
            child: Text(
          widget.title,
          style: TextStyle(color: darkViolet),
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[_form(), _list()],
        ),
      ),
    );
  }

  _form() => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _ctrlName,
                decoration: InputDecoration(labelText: 'Full name'),
                onSaved: (val) => setState(() => _employee.name = val),
                validator: (val) =>
                    (val.length == 0 ? 'This field is required' : null),
              ),
              TextFormField(
                controller: _ctrlAge,
                decoration: InputDecoration(labelText: 'Age'),
                onSaved: (val) => setState(() => _employee.age = val),
                validator: (val) =>
                    (val.length == 0 ? 'This field is required' : null),
              ),
              TextFormField(
                controller: _ctrlEmail,
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (val) => setState(() => _employee.email = val),
                validator: (val) =>
                    (val.length == 0 ? 'This field is required' : null),
              ),
              TextFormField(
                controller: _ctrlAddress,
                decoration: InputDecoration(labelText: 'Address'),
                onSaved: (val) => setState(() => _employee.address = val),
                validator: (val) =>
                    (val.length == 0 ? 'This field is required' : null),
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: () => _onSubmit(),
                      child: Text('ADD')
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: () => _onUpdate(),
                      child: Text('UPDATE'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewUsers(employee: _employees))),
                      child: Text('VIEW'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => About())),
                      child: Text('ABOUT'),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );

  _refreshEmployeeList() async {
    List<Employee> x = await _dbHelper.fetchEmployee();
    setState(() {
      _employees = x;
    });
  }

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      await _dbHelper.insertEmployee(_employee);
      _refreshEmployeeList();
      _resetForm();
    }
  }

  _onUpdate() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      await _dbHelper.updateEmployee(_employee);
      _refreshEmployeeList();
      _resetForm();
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _ctrlName.clear();
      _ctrlAge.clear();
      _ctrlEmail.clear();
      _ctrlAddress.clear();
      _employee.id = null;
    });
  }

  _list() => Expanded(
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
                      color: darkViolet,
                      size: 40.0,
                    ),
                    title: Text(
                      _employees[index].name.toUpperCase(),
                      style: TextStyle(
                          color: darkViolet, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_employees[index].address),
                    trailing: IconButton(
                        icon: Icon(Icons.delete_sweep, color: darkViolet),
                        onPressed: () async {
                          await _dbHelper.deleteEmployee(_employees[index].id);
                          _resetForm();
                          _refreshEmployeeList();
                        }),
                    onTap: () {
                      setState(() {
                        //_contact = _contacts[index];
                        //_ctrlName.text = _contacts[index].name;
                        _employee = _employees[index];
                        _ctrlName.text = _employees[index].name;
                        _ctrlAge.text = _employees[index].age;
                        _ctrlEmail.text = _employees[index].email;
                        _ctrlAddress.text = _employees[index].address;
                      });
                    },
                  ),
                  Divider()
                ],
              );
            },
            itemCount: _employees.length,
          ),
        ),
      );
}
