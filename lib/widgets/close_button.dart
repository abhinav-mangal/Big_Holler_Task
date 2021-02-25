import 'package:flutter/material.dart';

class CloseBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.black38),
          child: InkWell(
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onTap: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }
}
