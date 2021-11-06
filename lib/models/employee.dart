class Employee{
  static const tblEmployee = 'Employee';
  static const colId = 'id';
  static const colName = 'name';
  static const colAge = 'age';
  static const colEmail = 'email';
  static const colAddress = 'address';

  Employee({this.id, this.name, this.age, this.email, this.address});

  Employee.fromMap(Map<String, dynamic>map){
    id = map[colId];
    name = map[colName];
    age = map[colAge];
    email = map[colEmail];
    address = map[colAddress];
  }

  int id;
  String name;
  String age;
  String email;
  String address;

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{colName: name, colAge: age, colEmail: email, colAddress: address};
    if(id != null) map[colId] = id;
    return map;
  }
}