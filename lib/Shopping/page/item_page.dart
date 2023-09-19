import 'package:flutter/material.dart';
import 'package:flutter_application_2/Shopping/models/Item.dart';

class ItemPage extends StatelessWidget {
  final Item item;
  final void Function()? onTap;

  const ItemPage({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.only(left: 25),
        padding: const EdgeInsets.all(25),
        child: Column(children: [
          Text(
            item.name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                fontSize: 18),
          ),
          //price + rating
          SizedBox(
            width: 160,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //price
                  Text('\$' + item.price),
                  //rating as star
                  Icon(
                    Icons.star,
                    color: Colors.yellow[800],
                  ),
                  // rating as number
                  Text(item.rating),
                ]),
          )
        ]),
      ),
    );
  }
}
