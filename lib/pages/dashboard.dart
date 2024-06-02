import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendwise/pages/category_page.dart';
import 'package:spendwise/pages/transaction_page.dart';
import 'package:spendwise/widget/mydrawer.dart';
import 'expense_page.dart';

const _kPages = <String, IconData>{
  'home': Icons.home,
  'Categories': Icons.category_rounded,
  'Expense': Icons.add,
  'Transaction': Icons.history,
  'people': Icons.people,
};

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CategoryExpense> categoryExpenses = [];
  int _currentPageIndex = 0;
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCategoryExpenses();
    listenForTransactions();
  }

  Future<void> fetchCategoryExpenses() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String uid = user?.uid ?? '';

      DateTime now = DateTime.now();
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
          .where('date', isLessThanOrEqualTo: lastDayOfMonth)
          .get();

      Map<String, double> categoryAmountMap = {};
      double income = 0.0;
      double expense = 0.0;

      snapshot.docs.forEach((doc) {
        String category = doc['subCategory'];
        double amount = doc['amount'] ?? 0.0; // Add a null check here
        String mainCategory = doc['mainCategory']?.toString().toLowerCase() ?? ''; // Add a null check here

        if (mainCategory == 'income') {
          income += amount;
        } else if (mainCategory == 'expense') {
          expense += amount;
        }

        if (categoryAmountMap.containsKey(category)) {
          categoryAmountMap[category] = (categoryAmountMap[category] ?? 0) + amount; // Add a null check here
        } else {
          categoryAmountMap[category] = amount;
        }
      });


      List<CategoryExpense> expenses = [];
      categoryAmountMap.forEach((category, amount) {
        expenses.add(CategoryExpense(category, amount));
      });

      setState(() {
        categoryExpenses = expenses;
        totalIncome = income;
        totalExpense = expense;
      });
    } catch (e) {
      print('Error fetching category expenses: $e');
    }
  }

  void listenForTransactions() {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String uid = user?.uid ?? '';
      _firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        updateCategoryExpenses(snapshot);
      });
    } catch (e) {
      print('Error listening for transactions: $e');
    }
  }

  void updateCategoryExpenses(QuerySnapshot<Map<String, dynamic>> snapshot) {
    try {
      Map<String, double> categoryAmountMap = {};
      double income = 0.0;
      double expense = 0.0;

      snapshot.docs.forEach((doc) {
        String category = doc['subCategory'];
        double amount = doc['amount'];
        String mainCategory = doc['mainCategory']?.toString().toLowerCase() ?? '';

        if (mainCategory == 'income') {
          income += amount;
        } else if (mainCategory == 'expense') {
          expense += amount;
        }

        // Use null-aware operator ?? to provide a default value if the key is not present
        categoryAmountMap[category] = (categoryAmountMap[category] ?? 0) + amount;
      });

      List<CategoryExpense> expenses = [];
      categoryAmountMap.forEach((category, amount) {
        expenses.add(CategoryExpense(category, amount));
      });

      setState(() {
        categoryExpenses = expenses;
        totalIncome = income;
        totalExpense = expense;

        // Update available balance
        double availableBalance = totalIncome - totalExpense;
        // Set the new value of available balance
        // Ensure it's not negative
        availableBalance = availableBalance >= 0 ? availableBalance : 0.0;
        // Update availableBalance variable
        availableBalance = availableBalance;
      });
    } catch (e) {
      print('Error updating category expenses: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    double availableBalance = totalIncome- totalExpense ;
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 255, 0.965),
      appBar: AppBar(
        title: Text(
          "SpendWise",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(35, 26, 14, 0.965),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Daily',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Expenses',
                style: TextStyle(fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                '18 Jan 2024',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(181, 112, 193, 1),
                      Color.fromARGB(183, 255, 132, 175),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Available Balance',
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Text(
                        '\$$availableBalance',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            categoryExpensesWidget(),
            SizedBox(height: MediaQuery.of(context).size.width * 0.03),
          ],
        ),
      ),
      drawer: Drawer(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.965),
          child: MyDrawer()),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
          if (index == 0) {
            // Navigate to home page
          } else if (index == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Category()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ExpensePage()));
          } else if (index == 3) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => transation()));
          } else if (index == 4) {
            // Navigate to people page
          }
        },
        items: _kPages.entries
            .map(
              (MapEntry<String, IconData> entry) => BottomNavigationBarItem(
            icon: Icon(
              entry.value,
              color: Colors.black,
            ),
            activeIcon: Icon(
              entry.value,
              color: Colors.purple,
            ),
            label: entry.key,
          ),
        )
            .toList(),
        selectedIconTheme: IconThemeData(color: Colors.purple),
        unselectedIconTheme: IconThemeData(color: Colors.black),
        selectedItemColor: Colors.purple,
      ),
    );
  }

  Widget categoryExpensesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.width * 0.05),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Category-wise Expenses',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: categoryExpenses.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(categoryExpenses[index].categoryName),
              trailing: Text('\$${categoryExpenses[index].amount.toStringAsFixed(2)}'),
            );
          },
        ),
      ],
    );
  }
}

class CategoryExpense {
  final String categoryName;
  final double amount;

  CategoryExpense(this.categoryName, this.amount);
}
