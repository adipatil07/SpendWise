import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final String? imagePath;
  final String? name;
  final bool isSelected;
  final Function(bool)? onSelect;

  CategoryList({
    required this.imagePath,
    required this.name,
    required this.isSelected,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onSelect != null) {
          onSelect!(true);
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: isSelected
                ? Color(0xffFFBF9B)
                : Color.fromARGB(255, 236, 233, 233),
            child: ClipOval(
              child: Image.asset(
                imagePath!,
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(name!),
        ],
      ),
    );
  }
}
