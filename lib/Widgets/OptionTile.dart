import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OptionTile extends StatelessWidget {
  String? title;
  Widget? next;
  OptionTile({
    Key? key,
    this.title,
    this.next,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => next!,
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(
            this.title!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        elevation: 8,
        shadowColor: Colors.green,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green, width: 1)),
      ),
    );
  }
}
