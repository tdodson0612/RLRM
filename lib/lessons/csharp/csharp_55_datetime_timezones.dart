// lib/lessons/csharp/csharp_55_datetime_timezones.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson55 = Lesson(
  language: 'C#',
  title: 'DateTime, DateTimeOffset, and TimeZones',
  content: '''
🎯 METAPHOR:
DateTime without a timezone is like writing "3:00 PM"
on a note with no location. Is that 3 PM in Tokyo? New York?
London? It means nothing without context. DateTimeOffset is
like writing "3:00 PM +09:00" — the offset is baked in.
DateTimeOffset is almost always the right choice for
storing times that need to survive timezone changes.

TimeZoneInfo is the world time-zone database.
"Convert 3 PM New York time to Tokyo time" — it knows
about daylight saving, historical timezone changes, everything.

📖 EXPLANATION:
C# has three main date/time types:

DateTime
  - Stores date and time
  - Has a Kind: Unspecified, Local, or UTC
  - Dangerous for timezone conversion — Kind is often wrong

DateTimeOffset
  - Stores date, time, AND UTC offset
  - Always unambiguous
  - Preferred for most scenarios

TimeSpan
  - Duration (not a point in time)
  - Arithmetic result of subtracting DateTimes

DateOnly / TimeOnly (C# 10+)
  - Pure date (no time) or pure time (no date)
  - Cleaner than DateTime for date-only or time-only uses

TimeZoneInfo
  - Convert between time zones
  - Aware of DST (Daylight Saving Time)

💻 CODE:
using System;
using System.Globalization;

class Program
{
    static void Main()
    {
        // ─── DATETIME ───
        var now   = DateTime.Now;       // local time
        var utc   = DateTime.UtcNow;    // always UTC
        var spec  = new DateTime(2024, 3, 15, 14, 30, 0);  // unspecified kind
        var utcDt = new DateTime(2024, 3, 15, 14, 30, 0, DateTimeKind.Utc);

        Console.WriteLine(now.Kind);    // Local
        Console.WriteLine(utc.Kind);    // Utc
        Console.WriteLine(spec.Kind);   // Unspecified

        // DateTime properties
        Console.WriteLine(now.Year);
        Console.WriteLine(now.Month);
        Console.WriteLine(now.Day);
        Console.WriteLine(now.DayOfWeek);
        Console.WriteLine(now.DayOfYear);

        // Arithmetic
        var tomorrow  = now.AddDays(1);
        var nextWeek  = now.AddDays(7);
        var nextMonth = now.AddMonths(1);
        var inAnHour  = now.AddHours(1);

        TimeSpan diff = tomorrow - now;
        Console.WriteLine(diff.TotalHours);  // ~24

        // ─── DATEONLY / TIMEONLY (C# 10+) ───
        DateOnly today     = DateOnly.FromDateTime(now);
        TimeOnly timeNow   = TimeOnly.FromDateTime(now);
        DateOnly birthday  = new DateOnly(1990, 6, 15);
        TimeOnly meeting   = new TimeOnly(14, 30);

        Console.WriteLine(today);      // 2024-03-15
        Console.WriteLine(timeNow);    // 14:30:00
        Console.WriteLine(meeting.ToShortTimeString());  // 2:30 PM

        int age = today.Year - birthday.Year;
        if (today < birthday.AddYears(age)) age--;
        Console.WriteLine(\$"Age: {age}");

        // ─── DATETIMEOFFSET — preferred for real apps ───
        var dto  = DateTimeOffset.UtcNow;
        var dtol = DateTimeOffset.Now;   // local with offset

        var explicit_dto = new DateTimeOffset(2024, 3, 15, 14, 30, 0,
                                               TimeSpan.FromHours(-5)); // EST

        Console.WriteLine(dto);     // 2024-03-15T14:30:00+00:00
        Console.WriteLine(dtol);    // includes local offset
        Console.WriteLine(explicit_dto.Offset);  // -05:00:00

        // Convert to UTC
        DateTimeOffset utcDto = explicit_dto.ToUniversalTime();
        Console.WriteLine(utcDto);  // 2024-03-15T19:30:00+00:00

        // ─── TIMEZONE CONVERSION ───
        TimeZoneInfo easternZone = TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time");
        TimeZoneInfo tokyoZone   = TimeZoneInfo.FindSystemTimeZoneById("Tokyo Standard Time");

        // On Linux/Mac use IANA IDs:
        // TimeZoneInfo.FindSystemTimeZoneById("America/New_York")
        // TimeZoneInfo.FindSystemTimeZoneById("Asia/Tokyo")

        DateTime easternTime = new DateTime(2024, 3, 15, 14, 30, 0, DateTimeKind.Unspecified);
        DateTime tokyoTime   = TimeZoneInfo.ConvertTime(easternTime, easternZone, tokyoZone);
        Console.WriteLine(\$"Eastern: {easternTime}");
        Console.WriteLine(\$"Tokyo:   {tokyoTime}");

        // List all available timezones
        foreach (var tz in TimeZoneInfo.GetSystemTimeZones())
            if (tz.BaseUtcOffset.Hours == 9)
                Console.WriteLine(\$"UTC+9: {tz.Id}");

        // ─── TIMESPAN ───
        TimeSpan duration  = TimeSpan.FromHours(2.5);
        TimeSpan duration2 = new TimeSpan(1, 30, 0);  // 1h 30m
        TimeSpan combined  = duration + duration2;

        Console.WriteLine(duration.TotalMinutes);    // 150
        Console.WriteLine(combined.ToString(@"h\:mm\:ss")); // 4:00:00

        // ─── PARSING ───
        DateTime parsed = DateTime.Parse("2024-03-15");
        DateTime exact  = DateTime.ParseExact("15/03/2024", "dd/MM/yyyy",
                                               CultureInfo.InvariantCulture);
        bool ok = DateTime.TryParse("not a date", out DateTime result);
        Console.WriteLine(ok);  // False

        DateTimeOffset dtoP = DateTimeOffset.Parse("2024-03-15T14:30:00+05:00");
        Console.WriteLine(dtoP.Offset);  // 05:00:00

        // ─── UNIX TIMESTAMPS ───
        long unixSec  = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
        long unixMs   = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
        DateTimeOffset fromUnix = DateTimeOffset.FromUnixTimeSeconds(1710508200);
        Console.WriteLine(unixSec);
        Console.WriteLine(fromUnix);
    }
}

📝 KEY POINTS:
✅ Use DateTimeOffset for any time that involves timezones — not DateTime
✅ Use DateTime.UtcNow (not DateTime.Now) when you need the current UTC time
✅ Use DateOnly when you only care about the date (birthday, event date)
✅ TimeZoneInfo.ConvertTime handles DST transitions correctly
✅ DateTimeOffset.ToUnixTimeSeconds() and FromUnixTimeSeconds() for API interop
❌ Never store DateTime.Now in a database — always use UTC or DateTimeOffset
❌ DateTime.Kind = Unspecified is a trap — always specify Local or Utc
''',
  quiz: [
    Quiz(question: 'Why is DateTimeOffset preferred over DateTime for most applications?', options: [
      QuizOption(text: 'DateTimeOffset always includes the UTC offset — eliminating timezone ambiguity', correct: true),
      QuizOption(text: 'DateTimeOffset is faster to process', correct: false),
      QuizOption(text: 'DateTimeOffset uses less memory', correct: false),
      QuizOption(text: 'DateTime cannot be stored in a database', correct: false),
    ]),
    Quiz(question: 'What does DateOnly represent that DateTime does not?', options: [
      QuizOption(text: 'A pure calendar date with no time component — no timezone confusion', correct: true),
      QuizOption(text: 'A date in a different calendar system', correct: false),
      QuizOption(text: 'A date that is immutable', correct: false),
      QuizOption(text: 'A date with automatic DST adjustment', correct: false),
    ]),
    Quiz(question: 'What is wrong with storing DateTime.Now to a database?', options: [
      QuizOption(text: 'It stores local time with no timezone info — causes errors when reading from different timezones', correct: true),
      QuizOption(text: 'DateTime.Now cannot be serialized to SQL', correct: false),
      QuizOption(text: 'DateTime.Now changes value after being stored', correct: false),
      QuizOption(text: 'DateTime.Now is less precise than DateTimeOffset.Now', correct: false),
    ]),
  ],
);
