import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InputFieldArea extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String title;

  // ...

  const InputFieldArea({Key key, this.controller, this.obscureText, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // ...
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }
}
