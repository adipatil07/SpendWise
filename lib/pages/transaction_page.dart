import 'package:flutter/material.dart';
import 'package:spendwise/widget/transactionList.dart';

class transation extends StatefulWidget {
  @override
  State<transation> createState() => _transationState();
}

class _transationState extends State<transation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recent Transactions"),
      ),
      body: SingleChildScrollView(
        child: Container(child: TransactionList()),
      ),
    );
  }
}
