import 'package:flutter/material.dart';
import 'package:flutter_application_2/Shopping/models/Item.dart';
import 'package:flutter_application_2/Shopping/page/cart_page.dart';
import 'package:flutter_application_2/Shopping/page/itemDetail_page.dart';
import 'package:flutter_application_2/components/my_button.dart';
import '../../components/item_page.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List itemList = [
    Item(
      // imagePath: "R3.jpeg",
      name: "Yamaha R3",
      price: "5680",
      rating: "4.5",
      description:
          "作為Yamaha當家跑車「YZF-R」系列作之一,「YZF-R3」外觀承襲自Yamaha MotoGP廠車 「YZR-M1」,以低風阻的空氣力學設計,並搭配競技感騎士三角和37mm倒立式前叉,擁有易操控特性的同時,也能感受Yamaha Racing DNA.",
    ),
    Item(
      // imagePath: "R7.jpeg",
      name: "Yamaha R7",
      price: "9680",
      rating: "4.7",
      description:
          "「YZF-R7」於去年上市後深得顧客青睞，Yamaha深信在每個人的心中，都潛藏著追求極致操駕、競技感受的「R DNA」。從空氣力學、動力開發至操控體驗，匯聚多項特色的「YZF-R7」，將徹底喚醒您的「R DNA」、釋放操駕潛能。「YZF-R7」承襲R系列的家族化外觀並具有最新世代的正面造型。搭載41mm全可調倒立式前叉與多連桿式後懸吊，強化部分車架結構，使之擁有快速、靈敏的操控反應。搭配以十字曲軸概念開發，且廣受市場好評，代號CP2的689c.c.直列雙缸引擎，提供駕駛者更恣意的加速感受。",
    ),
    Item(
      // imagePath: "RS660.jpeg",
      name: "Aprilia RS660",
      price: "12800",
      rating: "4.8",
      description:
          "Aprilia純種義式中量級跑車RS660，以紮實的用料和優異性能在中排氣量Super Sports市場佔有一席之地。高轉精神雙缸引擎搭配堅固的鋁合金車架、加上倒立前叉、高性能煞車，還有多功能儀錶板等等，整體競技感也是其讓玩家無法抵擋的魅力。",
    ),
  ];

  //navigation to item detail page
  void navigateToItemDetailPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (conetxt) => ItemDetailPage(
          item: itemList[index],
        ),
      ),
    );
  }

  //navigation to cart Page
  void goToCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        elevation: 0,
        title: Text(
          "Menu",
          style: TextStyle(color: Colors.red[900]),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),

          //discount item
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[300],
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const Text("50% OFF !!!"),
                const SizedBox(height: 25),
                MyButton(onTap: () {}, content: "get it now!")
              ],
            ),
          ),
          //searching
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),

          //items scrolling menu
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Food Menu",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  fontSize: 18),
            ),
          ),
          const SizedBox(height: 25),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 25),
              scrollDirection: Axis.horizontal,
              itemCount: itemList.length,
              itemBuilder: (context, index) => ItemPage(
                  item: itemList[index],
                  onTap: () => navigateToItemDetailPage(index)),
            ),
          ),

          //floating button for cartPage
          const SizedBox(height: 25),
          MyButton(
            onTap: goToCartPage,
            content: "Cart Page",
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
