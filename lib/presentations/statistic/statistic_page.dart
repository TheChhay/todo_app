import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:todo_app/configs/app_colors.dart';
import 'package:todo_app/presentations/home/task_cubit/task_cubit.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  String _filter = 'Weekly';

  // Returns a list of completed task counts for each weekday (Mon-Sun) for the given tasks.
  // Used for the 'Weekly' filter. Index 0 = Monday, 6 = Sunday.
  List<int> _getCompletedTasksByWeekday(List tasks) {
    final counts = List<int>.filled(7, 0);
    for (final task in tasks) {
      if (task.isComplete == true && task.completedAt != null) {
        final weekday = task.completedAt.weekday % 7;
        counts[weekday == 0 ? 6 : weekday - 1]++;
      }
    }
    return counts;
  }

  // Returns a list of completed task counts for each month (Jan-Dec) in the current year.
  // Used for the 'Monthly' filter. Index 0 = January, 11 = December.
  List<int> _getCompletedTasksByMonth(List tasks) {
    final now = DateTime.now();
    final counts = List<int>.filled(12, 0);
    for (final task in tasks) {
      if (task.isComplete == true && task.completedAt != null && task.completedAt.year == now.year) {
        counts[task.completedAt.month - 1]++;
      }
    }
    return counts;
  }

  // Returns a map of completed task counts for each year with data.
  // Used for the 'Yearly' filter. Key = year, Value = completed count.
  Map<int, int> _getCompletedTasksByYear(List tasks) {
    final Map<int, int> counts = {};
    for (final task in tasks) {
      if (task.isComplete == true && task.completedAt != null) {
        final year = task.completedAt.year;
        counts[year] = (counts[year] ?? 0) + 1;
      }
    }
    return counts;
  }

  // Filters tasks for the current week if 'Weekly' filter is selected.
  // For 'Monthly' and 'Yearly', returns all completed tasks (further filtering is done in chart data methods).
  List _filterTasks(List tasks) {
    final now = DateTime.now();
    if (_filter == 'Weekly') {
      final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
      return tasks.where((t) {
        if (t.completedAt == null) return false;
        final d = t.completedAt;
        return !d.isBefore(firstDayOfWeek) && !d.isAfter(lastDayOfWeek);
      }).toList();
    }
    // For Monthly and Yearly, return all completed tasks (filtering is done in chart data methods)
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistic tasks'),
      ),
      body: Container(
        margin: EdgeInsets.all(16.w),
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            // Prepare chart data and labels based on the selected filter
            // - Weekly: 7 bars for Mon-Sun
            // - Monthly: 12 bars for Jan-Dec (current year)
            // - Yearly: 1 bar per year with completed tasks
            List<double> chartData = [];
            List<String> bottomLabels = [];
            double maxY = 2;
            bool hasData = false;
            if (state is TaskLoaded) {
              final filtered = _filterTasks(state.tasks);
              if (_filter == 'Weekly') {
                // Show completed tasks by weekday for current week
                final counts = _getCompletedTasksByWeekday(filtered);
                chartData = counts.map((e) => e.toDouble()).toList();
                bottomLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                maxY = (chartData.isEmpty || chartData.every((e) => e == 0)) ? 2 : (chartData.reduce((a, b) => a > b ? a : b) + 2);
                hasData = chartData.any((e) => e > 0);
              } else if (_filter == 'Monthly') {
                // Show completed tasks by month for current year
                final counts = _getCompletedTasksByMonth(filtered);
                chartData = counts.map((e) => e.toDouble()).toList();
                bottomLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                maxY = (chartData.isEmpty || chartData.every((e) => e == 0)) ? 2 : (chartData.reduce((a, b) => a > b ? a : b) + 2);
                hasData = chartData.any((e) => e > 0);
              } else if (_filter == 'Yearly') {
                // Show completed tasks by year (all years with data)
                final countsMap = _getCompletedTasksByYear(filtered);
                final years = countsMap.keys.toList()..sort();
                chartData = years.map((y) => countsMap[y]!.toDouble()).toList();
                bottomLabels = years.map((y) => y.toString()).toList();
                maxY = (chartData.isEmpty || chartData.every((e) => e == 0)) ? 2 : (chartData.reduce((a, b) => a > b ? a : b) + 2);
                hasData = chartData.any((e) => e > 0);
              }
            }
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButton<String>(
                      value: _filter,
                      items: const [
                        DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                        DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                        DropdownMenuItem(value: 'Yearly', child: Text('Yearly')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _filter = val);
                      },
                    ),
                  ],
                ),
                // Show chart if there is data, otherwise show empty state
                hasData
                    ? SizedBox(
                        height: 320,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: maxY,
                            minY: 0,
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: AppColor.gray40,
                                strokeWidth: 1,
                              ),
                            ),
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  return BarTooltipItem(
                                    rod.toY.toString(),
                                    TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  );
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 32,
                                  getTitlesWidget: (value, meta) => Text(
                                    value.toInt().toString(),
                                    style: TextStyle(
                                      color: AppColor.gray80,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (_filter == 'Weekly' && value.toInt() >= 0 && value.toInt() < 7) {
                                      return Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          bottomLabels[value.toInt()],
                                          style: TextStyle(
                                            color: AppColor.blue70,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      );
                                    } else if (_filter == 'Monthly' && value.toInt() >= 0 && value.toInt() < 12) {
                                      return Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          bottomLabels[value.toInt()],
                                          style: TextStyle(
                                            color: AppColor.blue70,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      );
                                    } else if (_filter == 'Yearly' && value.toInt() >= 0 && value.toInt() < bottomLabels.length) {
                                      return Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          bottomLabels[value.toInt()],
                                          style: TextStyle(
                                            color: AppColor.blue70,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      );
                                    }
                                    return SizedBox.shrink();
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: List.generate(chartData.length, (i) => BarChartGroupData(
                              x: i,
                              barRods: [BarChartRodData(
                                toY: chartData[i],
                                borderRadius: BorderRadius.circular(6),
                                gradient: LinearGradient(colors: [AppColor.blue50, AppColor.blue70]),
                              )],
                            )),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48.0),
                        child: Column(
                          children: [
                            Icon(Icons.bar_chart, size: 64, color: AppColor.gray40),
                            SizedBox(height: 16),
                            Text(
                              'No completed tasks for this filter.',
                              style: TextStyle(
                                color: AppColor.gray80,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}