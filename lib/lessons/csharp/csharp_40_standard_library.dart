// lib/lessons/csharp/csharp_40_standard_library.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson40 = Lesson(
  language: 'C#',
  title: 'The .NET Standard Library',
  content: '''
🎯 METAPHOR:
The .NET Base Class Library (BCL) is like the fully-stocked
pantry of a professional restaurant. Before you even start
cooking your special dish (your application), the pantry
already has flour, sugar, salt, oil — all the fundamentals.
You do not grow your own wheat or make your own oil.
You use what is already there and focus on your dish.
Knowing what is in the pantry prevents you from
reinventing tools that already exist — and exist better.

📖 EXPLANATION:
The .NET BCL is organized into namespaces. Here is the map.

💻 CODE:
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using System.Linq;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Globalization;

class Program
{
    static async Task Main()
    {
        // ─── MATH ───
        Console.WriteLine(Math.PI);             // 3.14159...
        Console.WriteLine(Math.Abs(-42));        // 42
        Console.WriteLine(Math.Sqrt(144));       // 12
        Console.WriteLine(Math.Pow(2, 10));      // 1024
        Console.WriteLine(Math.Max(5, 10));      // 10
        Console.WriteLine(Math.Floor(3.7));      // 3
        Console.WriteLine(Math.Ceiling(3.2));    // 4
        Console.WriteLine(Math.Round(3.567, 2)); // 3.57
        Console.WriteLine(Math.Log(Math.E));     // 1
        Console.WriteLine(Math.Sin(Math.PI / 2)); // 1

        // ─── DATETIME ───
        var now = DateTime.Now;
        var utc = DateTime.UtcNow;
        var today = DateOnly.FromDateTime(now);   // C# 10+
        var time = TimeOnly.FromDateTime(now);    // C# 10+

        Console.WriteLine(now.ToString("yyyy-MM-dd HH:mm:ss"));
        Console.WriteLine(now.AddDays(7));         // one week later
        Console.WriteLine(now.DayOfWeek);
        Console.WriteLine(now.Month);

        var span = DateTime.Now - DateTime.Now.AddHours(-2);
        Console.WriteLine(span.TotalMinutes);  // 120

        // Parse dates
        DateTime parsed = DateTime.Parse("2024-01-15");
        DateTime exact = DateTime.ParseExact("15/01/2024", "dd/MM/yyyy",
                                              CultureInfo.InvariantCulture);

        // ─── GUID ───
        var id = Guid.NewGuid();
        Console.WriteLine(id);  // e.g., a1b2c3d4-e5f6-...
        Console.WriteLine(Guid.NewGuid().ToString("N"));  // no dashes

        // ─── ENVIRONMENT ───
        Console.WriteLine(Environment.MachineName);
        Console.WriteLine(Environment.UserName);
        Console.WriteLine(Environment.OSVersion);
        Console.WriteLine(Environment.ProcessorCount);
        string home = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);

        // ─── RANDOM ───
        var rng = new Random();
        Console.WriteLine(rng.Next(1, 7));           // dice roll 1-6
        Console.WriteLine(rng.NextDouble());         // 0.0 to 1.0
        int[] shuffled = { 1, 2, 3, 4, 5 };
        Random.Shared.Shuffle(shuffled);             // C# 8, in-place shuffle

        // ─── REGEX ───
        string text = "Contact: alice@example.com or bob@test.org";
        var emailRegex = new Regex(@"[\w.]+@[\w.]+");
        foreach (Match m in emailRegex.Matches(text))
            Console.WriteLine(m.Value);

        bool isEmail = Regex.IsMatch("test@example.com", @"^[\w.]+@[\w.]+\.\w+\$");
        string cleaned = Regex.Replace("Hello   World", @"\s+", " ");

        // ─── JSON ───
        var data = new { Name = "Alice", Age = 30, Scores = new[] { 95, 87 } };
        string json = JsonSerializer.Serialize(data, new JsonSerializerOptions
        {
            WriteIndented = true,
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase
        });
        Console.WriteLine(json);

        // Deserialize
        var obj = JsonSerializer.Deserialize<Dictionary<string, object>>(json);

        // ─── HTTP CLIENT ───
        using var http = new HttpClient();
        http.DefaultRequestHeaders.Add("User-Agent", "MyApp/1.0");

        // GET request
        // var response = await http.GetStringAsync("https://api.example.com/data");
        // var typed = await http.GetFromJsonAsync<MyClass>("https://...");

        // ─── STOPWATCH ───
        var sw = Stopwatch.StartNew();
        // ... do work ...
        for (int i = 0; i < 1_000_000; i++) { var _ = i * i; }
        sw.Stop();
        Console.WriteLine(\$"Elapsed: {sw.ElapsedMilliseconds}ms");

        // ─── STRING MANIPULATION ───
        Console.WriteLine(string.Join(", ", new[] { "a", "b", "c" }));
        Console.WriteLine(string.IsNullOrWhiteSpace("  "));   // True
        Console.WriteLine("hello".PadLeft(10));                // "     hello"
        Console.WriteLine("42".PadLeft(5, '0'));               // "00042"

        // ─── CONVERT AND PARSE ───
        Console.WriteLine(Convert.ToBase64String(new byte[] { 1, 2, 3 }));
        Console.WriteLine(Convert.ToInt32("FF", 16));  // 255 (hex)
        Console.WriteLine(int.Parse("42"));
        Console.WriteLine(double.TryParse("3.14", out double d) ? d : -1);

        // ─── ENCODING ───
        byte[] utf8  = Encoding.UTF8.GetBytes("Hello");
        string back  = Encoding.UTF8.GetString(utf8);
        Console.WriteLine(back);
    }
}

─────────────────────────────────────
KEY NAMESPACES:
─────────────────────────────────────
System                  Math, Console, Environment, Convert
System.Collections.Generic  List, Dictionary, HashSet, Queue
System.Linq             Where, Select, GroupBy, OrderBy
System.Text             StringBuilder, Encoding
System.Text.Json        JsonSerializer
System.Text.RegularExpressions  Regex
System.IO               File, Stream, Path, Directory
System.Net.Http         HttpClient
System.Threading        Thread, Mutex, SemaphoreSlim
System.Threading.Tasks  Task, Parallel, CancellationToken
System.Diagnostics      Stopwatch, Debug, Process
System.Reflection       Assembly, Type, MethodInfo
System.Globalization    CultureInfo, DateTimeFormatInfo
─────────────────────────────────────

📝 KEY POINTS:
✅ HttpClient should be reused (singleton or IHttpClientFactory) — not created per request
✅ Use Random.Shared for thread-safe random without creating instances
✅ DateOnly/TimeOnly (C# 10) are better than DateTime for date/time-only scenarios
✅ Stopwatch is the correct tool for measuring performance
✅ JsonSerializer.Serialize/Deserialize is the modern JSON API — not Json.NET for new code
❌ Don't create new HttpClient for each request — socket exhaustion
❌ Don't use DateTime.Now for UTC timestamps — use DateTime.UtcNow
''',
  quiz: [
    Quiz(question: 'Why should HttpClient be reused instead of creating a new one per request?', options: [
      QuizOption(text: 'Creating many HttpClient instances can exhaust socket connections', correct: true),
      QuizOption(text: 'HttpClient is not thread-safe and must be reused', correct: false),
      QuizOption(text: 'New HttpClient instances cannot reuse cached DNS results', correct: false),
      QuizOption(text: 'HttpClient has a fixed number of total requests it can make', correct: false),
    ]),
    Quiz(question: 'What is the correct way to measure code execution time in C#?', options: [
      QuizOption(text: 'Stopwatch.StartNew() from System.Diagnostics', correct: true),
      QuizOption(text: 'DateTime.Now subtraction', correct: false),
      QuizOption(text: 'Environment.TickCount', correct: false),
      QuizOption(text: 'Console.WriteLine with timestamps', correct: false),
    ]),
    Quiz(question: 'What does Random.Shared provide in modern C#?', options: [
      QuizOption(text: 'A thread-safe shared Random instance — no need to create your own', correct: true),
      QuizOption(text: 'A cryptographically secure random number generator', correct: false),
      QuizOption(text: 'A static method that only works in single-threaded contexts', correct: false),
      QuizOption(text: 'A Random that is seeded with the current timestamp', correct: false),
    ]),
  ],
);
