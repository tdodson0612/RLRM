// lib/lessons/csharp/csharp_69_abstract_vs_interface.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson69 = Lesson(
  language: 'C#',
  title: 'Abstract Classes vs Interfaces: Design Patterns',
  content: '''
🎯 METAPHOR:
An abstract class is like an employment contract template.
It says: "All employees MUST have an employee ID (abstract).
All employees CAN use the company cafeteria (concrete method).
All employees get two weeks vacation (implemented behavior)."
New employee types fill in their own ID system but inherit
all the shared benefits automatically.

An interface is a professional certification.
"Certified Accountant" means you can Audit(), file Taxes(),
and read BalanceSheets() — regardless of which firm you work
for, or what ELSE you can do. Multiple certifications are fine.
The certification defines capability, not background.

USE ABSTRACT CLASS when:
  - Sharing implementation code among related types
  - Representing an "is-a" hierarchy
  - Providing default behavior with optional overrides

USE INTERFACE when:
  - Defining a capability ("can-do")
  - Multiple unrelated types share the capability
  - You need multiple "inheritance"

📖 EXPLANATION:
ABSTRACT CLASS:
  ✅ Can have state (fields, properties with backing)
  ✅ Can have constructors
  ✅ Can have implemented methods
  ✅ Can have protected members
  ❌ Single inheritance only
  ❌ Cannot be instantiated

INTERFACE:
  ✅ Multiple implementation
  ✅ Clear contract — no hidden state
  ✅ Default implementations (C# 8+)
  ❌ No instance fields
  ❌ Cannot have constructors
  ❌ No protected members

💻 CODE:
using System;
using System.Collections.Generic;

// ─── ABSTRACT CLASS: "is-a" with shared behavior ───
abstract class Animal
{
    // State (abstract class can have fields)
    private string _name;
    private int _age;

    public string Name => _name;
    public int    Age  => _age;

    protected Animal(string name, int age)
    {
        _name = name;
        _age  = age;
    }

    // Abstract: MUST be overridden
    public abstract string MakeSound();
    public abstract double MovementSpeed { get; }  // km/h

    // Concrete: shared, inheritable behavior
    public void Sleep()    => Console.WriteLine(\$"{Name} is sleeping.");
    public void Eat(string food) => Console.WriteLine(\$"{Name} eats {food}.");

    public virtual void Describe()
        => Console.WriteLine(\$"{GetType().Name} '{Name}', age {Age}: {MakeSound()}");
}

class Dog : Animal
{
    public string Breed { get; }
    public Dog(string name, int age, string breed) : base(name, age) { Breed = breed; }
    public override string MakeSound()    => "Woof!";
    public override double MovementSpeed => 48;  // km/h
    public void Fetch()                  => Console.WriteLine(\$"{Name} fetches the ball!");
}

class Cat : Animal
{
    public Cat(string name, int age) : base(name, age) {}
    public override string MakeSound()    => "Meow!";
    public override double MovementSpeed => 48;
}

// ─── INTERFACE: "can-do" capabilities ───
interface ISaveable
{
    void Save(string path);
    bool Load(string path);
}

interface IPrintable
{
    void Print();
    string GetPreview(int maxChars = 100);  // default implementation via parameter
}

interface IEncryptable
{
    void Encrypt(string key);
    void Decrypt(string key);
}

// One class, multiple capabilities
class Document : ISaveable, IPrintable
{
    public string Title { get; set; }
    public string Content { get; set; }

    public void Save(string path) => Console.WriteLine(\$"Saving '{Title}' to {path}");
    public bool Load(string path) { Console.WriteLine(\$"Loading from {path}"); return true; }
    public void Print()           => Console.WriteLine(\$"=== {Title} ===\n{Content}");
    public string GetPreview(int maxChars = 100)
        => Content?.Length > maxChars ? Content[..maxChars] + "..." : Content;
}

// ─── COMBINING BOTH (common real-world pattern) ───
// Abstract class provides the template; interfaces add capabilities
abstract class Shape : IPrintable
{
    public string Color { get; set; } = "black";
    public abstract double Area { get; }

    // Abstract class implements the interface
    public void Print()          => Console.WriteLine(\$"{GetType().Name}: {Color}, area={Area:F2}");
    public string GetPreview(int maxChars = 100) => \$"{GetType().Name}({Color})";
}

class Square : Shape
{
    public double Side { get; }
    public Square(double side, string color) { Side = side; Color = color; }
    public override double Area => Side * Side;
}

// ─── STRATEGY PATTERN (interfaces shine here) ───
interface ISortStrategy<T>
{
    IEnumerable<T> Sort(IEnumerable<T> items);
}

class AscendingSort<T> : ISortStrategy<T> where T : IComparable<T>
{
    public IEnumerable<T> Sort(IEnumerable<T> items)
        => items.OrderBy(x => x);
}

class DescendingSort<T> : ISortStrategy<T> where T : IComparable<T>
{
    public IEnumerable<T> Sort(IEnumerable<T> items)
        => items.OrderByDescending(x => x);
}

class DataProcessor<T> where T : IComparable<T>
{
    private ISortStrategy<T> _strategy;
    public DataProcessor(ISortStrategy<T> strategy) { _strategy = strategy; }
    public void SetStrategy(ISortStrategy<T> strategy) { _strategy = strategy; }
    public IEnumerable<T> Process(IEnumerable<T> data) => _strategy.Sort(data);
}

class Program
{
    static void Main()
    {
        // Abstract class hierarchy
        var animals = new List<Animal> { new Dog("Rex", 3, "Husky"), new Cat("Whiskers", 5) };
        foreach (var a in animals)
        {
            a.Describe();
            a.Sleep();
        }

        // Interface polymorphism
        var doc = new Document { Title = "Report", Content = "Annual summary..." };
        ISaveable   saveable  = doc;
        IPrintable  printable = doc;
        saveable.Save("report.pdf");
        printable.Print();

        // Combined pattern
        var shapes = new List<Shape>
        {
            new Square(4, "red"),
            new Square(5, "blue")
        };
        foreach (IPrintable p in shapes) p.Print();

        // Strategy pattern
        var processor = new DataProcessor<int>(new AscendingSort<int>());
        var data = new[] { 5, 3, 8, 1, 9 };
        Console.WriteLine(string.Join(",", processor.Process(data)));  // 1,3,5,8,9

        processor.SetStrategy(new DescendingSort<int>());
        Console.WriteLine(string.Join(",", processor.Process(data)));  // 9,8,5,3,1
    }
}

📝 KEY POINTS:
✅ Abstract class = "is-a" with shared state and behavior
✅ Interface = "can-do" capability that any unrelated type can implement
✅ Prefer interfaces for public APIs — they are more flexible
✅ Use abstract classes when sharing implementation code among a related group
✅ Classes can implement many interfaces but inherit only one abstract class
❌ Don't use abstract classes as a workaround for multiple inheritance
❌ Don't put business logic in interfaces — use abstract classes or extension methods
''',
  quiz: [
    Quiz(question: 'When should you choose an abstract class over an interface?', options: [
      QuizOption(text: 'When you need to share implementation code and state among closely related types', correct: true),
      QuizOption(text: 'When you need multiple inheritance', correct: false),
      QuizOption(text: 'When the type needs to implement multiple behaviors', correct: false),
      QuizOption(text: 'Abstract class is always preferred in modern C#', correct: false),
    ]),
    Quiz(question: 'What can an abstract class have that an interface cannot?', options: [
      QuizOption(text: 'Instance fields, constructors, and protected members', correct: true),
      QuizOption(text: 'Default method implementations', correct: false),
      QuizOption(text: 'Generic type parameters', correct: false),
      QuizOption(text: 'Static methods', correct: false),
    ]),
    Quiz(question: 'Which pattern is best demonstrated by using interfaces with dependency injection?', options: [
      QuizOption(text: 'Program to interfaces — depend on the capability, not the implementation', correct: true),
      QuizOption(text: 'Template method — define skeleton in base class', correct: false),
      QuizOption(text: 'Singleton — ensure only one instance', correct: false),
      QuizOption(text: 'Observer — notify subscribers of changes', correct: false),
    ]),
  ],
);
