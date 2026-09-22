// lib/lessons/csharp/csharp_42_local_functions.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson42 = Lesson(
  language: 'C#',
  title: 'Local Functions',
  content: '''
🎯 METAPHOR:
A local function is like a tool you build specifically for
one job and keep right next to where you use it.
A named private helper method is like a tool in the main
workshop — available to everyone in the class, searchable,
potentially called from anywhere. A local function is more
like a pocket tool — it lives inside the one method that
uses it, and nobody else can even see it exists.
It has exactly the right scope: visible only where needed.

📖 EXPLANATION:
Local functions (C# 7+) are methods defined INSIDE another
method, constructor, property accessor, or lambda.

WHY LOCAL FUNCTIONS over private methods:
  - Scope: only visible where they are used (less surface area)
  - Can access outer variables without parameters (like lambdas)
  - Appear right next to their usage — better readability
  - Can be recursive (unlike lambdas easily)
  - No heap allocation (unlike lambdas with closures)

WHY LOCAL FUNCTIONS over lambdas:
  - Can be recursive naturally
  - Can have ref/out/params parameters
  - No heap allocation if static
  - Support yield return (iterator local functions)
  - Better stack traces (have actual names)

static local functions (C# 8+):
  - Cannot capture outer variables (explicitly)
  - Zero allocation guarantee
  - Preferred when you don't need outer scope access

💻 CODE:
using System;
using System.Collections.Generic;

class Program
{
    // ─── BASIC LOCAL FUNCTION ───
    static int Fibonacci(int n)
    {
        // Validate once at the outer level
        if (n < 0) throw new ArgumentException("n must be non-negative");

        return Fib(n);  // call local function

        // Local function — only visible inside Fibonacci()
        int Fib(int x)
        {
            if (x <= 1) return x;
            return Fib(x - 1) + Fib(x - 2);  // recursive!
        }
    }

    // ─── LOCAL FUNCTION ACCESSING OUTER VARIABLES ───
    static List<int> FilterAndTransform(List<int> numbers, int threshold)
    {
        var result = new List<int>();

        foreach (int n in numbers)
        {
            if (IsValid(n))
                result.Add(Transform(n));
        }

        return result;

        // Local functions close over outer variables (threshold)
        bool IsValid(int x)   => x > threshold && x < threshold * 10;
        int  Transform(int x) => x * x - threshold;
    }

    // ─── STATIC LOCAL FUNCTION (C# 8+) — no closure, no allocation ───
    static double CalculateDistance(double x1, double y1, double x2, double y2)
    {
        double dx = x2 - x1;
        double dy = y2 - y1;
        return Hypotenuse(dx, dy);

        // static: cannot access outer variables — explicit is safer
        static double Hypotenuse(double a, double b)
            => Math.Sqrt(a * a + b * b);
    }

    // ─── LOCAL FUNCTION WITH YIELD (iterator) ───
    static IEnumerable<int> Range(int start, int end, int step = 1)
    {
        if (step <= 0) throw new ArgumentException("Step must be positive");
        if (start > end) throw new ArgumentException("start must be <= end");

        return Generate();  // return the iterator

        IEnumerable<int> Generate()  // local iterator
        {
            for (int i = start; i <= end; i += step)
                yield return i;
        }
    }

    // ─── GUARD CLAUSE PATTERN WITH LOCAL FUNCTION ───
    static string ProcessData(string input)
    {
        // Validate eagerly (no lazy execution surprises)
        if (string.IsNullOrWhiteSpace(input))
            throw new ArgumentException("Input cannot be empty");

        return Process();

        string Process()
        {
            // Heavy processing here — only called after validation
            return input.Trim().ToUpper().Replace(" ", "_");
        }
    }

    // ─── LOCAL FUNCTION vs LAMBDA COMPARISON ───
    static void ComparisonDemo()
    {
        int[] numbers = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

        // Lambda approach
        Func<int, bool> isEvenLambda = n => n % 2 == 0;

        // Local function approach — recursive, no allocation
        static bool IsEven(int n) => n % 2 == 0;

        // Both work identically here
        Array.FindAll(numbers, n => IsEven(n));

        // Local function can have ref/out — lambda cannot
        static void Increment(ref int x) => x++;

        int val = 5;
        Increment(ref val);
        Console.WriteLine(val);  // 6
    }

    static void Main()
    {
        // Fibonacci
        for (int i = 0; i <= 10; i++)
            Console.Write(Fibonacci(i) + " ");
        Console.WriteLine();  // 0 1 1 2 3 5 8 13 21 34 55

        // Filter and transform
        var nums = new List<int> { 1, 5, 10, 15, 3, 8, 25 };
        var result = FilterAndTransform(nums, 4);
        Console.WriteLine(string.Join(", ", result));

        // Distance
        Console.WriteLine(CalculateDistance(0, 0, 3, 4));  // 5

        // Range iterator
        foreach (int n in Range(0, 20, 3))
            Console.Write(n + " ");  // 0 3 6 9 12 15 18
        Console.WriteLine();

        // Process
        Console.WriteLine(ProcessData("hello world"));  // HELLO_WORLD

        ComparisonDemo();
    }
}

─────────────────────────────────────
LOCAL FUNCTION vs LAMBDA:
─────────────────────────────────────
Feature              Local Function    Lambda
Recursive            ✅ natural        ❌ awkward
ref/out params       ✅                ❌
yield return         ✅                ❌
Stack trace name     ✅                ❌ (anonymous)
Heap allocation      ❌ (static)       ✅ (with capture)
Passed as variable   ❌                ✅
─────────────────────────────────────

📝 KEY POINTS:
✅ Local functions are scoped to the containing method — invisible to the rest of the class
✅ static local functions cannot capture outer variables — prevents accidental closure bugs
✅ Local functions support yield return — use them for lazy iterator helpers
✅ Use local functions for recursive helpers and iterator helpers
✅ Local functions appear in stack traces with real names — easier debugging
❌ Don't make local functions too long — extract to a private method if they grow
❌ Don't use local functions when a lambda would be cleaner and simpler
''',
  quiz: [
    Quiz(question: 'What is the key advantage of a local function over a lambda for recursive algorithms?', options: [
      QuizOption(text: 'Local functions support natural recursion without workarounds', correct: true),
      QuizOption(text: 'Local functions are always faster than lambdas', correct: false),
      QuizOption(text: 'Lambdas cannot be defined inside methods', correct: false),
      QuizOption(text: 'Local functions have access to private class members', correct: false),
    ]),
    Quiz(question: 'What does "static" on a local function guarantee?', options: [
      QuizOption(text: 'It cannot capture outer variables — preventing accidental closures and heap allocations', correct: true),
      QuizOption(text: 'It is shared across all instances of the class', correct: false),
      QuizOption(text: 'It can be called without creating an instance', correct: false),
      QuizOption(text: 'It runs on a background thread', correct: false),
    ]),
    Quiz(question: 'Which feature do local functions support that lambdas do NOT?', options: [
      QuizOption(text: 'yield return for creating iterator sequences', correct: true),
      QuizOption(text: 'Capturing outer variables', correct: false),
      QuizOption(text: 'Being passed as Func<T> parameters', correct: false),
      QuizOption(text: 'Access to public class members', correct: false),
    ]),
  ],
);
