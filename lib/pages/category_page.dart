import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore


import 'package:spendwise/widget/category_types.dart';

class Category extends StatefulWidget {
  @override
  State<Category> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<Category> {
  bool isExpenseSelected = true;

  @override
  void initState() {
    super.initState();
  }

  // Function to upload categories to Firestore


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {


            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpenseSelected = true;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 50,
                    color: isExpenseSelected
                        ? Color(0xffFFBF9B)
                        : Color.fromARGB(255, 236, 233, 233),
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
                      isExpenseSelected = false;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 50,
                    color: isExpenseSelected
                        ? Color.fromARGB(255, 236, 233, 233)
                        : Color(0xffFFBF9B),
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
            SizedBox(height: MediaQuery.of(context).size.width * 0.03),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: isExpenseSelected ? iconDataList.length : incomeIconDataList.length + 1, // Add 1 for the "Add New" button for income categories
                itemBuilder: (BuildContext context, int index) {
                  if (!isExpenseSelected && index == incomeIconDataList.length) {
                    // Display the "Add New" button for income categories
                    return Card(
                      child: ListTile(
                        onTap: () {
                          // Implement adding a new category for income
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Add New Category'),
                                content: TextField(
                                  decoration: InputDecoration(hintText: 'Enter category name'),
                                  onChanged: (value) {
                                    // Implement updating category name
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Implement saving the new category for income
                                      Navigator.pop(context);
                                    },
                                    child: Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        title: Center(child: Text('Add New')),
                      ),
                    );
                  } else {
                    // Display existing categories
                    return Card(
                      child: ListTile(
                        leading: Image.asset(
                          isExpenseSelected ? iconDataList[index]["imagePath"]! : incomeIconDataList[index]["imagePath"]!,
                          width: 30,
                          height: 30,
                        ),
                        title: Text(isExpenseSelected ? iconDataList[index]["name"]! : incomeIconDataList[index]["name"]!),
                        onTap: () {
                          // Implement updating existing category
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Edit Category'),
                                content: TextField(
                                  decoration: InputDecoration(hintText: 'Enter category name'),
                                  onChanged: (value) {
                                    // Implement updating category name
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Implement saving the updated category
                                      Navigator.pop(context);
                                    },
                                    child: Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
