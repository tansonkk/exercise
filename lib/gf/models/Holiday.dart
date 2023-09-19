class Holiday {
  final DateTime date;
  final String name;

  Holiday(this.date, this.name);
}

List<Holiday> getHKHolidaysForYear(int year) {
  final holidays = [
    Holiday(DateTime(year, 1, 1), "新年"), // 新年
    Holiday(DateTime(year, 1, 2), "新年第二天"), // 新年
    Holiday(DateTime(year, 4, 5), "清明"), // 新年
    Holiday(DateTime(year, 5, 1), "勞動"), // 新年
    Holiday(DateTime(year, 7, 1), "HK回归纪念日"), // 新年
    Holiday(DateTime(year, 10, 1), "國慶"), // 新年
    Holiday(DateTime(year, 12, 25), "聖誕"), // 新年
  ];

  return holidays;
}

List<DateTime> getHolidayDates() {
  List<Holiday> holidays = getHKHolidaysForYear(DateTime.now().year);
  List<DateTime> result = holidays.map((e) => e.date).toList();
  return result;
}
