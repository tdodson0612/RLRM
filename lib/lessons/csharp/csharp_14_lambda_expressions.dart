// lib/lessons/csharp/csharp_14_lambda_expressions.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson14 = Lesson(
  language: 'C#',
  title: 'Lambda Expressions',
  content: '''
🎯 METAPHOR:
A lambda is like a one-time instruction note.
A regular method is a framed manual on the wall — named,
permanent, referenced by title. A lambda is a sticky note
you write right now for one specific task: "take x,
give back x times two." You use it once, inline, right
where you need it. No name, no manual, no shelf space.
Perfect for short, single-use logic passed to LINQ, events,
or any method expecting a delegate.

📖 EXPLANATION:
Lambdas are anonymous methods written inline.
They are the cornerstone of modern C# — LINQ runs on them,
events use them, async callbacks use them.

SYNTAX:
  (parameters) => expression           // expression lambda
  (parameters) => { statements; }      // statement lambda
  parameter => expression              // single param, no parens needed

CLOSURES:
  Lambdas can "capture" variables from the surrounding scope.
  The lambda keeps a reference to those variables — they
  stay alive as long as the lambda does.

💻 CODE:
using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static void Main()
    {
        // ─── BASIC LAMBDAS ───
        Func<int, int> square = x => x * x;
        Console.WriteLine(square(5));  // 25

        Func<int, int, int> add = (a, b) => a + b;
        Console.WriteLine(add(3, 4));  // 7

        Action<string> greet = name => Console.WriteLine(\$"Hello, {name}!");
        greet("Alice");

        Predicate<int> isEven = n => n % 2 == 0;
        Console.WriteLine(isEven(4));  // True

        // Statement lambda (multiple lines)
        Func<int, string> classify = n =>
        {
            if (n < 0) return "negative";
            if (n == 0) return "zero";
            if (n < 10) return "small";
            return "large";
        };
        Console.WriteLine(classify(-5));   // negative
        Console.WriteLine(classify(100));  // large

        // ─── LAMBDAS WITH LINQ ───
        var numbers = new List<int> { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

        var evens   = numbers.Where(n => n % 2 == 0);
        var doubled = numbers.Select(n => n * 2);
        var sum     = numbers.Aggregate(0, (acc, n) => acc + n);

        Console.WriteLine(string.Join(", ", evens));    // 2, 4, 6, 8, 10
        Console.WriteLine(string.Join(", ", doubled));  // 2, 4, 6, ...
        Console.WriteLine(sum);                         // 55

        // ─── CLOSURES ───
        // Lambdas capture variables by REFERENCE
        int multiplier = 3;
        Func<int, int> times = x => x * multiplier;

        Console.WriteLine(times(5));  // 15
        multiplier = 10;
        Console.WriteLine(times(5));  // 50 — lambda sees the UPDATED value!

        // Closure gotcha in loops — capture loop variable
        var actions = new List<Action>();
        for (int i = 0; i < 3; i++)
        {
            int captured = i;  // create a copy each iteration
            actions.Add(() => Console.WriteLine(captured));
        }
        foreach (var a in actions) a();  // 0, 1, 2 (correct!)

        // Without 'captured': all would print 3 (the final i value)

        // ─── IMMEDIATELY INVOKED LAMBDA ───
        int result = ((Func<int, int>)(x => x * x))(7);
        Console.WriteLine(result);  // 49

        // ─── LAMBDA AS EVENT HANDLER ───
        var button = new System.Timers.Timer(1000);
        button.Elapsed += (sender, e) => Console.WriteLine("Tick!");
        // button.Start(); // would fire every second

        // ─── GENERIC LAMBDA (C# 10+) ───
        // var identity = <T>(T x) => x;  // C# 10 generic lambda

        // ─── CUSTOM SORT WITH LAMBDA ───
        var people = new List<(string Name, int Age)>
        {
            ("Alice", 30), ("Bob", 25), ("Charlie", 35)
        };

        people.Sort((a, b) => a.Age.CompareTo(b.Age));
        foreach (var (name, age) in people)
            Console.WriteLine(\$"{name}: {age}");
        // Bob: 25, Alice: 30, Charlie: 35
    }
}

─────────────────────────────────────
EXPRESSION vs STATEMENT LAMBDA:
─────────────────────────────────────
Expression: x => x * x           (returns the expression value)
Statement:  x => { return x * x; }  (explicit return in braces)
Both are equivalent — expression is preferred when possible
─────────────────────────────────────

📝 KEY POINTS:
✅ Lambdas are the syntax for passing anonymous functions inline
✅ Closures capture variables by reference — changes to captured vars affect the lambda
✅ In loops, create a local copy of the loop variable to capture correctly
✅ Expression lambdas are cleaner — use statement lambdas only when needed
✅ Lambdas are the foundation of LINQ, events, and async callbacks
❌ Don't capture variables that will be null or disposed before the lambda runs
❌ Avoid complex logic in lambdas — extract to a named method for readability
''',
  quiz: [
    Quiz(question: 'What does a closure mean in the context of C# lambdas?', options: [
      QuizOption(text: 'The lambda captures and holds a reference to variables from its surrounding scope', correct: true),
      QuizOption(text: 'The lambda is sealed and cannot be reassigned', correct: false),
      QuizOption(text: 'The lambda runs in a closed (isolated) scope with no outside access', correct: false),
      QuizOption(text: 'The lambda automatically disposes resources when done', correct: false),
    ]),
    Quiz(question: 'What is the syntax for a single-parameter expression lambda?', options: [
      QuizOption(text: 'x => x * x', correct: true),
      QuizOption(text: 'lambda x: x * x', correct: false),
      QuizOption(text: '(x) { return x * x; }', correct: false),
      QuizOption(text: 'x -> x * x', correct: false),
    ]),
    Quiz(question: 'Why should you create a local copy of a loop variable when capturing it in a lambda?', options: [
      QuizOption(text: 'Because all lambdas would otherwise capture the same final value of the loop variable', correct: true),
      QuizOption(text: 'To prevent the lambda from modifying the loop counter', correct: false),
      QuizOption(text: 'Because lambdas cannot access loop variables directly', correct: false),
      QuizOption(text: 'For performance — local copies are faster to access', correct: false),
    ]),
  ],
);
