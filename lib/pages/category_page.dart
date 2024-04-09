import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class Category extends StatefulWidget {
  @override
  State<Category> createState() => _CategoryScreenState();
}

class CategoryList {
  final String name;
  final String imagePath;

  CategoryList(this.name, this.imagePath);
}

class _CategoryScreenState extends State<Category> {
  bool isExpenseSelected = true;
  List<CategoryList> incomeCategories = [];
  List<CategoryList> expenseCategories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      List<List<CategoryList>> categories = await getCategories();
      setState(() {
        incomeCategories = categories[0];
        expenseCategories = categories[1];
      });
    } catch (error) {
      print("Error fetching categories: $error");
      // Handle error here
    }
  }

  Future<List<List<CategoryList>>> getCategories() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user?.uid ?? '';

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userDocRef = firestore.collection('users').doc(uid);

    CollectionReference incomeCategoriesCollection = userDocRef.collection('incomeCategories');
    CollectionReference expenseCategoriesCollection = userDocRef.collection('expenseCategories');

    QuerySnapshot incomeSnapshot = await incomeCategoriesCollection.get();
    QuerySnapshot expenseSnapshot = await expenseCategoriesCollection.get();

    List<CategoryList> incomeCategoryList = [];
    List<CategoryList> expenseCategoryList = [];

    incomeSnapshot.docs.forEach((doc) {
      String name = doc.get('name');
      String imagePath = doc.get('imagePath');
      incomeCategoryList.add(CategoryList(name, imagePath));
    });

    expenseSnapshot.docs.forEach((doc) {
      String name = doc.get('name');
      String imagePath = doc.get('imagePath');
      expenseCategoryList.add(CategoryList(name, imagePath));
    });

    return [incomeCategoryList, expenseCategoryList];
  }

  @override
  Widget build(BuildContext context) {
    List<CategoryList> selectedCategories = isExpenseSelected ? expenseCategories : incomeCategories;

    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              fetchCategories();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
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
                  color: isExpenseSelected ? Color(0xffFFBF9B) : Color.fromARGB(255, 236, 233, 233),
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
                  color: isExpenseSelected ? Color.fromARGB(255, 236, 233, 233) : Color(0xffFFBF9B),
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
              itemCount: selectedCategories.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == selectedCategories.length) {
                  // Add New button
                  return Card(
                    child: ListTile(
                      onTap: () {
                        // Implement adding a new category
                      },
                      title: Center(child: Text('Add New')),
                    ),
                  );
                } else {
                  // Category item
                  CategoryList category = selectedCategories[index];
                  return Card(
                    child: ListTile(
                      leading: Image.asset(
                        category.imagePath,
                        width: 30,
                        height: 30,
                      ),
                      title: Text(category.name),
                      onTap: () {
                        // Implement editing existing category
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
