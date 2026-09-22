// lib/lessons/csharp/csharp_22_extension_methods.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson22 = Lesson(
  language: 'C#',
  title: 'Extension Methods',
  content: '''
🎯 METAPHOR:
An extension method is like a universal adapter plug.
You can't rewire a hotel's wall socket — it is built in.
But you CAN plug in an adapter that gives it new capabilities.
Extension methods let you "add" new methods to existing types
— even types you don't own like string, int, or List<T> —
without touching their source code. The type gets a new
capability; you didn't change it, you extended it.
This is how LINQ itself works — Where(), Select(), OrderBy()
are all extension methods on IEnumerable<T>.

📖 EXPLANATION:
An extension method is a STATIC method in a STATIC class
that takes "this TypeName parameter" as its first parameter.
It appears to be a method on that type when called.

Rules:
  - Must be in a static class
  - First parameter has "this" keyword
  - Cannot override existing methods
  - Cannot access private members (it's not really inside the class)

💻 CODE:
using System;
using System.Collections.Generic;
using System.Linq;

// ─── EXTENSION METHODS MUST BE IN STATIC CLASS ───
static class StringExtensions
{
    // Extends string
    public static bool IsNullOrEmpty(this string s)
        => string.IsNullOrEmpty(s);

    public static string Truncate(this string s, int maxLength)
    {
        if (s == null || s.Length <= maxLength) return s;
        return s[..maxLength] + "...";
    }

    public static string Repeat(this string s, int times)
        => string.Concat(Enumerable.Repeat(s, times));

    public static bool IsValidEmail(this string s)
        => s?.Contains('@') == true && s.Contains('.');

    public static int WordCount(this string s)
        => s?.Split(' ', StringSplitOptions.RemoveEmptyEntries).Length ?? 0;

    public static string ToTitleCase(this string s)
    {
        if (string.IsNullOrEmpty(s)) return s;
        var words = s.Split(' ');
        for (int i = 0; i < words.Length; i++)
            if (words[i].Length > 0)
                words[i] = char.ToUpper(words[i][0]) + words[i][1..].ToLower();
        return string.Join(' ', words);
    }
}

static class IntExtensions
{
    public static bool IsEven(this int n) => n % 2 == 0;
    public static bool IsOdd(this int n)  => n % 2 != 0;
    public static bool IsBetween(this int n, int min, int max) => n >= min && n <= max;

    public static string Pluralize(this int count, string word)
        => count == 1 ? \$"1 {word}" : \$"{count} {word}s";

    // Loop n times
    public static void Times(this int n, Action action)
    {
        for (int i = 0; i < n; i++) action();
    }
}

static class ListExtensions
{
    // Chunk a list into pages
    public static IEnumerable<List<T>> Chunk<T>(this List<T> list, int size)
    {
        for (int i = 0; i < list.Count; i += size)
            yield return list.GetRange(i, Math.Min(size, list.Count - i));
    }

    public static void ForEach<T>(this IEnumerable<T> source, Action<T> action)
    {
        foreach (var item in source) action(item);
    }
}

// ─── EXTENDING A CUSTOM CLASS WITHOUT MODIFYING IT ───
class User
{
    public string Name { get; set; }
    public string Email { get; set; }
    public DateTime JoinDate { get; set; }
}

static class UserExtensions
{
    public static bool IsNewUser(this User user)
        => (DateTime.Now - user.JoinDate).TotalDays < 30;

    public static string GetDisplayName(this User user)
        => user?.Name ?? user?.Email?.Split('@')[0] ?? "Anonymous";
}

class Program
{
    static void Main()
    {
        // ─── STRING EXTENSIONS ───
        string text = "Hello, World!";
        Console.WriteLine(text.Truncate(7));          // Hello, ...
        Console.WriteLine("ha".Repeat(3));            // hahaha
        Console.WriteLine("alice@example.com".IsValidEmail()); // True
        Console.WriteLine("hello world foo".WordCount()); // 3
        Console.WriteLine("the quick brown fox".ToTitleCase()); // The Quick Brown Fox

        string empty = "";
        Console.WriteLine(empty.IsNullOrEmpty());     // True

        // ─── INT EXTENSIONS ───
        Console.WriteLine(4.IsEven());                // True
        Console.WriteLine(7.IsOdd());                 // True
        Console.WriteLine(5.IsBetween(1, 10));        // True

        Console.WriteLine(3.Pluralize("item"));       // 3 items
        Console.WriteLine(1.Pluralize("item"));       // 1 item

        3.Times(() => Console.Write("Go! "));         // Go! Go! Go!
        Console.WriteLine();

        // ─── LIST EXTENSIONS ───
        var numbers = new List<int> { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
        foreach (var chunk in numbers.Chunk(3))
        {
            Console.WriteLine(string.Join(", ", chunk));
            // 1, 2, 3
            // 4, 5, 6
            // 7, 8, 9
            // 10
        }

        numbers.Where(n => n % 2 == 0)
               .ForEach(n => Console.Write(n + " "));  // 2 4 6 8 10
        Console.WriteLine();

        // ─── USER EXTENSION ───
        var user = new User
        {
            Name = "Alice",
            Email = "alice@example.com",
            JoinDate = DateTime.Now.AddDays(-10)
        };
        Console.WriteLine(user.IsNewUser());           // True
        Console.WriteLine(user.GetDisplayName());      // Alice
    }
}

📝 KEY POINTS:
✅ Extension methods enable adding behavior to types you don't control
✅ They must be in a static class with the "this" prefix on the first parameter
✅ LINQ is entirely built on extension methods to IEnumerable<T>
✅ They show up in IntelliSense as if they were real methods on the type
✅ Great for fluent APIs and making code read like natural language
❌ Extension methods cannot access private members
❌ If a real method with the same name exists, it takes priority
❌ Don't use extension methods to work around bad design — fix the design
''',
  quiz: [
    Quiz(question: 'What is required for a method to be an extension method?', options: [
      QuizOption(text: 'It must be in a static class and its first parameter must have the "this" keyword', correct: true),
      QuizOption(text: 'It must be public and override an existing method', correct: false),
      QuizOption(text: 'It must be defined inside the class it extends', correct: false),
      QuizOption(text: 'It requires the [Extension] attribute', correct: false),
    ]),
    Quiz(question: 'Can extension methods access private members of the extended type?', options: [
      QuizOption(text: 'No — they only have access to public members', correct: true),
      QuizOption(text: 'Yes — they have full access like member methods', correct: false),
      QuizOption(text: 'Only if declared in the same assembly', correct: false),
      QuizOption(text: 'Only if the class is sealed', correct: false),
    ]),
    Quiz(question: 'How is LINQ related to extension methods?', options: [
      QuizOption(text: 'LINQ methods like Where() and Select() are extension methods on IEnumerable<T>', correct: true),
      QuizOption(text: 'LINQ requires extension methods to be disabled', correct: false),
      QuizOption(text: 'LINQ uses extension methods only for custom collections', correct: false),
      QuizOption(text: 'LINQ is unrelated to extension methods', correct: false),
    ]),
  ],
);
