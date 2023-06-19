import 'dart:convert';

import 'package:crud/screens/form.dart';
import 'package:crud/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:crud/models/user.dart';

class MyList extends StatefulWidget {
  MyList({Key? key}) : super(key: key);

  @override
  _MyListState createState() => _MyListState();
}

Future fetch_users() async {
  var response = await http.get(Uri.parse('http://127.0.0.1:8000/'));
  var users = [];
  for (var u in jsonDecode(response.body)) {
    users.add(User(u['id'], u['nom']));
  }
  print(users);
  return users;
}

class _MyListState extends State<MyList> {
  Future delete(id) async {
    await http.delete(Uri.parse('http://127.0.0.1:8000/' + id));
  }

  @override
  void initState() {
    super.initState();
    fetch_users();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: fetch_users(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          } else {
            return Column(
              children: [
                DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Name',
                          style: TextStyle(fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Actions',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: snapshot.data!.map<DataRow>((user) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(user.nom)),
                        DataCell(
                          Row(
                            children: [
                              MaterialButton(
                                child:     Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                  size: 24.0,
                                  semanticLabel: 'Edit',
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(
                                        widgetName: MyForm(
                                          user: user,
                                        ),
                                        title: 'Edit',
                                        index: 1,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 8),
                              MaterialButton(

                                child:  Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 24.0,
                                  semanticLabel: 'Delete',
                                ),
                                onPressed: () async {
                                  await delete(user.id.toString());
                                  setState(() {});
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(
                                        widgetName: MyList(),
                                        title: 'List',
                                        index: 0,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            );
          }
        },
      ),
    );
  }

}
