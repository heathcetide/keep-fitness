import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../pages/fitness_app/fitness_app_theme.dart';

class CalendarView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const CalendarView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isExpanded = false;

  Widget _buildDayCell(DateTime day) {
    final isSelected = isSameDay(_selectedDay, day);
    final isToday = isSameDay(day, DateTime.now());
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isSelected
            ? FitnessAppTheme.nearlyDarkBlue
            : Colors.transparent,
        border: isToday
            ? Border.all(
                color: FitnessAppTheme.nearlyDarkBlue,
                width: 2,
              )
            : null,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        day.day.toString(),
        style: TextStyle(
          color: isSelected ? Colors.white : FitnessAppTheme.darkerText,
          fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildCollapsedView() {
    return Container(
      height: 44,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final firstDayOfWeek = _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
              return _buildDayCell(firstDayOfWeek.add(Duration(days: index)));
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedView() {
    return Container(
      constraints: BoxConstraints(maxHeight: 300), // 限高
      child: SingleChildScrollView(
        child: TableCalendar(
          daysOfWeekHeight: 32,
          rowHeight: 40,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          calendarBuilders: CalendarBuilders(
            todayBuilder: (context, day, focusedDay) => Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: FitnessAppTheme.nearlyDarkBlue,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                day.day.toString(),
                style: TextStyle(
                  color: FitnessAppTheme.darkerText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            formatButtonDecoration: BoxDecoration(
              color: FitnessAppTheme.nearlyDarkBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            formatButtonTextStyle: TextStyle(color: Colors.white),
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: FitnessAppTheme.nearlyDarkBlue,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
          ),
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (context, child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Container(
              margin: EdgeInsets.all(16),
              constraints: BoxConstraints(
                minHeight: 100,   // 只给个最小高度，允许内部自己变化！
                maxHeight: 400,   // 留足最大空间，比如400
              ),
              decoration: BoxDecoration(
                color: FitnessAppTheme.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: FitnessAppTheme.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(1.1, 1.1),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: FitnessAppTheme.nearlyDarkBlue,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Training Calendar',
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: FitnessAppTheme.darkerText,
                            ),
                          ),
                          Spacer(),
                          Text(
                            DateFormat('MMM yyyy').format(_focusedDay),
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              color: FitnessAppTheme.grey.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedSize(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: ClipRect(  // <<< 加这一层
                      child: AnimatedCrossFade(
                        duration: Duration(milliseconds: 300),
                        crossFadeState: _isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: _buildCollapsedView(),
                        secondChild: _buildExpandedView(),
                        sizeCurve: Curves.easeInOut, // 动画曲线，加了也更自然
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}