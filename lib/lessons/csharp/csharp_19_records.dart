// lib/lessons/csharp/csharp_19_records.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson19 = Lesson(
  language: 'C#',
  title: 'Records',
  content: '''
🎯 METAPHOR:
A record is like a stamped official document.
Once issued, the document is immutable — you cannot change
the birth date on a birth certificate. If you need an
updated version, you issue a NEW certificate with the
correction. But comparing two birth certificates with the
same information tells you they represent the same person —
even if they are printed on different paper (different objects).
Records give you value-based equality, immutability,
and concise syntax — all at once.

📖 EXPLANATION:
Records (C# 9+) are a special kind of class/struct designed
for immutable data with value-based equality.

RECORD CLASS (reference type):
  - Immutable by default (init-only properties)
  - Value-based equality (two records with same data are equal)
  - Auto-generated ToString(), Equals(), GetHashCode()
  - "with" expression for non-destructive mutation

RECORD STRUCT (value type, C# 10+):
  - Same as record class but stored on the stack
  - Copied by value

WHEN TO USE RECORDS:
  - DTOs (Data Transfer Objects)
  - Configuration objects
  - Immutable data models
  - API response/request objects

💻 CODE:
using System;

// ─── POSITIONAL RECORD (most concise syntax) ───
record Point(double X, double Y);

record Person(string Name, int Age, string Email);

// ─── RECORD WITH ADDITIONAL MEMBERS ───
record Product(string Name, decimal Price, int Stock)
{
    // Additional computed property
    public bool InStock => Stock > 0;

    // Additional method
    public Product ApplyDiscount(decimal percent) =>
        this with { Price = Price * (1 - percent / 100) };

    // Custom validation in constructor
    public Product
    {
        if (Price < 0) throw new ArgumentException("Price cannot be negative");
        if (Stock < 0) throw new ArgumentException("Stock cannot be negative");
    }
}

// ─── STANDARD RECORD (more control) ───
record class Employee
{
    public string Id { get; init; }
    public string Name { get; init; }
    public string Department { get; init; }
    public decimal Salary { get; init; }

    public Employee(string id, string name, string dept, decimal salary)
    {
        Id = id;
        Name = name;
        Department = dept;
        Salary = salary;
    }
}

// ─── MUTABLE RECORD (override immutability) ───
record MutablePoint(double X, double Y)
{
    public double X { get; set; } = X;  // override with set instead of init
    public double Y { get; set; } = Y;
}

// ─── RECORD STRUCT (value type) ───
record struct Coordinate(double Lat, double Lng);

// ─── INHERITANCE WITH RECORDS ───
record Shape(string Color);
record Circle(string Color, double Radius) : Shape(Color);
record Rectangle(string Color, double Width, double Height) : Shape(Color);

class Program
{
    static void Main()
    {
        // ─── CREATION ───
        var p1 = new Point(3.0, 4.0);
        var p2 = new Point(3.0, 4.0);
        var p3 = new Point(1.0, 2.0);

        // ─── VALUE-BASED EQUALITY ───
        Console.WriteLine(p1 == p2);   // True! (same values)
        Console.WriteLine(p1 == p3);   // False (different values)
        Console.WriteLine(p1.Equals(p2)); // True

        // ─── AUTO TOSTRING ───
        Console.WriteLine(p1);         // Point { X = 3, Y = 4 }

        // ─── WITH EXPRESSION (non-destructive copy) ───
        var person = new Person("Alice", 30, "alice@example.com");
        var olderAlice = person with { Age = 31 };  // new record, changed age
        var renamed    = person with { Name = "Alicia", Age = 31 };

        Console.WriteLine(person);      // Person { Name = Alice, Age = 30, ... }
        Console.WriteLine(olderAlice);  // Person { Name = Alice, Age = 31, ... }
        Console.WriteLine(ReferenceEquals(person, olderAlice)); // False (new object)

        // ─── DECONSTRUCTION ───
        var (name, age, email) = person;
        Console.WriteLine(\$"{name} is {age}");  // Alice is 30

        // ─── PRODUCT RECORD ───
        var product = new Product("Widget", 9.99m, 100);
        Console.WriteLine(product.InStock);  // True
        var discounted = product.ApplyDiscount(20);
        Console.WriteLine(discounted.Price); // 7.992

        // ─── INHERITANCE ───
        Shape shape = new Circle("red", 5.0);
        Console.WriteLine(shape);  // Circle { Color = red, Radius = 5 }

        // ─── RECORD STRUCT ───
        var coord = new Coordinate(40.7128, -74.0060);
        Console.WriteLine(coord);  // Coordinate { Lat = 40.7128, Lng = -74.006 }
    }
}

📝 KEY POINTS:
✅ Records provide value equality — two records with same data are equal
✅ "with" expression creates a modified copy without changing the original
✅ Auto-generated ToString() shows all property values — great for debugging
✅ Positional records are the most concise — one line for a full immutable type
✅ Use records for DTOs, configs, domain values, and API models
❌ Don't use records when you need mutable state with complex behavior — use classes
❌ Record equality compares ALL properties — be careful with large records
''',
  quiz: [
    Quiz(question: 'What makes record equality different from class equality by default?', options: [
      QuizOption(text: 'Records use value equality — two records with same data are equal', correct: true),
      QuizOption(text: 'Records use reference equality just like classes', correct: false),
      QuizOption(text: 'Records are always unequal unless they are the same object', correct: false),
      QuizOption(text: 'Records compare only the first property', correct: false),
    ]),
    Quiz(question: 'What does the "with" expression do for a record?', options: [
      QuizOption(text: 'Creates a new record copy with specified properties changed', correct: true),
      QuizOption(text: 'Modifies the original record in place', correct: false),
      QuizOption(text: 'Merges two records into one', correct: false),
      QuizOption(text: 'Resets all properties to their default values', correct: false),
    ]),
    Quiz(question: 'What C# version introduced records?', options: [
      QuizOption(text: 'C# 9', correct: true),
      QuizOption(text: 'C# 7', correct: false),
      QuizOption(text: 'C# 8', correct: false),
      QuizOption(text: 'C# 10', correct: false),
    ]),
  ],
);
