import 'package:flutter/material.dart';
import 'package:save/constants.dart';

class HomeItem extends StatelessWidget {
  const HomeItem(
      {required this.ontap, super.key, required this.path, required this.data});
  final String path;
  final String data;
  final VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ontap();
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.black12.withOpacity(.05),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: SizedBox(
        width: Rocks.width(context) * .4,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(path, height: 30, width: 30),
                  SizedBox(width: 10),
                  Text(
                    '0',
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0xff111111),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  data,
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    color: Colors.grey[600],
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
