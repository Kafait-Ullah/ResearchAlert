import 'package:flutter/material.dart';

class CustomBottomBarNotes extends StatelessWidget {
  final Function()? boldOnTap;
  final Function()? italicOnTap;
  final Function()? scheduleOnTap;

  const CustomBottomBarNotes({
    this.boldOnTap,
    this.italicOnTap,
    this.scheduleOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.5),
          spreadRadius: 2.0,
          blurRadius: 8.0,
        )
      ]),
      child: Row(
        children: [
          IconButton(
              onPressed: scheduleOnTap,
              icon: const Icon(Icons.schedule_outlined)),
        ],
      ),
    );
  }
}
