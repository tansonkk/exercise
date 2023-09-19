import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/my_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 138, 60, 55),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 25),
            const Text(
              "List",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            //exe List
            const SizedBox(height: 25),
            MyButton(
                onTap: () {
                  Navigator.pushNamed(context, '/chatroom');
                },
                content: "chatroom"),
            const SizedBox(height: 25),
            MyButton(
                onTap: () {
                  Navigator.pushNamed(context, '/cart');
                },
                content: "cart function"),
            const SizedBox(height: 25),
            // googlemapshipping
            MyButton(
                onTap: () {
                  Navigator.pushNamed(context, '/googlemapshipping');
                },
                content: "GoogleMap-Shipping"),
            const SizedBox(height: 25),
            // GF
            MyButton(
                onTap: () {
                  Navigator.pushNamed(context, '/gf');
                },
                content: "GF"),
            const SizedBox(height: 25),
            // MyButton(
            //     onTap: () {
            //       Navigator.pushNamed(context, '/trainingTracker');
            //     },
            //     content: "training tracker")
          ],
        ),
      ),
    );
  }
}
