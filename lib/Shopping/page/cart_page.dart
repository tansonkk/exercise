import 'package:flutter/material.dart';
import 'package:flutter_application_2/Shopping/models/Cart_item.dart';
import 'package:flutter_application_2/Shopping/cart_services.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartServices>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          elevation: 0,
          title: Text(
            "You Cart!!",
            style: TextStyle(color: Colors.red[900]),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: const Column(
                children: [
                  Text(
                    "Item",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text("Name"),
                      SizedBox(width: 35),
                      Text("Quantity"),
                      SizedBox(width: 30),
                      Text("Edit"),
                      SizedBox(width: 40),
                      Text('Amount'),
                      SizedBox(width: 25),
                      Text('Delete'),
                      SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
            value.cartItemList.isEmpty
                ? const Text("No Item")
                : Expanded(
                    child: ListView.builder(
                      itemCount: value.cartItemList.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                const SizedBox(width: 20),
                                Text(value.cartItemList[index].name),
                                const SizedBox(width: 20),
                                Text(value.cartItemList[index].quantity
                                    .toString()),
                                //minus button
                                const SizedBox(width: 25),
                                Container(
                                  height: 35,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(109, 140, 94, 91),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Provider.of<CartServices>(context,
                                              listen: false)
                                          .decrementQuantity(
                                              value.cartItemList[index]);
                                    },
                                  ),
                                ),
                                //plus button
                                Container(
                                  height: 35,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(109, 140, 94, 91),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Provider.of<CartServices>(context,
                                              listen: false)
                                          .incrementItem(
                                              value.cartItemList[index]);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Text("\$${value.cartItemList[index].amount}"),
                                //remove button
                                const SizedBox(width: 10),
                                Container(
                                  height: 45,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(109, 140, 94, 91),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Provider.of<CartServices>(context,
                                              listen: false)
                                          .removeItemFromCart(
                                              value.cartItemList[index]);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(35),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue[400],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "Total Amount",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        "\$${value.totalAmount}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
