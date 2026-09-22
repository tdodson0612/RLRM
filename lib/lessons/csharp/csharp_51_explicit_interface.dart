// lib/lessons/csharp/csharp_51_explicit_interface.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson51 = Lesson(
  language: 'C#',
  title: 'Explicit Interface Implementation',
  content: '''
🎯 METAPHOR:
Explicit interface implementation is like a professional
with two job titles that share the same word.
As "Manager" you Approve() budgets. As "Mentor" you
Approve() career plans. Both roles have Approve() but
mean completely different things. Explicit implementation
lets you say: "when accessed AS a Manager, do THIS.
When accessed AS a Mentor, do THAT." Same word, different
behavior depending on which hat the caller sees you wearing.

📖 EXPLANATION:
By default, when a class implements an interface method,
that method is publicly accessible on the class directly.

EXPLICIT implementation hides the method from the class
surface — it is ONLY accessible through the interface type.

When is this useful?
  - Two interfaces define a method with the same name
  - You want to hide interface-specific methods from the
    class's public API
  - You want different behavior depending on which
    interface is being used

SYNTAX: InterfaceName.MethodName() — no access modifier,
method only accessible through the interface reference.

💻 CODE:
using System;
using System.Collections;
using System.Collections.Generic;

// ─── NAMING CONFLICT ───
interface IAnimal
{
    string Describe();
}

interface IMachine
{
    string Describe();  // same name — conflict!
}

class RobotDog : IAnimal, IMachine
{
    // Explicit implementation for IAnimal
    string IAnimal.Describe()
        => "I am a biological-looking robot dog.";

    // Explicit implementation for IMachine
    string IMachine.Describe()
        => "I am a machine with four legs and actuators.";

    // Class's own public method (optional)
    public string Describe()
        => "I am RobotDog — half animal, half machine.";
}

// ─── HIDING INTERFACE PLUMBING FROM PUBLIC API ───
class NumberList : IEnumerable<int>
{
    private List<int> _items = new() { 1, 2, 3, 4, 5 };

    // Public method — the nice API
    public void Add(int item) => _items.Add(item);
    public int Count => _items.Count;

    // Explicit — GetEnumerator() is "plumbing"
    // We don't want it cluttering the public surface
    IEnumerator<int> IEnumerable<int>.GetEnumerator()
        => _items.GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator()
        => _items.GetEnumerator();
}

// ─── VERSIONING — adding to interface without breaking class ───
interface ILogger
{
    void Log(string message);
}

interface ILoggerV2 : ILogger
{
    void LogError(string message);
    void LogWarning(string message);
}

class SimpleLogger : ILoggerV2
{
    // Regular implementation — visible on class
    public void Log(string message)
        => Console.WriteLine(\$"[INFO] {message}");

    // Explicit — only accessible via ILoggerV2 reference
    void ILoggerV2.LogError(string message)
        => Console.WriteLine(\$"[ERROR] {message}");

    void ILoggerV2.LogWarning(string message)
        => Console.WriteLine(\$"[WARN] {message}");
}

class Program
{
    static void Main()
    {
        // ─── NAMING CONFLICT ───
        var robot = new RobotDog();

        Console.WriteLine(robot.Describe());  // RobotDog's own method

        IAnimal animal = robot;
        Console.WriteLine(animal.Describe()); // I am a biological-looking robot dog.

        IMachine machine = robot;
        Console.WriteLine(machine.Describe()); // I am a machine with four legs...

        // robot.IAnimal.Describe();  // ERROR — not accessible this way

        // ─── CLEAN PUBLIC API ───
        var list = new NumberList();
        list.Add(6);
        Console.WriteLine(list.Count);  // 6

        // GetEnumerator not visible on NumberList:
        // list.GetEnumerator();  // no such public method!

        // But foreach works because it goes through the interface
        foreach (int n in list)
            Console.Write(n + " ");
        Console.WriteLine();

        // ─── LOGGER ───
        var logger = new SimpleLogger();
        logger.Log("Starting up");  // visible on class

        // logger.LogError("test");  // ERROR — not on class surface

        ILoggerV2 v2 = logger;
        v2.LogError("Something failed");   // accessible via interface
        v2.LogWarning("Low memory");
    }
}

📝 KEY POINTS:
✅ Use explicit implementation when two interfaces share method names
✅ Use explicit implementation to hide "plumbing" from the public API
✅ Explicitly implemented methods are only accessible via the interface type
✅ A class can have BOTH an explicit impl and its own public method of the same name
❌ Explicitly implemented methods have no access modifier — that is intentional
❌ You cannot call an explicitly implemented method through the class reference
''',
  quiz: [
    Quiz(question: 'How do you access an explicitly implemented interface method?', options: [
      QuizOption(text: 'Only through a reference of the interface type', correct: true),
      QuizOption(text: 'Through the class reference like any public method', correct: false),
      QuizOption(text: 'Using the base keyword', correct: false),
      QuizOption(text: 'By casting with (ClassName)obj', correct: false),
    ]),
    Quiz(question: 'What access modifier does an explicit interface implementation use?', options: [
      QuizOption(text: 'None — no access modifier is allowed', correct: true),
      QuizOption(text: 'private', correct: false),
      QuizOption(text: 'public', correct: false),
      QuizOption(text: 'protected', correct: false),
    ]),
    Quiz(question: 'When is explicit interface implementation most necessary?', options: [
      QuizOption(text: 'When two interfaces define methods with the same signature', correct: true),
      QuizOption(text: 'When a method needs to be faster', correct: false),
      QuizOption(text: 'When inheriting from an abstract class', correct: false),
      QuizOption(text: 'When a method returns void', correct: false),
    ]),
  ],
);
