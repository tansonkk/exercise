import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/my_button.dart';
import 'package:flutter_application_2/Shopping/models/Cart_item.dart';
import 'package:flutter_application_2/Shopping/models/Item.dart';
import 'package:flutter_application_2/Shopping/cart_services.dart';
import 'package:provider/provider.dart';

class ItemDetailPage extends StatefulWidget {
  final Item item;
  const ItemDetailPage({super.key, required this.item});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  //quantity
  int quantityCount = 0;

  //decrement quantity
  void decrementQuantity() {
    quantityCount <= 0
        ? setState(() {
            quantityCount = 0;
          })
        : setState(() {
            quantityCount--;
          });
  }

  //increment quantity
  void incrementQuantity() {
    setState(() {
      quantityCount++;
    });
  }

  //add to cart
  void addToCart() {
    final cartModel = Provider.of<CartServices>(context, listen: false);

    final cartItem = CartItem(
        quantity: quantityCount,
        // imagePath: widget.item.imagePath,
        name: widget.item.name,
        price: widget.item.price,
        rating: widget.item.rating,
        description: widget.item.description);

    cartItem.quantity != 0 ? cartModel.addItemToCart(cartItem) : null;
    print(cartModel.cartItemList.length);
    showDialog(
      context: context,
      //cant click outside the box
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Text('${cartItem.name}added into cart!'),
        actions: [
          IconButton(
            onPressed: () {
              // pop once to remove dialog box
              Navigator.pop(context);
              // pop again to go to previous page
              Navigator.pop(context);
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey[900],
      ),
      body: Container(
        child: Column(
          children: [
            //listView of item detail
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: ListView(
                  children: [
                    //image
                    const SizedBox(height: 25),
                    // Image.asset(
                    //   widget.item.imagePath,
                    //   height: 200,
                    // ),
                    //rating
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        //rating star
                        Icon(
                          Icons.star,
                          color: Colors.yellow[800],
                        ),
                        //rating number
                        const SizedBox(height: 25),
                        Text(
                          widget.item.rating,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    //item name
                    const SizedBox(height: 10),
                    Text(widget.item.name),
                    //description
                    const SizedBox(height: 25),
                    Text(
                      "Description",
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(widget.item.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          height: 2,
                        ))
                  ],
                ),
              ),
            ),

            //price + quantity + add to cart button
            const SizedBox(
              height: 25,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              color: const Color.fromARGB(255, 138, 60, 55),
              child: Column(
                children: [
                  //quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //price
                      Text(
                        "\$" + widget.item.price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      //minus button
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(109, 140, 94, 91),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                          onPressed: decrementQuantity,
                        ),
                      ),
                      //quantity count
                      Text(
                        quantityCount < 0 ? "0" : quantityCount.toString(),
                        // quantityCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      //plus button
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(109, 140, 94, 91),
                          // borderRadius: BorderRadius.circular(20),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: incrementQuantity,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    onTap: addToCart,
                    content: "Add to Cart",
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
