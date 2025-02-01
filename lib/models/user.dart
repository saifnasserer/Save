import 'package:flutter/material.dart';

class User extends StatelessWidget {
  const User({super.key, required this.path});
  final String path;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            height: 200,
            width: 200,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey[300]),
          ),
        ),
        // SvgPicture.asset(
        //   path,
        //   height: 200,
        //   width: 200,
        // ),
        Center(child: Image.asset(path))
      ],
    );
  }
}
