// lib/lessons/csharp/csharp_67_records_advanced.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson67 = Lesson(
  language: 'C#',
  title: 'Records Advanced: Inheritance, Custom Logic, and Patterns',
  content: '''
🎯 METAPHOR:
Advanced records are like a family of official documents.
A base Document has common fields (ID, timestamp, author).
A Contract extends Document and adds parties and terms.
A Will extends Document differently and adds beneficiaries.
All are Documents — they share equality and printing behavior
from the base. But each adds its own specific fields and
behaviors. The "official document" nature (immutability,
value equality) is inherited across the whole family.

📖 EXPLANATION:
RECORD INHERITANCE:
  Records can inherit from other records (not classes, not structs).
  All records implicitly inherit from System.Object via Record base.
  Virtual and override work for custom behavior.
  EqualityContract — how records know their full type for equality.

RECORDS WITH CUSTOM LOGIC:
  Records CAN have constructors, methods, properties.
  Compact constructor: validates in the primary constructor body.
  Property override: replace auto-generated with custom property.

DECONSTRUCTION:
  Positional records auto-generate Deconstruct().
  Can add your own Deconstruct() overloads.

WITH EXPRESSIONS:
  Works on records and C# 10+ structs.
  Creates a copy with specified properties changed.

💻 CODE:
using System;

// ─── RECORD INHERITANCE ───
abstract record Shape(string Color)
{
    public abstract double Area { get; }
    public abstract double Perimeter { get; }

    public virtual string Describe()
        => \$"{GetType().Name}({Color}): area={Area:F2}, perimeter={Perimeter:F2}";
}

record Circle(string Color, double Radius) : Shape(Color)
{
    public override double Area      => Math.PI * Radius * Radius;
    public override double Perimeter => 2 * Math.PI * Radius;
}

record Rectangle(string Color, double Width, double Height) : Shape(Color)
{
    public override double Area      => Width * Height;
    public override double Perimeter => 2 * (Width + Height);

    public bool IsSquare => Width == Height;
}

// ─── COMPACT CONSTRUCTOR (validation) ───
record Temperature(double Celsius)
{
    // Compact constructor: runs AFTER parameter assignment
    public double Celsius { get; } = Celsius >= -273.15
        ? Celsius
        : throw new ArgumentOutOfRangeException(nameof(Celsius), "Below absolute zero!");

    public double Fahrenheit => Celsius * 9.0 / 5.0 + 32;
    public double Kelvin => Celsius + 273.15;
}

// ─── CUSTOM PROPERTY IN POSITIONAL RECORD ───
record Person(string FirstName, string LastName, DateTime BirthDate)
{
    // Override generated property with computed value
    public string FirstName { get; } = string.IsNullOrWhiteSpace(FirstName)
        ? throw new ArgumentException("FirstName required")
        : FirstName.Trim();

    // Additional computed property
    public string FullName  => \$"{FirstName} {LastName}";
    public int    Age       => DateTime.Today.Year - BirthDate.Year
                               - (DateTime.Today < BirthDate.AddYears(DateTime.Today.Year - BirthDate.Year) ? 1 : 0);

    // Extra Deconstruct overload
    public void Deconstruct(out string fullName, out int age)
    {
        fullName = FullName;
        age = Age;
    }
}

// ─── RECORD STRUCT ───
record struct Point3D(double X, double Y, double Z)
{
    public double Length => Math.Sqrt(X*X + Y*Y + Z*Z);

    public static Point3D operator +(Point3D a, Point3D b)
        => new(a.X + b.X, a.Y + b.Y, a.Z + b.Z);
}

// ─── SEALED RECORD ───
sealed record FinalConfig(string Host, int Port)
{
    // Cannot be inherited
}

class Program
{
    static void Main()
    {
        // ─── INHERITANCE ───
        Shape[] shapes =
        {
            new Circle("red", 5),
            new Rectangle("blue", 4, 6),
            new Rectangle("green", 5, 5),
        };

        foreach (Shape s in shapes)
            Console.WriteLine(s.Describe());

        // Polymorphic with pattern matching
        foreach (Shape s in shapes)
        {
            string info = s switch
            {
                Circle { Radius: > 4 } c => \$"Large circle r={c.Radius}",
                Rectangle { IsSquare: true } r => \$"Square side={r.Width}",
                Rectangle r => \$"Rectangle {r.Width}x{r.Height}",
                _ => "Unknown"
            };
            Console.WriteLine(info);
        }

        // Record equality with inheritance
        var c1 = new Circle("red", 5);
        var c2 = new Circle("red", 5);
        var c3 = new Rectangle("red", 5, 5);
        Console.WriteLine(c1 == c2);  // True (same type AND values)
        Console.WriteLine(c1 == c3);  // False (different types!)

        // ─── COMPACT CONSTRUCTOR ───
        var boiling = new Temperature(100);
        Console.WriteLine(\$"{boiling.Fahrenheit}°F");  // 212°F
        Console.WriteLine(\$"{boiling.Kelvin}K");       // 373.15K

        try { var bad = new Temperature(-300); }
        catch (ArgumentOutOfRangeException ex) { Console.WriteLine(ex.Message); }

        // ─── PERSON RECORD ───
        var alice = new Person("Alice", "Smith", new DateTime(1990, 6, 15));
        Console.WriteLine(alice.FullName);  // Alice Smith
        Console.WriteLine(alice.Age);       // age depends on current date

        // Standard deconstruct
        var (fn, ln, bd) = alice;
        Console.WriteLine(\$"{fn} {ln} born {bd:yyyy-MM-dd}");

        // Custom deconstruct
        var (fullName, age) = alice;
        Console.WriteLine(\$"{fullName}, age {age}");

        // ─── WITH EXPRESSION ───
        var updated = alice with { LastName = "Jones" };
        Console.WriteLine(updated.FullName);  // Alice Jones
        Console.WriteLine(alice.FullName);    // Alice Smith (unchanged)

        // ─── RECORD STRUCT ───
        var p1 = new Point3D(1, 2, 3);
        var p2 = new Point3D(4, 5, 6);
        Point3D sum = p1 + p2;
        Console.WriteLine(sum);       // Point3D { X = 5, Y = 7, Z = 9 }
        Console.WriteLine(p1.Length); // ~3.74

        // ─── NESTED WITH ───
        record Address(string City, string Country);
        record Employee(string Name, Address Location);

        var emp = new Employee("Bob", new Address("New York", "USA"));
        var moved = emp with { Location = emp.Location with { City = "London" } };
        Console.WriteLine(moved.Location);  // Address { City = London, Country = USA }
    }
}

📝 KEY POINTS:
✅ Records use EqualityContract (the actual runtime type) for equality — Circle != Rectangle even with same values
✅ Compact constructors validate AFTER parameter assignment — can throw on invalid values
✅ Property overrides in positional records let you add validation to auto-generated properties
✅ with expression works for nested records too — chain them
✅ Record structs are value types with record features — use for small immutable value objects
❌ Records cannot inherit from classes (only from other records or object)
❌ Two records of different types are NEVER equal even if all property values match
''',
  quiz: [
    Quiz(question: 'When comparing two records of different derived types with the same property values, what does == return?', options: [
      QuizOption(text: 'false — records use the runtime type (EqualityContract) in equality checks', correct: true),
      QuizOption(text: 'true — only property values matter', correct: false),
      QuizOption(text: 'It depends on whether the base record overrides Equals()', correct: false),
      QuizOption(text: 'A compile error — you cannot compare different record types', correct: false),
    ]),
    Quiz(question: 'What does the compact constructor in a positional record do?', options: [
      QuizOption(text: 'Runs additional validation code after parameters are assigned', correct: true),
      QuizOption(text: 'Replaces the generated constructor entirely', correct: false),
      QuizOption(text: 'Runs before parameters are assigned', correct: false),
      QuizOption(text: 'Generates the with expression support', correct: false),
    ]),
    Quiz(question: 'Can a record inherit from a class in C#?', options: [
      QuizOption(text: 'No — records can only inherit from other records or object', correct: true),
      QuizOption(text: 'Yes — records can inherit from any class', correct: false),
      QuizOption(text: 'Yes — but only from abstract classes', correct: false),
      QuizOption(text: 'Only in C# 12 and later', correct: false),
    ]),
  ],
);
