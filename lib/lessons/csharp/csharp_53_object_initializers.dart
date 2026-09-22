// lib/lessons/csharp/csharp_53_object_initializers.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson53 = Lesson(
  language: 'C#',
  title: 'Object and Collection Initializers',
  content: '''
🎯 METAPHOR:
Object initializers are like a move-in checklist for a
new apartment. Instead of calling maintenance five times
("set the thermostat," "hang the curtains," "unlock the
mailbox"), you hand over one comprehensive list on move-in
day and everything is set up at once. Clean, atomic,
readable — all the setup happens in one expression.

Collection initializers are the same idea for a shopping
bag: "one bag, add apple, banana, cherry." You describe
the final contents, not the individual Add() calls.

📖 EXPLANATION:
OBJECT INITIALIZER:
  Sets properties/fields right after construction.
  var p = new Person { Name = "Alice", Age = 30 };
  The constructor runs first, then properties are set.

COLLECTION INITIALIZER:
  Calls Add() implicitly.
  var list = new List<int> { 1, 2, 3 };
  Works on any type with an Add() method + IEnumerable.

NESTED INITIALIZERS:
  var order = new Order
  {
      Customer = new Customer { Name = "Alice" },
      Items = new List<Item> { new Item { Name = "Widget" } }
  };

INIT-ONLY PROPERTIES (C# 9):
  { get; init; } — settable in initializer, locked after.

WITH EXPRESSION (records and structs):
  var updated = original with { Age = 31 };

💻 CODE:
using System;
using System.Collections.Generic;

class Address
{
    public string Street { get; set; }
    public string City { get; set; }
    public string PostalCode { get; set; }
    public override string ToString() => \$"{Street}, {City} {PostalCode}";
}

class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
    public Address HomeAddress { get; set; }
    public List<string> Hobbies { get; set; } = new();

    // init-only property (C# 9)
    public string Id { get; init; } = Guid.NewGuid().ToString("N")[..8];
}

class Order
{
    public int OrderId { get; set; }
    public Person Customer { get; set; }
    public List<string> Items { get; set; }
    public decimal Total { get; set; }
}

// Custom collection with initializer support
class TagCollection : IEnumerable<string>
{
    private List<string> _tags = new();
    public void Add(string tag) => _tags.Add(tag.ToLower().Trim());
    public IEnumerator<string> GetEnumerator() => _tags.GetEnumerator();
    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        => _tags.GetEnumerator();
}

// Dictionary initializer
class Settings : IEnumerable<KeyValuePair<string, object>>
{
    private Dictionary<string, object> _data = new();
    public void Add(string key, object value) => _data[key] = value;
    public object this[string key] => _data[key];
    public IEnumerator<KeyValuePair<string, object>> GetEnumerator()
        => _data.GetEnumerator();
    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        => _data.GetEnumerator();
}

class Program
{
    static void Main()
    {
        // ─── OBJECT INITIALIZER ───
        var alice = new Person
        {
            Name = "Alice",
            Age  = 30,
            HomeAddress = new Address
            {
                Street     = "123 Main St",
                City       = "Springfield",
                PostalCode = "12345"
            },
            Hobbies = new List<string> { "Reading", "Hiking", "Coding" }
        };

        Console.WriteLine(\$"{alice.Name}, {alice.Age}");
        Console.WriteLine(alice.HomeAddress);
        Console.WriteLine(string.Join(", ", alice.Hobbies));

        // init-only: Id set at creation, locked after
        Console.WriteLine(alice.Id);
        // alice.Id = "new";  // ERROR: init-only!

        // ─── COLLECTION INITIALIZER ───
        var numbers = new List<int> { 1, 2, 3, 4, 5 };
        var names   = new HashSet<string> { "Alice", "Bob", "Charlie" };
        var lookup  = new Dictionary<string, int>
        {
            { "Alice", 30 },
            { "Bob",   25 },
            ["Charlie"] = 35   // alternative syntax
        };

        // ─── NESTED INITIALIZER ───
        var order = new Order
        {
            OrderId  = 1001,
            Customer = new Person { Name = "Bob", Age = 25 },
            Items    = new List<string> { "Widget", "Gadget", "Doohickey" },
            Total    = 49.97m
        };
        Console.WriteLine(\$"Order {order.OrderId} for {order.Customer.Name}");

        // ─── CUSTOM COLLECTION INITIALIZER ───
        var tags = new TagCollection
        {
            "CSharp",
            "  Dotnet  ",    // trimmed automatically in Add()
            "Programming"
        };
        foreach (var tag in tags) Console.Write(tag + " ");
        Console.WriteLine();  // csharp dotnet programming

        // ─── SETTINGS DICTIONARY-LIKE ───
        var settings = new Settings
        {
            { "theme", "dark" },
            { "fontSize", 14 },
            { "debug", true }
        };
        Console.WriteLine(settings["theme"]);    // dark
        Console.WriteLine(settings["fontSize"]); // 14

        // ─── WITH EXPRESSIONS (records) ───
        record Point(int X, int Y);
        var p1 = new Point(3, 4);
        var p2 = p1 with { Y = 10 };  // non-destructive copy
        Console.WriteLine(p1);  // Point { X = 3, Y = 4 }
        Console.WriteLine(p2);  // Point { X = 3, Y = 10 }

        // ─── TARGET-TYPED NEW (C# 9) ───
        // Type inferred from the context — no need to repeat it
        List<string> greetings = new() { "Hello", "Hi", "Hey" };
        Person bob = new() { Name = "Bob", Age = 25 };
        Console.WriteLine(bob.Name);
    }
}

📝 KEY POINTS:
✅ Object initializers set properties after construction — constructor runs first
✅ Collection initializers call Add() — any class with Add() + IEnumerable works
✅ Nested initializers build complex object graphs cleanly in one expression
✅ Target-typed new() (C# 9) avoids repeating the type name
✅ with expressions create modified copies of records without mutation
❌ Object initializers cannot call non-default constructors directly — use constructors for required params
❌ Init-only properties cannot be set after the initializer block
''',
  quiz: [
    Quiz(question: 'What does a collection initializer do under the hood?', options: [
      QuizOption(text: 'Calls the Add() method for each item listed', correct: true),
      QuizOption(text: 'Creates an array and converts it to the collection type', correct: false),
      QuizOption(text: 'Uses a special constructor that accepts multiple arguments', correct: false),
      QuizOption(text: 'Bypasses the Add() method for performance', correct: false),
    ]),
    Quiz(question: 'What is target-typed new() in C# 9?', options: [
      QuizOption(text: 'Allows omitting the type name in new expressions when the type is known from context', correct: true),
      QuizOption(text: 'Creates a new type at runtime based on usage', correct: false),
      QuizOption(text: 'A way to create anonymous types without naming them', correct: false),
      QuizOption(text: 'Creates an instance using the default constructor only', correct: false),
    ]),
    Quiz(question: 'When does the constructor run relative to object initializer property assignments?', options: [
      QuizOption(text: 'Constructor runs first, then properties are set by the initializer', correct: true),
      QuizOption(text: 'Properties are set first, then the constructor runs', correct: false),
      QuizOption(text: 'They run simultaneously', correct: false),
      QuizOption(text: 'The constructor is skipped when an initializer is used', correct: false),
    ]),
  ],
);
