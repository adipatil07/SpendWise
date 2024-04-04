import 'package:flutter/material.dart';
import 'package:spendwise/widget/transactionList.dart';
import 'package:firebase_auth/firebase_auth.dart';

class transation extends StatefulWidget {
  @override
  State<transation> createState() => _transationState();
}

class _transationState extends State<transation> {
  late String _userId; // Add userId variable

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  // Fetch the current user's ID
  Future<void> _fetchUserId() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    setState(() {
      _userId = user?.uid ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recent Transactions"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: TransactionList(userId: _userId), // Pass userId to TransactionList
        ),
      ),
    );
  }
}
