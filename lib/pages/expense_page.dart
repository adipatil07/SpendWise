import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widget/category_list.dart'; // Ensure this path is correct
import '../widget/categoryService.dart';

class ExpensePage extends StatefulWidget {
  @override
  State<ExpensePage> createState() => _TransactionState();
}

class _TransactionState extends State<ExpensePage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = '';
  bool isLeftSelected = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<CategoryList> expenseCategories = [];
  List<CategoryList> incomeCategories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      List<List<Map<String, String>>> categories = await CategoryService.getCategories();
      List<CategoryList> expenseList = categories[1].map<CategoryList>((category) => CategoryList(name: category["name"]!, imagePath: category["imagePath"]!, isSelected: false)).toList();
      List<CategoryList> incomeList = categories[0].map<CategoryList>((category) => CategoryList(name: category["name"]!, imagePath: category["imagePath"]!, isSelected: false)).toList();
      setState(() {
        expenseCategories = expenseList;
        incomeCategories = incomeList;
        _selectedCategory = (isLeftSelected && expenseCategories.isNotEmpty
            ? expenseCategories.first.name
            : incomeCategories.isNotEmpty
            ? incomeCategories.first.name
            : '')!;
      });
    } catch (error) {
      print("Error fetching categories: $error");
    }
  }



  Future<void> _addTransaction(double amount, DateTime date, String mainCategory, String subCategory, String description) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String uid = user?.uid ?? '';

      await _firestore.collection('users').doc(uid).collection('transactions').add({
        'amount': amount,
        'date': date,
        'mainCategory': mainCategory,
        'subCategory': subCategory,
        'description': description,
        'timestamp': DateTime.now(),
      });

      Navigator.pop(context);

    } catch (e) {
      print('Error adding transaction: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CategoryList> selectedCategories = isLeftSelected ? expenseCategories : incomeCategories;

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
                          isLeftSelected = true;
                          _selectedCategory = (expenseCategories.isNotEmpty ? expenseCategories.first.name : '')!;
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
                          isLeftSelected = false;
                          _selectedCategory = (incomeCategories.isNotEmpty ? incomeCategories.first.name : '')!;
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
                    height: 12,
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
                  itemCount: expenseCategories.length,
                  itemBuilder: (context, index) {
                    final category = expenseCategories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: CategoryList(
                        imagePath: category.imagePath,
                        name: category.name,
                        isSelected: category.name == _selectedCategory,
                        onSelect: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              _selectedCategory = category.name!;
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
                  itemCount: incomeCategories.length,
                  itemBuilder: (context, index) {
                    final category = incomeCategories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: CategoryList(
                        imagePath: category.imagePath,
                        name: category.name,
                        isSelected: category.name == _selectedCategory,
                        onSelect: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              _selectedCategory = category.name!;
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
                ),
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
                    double amount = double.tryParse(amountController.text) ?? 0.0;
                    String mainCategory = isLeftSelected ? 'Expense' : 'Income';
                    _addTransaction(amount, _selectedDate, mainCategory, _selectedCategory, descriptionController.text);
                  },
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xffFFBF9B),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
