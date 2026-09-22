// lib/lessons/csharp/csharp_24_tuples_deconstruction.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson24 = Lesson(
  language: 'C#',
  title: 'Tuples and Deconstruction',
  content: '''
🎯 METAPHOR:
A tuple is like a grab bag of values.
When a function needs to return more than one thing,
instead of creating a whole class or using out parameters,
you grab a bag and throw in everything: "here's the result,
the error message, and the count — all in one package."
The caller reaches in and pulls out each item.
Named tuples label the items in the bag so you know
which is which without counting pockets.

📖 EXPLANATION:
Tuples let you group multiple values into one return value
without defining a class. C# 7+ has first-class tuple syntax.

VALUE TUPLES (C# 7+) — these are STRUCTS, copied by value:
  (int, string) pair = (42, "hello");
  (int x, int y) point = (3, 4);  // named elements

DECONSTRUCTION:
  Pulling out tuple values into individual variables.
  Works on tuples, records, and any type with Deconstruct().

WHEN TO USE:
  ✅ Returning multiple values from a private/internal method
  ✅ Temporary grouping of related values
  ❌ Public APIs — use named types (records/classes) for clarity

💻 CODE:
using System;
using System.Collections.Generic;

class Program
{
    // ─── RETURNING A TUPLE ───
    static (bool success, string message, int code) TryOperation(string input)
    {
        if (string.IsNullOrEmpty(input))
            return (false, "Input was empty", 400);

        if (input.Length > 100)
            return (false, "Input too long", 413);

        return (true, "OK", 200);
    }

    // ─── MINMAX IN ONE CALL ───
    static (int min, int max) MinMax(IEnumerable<int> numbers)
    {
        int min = int.MaxValue, max = int.MinValue;
        foreach (int n in numbers)
        {
            if (n < min) min = n;
            if (n > max) max = n;
        }
        return (min, max);
    }

    // ─── SWAP USING TUPLE ───
    static void Swap<T>(ref T a, ref T b) => (a, b) = (b, a);

    static void Main()
    {
        // ─── BASIC TUPLE ───
        (int, string) pair = (42, "hello");
        Console.WriteLine(pair.Item1);  // 42
        Console.WriteLine(pair.Item2);  // hello

        // Named tuple — preferred
        (int x, int y) point = (3, 4);
        Console.WriteLine(\$"({point.x}, {point.y})");  // (3, 4)

        // Infer names from variable names
        int a = 10, b = 20;
        var t = (a, b);     // element names: t.a and t.b
        Console.WriteLine(t.a);  // 10

        // ─── DECONSTRUCTION ───
        var (x, y) = point;
        Console.WriteLine(\$"x={x}, y={y}");  // x=3, y=4

        // Discard with _
        var (success, message, _) = TryOperation("hello");
        Console.WriteLine(\$"{success}: {message}");  // True: OK

        // ─── RETURN TUPLE USAGE ───
        var (s, msg, code) = TryOperation("");
        Console.WriteLine(\$"Success: {s}, Code: {code}");  // Success: False, Code: 400

        var (min, max) = MinMax(new[] { 5, 3, 8, 1, 9 });
        Console.WriteLine(\$"Min: {min}, Max: {max}");  // Min: 1, Max: 9

        // ─── SWAP ───
        int p = 1, q = 2;
        Swap(ref p, ref q);
        Console.WriteLine(\$"p={p}, q={q}");  // p=2, q=1

        // Tuple swap without method
        (p, q) = (q, p);
        Console.WriteLine(\$"p={p}, q={q}");  // back to p=2, q=1... wait
        // (p, q) = (q, p): p=1, q=2

        // ─── NESTED TUPLES ───
        ((int x, int y) start, (int x, int y) end) line = ((0, 0), (10, 10));
        Console.WriteLine(line.start.x);  // 0
        Console.WriteLine(line.end.y);    // 10

        // ─── TUPLE EQUALITY ───
        var t1 = (1, "hello", true);
        var t2 = (1, "hello", true);
        Console.WriteLine(t1 == t2);  // True (value equality)

        // ─── TUPLE IN COLLECTIONS ───
        var people = new List<(string Name, int Age)>
        {
            ("Alice", 30),
            ("Bob",   25),
            ("Charlie", 35)
        };

        foreach (var (name, age) in people)
            Console.WriteLine(\$"{name}: {age}");

        // Sort by age
        people.Sort((x, y) => x.Age.CompareTo(y.Age));

        // ─── DECONSTRUCTING CUSTOM TYPES ───
        // Any class/struct can support deconstruction
    }
}

// Custom type with Deconstruct
class Rectangle
{
    public double Width { get; }
    public double Height { get; }

    public Rectangle(double w, double h) { Width = w; Height = h; }

    // Deconstruct method enables var (w, h) = rect;
    public void Deconstruct(out double width, out double height)
    {
        width = Width;
        height = Height;
    }
}

// Usage: var rect = new Rectangle(4, 6);
//        var (w, h) = rect;   // w=4, h=6

📝 KEY POINTS:
✅ Named tuples are preferred over unnamed ones — use (int x, int y) not (int, int)
✅ Deconstruction with var (a, b) = tuple is clean and readable
✅ Use _ to discard parts of a tuple you don't need
✅ Tuples support == and != for value equality
✅ Any type with a Deconstruct() method supports tuple-style deconstruction
❌ Don't use tuples in public APIs — create named records/classes for clarity
❌ Avoid nesting tuples more than one level deep — it gets unreadable
''',
  quiz: [
    Quiz(question: 'How do you access the elements of an unnamed tuple (int, string)?', options: [
      QuizOption(text: 'Using .Item1 and .Item2', correct: true),
      QuizOption(text: 'Using index [0] and [1]', correct: false),
      QuizOption(text: 'Using .First and .Second', correct: false),
      QuizOption(text: 'Using .Value1 and .Value2', correct: false),
    ]),
    Quiz(question: 'What does the _ (discard) do in deconstruction?', options: [
      QuizOption(text: 'Ignores that part of the tuple — does not create a variable for it', correct: true),
      QuizOption(text: 'Stores the value in a default variable named _', correct: false),
      QuizOption(text: 'Throws if the value is not null', correct: false),
      QuizOption(text: 'Converts the value to a string', correct: false),
    ]),
    Quiz(question: 'What must a class implement to support deconstruction with var (a, b) = obj?', options: [
      QuizOption(text: 'A public void Deconstruct(out T1 a, out T2 b) method', correct: true),
      QuizOption(text: 'The ITuple interface', correct: false),
      QuizOption(text: 'An implicit conversion operator to a tuple', correct: false),
      QuizOption(text: 'The IDeconstructable interface', correct: false),
    ]),
  ],
);
