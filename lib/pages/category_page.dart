import 'package:flutter/material.dart';
import 'package:spendwise/widget/category_types.dart';

class category extends StatefulWidget {
  @override
  State<category> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<category> {
  bool isExpenseSelected = true;
  List<Map<String, String>> getSelectedList() {
    return isExpenseSelected ? iconDataList : incomeIconDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        // backgroundColor: Colors.blue,
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
                itemCount: getSelectedList().length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: Image.asset(
                        getSelectedList()[index]["imagePath"]!,
                        width: 30,
                        height: 30,
                      ),
                      title: Text(getSelectedList()[index]["name"]!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
