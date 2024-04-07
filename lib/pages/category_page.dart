import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendwise/widget/category_types.dart';

class Category extends StatefulWidget {
  @override
  State<Category> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<Category> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isExpenseSelected = true;

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Fetch categories when the widget initializes
  }

  void fetchCategories() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('categories').get();

      // Check if there are any documents
      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, String>> expenseCategories = [];
        List<Map<String, String>> incomeCategories = [];

        // Loop through documents and populate the lists
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data['isExpense']) {
            expenseCategories.add({
              'name': data['name'],
              'imagePath': data['imagePath'],
            });
          } else {
            incomeCategories.add({
              'name': data['name'],
              'imagePath': data['imagePath'],
            });
          }
        });

        setState(() {
          iconDataList = expenseCategories;
          incomeIconDataList = incomeCategories;
        });
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> uploadCategories(List<Map<String, String>> categories, bool isExpense, String userId) async {
    try {
      // Reference the user's document
      DocumentReference userDocRef = _firestore.collection('users').doc(userId);

      // Reference the categories subcollection under the user's document
      CollectionReference categoriesCollectionRef = userDocRef.collection('categories');

      // Clear existing categories in the subcollection
      await categoriesCollectionRef.doc(isExpense ? 'expense' : 'income').delete();

      // Upload updated categories to the subcollection
      categories.forEach((category) async {
        await categoriesCollectionRef.doc(isExpense ? 'expense' : 'income').set(category);
      });

      print('Categories updated successfully.');
    } catch (e) {
      print('Error uploading categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              FirebaseAuth auth = FirebaseAuth.instance;
              User? user = auth.currentUser;
              String uid = user?.uid ?? '';
               // Replace with the actual user's document ID
              uploadCategories(iconDataList, true, uid); // Upload expense categories
              uploadCategories(incomeIconDataList, false, uid);// Upload income categories
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
