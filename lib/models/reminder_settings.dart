// lib/models/reminder_settings.dart

/// The user's workout reminder choices.
class ReminderSettings {
  const ReminderSettings({
    this.enabled = false,
    this.hour = 19,
    this.minute = 0,
    this.weekdays = const {1, 2, 4, 5, 6},
    this.title = 'Time to work out!',
    this.message = 'Your Pump Chump workout is ready.',
  });

  final bool enabled;

  /// 24-hour clock. 19 means 7 PM.
  final int hour;
  final int minute;

  /// 1 = Monday ... 7 = Sunday (the same numbers as DateTime.weekday).
  final Set<int> weekdays;
  final String title;
  final String message;

  ReminderSettings copyWith({
    bool? enabled,
    int? hour,
    int? minute,
    Set<int>? weekdays,
    String? title,
    String? message,
  }) =>
      ReminderSettings(
        enabled: enabled ?? this.enabled,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        weekdays: weekdays ?? this.weekdays,
        title: title ?? this.title,
        message: message ?? this.message,
      );

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'hour': hour,
        'minute': minute,
        'weekdays': (weekdays.toList()..sort()),
        'title': title,
        'message': message,
      };

  factory ReminderSettings.fromJson(Map<String, dynamic> json) {
    const defaults = ReminderSettings();
    return ReminderSettings(
      enabled: json['enabled'] as bool? ?? defaults.enabled,
      hour: json['hour'] as int? ?? defaults.hour,
      minute: json['minute'] as int? ?? defaults.minute,
      weekdays: (json['weekdays'] as List<dynamic>?)
              ?.map((d) => d as int)
              .toSet() ??
          defaults.weekdays,
      title: json['title'] as String? ?? defaults.title,
      message: json['message'] as String? ?? defaults.message,
    );
  }
}
