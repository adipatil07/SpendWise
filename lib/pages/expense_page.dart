import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/widget/category_list.dart';
import 'package:spendwise/widget/category_types.dart';
import 'dart:ui';
class expensePage extends StatefulWidget {

  @override
  State<expensePage> createState() => _TransactionState();
}

class _TransactionState extends State<expensePage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = ''; // Track the selected category
  bool isLeftSelected = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = iconDataList.first["name"] ?? ''; // Default to the first category
  }

  Future<void> _addTransaction(double amount, DateTime date, String category, String description) async {
    try {
      // Get current user's UID
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String uid = user?.uid ?? '';

      // Add transaction details to Firestore
      await _firestore.collection('users').doc(uid).collection('transactions').add({
        'amount': amount,
        'date': date,
        'category': category,
        'description': description,
        'timestamp': DateTime.now(),
      });

      // Navigate back to the dashboard page after adding the transaction
      Navigator.pop(context); // This will pop the expensePage off the navigation stack

    } catch (e) {
      print('Error adding transaction: $e');
      // Optionally, display an error message to the user
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.width * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLeftSelected = true; // Select the left container
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 50,
                        color: isLeftSelected ? Color(0xffFFBF9B) : Color.fromARGB(255, 236, 233, 233),
                        child: Center(
                          child: Text(
                            "Expense",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLeftSelected = false; // Select the right container
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 50,
                        color: isLeftSelected ? Color.fromARGB(255, 236, 233, 233) : Color(0xffFFBF9B),
                        child: Center(
                          child: Text(
                            "Income",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.03),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  prefixIcon: Image.asset(
                    "images/icons/rs.png",
                    height: 12, // Set the height here as desired
                    width: 12,
                  ),
                  labelText: "Amount",
                  hintText: "Enter amount",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.03),
              Text("Date"),
              EasyDateTimeLine(
                initialDate: DateTime.now(),
                onDateChange: (selectedDate) {
                  setState(() {
                    _selectedDate = selectedDate;
                  });
                },
                activeColor: const Color(0xffFFBF9B),
                headerProps: const EasyHeaderProps(
                  dateFormatter: DateFormatter.monthOnly(),
                ),
                dayProps: const EasyDayProps(
                  height: 56.0,
                  width: 56.0,
                  dayStructure: DayStructure.dayNumDayStr,
                  inactiveDayStyle: DayStyle(
                    borderRadius: 48.0,
                    dayNumStyle: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  activeDayStyle: DayStyle(
                    dayNumStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.05),
              Text("Categories"),
              SizedBox(height: MediaQuery.of(context).size.width * 0.05),
              isLeftSelected
                  ? Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: iconDataList.length,
                  itemBuilder: (context, index) {
                    final iconData = iconDataList[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: CategoryList(
                        imagePath: iconData["imagePath"]!,
                        name: iconData["name"]!,
                        isSelected: iconData["name"] == _selectedCategory,
                        onSelect: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              _selectedCategory = iconData["name"]!;
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              )
                  : Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: incomeIconDataList.length,
                  itemBuilder: (context, index) {
                    final iconData = incomeIconDataList[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: CategoryList(
                        imagePath: iconData["imagePath"]!,
                        name: iconData["name"]!,
                        isSelected: iconData["name"] == _selectedCategory,
                        onSelect: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              _selectedCategory = iconData["name"]!;
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.03),
              Text("Description"),
              SizedBox(height: MediaQuery.of(context).size.width * 0.03),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 236, 233, 233),
                  // borderRadius: BorderRadius.circular(10)
                ),
                // padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your Description",
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: GestureDetector(
                  onTap: () {
                    // Add functionality here
                    double amount = double.tryParse(amountController.text) ?? 0.0; // Parse the amount from TextField
                    _addTransaction(amount, _selectedDate, _selectedCategory, descriptionController.text);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffFFBF9B), // Set background color to orange
                    ),
                    child: Center(
                      child: Text(
                        "Add",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
