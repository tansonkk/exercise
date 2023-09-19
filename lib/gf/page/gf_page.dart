import 'package:flutter/material.dart';

import '../../components/my_button.dart';

class GF_Page extends StatefulWidget {
  const GF_Page({super.key});

  @override
  State<GF_Page> createState() => _GF_PageState();
}

class _GF_PageState extends State<GF_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(height: 25),
          MyButton(
              onTap: () {
                Navigator.pushNamed(context, '/calendar');
              },
              content: "calendar"),
          const SizedBox(height: 25),
          MyButton(
              onTap: () {
                Navigator.pushNamed(context, '/restaurant');
              },
              content: "restaurant"),
          const SizedBox(height: 25),
          MyButton(
              onTap: () {
                Navigator.pushNamed(context, '/movie');
              },
              content: "movie"),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
