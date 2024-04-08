import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/pages/dashboard.dart';
import 'package:spendwise/pages/transaction_page.dart';
import 'package:spendwise/widget/category_types.dart'; // Import your category types

import 'login.dart';
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> iconDataList = [
  {"imagePath": "images/icons/clothes.png", "name": "Clothes"},
  {"imagePath": "images/icons/destination.png", "name": "Travel"},
  {"imagePath": "images/icons/sports.png", "name": "Sports"},
  {"imagePath": "images/icons/holiday.png", "name": "Holidays"},
  {"imagePath": "images/icons/shopping.png", "name": "Shopping"},
  {"imagePath": "images/icons/fuel.png", "name": "Fuel"},
  {"imagePath": "images/icons/eating.png", "name": "Eating"},
  // Add more icon data as needed
];

final List<Map<String, dynamic>> incomeIconDataList = [
  {"imagePath": "images/icons/income.png", "name": "Home Income"},
  {"imagePath": "images/icons/salary.png", "name": "Salary"},
  {"imagePath": "images/icons/stock.png", "name": "Stock Market"},
];

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}
Future<void> uploadCategoriesToFirestore( List<Map<String, dynamic>> incomeCategories, List<Map<String, dynamic>> expenseCategories) async {
  try {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user?.uid ?? '';

    // Reference to the user's document in Firestore
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);

    // Reference to the income and expense subcollections under the user's document
    CollectionReference incomeCollectionRef = userDocRef.collection('incomeCategories');
    CollectionReference expenseCollectionRef = userDocRef.collection('expenseCategories');

    // Upload income categories
    for (Map<String, dynamic> category in incomeCategories) {
      await incomeCollectionRef.add(category);
    }

    // Upload expense categories
    for (Map<String, dynamic> category in expenseCategories) {
      await expenseCollectionRef.add(category);
    }

    print('Income and expense categories uploaded successfully');
  } catch (e) {
    print('Error uploading categories: $e');
  }
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController cpasscontrolller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  signUp(String email, String pass) async {
    try {
      UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
      print("Registration Succesful");

      // Create user categories after successful registration
      _createUserCategories(userCredential?.user?.uid ?? '');
      uploadCategoriesToFirestore( incomeIconDataList, iconDataList);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } on FirebaseAuthException catch (ex) {}
  }

  Future<void> _createUserCategories(String userId) async {
    try {
      // Upload default categories for the new user
      await FirebaseFirestore.instance.doc(userId).collection('user_categories').add({
        'expense_categories': iconDataList.map((category) => category['name']).toList(),
        'income_categories': incomeIconDataList.map((category) => category['name']).toList(),
      });
      print('User categories created successfully.');
    } catch (e) {
      print('Error creating user categories: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.asset(
              "images/bg4.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // Login form taking 80% of the height, positioned at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height * 0.70,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Join Spend-Wise Today",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "Enter your email",
                          ),
                          validator: (value) {
                            if (value == "") {
                              return 'Email can not be empty';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: passController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Enter your Password",
                          ),
                          validator: (value) {
                            if (value == "") {
                              return 'Password can not be empty';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: cpasscontrolller,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            hintText: "Confirm Your Password",
                          ),
                          validator: (value) {
                            if (value != passController.text.toString()) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              signUp(emailController.text.toString(), passController.text.toString());
                            }
                          },
                          child: SizedBox(
                            width: 100,
                            height: 30,
                            child: Center(
                              child: Text(
                                "Register",
                                style: TextStyle(fontSize: 19),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
