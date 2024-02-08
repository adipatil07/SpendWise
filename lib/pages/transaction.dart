import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/widget/category_list.dart';

class Transaction extends StatefulWidget {
  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  DateTime? _selectedValue = DateTime.now();
  late String _selectedCategory; // Track the selected category
  final List<Map<String, String>> iconDataList = [
    {"imagePath": "images/icons/clothes.png", "name": "Clothes"},
    {"imagePath": "images/icons/destination.png", "name": "Travel"},
    {"imagePath": "images/icons/sports.png", "name": "Sports"},
    {"imagePath": "images/icons/holiday.png", "name": "Holidays"},
    {"imagePath": "images/icons/shopping.png", "name": "Shopping"},
    {"imagePath": "images/icons/fuel.png", "name": "Fuel"},
    {"imagePath": "images/icons/eating.png", "name": "Eating"},
    // Add more icon data as needed
  ];

  final List<Map<String, String>> incomeIconDataList = [
    {"imagePath": "images/icons/income.png", "name": "Home Income"},
    {"imagePath": "images/icons/salary.png", "name": "Salary"},
    {"imagePath": "images/icons/stock.png", "name": "Stock Market"},

    // Add more icon data as needed
  ];
  bool isLeftSelected = true;
  @override
  void initState() {
    super.initState();
    _selectedCategory =
        iconDataList.first["name"]!; // Default to the first category
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        color: isLeftSelected
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
                          isLeftSelected = false; // Select the right container
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 50,
                        color: isLeftSelected
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
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.03),
              Text("Amount"),
              SizedBox(height: MediaQuery.of(context).size.width * 0.03),
              TextField(
                decoration: InputDecoration(
                    prefixIcon: Image.asset(
                      "images/icons/rs.png",
                      height: 12, // Set the height here as desired
                      width: 12,
                    ),
                    labelText: "Amount",
                    hintText: "Enter amount",
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.03),
              Text("Date"),
              Column(
                children: <Widget>[
                  EasyDateTimeLine(
                    initialDate: DateTime.now(),
                    onDateChange: (selectedDate) {
                      setState(() {
                        _selectedValue = selectedDate;
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
                  )
                ],
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
              Text("Desciption"),
              SizedBox(height: MediaQuery.of(context).size.width * 0.03),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 236, 233, 233),
                  // borderRadius: BorderRadius.circular(10)
                ),
                // padding: const EdgeInsets.all(8.0),
                child: TextField(
                    maxLines: 4, //or null
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter your Description")),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.03),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: GestureDetector(
                  onTap: () {
                    // Add functionality here
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(
                            0xffFFBF9B)), // Set background color to orange
                    child: Center(
                      child: Text(
                        "Add",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
