// lib/lessons/csharp/csharp_13_delegates_events.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson13 = Lesson(
  language: 'C#',
  title: 'Delegates and Events',
  content: '''
🎯 METAPHOR:
A delegate is like a job posting for a specific role.
"Wanted: someone who takes two ints and returns a bool."
Whoever meets that description (has matching parameters
and return type) can be hired. Multiple people can hold
the job at once (multicast). The employer doesn't care
WHO they hired — just that they can do the job.

An event is like a notification subscription.
A button (publisher) doesn't know or care who is listening.
Whoever subscribes (handler) gets notified when the event
fires. The button just fires — subscribers react.
This is the foundation of GUI programming and reactive code.

📖 EXPLANATION:
DELEGATE — a type-safe function pointer.
  Defines a method signature. Variables of that type
  can hold any method matching the signature.

BUILT-IN DELEGATE TYPES (use these instead of custom):
  Action<T>        — takes params, returns void
  Func<T, TResult> — takes params, returns a value
  Predicate<T>     — takes T, returns bool

EVENT — a delegate that can only be fired by its owner.
  Subscribers can += and -= but cannot invoke directly.
  The publisher class controls when it fires.

💻 CODE:
using System;

// ─── CUSTOM DELEGATE ───
delegate int MathOperation(int a, int b);
delegate bool Validator(string input);

// ─── EVENT EXAMPLE ───
class Button
{
    // EventHandler is a built-in delegate: void(object, EventArgs)
    public event EventHandler Clicked;
    public event EventHandler<string> TextChanged;

    public string Text { get; private set; } = "";

    public void Click()
    {
        Console.WriteLine("Button clicked!");
        Clicked?.Invoke(this, EventArgs.Empty);  // fire if anyone subscribed
    }

    public void SetText(string newText)
    {
        Text = newText;
        TextChanged?.Invoke(this, newText);
    }
}

class Program
{
    static int Add(int a, int b) => a + b;
    static int Multiply(int a, int b) => a * b;

    static void Main()
    {
        // ─── BASIC DELEGATE USAGE ───
        MathOperation op = Add;
        Console.WriteLine(op(3, 4));  // 7

        op = Multiply;
        Console.WriteLine(op(3, 4));  // 12

        // ─── MULTICAST DELEGATE ───
        Action greet = () => Console.WriteLine("Hello!");
        greet += () => Console.WriteLine("Bonjour!");
        greet += () => Console.WriteLine("Hola!");
        greet();  // all three fire

        greet -= () => Console.WriteLine("Hello!");  // remove one

        // ─── BUILT-IN DELEGATE TYPES ───
        // Action — returns void
        Action<string> print = s => Console.WriteLine(s);
        print("Hello from Action");

        Action<int, int> printSum = (a, b) => Console.WriteLine(a + b);
        printSum(3, 4);  // 7

        // Func — returns a value (last type is return type)
        Func<int, int, int> add = (a, b) => a + b;
        Console.WriteLine(add(5, 3));  // 8

        Func<string, int> strlen = s => s.Length;
        Console.WriteLine(strlen("Hello"));  // 5

        // Predicate — returns bool
        Predicate<int> isEven = n => n % 2 == 0;
        Console.WriteLine(isEven(4));  // True
        Console.WriteLine(isEven(7));  // False

        // ─── PASSING DELEGATES AS PARAMETERS ───
        int[] numbers = { 1, 2, 3, 4, 5, 6 };
        var evens = Array.FindAll(numbers, isEven);
        Console.WriteLine(string.Join(", ", evens));  // 2, 4, 6

        // ─── EVENTS ───
        var btn = new Button();

        // Subscribe with += 
        btn.Clicked      += (sender, e) => Console.WriteLine("Handler 1: button was clicked!");
        btn.Clicked      += (sender, e) => Console.WriteLine("Handler 2: logging the click");
        btn.TextChanged  += (sender, text) => Console.WriteLine(\$"Text changed to: {text}");

        btn.Click();       // fires both Clicked handlers
        btn.SetText("OK"); // fires TextChanged handler

        // Unsubscribe with -=
        void OnClick(object s, EventArgs e) => Console.WriteLine("Named handler");
        btn.Clicked += OnClick;
        btn.Click();     // 3 handlers fire
        btn.Clicked -= OnClick;
        btn.Click();     // back to 2 handlers

        // Cannot fire from outside:
        // btn.Clicked(this, EventArgs.Empty);  // ERROR — event can only be invoked by owner
    }
}

─────────────────────────────────────
DELEGATE TYPE GUIDE:
─────────────────────────────────────
void method()              → Action
void method(T arg)         → Action<T>
void method(T1, T2)        → Action<T1, T2>
TResult method()           → Func<TResult>
TResult method(T arg)      → Func<T, TResult>
bool method(T arg)         → Predicate<T>
─────────────────────────────────────

📝 KEY POINTS:
✅ Use Action/Func/Predicate instead of custom delegates in most cases
✅ Events can only be fired by the class that declares them
✅ Always use ?.Invoke() to fire events safely when no subscribers exist
✅ Multicast delegates call all subscribed methods in order
✅ -= unsubscribes a handler — essential for avoiding memory leaks
❌ Don't fire events without null check (?.Invoke()) — crashes if no subscribers
❌ Don't use delegates when lambdas or LINQ are cleaner
''',
  quiz: [
    Quiz(question: 'What is the difference between a delegate and an event?', options: [
      QuizOption(text: 'An event can only be fired by the class that owns it; delegates can be invoked by anyone', correct: true),
      QuizOption(text: 'Events hold multiple handlers; delegates hold only one', correct: false),
      QuizOption(text: 'Delegates are for return values; events are for void methods', correct: false),
      QuizOption(text: 'They are identical — events are just a naming convention', correct: false),
    ]),
    Quiz(question: 'Which built-in delegate type takes parameters and returns void?', options: [
      QuizOption(text: 'Action<T>', correct: true),
      QuizOption(text: 'Func<T>', correct: false),
      QuizOption(text: 'Predicate<T>', correct: false),
      QuizOption(text: 'EventHandler<T>', correct: false),
    ]),
    Quiz(question: 'Why should you use ?.Invoke() to fire an event?', options: [
      QuizOption(text: 'To safely handle the case where no handlers are subscribed (null check)', correct: true),
      QuizOption(text: 'To fire the event asynchronously', correct: false),
      QuizOption(text: 'To prevent duplicate invocations', correct: false),
      QuizOption(text: '?.Invoke() is required syntax for all event firing', correct: false),
    ]),
  ],
);
