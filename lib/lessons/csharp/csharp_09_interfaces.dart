// lib/lessons/csharp/csharp_09_interfaces.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson09 = Lesson(
  language: 'C#',
  title: 'Interfaces',
  content: '''
🎯 METAPHOR:
An interface is like a job posting with required skills.
"Must be able to: drive a forklift, read blueprints,
operate a crane." The posting doesn't say HOW you learned
these skills or what else you can do. Any person who meets
all requirements qualifies — regardless of background.
In C#: any class that implements all interface members
qualifies as that interface type. Multiple classes can
implement the same interface in completely different ways.

📖 EXPLANATION:
An interface defines a CONTRACT — a set of members a class
MUST implement. It has no implementation itself (traditionally).

Key facts:
  - A class can implement MULTIPLE interfaces (unlike inheritance)
  - Interfaces cannot have instance fields
  - All interface members are public by default
  - C# 8+ allows default interface implementations
  - Use interfaces for "can do" relationships

INTERFACE vs ABSTRACT CLASS:
  Abstract class → is-a relationship, can have state/implementation
  Interface      → can-do relationship, pure contract
─────────────────────────────────────

💻 CODE:
using System;
using System.Collections.Generic;

// ─── DEFINING INTERFACES ───
interface ISaveable
{
    void Save();
    bool Load(string path);
}

interface IPrintable
{
    void Print();
    string GetPreview();  // default can be added in C# 8+
}

interface IResizable
{
    void Resize(double factor);
    double Width { get; }
    double Height { get; }
}

// ─── IMPLEMENTING MULTIPLE INTERFACES ───
class Document : ISaveable, IPrintable
{
    public string Title { get; set; }
    public string Content { get; set; }

    public Document(string title, string content)
    {
        Title = title;
        Content = content;
    }

    // ISaveable
    public void Save()
        => Console.WriteLine(\$"Saving '{Title}' to disk...");

    public bool Load(string path)
    {
        Console.WriteLine(\$"Loading from {path}...");
        return true;
    }

    // IPrintable
    public void Print()
        => Console.WriteLine(\$"=== {Title} ===\\n{Content}");

    public string GetPreview()
        => Content.Length > 50 ? Content[..50] + "..." : Content;
}

// ─── INTERFACE AS A TYPE ───
class FileManager
{
    // Accepts ANYTHING that is ISaveable — doesn't care about the class
    public void SaveAll(IEnumerable<ISaveable> items)
    {
        foreach (var item in items)
            item.Save();
    }
}

// ─── DEFAULT INTERFACE IMPLEMENTATIONS (C# 8+) ───
interface ILogger
{
    void Log(string message);

    // Default implementation — classes can override or use this
    void LogError(string message) => Log(\$"[ERROR] {message}");
    void LogInfo(string message)  => Log(\$"[INFO] {message}");
}

class ConsoleLogger : ILogger
{
    public void Log(string message)
        => Console.WriteLine(\$"[{DateTime.Now:HH:mm:ss}] {message}");
    // LogError and LogInfo are inherited from the interface default
}

// ─── EXPLICIT INTERFACE IMPLEMENTATION ───
// When two interfaces have the same method name:
interface ILeft  { void Draw(); }
interface IRight { void Draw(); }

class Widget : ILeft, IRight
{
    void ILeft.Draw()  => Console.WriteLine("Drawing left");
    void IRight.Draw() => Console.WriteLine("Drawing right");
}

class Program
{
    static void Main()
    {
        var doc = new Document("My Doc", "Hello World content here");
        doc.Save();
        doc.Print();
        Console.WriteLine(doc.GetPreview());

        // Interface as type
        ISaveable saveable = doc;
        saveable.Save();    // works through interface

        IPrintable printable = doc;
        printable.Print();

        // FileManager accepts any ISaveable
        var manager = new FileManager();
        manager.SaveAll(new ISaveable[] { doc });

        // Default interface implementation
        ILogger logger = new ConsoleLogger();
        logger.Log("Starting up");
        logger.LogError("Something broke");  // uses default impl
        logger.LogInfo("All good");           // uses default impl

        // Explicit interface implementation
        var widget = new Widget();
        ((ILeft)widget).Draw();   // Drawing left
        ((IRight)widget).Draw();  // Drawing right

        // Type checking
        Console.WriteLine(doc is ISaveable);   // True
        Console.WriteLine(doc is IPrintable);  // True
    }
}

📝 KEY POINTS:
✅ A class can implement multiple interfaces — this is C#'s solution to multiple inheritance
✅ Use interfaces for "can do" contracts — not for "is a" relationships
✅ Interface references let you write code that works with any implementing type
✅ C# 8+ default implementations let you add methods without breaking existing implementors
✅ Explicit implementation resolves naming conflicts between interfaces
❌ Don't put fields in interfaces — use abstract classes if you need shared state
❌ Don't make interfaces too large — "interface segregation" means many small interfaces
''',
  quiz: [
    Quiz(question: 'How many interfaces can a C# class implement?', options: [
      QuizOption(text: 'As many as needed — there is no limit', correct: true),
      QuizOption(text: 'Only one', correct: false),
      QuizOption(text: 'Up to two', correct: false),
      QuizOption(text: 'The same number as base classes', correct: false),
    ]),
    Quiz(question: 'What is the key difference between an interface and an abstract class?', options: [
      QuizOption(text: 'Interfaces define contracts with no state; abstract classes can have state and partial implementation', correct: true),
      QuizOption(text: 'Abstract classes have no methods; interfaces do', correct: false),
      QuizOption(text: 'Interfaces can only be used in Unity; abstract classes are general', correct: false),
      QuizOption(text: 'They are identical — just different syntax', correct: false),
    ]),
    Quiz(question: 'What did C# 8 add to interfaces?', options: [
      QuizOption(text: 'Default interface implementations — methods with a body in the interface', correct: true),
      QuizOption(text: 'The ability to have instance fields', correct: false),
      QuizOption(text: 'Support for private interface members', correct: false),
      QuizOption(text: 'The ability to inherit from multiple interfaces', correct: false),
    ]),
  ],
);
