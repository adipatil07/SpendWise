import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView(
        padding: EdgeInsets.all(15),
        children: const <Widget>[
          Card(
            child: ListTile(
              leading: Icon(Icons.dinner_dining),
              title: Text("Lunch"),
              subtitle: Text(
                "Thursday, 18 Jan 2024, 1:00 PM", // Example date and time
              ),
              trailing: Text(
                "150Rs",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.dinner_dining),
              title: Text("Lunch"),
              subtitle: Text(
                "Thursday, 18 Jan 2024, 1:00 PM", // Example date and time
              ),
              trailing: Text(
                "150Rs",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.dinner_dining),
              title: Text("Lunch"),
              subtitle: Text(
                "Thursday, 18 Jan 2024, 1:00 PM", // Example date and time
              ),
              trailing: Text(
                "150Rs",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.dinner_dining),
              title: Text("Lunch"),
              subtitle: Text(
                "Thursday, 18 Jan 2024, 1:00 PM", // Example date and time
              ),
              trailing: Text(
                "150Rs",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.dinner_dining),
              title: Text("Lunch"),
              subtitle: Text(
                "Thursday, 18 Jan 2024, 1:00 PM", // Example date and time
              ),
              trailing: Text(
                "150Rs",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.dinner_dining),
              title: Text("Lunch"),
              subtitle: Text(
                "Thursday, 18 Jan 2024, 1:00 PM", // Example date and time
              ),
              trailing: Text(
                "150Rs",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
