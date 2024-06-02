import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryService {
  static Future<List<List<Map<String, String>>>> getCategories() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user?.uid ?? '';

    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);

    List<Map<String, String>> incomeCategories = [];
    List<Map<String, String>> expenseCategories = [];

    try {
      QuerySnapshot incomeSnapshot = await userDocRef.collection('incomeCategories').get();
      QuerySnapshot expenseSnapshot = await userDocRef.collection('expenseCategories').get();

      incomeCategories = incomeSnapshot.docs.map((doc) => (doc.data() as Map<String, dynamic>).cast<String, String>()).toList();
      expenseCategories = expenseSnapshot.docs.map((doc) => (doc.data() as Map<String, dynamic>).cast<String, String>()).toList();
    } catch (e) {
      print('Error fetching categories: $e');
    }

    return [incomeCategories, expenseCategories];
  }
}
