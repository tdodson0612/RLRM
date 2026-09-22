// lib/lessons/csharp/csharp_49_source_generators.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson49 = Lesson(
  language: 'C#',
  title: 'Source Generators and the Roslyn Compiler',
  content: '''
🎯 METAPHOR:
Source generators are like a robot assistant that reads
your blueprints and automatically writes the boring parts.
You write "this class should be serializable" and the
robot writes all the serialization code for you — correctly,
consistently, and without you ever typing it.
It runs AT COMPILE TIME, not runtime, so there is zero
overhead. The generated code is just regular C# that gets
compiled alongside your code. You see it in the IDE.
It is like having an intern who never makes mistakes and
works at compiler speed.

📖 EXPLANATION:
SOURCE GENERATORS (C# 9+):
  - Run during compilation
  - Read your code (syntax trees, symbols)
  - Generate additional C# source files
  - Zero runtime overhead — it's just generated code
  - Used by: System.Text.Json, logging frameworks,
    regex [GeneratedRegex], Dapper, gRPC

ROSLYN — the C# compiler platform:
  - Open source, written in C#
  - Exposes a full API for analyzing and transforming code
  - Powers IDE features, analyzers, and source generators

You do NOT need to write source generators as an
app developer. But you WILL use them constantly:
  [GeneratedRegex]    — compile-time regex
  JsonSerializerContext — compile-time JSON serialization
  LoggerMessage       — compile-time structured logging
  INotifyPropertyChanged generators in MVVM frameworks

💻 CODE:
using System;
using System.Text.RegularExpressions;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.Extensions.Logging;

// ─── GENERATEDREGEX (C# 7, AOT-friendly) ───
partial class EmailValidator
{
    // Source generator creates optimized Regex at compile time
    [GeneratedRegex(@"^[\w.]+@[\w.]+\.\w+\$", RegexOptions.IgnoreCase)]
    private static partial Regex EmailRegex();

    public static bool IsValid(string email) => EmailRegex().IsMatch(email);
}

// ─── JSON SOURCE GENERATION ───
// Instead of runtime reflection, generates serialization code at compile time
[JsonSerializable(typeof(UserDto))]
[JsonSerializable(typeof(OrderDto))]
partial class MyJsonContext : JsonSerializerContext { }

record UserDto(string Name, int Age, string Email);
record OrderDto(int Id, string Item, decimal Price);

// ─── LOGGERMESSAGE SOURCE GENERATOR ───
// Generates high-performance structured logging at compile time
partial class OrderProcessor
{
    private readonly ILogger<OrderProcessor> _logger;

    public OrderProcessor(ILogger<OrderProcessor> logger)
    {
        _logger = logger;
    }

    // [LoggerMessage] generates efficient logging code (no boxing, no allocation)
    [LoggerMessage(EventId = 1001, Level = LogLevel.Information,
                   Message = "Processing order {OrderId} for customer {CustomerId}")]
    partial void LogProcessingOrder(int orderId, int customerId);

    [LoggerMessage(EventId = 1002, Level = LogLevel.Error,
                   Message = "Failed to process order {OrderId}: {Error}")]
    partial void LogOrderFailed(int orderId, string error);

    public void Process(int orderId, int customerId)
    {
        LogProcessingOrder(orderId, customerId);
        // ... processing logic
    }
}

class Program
{
    static void Main()
    {
        // ─── GENERATEDREGEX ───
        Console.WriteLine(EmailValidator.IsValid("alice@example.com")); // True
        Console.WriteLine(EmailValidator.IsValid("not-an-email"));      // False
        Console.WriteLine(EmailValidator.IsValid("test@test.org"));     // True

        // ─── JSON WITH SOURCE GENERATION ───
        var user = new UserDto("Alice", 30, "alice@example.com");

        // Use the generated context — NO reflection at runtime!
        string json = JsonSerializer.Serialize(user, MyJsonContext.Default.UserDto);
        Console.WriteLine(json);  // {"Name":"Alice","Age":30,"Email":"alice@example.com"}

        var back = JsonSerializer.Deserialize(json, MyJsonContext.Default.UserDto);
        Console.WriteLine(back.Name);  // Alice

        var order = new OrderDto(42, "Widget", 9.99m);
        string orderJson = JsonSerializer.Serialize(order, MyJsonContext.Default.OrderDto);
        Console.WriteLine(orderJson);

        // ─── REGULAR REGEX vs GENERATED ───
        // Old way — compiled at runtime, uses reflection
        var runtimeRegex = new Regex(@"^\d{4}-\d{2}-\d{2}\$");
        Console.WriteLine(runtimeRegex.IsMatch("2024-01-15"));  // True

        // New way — generated at compile time, faster, AOT-compatible
        // [GeneratedRegex(@"^\d{4}-\d{2}-\d{2}\$")]
        // private static partial Regex DateRegex();

        // ─── WHAT SOURCE GENERATORS DO INTERNALLY ───
        // They read your [GeneratedRegex("pattern")] attribute
        // and generate something like:
        //
        // private static partial Regex EmailRegex() =>
        //     _emailRegex ??= new Regex(@"...", RegexOptions.Compiled | RegexOptions.IgnoreCase);
        // private static Regex _emailRegex;
        //
        // You never write this — the generator does it.
    }
}

─────────────────────────────────────
COMMON SOURCE GENERATORS IN .NET:
─────────────────────────────────────
[GeneratedRegex]           optimized compile-time regex
JsonSerializerContext      AOT-safe JSON serialization
[LoggerMessage]            zero-allocation structured logging
LibraryImportAttribute     zero-overhead P/Invoke (C# 11)
INotifyPropertyChanged     MVVM boilerplate (community pkgs)
gRPC                       client/server code generation
EF Core scaffolding        model code generation
─────────────────────────────────────

📝 KEY POINTS:
✅ Source generators run at COMPILE time — zero runtime overhead
✅ Generated code is visible in your IDE — you can inspect it
✅ [GeneratedRegex] is always preferred over new Regex() for known patterns
✅ JSON source generation is required for AOT (Ahead of Time) compiled apps
✅ [LoggerMessage] eliminates boxing and string allocations in hot logging paths
❌ You don't need to write source generators as an app developer — just USE them
❌ Source generators cannot modify existing code — they only ADD new code
''',
  quiz: [
    Quiz(question: 'When do source generators run?', options: [
      QuizOption(text: 'At compile time — they generate C# source code before compilation completes', correct: true),
      QuizOption(text: 'At application startup', correct: false),
      QuizOption(text: 'At runtime when the annotated attribute is first encountered', correct: false),
      QuizOption(text: 'During unit test execution only', correct: false),
    ]),
    Quiz(question: 'What is the main advantage of [GeneratedRegex] over new Regex()?', options: [
      QuizOption(text: 'The regex is compiled at build time — faster and compatible with AOT compilation', correct: true),
      QuizOption(text: 'GeneratedRegex supports more regex syntax', correct: false),
      QuizOption(text: 'It automatically caches the regex instance', correct: false),
      QuizOption(text: 'It validates the regex pattern at design time only', correct: false),
    ]),
    Quiz(question: 'Why is JSON source generation (JsonSerializerContext) preferred for AOT apps?', options: [
      QuizOption(text: 'It generates serialization code at compile time, eliminating runtime reflection', correct: true),
      QuizOption(text: 'It compresses the JSON output for smaller file sizes', correct: false),
      QuizOption(text: 'It validates JSON schemas at compile time', correct: false),
      QuizOption(text: 'It is required for all .NET 6+ applications', correct: false),
    ]),
  ],
);
