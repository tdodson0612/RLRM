// lib/lessons/csharp/csharp_29_iterators_yield.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson29 = Lesson(
  language: 'C#',
  title: 'Iterators and yield',
  content: '''
🎯 METAPHOR:
yield is like a vending machine that makes items on demand.
A regular method fills a whole bag with snacks and hands
it all over at once — whether you eat them or not.
A yield method is the vending machine: it makes ONE snack
when you press the button, waits, makes another when you
press again. It never makes tomorrow's snack until you need
it. This is lazy evaluation — compute only what is consumed.
Perfect for infinite sequences, large datasets, or pipelines.

📖 EXPLANATION:
An iterator method uses yield return to produce values
one at a time. The method pauses at each yield and resumes
when the next value is requested.

yield return  — produce the next value, pause execution
yield break   — stop the sequence (like return)

Iterator methods return:
  IEnumerable<T>   — a sequence you can foreach over
  IEnumerator<T>   — used when implementing IEnumerable

The compiler transforms yield methods into a state machine
class behind the scenes. No list is built — values are
generated lazily on demand.

💻 CODE:
using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    // ─── BASIC YIELD ───
    static IEnumerable<int> CountUp(int from, int to)
    {
        for (int i = from; i <= to; i++)
        {
            Console.WriteLine(\$"  (generating {i})");
            yield return i;
        }
    }

    // ─── INFINITE SEQUENCE ───
    static IEnumerable<int> Fibonacci()
    {
        int a = 0, b = 1;
        while (true)
        {
            yield return a;
            (a, b) = (b, a + b);
        }
    }

    // ─── YIELD BREAK ───
    static IEnumerable<int> TakeWhilePositive(IEnumerable<int> source)
    {
        foreach (int n in source)
        {
            if (n < 0) yield break;  // stop the sequence
            yield return n;
        }
    }

    // ─── CUSTOM COLLECTION WITH IEnumerable ───
    static IEnumerable<string> ReadLines(string text)
    {
        foreach (string line in text.Split('\\n'))
        {
            if (!string.IsNullOrWhiteSpace(line))
                yield return line.Trim();
        }
    }

    // ─── PIPELINE WITH YIELD ───
    static IEnumerable<T> Filter<T>(IEnumerable<T> source, Func<T, bool> predicate)
    {
        foreach (var item in source)
            if (predicate(item))
                yield return item;
    }

    static IEnumerable<TResult> Map<T, TResult>(IEnumerable<T> source, Func<T, TResult> selector)
    {
        foreach (var item in source)
            yield return selector(item);
    }

    static void Main()
    {
        // ─── LAZY EVALUATION ───
        Console.WriteLine("Starting iteration:");
        foreach (int n in CountUp(1, 5))
        {
            Console.WriteLine(\$"Got: {n}");
            if (n == 3) break;  // stops early — never generates 4 or 5!
        }
        // Output shows values generated only up to 3

        // ─── INFINITE FIBONACCI ───
        Console.WriteLine("\\nFirst 10 Fibonacci numbers:");
        foreach (int fib in Fibonacci().Take(10))
            Console.Write(fib + " ");
        Console.WriteLine();  // 0 1 1 2 3 5 8 13 21 34

        // ─── YIELD BREAK ───
        var nums = new[] { 3, 1, 4, -1, 5, 9 };
        Console.WriteLine("\\nUntil negative:");
        foreach (int n in TakeWhilePositive(nums))
            Console.Write(n + " ");  // 3 1 4
        Console.WriteLine();

        // ─── TEXT PROCESSING ───
        string text = "  Hello  \\n  World  \\n  \\n  C#  ";
        Console.WriteLine("\\nNon-empty lines:");
        foreach (string line in ReadLines(text))
            Console.WriteLine(\$"  '{line}'");

        // ─── COMPOSING PIPELINES ───
        var numbers = Enumerable.Range(1, 20);
        var result = Map(
            Filter(numbers, n => n % 2 == 0),
            n => n * n
        );
        Console.WriteLine("\\nSquares of evens:");
        foreach (int n in result.Take(5))
            Console.Write(n + " ");  // 4 16 36 64 100
        Console.WriteLine();

        // LINQ is built on the same principle
        var linqResult = Enumerable.Range(1, 20)
            .Where(n => n % 2 == 0)
            .Select(n => n * n)
            .Take(5);
        Console.WriteLine(string.Join(", ", linqResult));

        // ─── MEMORY EFFICIENCY ───
        // This does NOT build a list of 1 million items:
        var bigSequence = Enumerable.Range(1, 1_000_000)
            .Where(n => n % 7 == 0)
            .Select(n => n * 2)
            .Take(5);
        // Only 5 values ever computed!
        Console.WriteLine(string.Join(", ", bigSequence));
    }
}

─────────────────────────────────────
YIELD vs RETURNING A LIST:
─────────────────────────────────────
List approach:   builds entire list, then returns → memory!
yield approach:  produces one item at a time → lazy, efficient

Use yield when:
  - The sequence could be infinite
  - You might stop early (break)
  - The dataset is large
  - You want to pipeline operations
─────────────────────────────────────

📝 KEY POINTS:
✅ yield return produces one value then PAUSES — the method resumes on next request
✅ yield break ends the sequence early
✅ Infinite sequences are possible and safe — only consumed values are generated
✅ LINQ's Where/Select/Take are built on the same lazy evaluation principle
✅ Early break in foreach stops generation — no wasted computation
❌ Don't yield return inside a try/finally with yield — complex edge cases
❌ Don't use yield when you need all values immediately — just return a List
''',
  quiz: [
    Quiz(question: 'What does yield return do in an iterator method?', options: [
      QuizOption(text: 'Produces the next value and pauses the method until the next value is requested', correct: true),
      QuizOption(text: 'Returns all remaining values at once', correct: false),
      QuizOption(text: 'Adds a value to an internal list that is returned at the end', correct: false),
      QuizOption(text: 'Creates a new thread to generate values', correct: false),
    ]),
    Quiz(question: 'Why is using yield more memory-efficient than returning a List?', options: [
      QuizOption(text: 'Values are generated one at a time on demand — no list is allocated in memory', correct: true),
      QuizOption(text: 'yield uses a compressed storage format', correct: false),
      QuizOption(text: 'yield stores values on the stack instead of the heap', correct: false),
      QuizOption(text: 'yield automatically removes duplicates', correct: false),
    ]),
    Quiz(question: 'What does yield break do?', options: [
      QuizOption(text: 'Ends the iterator sequence — no more values will be produced', correct: true),
      QuizOption(text: 'Pauses the iterator until resumed', correct: false),
      QuizOption(text: 'Throws an exception to the caller', correct: false),
      QuizOption(text: 'Resets the iterator to the beginning', correct: false),
    ]),
  ],
);
