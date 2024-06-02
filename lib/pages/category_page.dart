import 'package:flutter/material.dart';
import '../widget/categoryService.dart'; // Import Firestore

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
      List<List<Map<String, String>>> categories = await CategoryService.getCategories();

      setState(() {
        incomeCategories = categories[0].map((category) => CategoryList(category['name']!, category['imagePath']!)).toList();
        expenseCategories = categories[1].map((category) => CategoryList(category['name']!, category['imagePath']!)).toList();
      });
    } catch (error) {
      print("Error fetching categories: $error");
      // Handle error here
    }
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
                  return Card(
                    child: ListTile(
                      onTap: () {
                        // Implement adding a new category
                      },
                      title: Center(child: Text('Add New')),
                    ),
                  );
                } else {
                  CategoryList category = selectedCategories[index];
                  return Card(
                    child: ListTile(
                      leading: SizedBox(
                        width: 56,
                        height: 56,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            category.imagePath, // Assuming category.imagePath contains the file path
                            width: 30,
                            height: 30,
                          ),
                        ),
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
