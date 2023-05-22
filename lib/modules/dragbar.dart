import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DragBar extends StatelessWidget {
  const DragBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        Center(
          child: Container(
            height: 4,
            width: 50,
            color: Colors.grey.shade200,
          ),
        ),
        SizedBox(
          height: 18,
        ),
      ],
    );
  }
}
