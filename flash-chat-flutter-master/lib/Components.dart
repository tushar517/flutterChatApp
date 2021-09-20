import 'package:flutter/material.dart';
class button extends StatelessWidget {
  button(this.clr,this.title,this.onFunction);
  final Color clr;
  final String title;
  final Function onFunction;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: clr,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onFunction,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}