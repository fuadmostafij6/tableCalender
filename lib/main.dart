import 'dart:math';

import 'package:cal/EvenModel.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: CalenderEvent(),
    );
  }
}

class CalenderEvent extends StatefulWidget {
  const CalenderEvent({Key? key}) : super(key: key);

  @override
  State<CalenderEvent> createState() => _CalenderEventState();
}

class _CalenderEventState extends State<CalenderEvent> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Event>> selectedEvents = {};
  TextEditingController _eventController = TextEditingController();
  DateTime selectedDay = DateTime.now();
  DateTime focusDay = DateTime.now();
  bool evenDate = false;
  bool show = false;
  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime(1990),
              lastDay: DateTime(2050),
              calendarFormat: calendarFormat,
              onFormatChanged: (CalendarFormat _format) {
                setState(() {
                  calendarFormat = _format;
                });
              },
              startingDayOfWeek: StartingDayOfWeek.sunday,
              daysOfWeekVisible: true,

              //Day Changed
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                setState(() {
                  selectedDay = selectDay;
                  focusDay = focusDay;
                });
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },

              eventLoader: (day) {
                return _getEventsfromDay(day);
              },

              //To style the Calendar
              calendarStyle: const CalendarStyle(
                  markersAlignment: Alignment.bottomCenter,
                  isTodayHighlighted: true,
                  selectedTextStyle: TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(color: Colors.grey),
                  defaultDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  weekendDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.grey)),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                formatButtonTextStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                // markerBuilder: (BuildContext context, date, events) {
                //   if (events.isEmpty) return SizedBox();
                //   return ListView.builder(
                //       shrinkWrap: true,
                //       scrollDirection: Axis.horizontal,
                //       itemCount: events.length,
                //       itemBuilder: (context, index) {
                //         return Container(
                //           margin: const EdgeInsets.only(top: 25),
                //           padding: const EdgeInsets.all(1),
                //           child: Container(
                //             // height: 7,
                //             width: 7,
                //             decoration: const BoxDecoration(
                //                 shape: BoxShape.circle, color: Colors.black),
                //           ),
                //         );
                //       });
                // },
                markerBuilder: (BuildContext context, date, events) {
                  final difference = focusDay.difference(date).inDays;
                  print(difference);
                  if (events.isEmpty) return const SizedBox();
                  return InkWell(
                    onTap: () => setState(() {
                      selectedEvents[date] = [Event(title: "")];
                    }),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListView.builder(
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: events.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 8,
                                    width: 8,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black),
                                  );
                                }),
                          ),
                          Center(
                            child: Text(
                              date.day.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ),
                          ..._getEventsfromDay(date)
                              .map((Event event) => difference > 6
                                  ? Text(
                                      event.title,
                                    )
                                  : const Text("")),
                        ],
                      ),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                    ),
                  );
                },
              ),
            ),
            ..._getEventsfromDay(selectedDay).map(
              (Event event) => ListTile(
                title: Text(
                  event.title,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Add Event"),
            content: TextFormField(
              controller: _eventController,
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("Ok"),
                onPressed: () {
                  if (_eventController.text.isEmpty) {
                  } else {
                    if (selectedEvents[selectedDay] != null) {
                      selectedEvents[selectedDay]?.add(
                        Event(title: _eventController.text),
                      );
                    } else {
                      selectedEvents[selectedDay] = [
                        Event(title: _eventController.text)
                      ];
                    }
                  }
                  Navigator.pop(context);
                  _eventController.clear();
                  setState(() {});
                  return;
                },
              ),
            ],
          ),
        ),
        label: Text("Add Event"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
