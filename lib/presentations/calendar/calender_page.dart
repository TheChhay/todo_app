import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/configs/app_colors.dart';
import 'package:todo_app/presentations/home/task_cubit/task_cubit.dart';
// Custom event class to hold completion status
class TaskEvent extends Event {
  final bool isCompleted;
  TaskEvent({
    required DateTime date,
    required String title,
    required this.isCompleted,
    Widget? dot,
  }) : super(date: date, title: title, dot: dot);
}


class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  // Currently selected date on the calendar
  DateTime _currentDate = DateTime.now();
  // Map of dates to events (tasks with reminders)
  EventList<Event> _markedDateMap = EventList<Event>(events: {});
  // Loading state for async fetch
  bool _loading = true;
  // List of events for the selected day
  List<Event> _selectedDayEvents = [];

  @override
  void initState() {
    super.initState();
    // Fetch tasks and mark reminder dates on the calendar
    _fetchAndMarkTasks();
  }

  Future<void> _fetchAndMarkTasks() async {
    // Fetch all tasks from Bloc and build the event map for the calendar
    try {
      final taskCubit = BlocProvider.of<TaskCubit>(context);
      await taskCubit.loadTasks();
      final state = taskCubit.state;
      if (state is TaskLoaded) {
        final tasks = state.tasks;
        // Build a map of dates to events (tasks with reminders)
        final events = <DateTime, List<Event>>{};
        for (final task in tasks) {
          if (task.reminderDate != null) {
            // Only use the year, month, day for grouping (ignore time)
            final date = DateTime(task.reminderDate!.year, task.reminderDate!.month, task.reminderDate!.day);
            // Use TaskEvent to store completion status
            events.putIfAbsent(date, () => []).add(TaskEvent(
              date: date,
              title: task.taskName,
              isCompleted: task.isComplete ?? false,
              dot: Container(width: 6, height: 6, decoration: BoxDecoration(color: AppColor.blue50, shape: BoxShape.circle)),
            ));
          }
        }
        setState(() {
          // Update the calendar's marked dates and the selected day's events
          _markedDateMap = EventList<Event>(events: events);
          _selectedDayEvents = events[_currentDate] ?? [];
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Task'),
        backgroundColor: Colors.indigo.shade700,
        elevation: 0,
      ),
      backgroundColor: Colors.indigo.shade50,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Calendar widget with custom styling and event dots
                    Container(
                      margin: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CalendarCarousel<Event>(
                        onDayPressed: (DateTime date, List<Event> events) {
                          // Update selected date and show its events
                          setState(() {
                            _currentDate = date;
                            _selectedDayEvents = events;
                          });
                        },
                        weekendTextStyle: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                        weekdayTextStyle: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w500,
                        ),
                        todayButtonColor: Colors.indigo.shade200,
                        selectedDayButtonColor: Colors.indigo.shade400,
                        selectedDayBorderColor: Colors.indigo.shade700,
                        todayBorderColor: Colors.indigo.shade400,
                        thisMonthDayBorderColor: Colors.transparent,
                        weekFormat: false,
                        markedDatesMap: _markedDateMap,
                        height: 420.0,
                        selectedDateTime: _currentDate,
                        daysHaveCircularBorder: true,
                        // Custom builder for each day cell: handles event dots and selected day color
                        customDayBuilder: (
                          bool isSelectable,
                          int index,
                          bool isSelectedDay,
                          bool isToday,
                          bool isPrevMonthDay,
                          TextStyle textStyle,
                          bool isNextMonthDay,
                          bool isThisMonthDay,
                          DateTime day,
                        ) {
                          final events = _markedDateMap.getEvents(day);
                          // Check if this day is the selected day
                          final bool selected = _currentDate.year == day.year && _currentDate.month == day.month && _currentDate.day == day.day;
                          // If selected, override text color to white
                          final TextStyle effectiveTextStyle = selected
                              ? textStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold)
                              : textStyle;
                          if (events.isNotEmpty) {
                            // Show event dots under the day number
                            return Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text('${day.day}', style: effectiveTextStyle),
                                  Positioned(
                                    bottom: 4,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: events
                                          .take(3)
                                          .map((e) => Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                                width: 7,
                                                height: 7,
                                                decoration: BoxDecoration(
                                                  color: Colors.indigo.shade400,
                                                  shape: BoxShape.circle,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (selected) {
                            // Highlight selected day even if no events
                            return Center(child: Text('${day.day}', style: effectiveTextStyle));
                          }
                          return null;
                        },
                      ),
                    ),
                    // Card showing tasks for the selected day
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.event, color: Colors.indigo.shade400),
                                  SizedBox(width: 8),
                                  Text(
                                    // Display the selected date in YYYY-MM-DD format
                                    'Tasks on ${_currentDate.year}-${_currentDate.month.toString().padLeft(2, '0')}-${_currentDate.day.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.indigo.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (_selectedDayEvents.isEmpty)
                                // Show message if no tasks for the selected day
                                Text('No tasks for this day.', style: TextStyle(color: AppColor.gray70)),
                              // List all tasks for the selected day
                              // Show checked or unchecked icon based on TaskEvent completion status
                              ..._selectedDayEvents.map((e) => ListTile(
                                    leading: Icon(
                                      (e is TaskEvent && e.isCompleted)
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: AppColor.blue50,
                                    ),
                                    title: Text(e.title ?? '', style: const TextStyle(fontWeight: FontWeight.w500)),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}