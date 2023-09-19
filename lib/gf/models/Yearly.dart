class Yearly {
  String name;
  String description;
  DateTime date;
  Yearly(String this.name, String this.description, DateTime this.date);
}

List<Yearly> anniversary_year(int year) {
  final anniversary = [
    Yearly("HK for Tanson", "yearly", DateTime(year, 9, 30)),
  ];

  return anniversary;
}

List<DateTime> getYearlyDates() {
  List<Yearly> yearEvents = anniversary_year(DateTime.now().year);
  List<DateTime> result = yearEvents.map((e) => e.date).toList();
  return result;
}
