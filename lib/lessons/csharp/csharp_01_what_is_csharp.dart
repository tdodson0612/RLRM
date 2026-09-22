// lib/lessons/csharp/csharp_01_what_is_csharp.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson01 = Lesson(
  language: 'C#',
  title: 'What is C#?',
  content: '''
🎯 METAPHOR:
If C++ is a race car — raw power, manual everything, you
can crash at 200mph — then C# is a luxury sports car.
Same speed in real-world use, but the seatbelts fasten
automatically, the airbags deploy themselves, and the GPS
tells you when you're going the wrong way. You still drive,
but the car actively helps you not die.

📖 EXPLANATION:
C# (pronounced "C Sharp") was created by Anders Hejlsberg
at Microsoft and released in 2000 as part of the .NET platform.
It was designed to be safe, modern, and productive — fixing
many of C++ and Java's rough edges while keeping their power.

C# is used for:
  - Windows desktop apps (WPF, WinForms)
  - Web APIs and backends (ASP.NET Core)
  - Game development (Unity — the most popular game engine)
  - Mobile apps (Xamarin, MAUI)
  - Cloud services (Azure)
  - Enterprise software

─────────────────────────────────────
C# KEY CHARACTERISTICS:
─────────────────────────────────────
Managed language   → garbage collector handles memory
Strongly typed     → types checked at compile time
Object-oriented    → everything is in classes
Modern             → LINQ, async/await, records, etc.
Cross-platform     → .NET 6+ runs on Windows, Mac, Linux
─────────────────────────────────────

THE .NET ECOSYSTEM:
  .NET Runtime  → runs your compiled C# code
  CLR           → Common Language Runtime (like a JVM)
  BCL           → Base Class Library (the standard library)
  IL            → Intermediate Language (compiled target, like bytecode)

C# compiles to IL, which the CLR JIT-compiles to native code at runtime.
This is why C# is both fast AND portable.

💻 CODE:
// Every C# program needs a namespace and a class
using System;

namespace HelloWorld
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello, C#!");
        }
    }
}

// C# 9+ Top-level statements (no boilerplate needed):
Console.WriteLine("Hello, C#!");  // that's the whole program!

📝 KEY POINTS:
✅ C# is the primary language for Unity game development
✅ .NET 6+ is cross-platform — not Windows-only anymore
✅ C# has garbage collection — no manual memory management
✅ C# 9+ supports top-level statements — no class/Main boilerplate
✅ New versions release every year — C# 12 is the latest (2023)
❌ C# is NOT the same as C or C++ — completely different languages
❌ .NET Framework (old, Windows-only) vs .NET 6+ (new, cross-platform)
''',
  quiz: [
    Quiz(question: 'Who created C#?', options: [
      QuizOption(text: 'Anders Hejlsberg at Microsoft', correct: true),
      QuizOption(text: 'Bjarne Stroustrup at Bell Labs', correct: false),
      QuizOption(text: 'James Gosling at Sun Microsystems', correct: false),
      QuizOption(text: 'Guido van Rossum at CWI', correct: false),
    ]),
    Quiz(question: 'What is the CLR in .NET?', options: [
      QuizOption(text: 'Common Language Runtime — executes compiled C# code', correct: true),
      QuizOption(text: 'C# Language Reference — the official documentation', correct: false),
      QuizOption(text: 'Compiled Library Repository — stores NuGet packages', correct: false),
      QuizOption(text: 'Cross-platform Language Runtime — only for Linux', correct: false),
    ]),
    Quiz(question: 'What popular game engine uses C# as its scripting language?', options: [
      QuizOption(text: 'Unity', correct: true),
      QuizOption(text: 'Unreal Engine', correct: false),
      QuizOption(text: 'Godot', correct: false),
      QuizOption(text: 'CryEngine', correct: false),
    ]),
  ],
);
