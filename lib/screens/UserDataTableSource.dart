import 'dart:convert';

import 'package:crud/screens/form.dart';
import 'package:crud/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:crud/models/user.dart';
class UserDataTableSource extends DataTableSource {
  final List<User> users;

  UserDataTableSource(this.users);

  @override
  DataRow? getRow(int index) {
    if (index >= users.length) {
      return null;
    }

    final user = users[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(user.nom)),
        DataCell(
          Row(
            children: [
              MaterialButton(
                child: Icon(
                  Icons.edit,
                  color: Colors.blue,
                  size: 24.0,
                ),
                onPressed: () {
                  // Ajoutez votre logique d'édition ici
                },
              ),
              SizedBox(width: 8),
              MaterialButton(
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 24.0,
                ),
                onPressed: () {
                  // Ajoutez votre logique de suppression ici
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}