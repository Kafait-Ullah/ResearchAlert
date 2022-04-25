import 'package:flutter/material.dart';
import 'package:research_alert/core/services/auth_service.dart';

// ignore: must_be_immutable
class CustomBottomBar extends StatelessWidget {
  AuthService _authService = AuthService();

  final void Function()? onTap;

  CustomBottomBar({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 34, 53, 51),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 125, 126, 122),
              spreadRadius: 3.0,
              blurRadius: 12.0,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_add),
            color: Color.fromARGB(255, 34, 53, 51),
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 30, 127, 166),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_add),
            color: Color.fromARGB(255, 34, 53, 51),
          ),
        ],
      ),
    );
  }
}
