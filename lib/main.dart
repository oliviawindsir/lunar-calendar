import 'package:flutter/material.dart';
import 'package:tyme/tyme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lunar Calendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late SolarMonth _currentMonth;
  SolarDay? _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = SolarMonth.fromYm(now.year, now.month);
    _selectedDay = SolarDay.fromYmd(now.year, now.month, now.day);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = _currentMonth.next(-1);
      final now = DateTime.now();
      if (_currentMonth.getYear() == now.year &&
          _currentMonth.getMonth() == now.month) {
        // If navigating to current month, select today
        _selectedDay = SolarDay.fromYmd(now.year, now.month, now.day);
      } else {
        // Otherwise select first day of the month
        _selectedDay = _currentMonth.getDays().first;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = _currentMonth.next(1);
      final now = DateTime.now();
      if (_currentMonth.getYear() == now.year &&
          _currentMonth.getMonth() == now.month) {
        // If navigating to current month, select today
        _selectedDay = SolarDay.fromYmd(now.year, now.month, now.day);
      } else {
        // Otherwise select first day of the month
        _selectedDay = _currentMonth.getDays().first;
      }
    });
  }

  void _selectDay(SolarDay day) {
    setState(() {
      _selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lunar Calendar'),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          // Detect swipe direction based on velocity
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! > 0) {
              // Swiped right -> go to previous month
              _previousMonth();
            } else if (details.primaryVelocity! < 0) {
              // Swiped left -> go to next month
              _nextMonth();
            }
          }
        },
        child: Column(
          children: [
            _buildMonthHeader(),
            _buildWeekdayHeader(),
            Expanded(child: _buildCalendarGrid()),
            if (_selectedDay != null) _buildSelectedDayInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthHeader() {
    // Get the lunar month for the current day of the solar month
    final targetDay = _selectedDay ?? _currentMonth.getDays().first;
    final lunarMonth = targetDay.getLunarDay().getMonth();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousMonth,
          ),
          Column(
            children: [
              Text(
                '${_currentMonth.getYear()}年 ${_currentMonth.getMonth()}月',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '农历 $lunarMonth月',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    const weekdays = ['日', '一', '二', '三', '四', '五', '六'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: weekdays.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final days = _currentMonth.getDays();
    final firstDay = days.first;
    final week = firstDay.getWeek();
    final firstDayOfWeek = week.getIndex();

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: firstDayOfWeek + days.length,
      itemBuilder: (context, index) {
        if (index < firstDayOfWeek) {
          return const SizedBox();
        }

        final dayIndex = index - firstDayOfWeek;
        final day = days[dayIndex];
        final lunarDay = day.getLunarDay();
        final isSelected = _selectedDay?.getDay() == day.getDay() &&
            _selectedDay?.getMonth() == day.getMonth() &&
            _selectedDay?.getYear() == day.getYear();
        final isToday = _isToday(day);

        return GestureDetector(
          onTap: () => _selectDay(day),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              border: isToday
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${day.getDay()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  lunarDay.toString().split('月').last,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isToday(SolarDay day) {
    final now = DateTime.now();
    return day.getDay() == now.day &&
        day.getMonth() == now.month &&
        day.getYear() == now.year;
  }

  Widget _buildSelectedDayInfo() {
    if (_selectedDay == null) return const SizedBox();

    final lunarDay = _selectedDay!.getLunarDay();
    final solarTerm = _selectedDay!.getTerm();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '公历: $_selectedDay',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '农历: $lunarDay',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '节气: $solarTerm',
            style: const TextStyle(fontSize: 14, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
