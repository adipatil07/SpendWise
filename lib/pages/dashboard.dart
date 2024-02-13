import 'package:flutter/material.dart';
import 'package:spendwise/pages/category_page.dart';
import 'package:spendwise/pages/expense_page.dart';
import 'package:spendwise/pages/transaction_page.dart';
import 'package:spendwise/widget/mydrawer.dart';
import 'package:spendwise/widget/transactionList.dart';

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
  final double income = 1500.0;
  final double expense = 800.0;
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
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
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 217, 236, 203),
                          Color.fromARGB(255, 158, 240, 156),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/wallet.png',
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Text(
                            'Income',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            '\$$availableBalance',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  InkWell(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Transaction()))
                    },
                    splashColor: Color.fromARGB(255, 0, 0, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 234, 204, 196),
                            Color.fromARGB(255, 246, 191, 181),
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
                            Image.asset(
                              'images/expenses.png',
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.width * 0.1,
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Text(
                              'Expense',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              '\$$availableBalance',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                              builder: (context) => transation()));
                    },
                    child: Text("See All"),
                  ),
                ],
              ),
            ),
            TransactionList(),
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
                MaterialPageRoute(builder: (context) => Transaction()));
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
}
