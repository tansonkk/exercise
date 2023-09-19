class Monthly {
  String name;
  String description;
  DateTime date;
  Monthly(String this.name, String this.description, DateTime this.date);
}

List<Monthly> anniversary_mouth(int year) {
  final monthlyWork = [
    Monthly("meeting", "tanson", DateTime(year, 9, 14)),
  ];

  return monthlyWork;
}

List<DateTime> getMonthlyDates() {
  List<Monthly> monthEvents = anniversary_mouth(DateTime.now().year);
  List<DateTime> result = monthEvents.map((e) => e.date).toList();
  return result;
}
