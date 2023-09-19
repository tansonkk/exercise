class Item {
  String name;
  String price;
  String rating;
  String description;

  Item(
      {required this.name,
      required this.price,
      required this.rating,
      required this.description});

  String get _name => name;
  String get _price => price;
  String get _rating => rating;
  String get _description => description;
}
