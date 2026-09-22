// lib/lessons/csharp/csharp_21_pattern_matching.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson21 = Lesson(
  language: 'C#',
  title: 'Pattern Matching',
  content: '''
🎯 METAPHOR:
Pattern matching is like a sorting machine at a package
facility. Each package rolls down the belt. The machine
checks: "Is it a box over 5kg? Route to heavy freight.
Is it an envelope? Route to mail. Is it fragile? Flag it.
Does it match nothing? Send to overflow." You declare the
PATTERNS you care about, and the machine handles the routing.
C# pattern matching lets you inspect objects and react to
their shape, type, and values in one elegant expression.

📖 EXPLANATION:
Pattern matching in C# (C# 7-11) lets you test an expression
against a pattern and optionally extract values.

PATTERN TYPES:
  Type pattern       obj is string s
  Constant pattern   obj is 42 / obj is null / obj is true
  Var pattern        obj is var x  (always matches, captures value)
  Relational         n is > 0 / n is <= 100
  Logical            n is > 0 and < 100
  Property           obj is { Name: "Alice" }
  Positional         point is (0, 0)
  List patterns      arr is [1, 2, ..]     (C# 11)

💻 CODE:
using System;
using System.Collections.Generic;

record Point(double X, double Y);
record Circle(Point Center, double Radius);
record Rectangle(Point TopLeft, double Width, double Height);

class Program
{
    static void Main()
    {
        // ─── IS PATTERN ───
        object obj = "Hello";
        if (obj is string s)
            Console.WriteLine(\$"String of length {s.Length}");

        // ─── SWITCH EXPRESSION WITH PATTERNS ───
        object[] items = { 42, "hello", 3.14, true, null };
        foreach (var item in items)
        {
            string desc = item switch
            {
                int i    => \$"integer: {i}",
                string s => \$"string: '{s}'",
                double d => \$"double: {d}",
                bool b   => \$"bool: {b}",
                null     => "null",
                _        => "unknown"
            };
            Console.WriteLine(desc);
        }

        // ─── RELATIONAL PATTERNS ───
        int score = 85;
        string grade = score switch
        {
            >= 90 => "A",
            >= 80 => "B",
            >= 70 => "C",
            >= 60 => "D",
            _     => "F"
        };
        Console.WriteLine(grade);  // B

        // ─── LOGICAL PATTERNS (and, or, not) ───
        int temp = 72;
        string weather = temp switch
        {
            < 32            => "freezing",
            >= 32 and < 60  => "cold",
            >= 60 and < 80  => "comfortable",
            >= 80 and < 95  => "hot",
            _               => "extreme"
        };
        Console.WriteLine(weather);  // comfortable

        // "not" pattern
        object value = 42;
        if (value is not string)
            Console.WriteLine("Not a string");

        // ─── PROPERTY PATTERNS ───
        var alice = new { Name = "Alice", Age = 30, IsAdmin = true };
        string role = alice switch
        {
            { IsAdmin: true }  => "Administrator",
            { Age: >= 18 }     => "Adult user",
            _                  => "Regular user"
        };
        Console.WriteLine(role);  // Administrator

        // Nested property pattern
        var point = new Point(0, 0);
        string location = point switch
        {
            { X: 0, Y: 0 }  => "Origin",
            { X: 0 }        => "On Y-axis",
            { Y: 0 }        => "On X-axis",
            _               => "General position"
        };
        Console.WriteLine(location);  // Origin

        // ─── POSITIONAL PATTERNS ───
        Point p = new(3, 4);
        string quadrant = p switch
        {
            (0, 0)             => "Origin",
            ( > 0, > 0)        => "First quadrant",
            ( < 0, > 0)        => "Second quadrant",
            ( < 0, < 0)        => "Third quadrant",
            ( > 0, < 0)        => "Fourth quadrant",
            _                  => "On an axis"
        };
        Console.WriteLine(quadrant);  // First quadrant

        // ─── TYPE PATTERNS WITH PROPERTIES ───
        object shape = new Circle(new Point(0, 0), 5);
        string shapeInfo = shape switch
        {
            Circle { Radius: > 10 } c     => \$"Large circle r={c.Radius}",
            Circle c                       => \$"Circle r={c.Radius}",
            Rectangle { Width: var w, Height: var h } r => \$"Rect {w}x{h}",
            _                              => "Unknown shape"
        };
        Console.WriteLine(shapeInfo);  // Circle r=5

        // ─── LIST PATTERNS (C# 11) ───
        int[] nums = { 1, 2, 3, 4, 5 };
        string desc2 = nums switch
        {
            []              => "empty",
            [var single]    => \$"one element: {single}",
            [var first, ..]  => \$"starts with {first}",
            _               => "other"
        };
        Console.WriteLine(desc2);  // starts with 1
    }
}

📝 KEY POINTS:
✅ Pattern matching is more powerful and readable than chains of if/else
✅ and, or, not work directly in patterns — no parentheses needed
✅ Property patterns check specific properties without full type cast
✅ Positional patterns work with records and types with Deconstruct
✅ _ is the discard — matches anything, captures nothing
❌ Order matters in switch expressions — first matching pattern wins
❌ Don't use var pattern unless you genuinely need the captured value
''',
  quiz: [
    Quiz(question: 'What does the pattern ">= 80 and < 90" check?', options: [
      QuizOption(text: 'The value is at least 80 AND less than 90', correct: true),
      QuizOption(text: 'The value is between 80 and 90 exclusive', correct: false),
      QuizOption(text: 'A logical OR between two conditions', correct: false),
      QuizOption(text: 'A compile error — and is not valid in patterns', correct: false),
    ]),
    Quiz(question: 'What does a property pattern like { Name: "Alice" } check?', options: [
      QuizOption(text: 'The object has a Name property equal to "Alice"', correct: true),
      QuizOption(text: 'The object is named Alice', correct: false),
      QuizOption(text: 'The object is of type Alice', correct: false),
      QuizOption(text: 'The Name property is not null', correct: false),
    ]),
    Quiz(question: 'What does the _ pattern mean in a switch expression?', options: [
      QuizOption(text: 'The default case — matches anything not matched by previous patterns', correct: true),
      QuizOption(text: 'A null check', correct: false),
      QuizOption(text: 'An empty value pattern', correct: false),
      QuizOption(text: 'A wildcard that captures the value as a variable', correct: false),
    ]),
  ],
);
