import 'package:flutter/material.dart';
import 'package:flutter_application_2/gf/models/Holiday.dart';
import 'package:flutter_application_2/gf/models/Mouthly.dart';
import 'package:flutter_application_2/gf/models/Weekly.dart';
import 'package:flutter_application_2/gf/models/Yearly.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../components/my_button.dart';
import '../models/Event.dart';
import '../models/datatype.dart';

class Calendar_Page extends StatefulWidget {
  const Calendar_Page({super.key});

  @override
  State<Calendar_Page> createState() => _Calendar_PageState();
}

class _Calendar_PageState extends State<Calendar_Page> {
  // final calendar_service service = calendar_service();

  RepeatOption? _selectedRepeatOption;
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Holiday> holidays = getHKHolidaysForYear(DateTime.now().year);
  List<DateTime> holidayDate = getHolidayDates();
  List<Yearly> yearEvents = anniversary_year(DateTime.now().year);
  List<DateTime> yearEventDate = getYearlyDates();
  List<Monthly> monthEvent = anniversary_mouth(DateTime.now().year);
  List<DateTime> monthEventDate = getMonthlyDates();

  List<DateTime> weekEvents = anniversary_week();

  bool enableRangeSelection = false;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  Map<DateTime, List<Event>> event = {};
  late final ValueNotifier<List<Event>> _selectedEvents;

  List<Event> _getEventForDay(DateTime day) {
    for (Yearly yearlyEvent in yearEvents) {
      // print('day month ${day.month} day day ${day.day}');
      // print(
      //     'event date  month ${yearlyEvent.date.month} day ${yearlyEvent.date.day}');

      if ((day.day == yearlyEvent.date.month) &&
          (day.month == yearlyEvent.date.day)) {
        return [Event('Cyclic event', "event cyc")];
      }
    }
    if (day.day == _selectedDay.day) {
      return event[day] ?? [];
    }
    return event[day] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier(_getEventForDay(_selectedDay));
    _selectedDay = DateTime.now();
    int year = DateTime.now().year;
    holidays = getHKHolidaysForYear(year);
  }

  void _onDaySelected(DateTime? day, DateTime? focusedDay) {
    // print("day" + day.toString());
    // print("focus day" + focusedDay.toString());
    setState(() {
      if (day != null) {
        _selectedDay = day;
        _selectedEvents.value = _getEventForDay(day);
      }
    });
  }

  void _onRangesSelected(DateTime? start, DateTime? end, DateTime? focusedDay) {
    setState(() {
      _rangeEnd = end;
      _rangeStart = start;
    });
  }

  void _switchSelectMode() {
    setState(() {
      if (enableRangeSelection) {
        _onRangesSelected(null, null, null);
      } else {
        _selectedDay = DateTime.now();
      }
      enableRangeSelection = !enableRangeSelection;
    });
  }

  void _addEventForDay(String eventName, String eventDescription) {
    List<Event> dayEvents = event[_selectedDay] ?? [];
    dayEvents.add(Event(eventName, eventDescription));
    event[_selectedDay] = dayEvents;
    setState(() {});
  }

  void _addRepeatedEvent(
      String eventName, String eventDescription, RepeatOption duration) {
    _addEventForDay(eventName, eventDescription);
    if (duration == RepeatOption.year) {
      yearEvents.add(Yearly(eventName, eventDescription, _selectedDay));
    } else if (duration == RepeatOption.month) {
      monthEvent.add(Monthly(eventName, eventDescription, _selectedDay));
      monthEventDate.add(_selectedDay);
    } else if (duration == RepeatOption.week) {
      weekEvents.add(DateTime(_selectedDay.weekday));
    }
    setState(() {
      _selectedRepeatOption = null;
    });
  }

  void _addEventForDateRange(
      DateTime start, DateTime end, String eventName, String eventDescription) {
    if (_rangeStart != null && _rangeEnd != null) {
      for (var day = start;
          day.isBefore(end);
          day = day.add(const Duration(days: 1))) {
        // Get existing list of events
        List<Event> dayEvents = event[day] ?? [];

        // Add new event
        dayEvents.add(Event(eventName, eventDescription));

        // Update map
        event[day] = dayEvents;
      }
    }
    setState(() {});
  }

