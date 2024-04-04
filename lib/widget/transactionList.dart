import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionList extends StatelessWidget {
  final String userId; // User ID for fetching transactions

  TransactionList({required this.userId}); // Constructor to accept userId

  @override
  Widget build(BuildContext context) {
    // Get today's date
    DateTime today = DateTime.now();
    DateTime startDate = DateTime(today.year, today.month, today.day);
    DateTime endDate = DateTime(today.year, today.month, today.day + 1);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9, // Set a bounded height
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('transactions')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Convert each document snapshot into a list tile
          var documents = snapshot.data!.docs;
          documents.sort((a, b) {
            // Sorting based on timestamp in descending order
            Timestamp timestampA = a['date'];
            Timestamp timestampB = b['date'];
            return timestampB.compareTo(timestampA);
          });

          return ListView(
            padding: EdgeInsets.all(15),
            children: documents.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              // Extract timestamp from data
              Timestamp timestamp = data['date'];

              // Convert timestamp to DateTime
              DateTime dateTime = timestamp.toDate();

              // Format DateTime to display date and time
              String formattedDateTime =
                  "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";

              return Card(
                child: ListTile(
                  leading: Icon(Icons.dinner_dining),
                  title: Text(data['category'] ?? ''),
                  subtitle: Text(
                    formattedDateTime,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${data['amount']} Rs",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Delete the transaction when delete icon is pressed
                          deleteTransaction(document.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void deleteTransaction(String transactionId) {
    // Delete the transaction with the given ID
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(transactionId)
        .delete()
        .then((_) => print('Transaction deleted successfully'))
        .catchError((error) => print('Failed to delete transaction: $error'));
  }
}
