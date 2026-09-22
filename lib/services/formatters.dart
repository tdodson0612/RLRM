// lib/services/formatters.dart

const List<String> _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Example: "Sep 21, 2026"
String formatDate(DateTime date) =>
    '${_months[date.month - 1]} ${date.day}, ${date.year}';

/// 24-hour input, 12-hour output. Example: (19, 0) -> "7:00 PM"
String formatTime(int hour, int minute) {
  final period = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour % 12 == 0 ? 12 : hour % 12;
  return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
