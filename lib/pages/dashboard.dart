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

  @override
  void initState() {
    super.initState();
    fetchCategoryExpenses();
    listenForTransactions();
  }

  Future<void> fetchCategoryExpenses() async {
    try {
      // Get current user's UID
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String uid = user?.uid ?? '';

      // Fetch category-wise expenses from Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .get();

      // Process fetched data
      Map<String, double> categoryAmountMap = {};

// Initialize the map with an empty map
      snapshot.docs.forEach((doc) {
        String category = doc['category'];
        double amount = doc['amount'];
        // Check if the map contains the category
        if (categoryAmountMap.containsKey(category)) {
          // If it does, add the amount to the existing value
          categoryAmountMap[category] = (categoryAmountMap[category] ?? 0) + amount;
        } else {
          // If not, set the amount as the value for the category
          categoryAmountMap[category] = amount;
        }
      });


      // Convert data to CategoryExpense objects
      List<CategoryExpense> expenses = [];
      categoryAmountMap.forEach((category, amount) {
        expenses.add(CategoryExpense(category, amount));
      });

      setState(() {
        categoryExpenses = expenses;
      });
    } catch (e) {
      print('Error fetching category expenses: $e');
    }
  }

  // Listen for changes in the transactions collection
  void listenForTransactions() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user?.uid ?? '';
    _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      // Handle changes in the transactions collection
      updateCategoryExpenses(snapshot);
    });
  }

  // Update category expenses based on the changes in transactions
  void updateCategoryExpenses(QuerySnapshot<Map<String, dynamic>> snapshot) {
    Map<String, double> categoryAmountMap = {};

    // Initialize the map with an empty map
    snapshot.docs.forEach((doc) {
      String category = doc['category'];
      double amount = doc['amount'];
      // Check if the map contains the category
      if (categoryAmountMap.containsKey(category)) {
        // If it does, add the amount to the existing value
        categoryAmountMap[category] =
            (categoryAmountMap[category] ?? 0) + amount;
      } else {
        // If not, set the amount as the value for the category
        categoryAmountMap[category] = amount;
      }
    });

    // Convert data to CategoryExpense objects
    List<CategoryExpense> expenses = [];
    categoryAmountMap.forEach((category, amount) {
      expenses.add(CategoryExpense(category, amount));
    });

    setState(() {
      categoryExpenses = expenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    double income = 1500.0; // Assuming these values are defined somewhere in your code
    double expense = 800.0;

    double availableBalance = income - expense;

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
            categoryExpensesWidget(), // Display category-wise expenses
            SizedBox(height: MediaQuery.of(context).size.width * 0.03),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add your action when the "See All" button is pressed
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => expensePage()));
                    },
                    child: Text("See All"),
                  ),
                ],
              ),
            ),
            // TransactionList(),
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
            // Navigator.push(context,MaterialPageRoute(builder: (context) => Transaction()));
          } else if (index == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => category()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => expensePage()));
          } else if (index == 3) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => transation()));
          } else if (index == 4) {
            // Navigator.push(context,MaterialPageRoute(builder: (context) => Transaction()));
          }
        },
        items: _kPages.entries
            .map(
              (MapEntry<String, IconData> entry) => BottomNavigationBarItem(
            icon: Icon(
              entry.value,
              color: Colors.black, // Change the color of unselected icons
            ),
            activeIcon: Icon(
              entry.value,
              color: Colors.purple, // Change the color of selected icons
            ),
            label:
            entry.key, // Set the text for the BottomNavigationBarItem
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
        // Display each category expense
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