  void showEventDialog(
      BuildContext context, Event event, List<Event> eventsList) {
    TextEditingController titleController =
        TextEditingController(text: event.title);
    TextEditingController descriptionController =
        TextEditingController(text: event.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Event Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                event.title = titleController.text;
                event.description = descriptionController.text;
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                eventsList.remove(event);
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                // Close the dialog without saving any changes
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Table Calendar"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                title: const Text("Event adding"),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: _eventController,
                          decoration:
                              const InputDecoration(labelText: "Event name"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: 1, // Adjust the number of lines as needed
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              children: [
                                ListTile(
                                  title: const Text('Repeat every year'),
                                  leading: Radio<RepeatOption>(
                                    value: RepeatOption.year,
                                    groupValue: _selectedRepeatOption,
                                    onChanged: (RepeatOption? value) {
                                      setState(() {
                                        _selectedRepeatOption =
                                            value != _selectedRepeatOption
                                                ? value
                                                : null;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text('Repeat every week'),
                                  leading: Radio<RepeatOption>(
                                    value: RepeatOption.week,
                                    groupValue: _selectedRepeatOption,
                                    onChanged: (RepeatOption? value) {
                                      setState(() {
                                        _selectedRepeatOption =
                                            value != _selectedRepeatOption
                                                ? value
                                                : null;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text('Repeat every month'),
                                  leading: Radio<RepeatOption>(
                                    value: RepeatOption.month,
                                    groupValue: _selectedRepeatOption,
                                    onChanged: (RepeatOption? value) {
                                      setState(() {
                                        _selectedRepeatOption =
                                            value != _selectedRepeatOption
                                                ? value
                                                : null;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        if (!enableRangeSelection) {
                          // print(enableRangeSelection);
                          if (_selectedRepeatOption != null) {
                            _addRepeatedEvent(
                                _eventController.text,
                                _descriptionController.text,
                                _selectedRepeatOption!);
                          } else {
                            _addEventForDay(_eventController.text,
                                _descriptionController.text);
                          }
                        } else {
                          if (_rangeStart != null && _rangeEnd != null) {
                            // print(enableRangeSelection);
                            _addEventForDateRange(
                                _rangeStart!,
                                _rangeEnd!,
                                _eventController.text,
                                _descriptionController.text);
                          }
                        }
                        Navigator.of(context).pop();
                        _selectedEvents.value = _getEventForDay(_selectedDay);
                      },
                      child: const Text("Submit"))
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MyButton(
                onTap: _switchSelectMode,
                content: !enableRangeSelection ? "single day" : "date range",
              ),
            ),
            TableCalendar(
              locale: "en_US",
              rowHeight: 43,
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              focusedDay: _selectedDay,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              rangeSelectionMode: enableRangeSelection
                  ? RangeSelectionMode.toggledOn
                  : RangeSelectionMode.disabled,
              onRangeSelected: _onRangesSelected,
              onDaySelected: _onDaySelected,
              eventLoader: _getEventForDay,
              calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  holidayDecoration: BoxDecoration(
                      border: Border.fromBorderSide(BorderSide(
                          color: Color.fromARGB(255, 226, 66, 68), width: 1.4)),
                      shape: BoxShape.circle),
                  holidayTextStyle:
                      TextStyle(color: Color.fromARGB(255, 226, 66, 68))),
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _selectedDay = focusedDay;
              },
              holidayPredicate: (day) {
                for (DateTime holiday in holidayDate) {
                  if (day.month == holiday.month && day.day == holiday.day) {
                    // _addEventForDay("holiday", "hod");
                    EventType.holiday;
                    return true;
                  }
                }
                for (DateTime yearEvent in yearEventDate) {
                  if (day.month == yearEvent.month &&
                      day.day == yearEvent.day) {
                    EventType.yearEvent;
                    return true;
                  }
                }
                for (DateTime monthEvent in monthEventDate) {
                  if (day.day == monthEvent.day) {
                    EventType.monthEvent;
                    return true;
                  }
                }
                for (DateTime weekEvent in weekEvents) {
                  if (day.weekday == weekEvent.weekday) {
                    EventType.weekEvent;
                    return true;
                  }
                }
                if (day.weekday > 6) {
                  return true;
                }
                return false;
                // return day.weekday > 6;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                  'Selected Day : ${_selectedDay.toString().split(" ")[0]}'),
            ),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              onTap: () {
                                showEventDialog(context, value[index],
                                    _selectedEvents.value);
                              },
                              title: Text(value[index].title),
                            ),
                          );
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
