// lib/lessons/csharp/csharp_20_structs_enums.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson20 = Lesson(
  language: 'C#',
  title: 'Structs and Enums',
  content: '''
🎯 METAPHOR:
A struct is like a business card.
It has data (name, phone, title), it is small and simple,
and when you hand it to someone, they get their OWN copy —
not a reference to yours. Change yours later, theirs stays
the same. Structs are value types — they travel by copy.

An enum is like a traffic light.
Instead of saying "set the state to 2," you say
"set the state to Red." The label makes the intent
unmistakable. The compiler knows Red is 0, Yellow is 1,
Green is 2 — but you never have to remember those numbers.
Enums replace magic numbers with meaningful names.

📖 EXPLANATION:
STRUCT:
  - Value type — stored on the stack, copied on assignment
  - Cannot be null (unless Nullable<T> / struct?)
  - No inheritance (but can implement interfaces)
  - Best for small, simple data: coordinates, colors, money amounts
  - Default constructor always exists

ENUM:
  - Named set of integer constants
  - Strongly typed (no accidental int mixing without cast)
  - Flags attribute for bitwise combinations

💻 CODE:
using System;

// ─── STRUCT ───
struct Point
{
    public double X { get; }
    public double Y { get; }

    public Point(double x, double y)
    {
        X = x;
        Y = y;
    }

    public double DistanceTo(Point other)
    {
        double dx = X - other.X;
        double dy = Y - other.Y;
        return Math.Sqrt(dx * dx + dy * dy);
    }

    public Point Translate(double dx, double dy) => new(X + dx, Y + dy);

    public override string ToString() => \$"({X}, {Y})";
}

struct Money
{
    public decimal Amount { get; }
    public string Currency { get; }

    public Money(decimal amount, string currency)
    {
        Amount = amount;
        Currency = currency;
    }

    public static Money operator +(Money a, Money b)
    {
        if (a.Currency != b.Currency)
            throw new InvalidOperationException("Currency mismatch");
        return new Money(a.Amount + b.Amount, a.Currency);
    }

    public override string ToString() => \$"{Amount} {Currency}";
}

// ─── ENUM ───
enum DayOfWeekCustom
{
    Monday = 1,    // explicit values
    Tuesday,       // 2 (auto-increment)
    Wednesday,     // 3
    Thursday,
    Friday,
    Saturday,
    Sunday
}

enum HttpStatus
{
    OK          = 200,
    Created     = 201,
    BadRequest  = 400,
    Unauthorized = 401,
    NotFound    = 404,
    ServerError = 500
}

// ─── FLAGS ENUM (bitwise combination) ───
[Flags]
enum Permissions
{
    None    = 0,
    Read    = 1,
    Write   = 2,
    Execute = 4,
    Delete  = 8,
    All     = Read | Write | Execute | Delete
}

class Program
{
    static void Main()
    {
        // ─── STRUCT USAGE ───
        Point p1 = new(0, 0);
        Point p2 = new(3, 4);

        Console.WriteLine(p1.DistanceTo(p2));  // 5
        Console.WriteLine(p2.Translate(1, 1)); // (4, 5)

        // VALUE SEMANTICS — assignment copies
        Point p3 = p1;
        // p3.X = 99;  // would not affect p1 anyway (immutable here)
        Console.WriteLine(p1);  // (0, 0) — unaffected

        // Money struct
        var price   = new Money(10.00m, "USD");
        var tax     = new Money(0.80m, "USD");
        var total   = price + tax;
        Console.WriteLine(total);  // 10.80 USD

        // ─── ENUM USAGE ───
        DayOfWeekCustom today = DayOfWeekCustom.Wednesday;
        Console.WriteLine(today);                      // Wednesday
        Console.WriteLine((int)today);                 // 3

        // Convert from int
        DayOfWeekCustom day = (DayOfWeekCustom)5;
        Console.WriteLine(day);  // Friday

        // Parse from string
        DayOfWeekCustom parsed = Enum.Parse<DayOfWeekCustom>("Monday");
        Console.WriteLine(parsed);  // Monday

        // Safe parse
        if (Enum.TryParse("Saturday", out DayOfWeekCustom sat))
            Console.WriteLine(sat);  // Saturday

        // All values
        foreach (DayOfWeekCustom d in Enum.GetValues<DayOfWeekCustom>())
            Console.Write(d + " ");
        Console.WriteLine();

        // HTTP Status
        HttpStatus status = HttpStatus.OK;
        Console.WriteLine(\$"Status: {(int)status} {status}");  // Status: 200 OK

        // ─── FLAGS ENUM ───
        Permissions userPerms = Permissions.Read | Permissions.Write;
        Console.WriteLine(userPerms);         // Read, Write

        // Check if has a flag
        bool canRead  = userPerms.HasFlag(Permissions.Read);    // True
        bool canDelete = userPerms.HasFlag(Permissions.Delete); // False
        Console.WriteLine(\$"Read: {canRead}, Delete: {canDelete}");

        // Add a permission
        userPerms |= Permissions.Execute;
        Console.WriteLine(userPerms);  // Read, Write, Execute

        // Remove a permission
        userPerms &= ~Permissions.Write;
        Console.WriteLine(userPerms);  // Read, Execute
    }
}

📝 KEY POINTS:
✅ Structs are value types — they are copied on assignment, not referenced
✅ Use structs for small, immutable data: coordinates, money, colors
✅ Enums replace magic numbers with readable names
✅ Use [Flags] when enum values should be combined with bitwise OR
✅ HasFlag() cleanly checks if a flags enum contains a specific flag
❌ Don't make large structs — copying is expensive for big data
❌ Don't add mutable state to structs — mutation through copies causes bugs
❌ Always use [Flags] when values are meant to be OR-combined
''',
  quiz: [
    Quiz(question: 'What is the key difference between a struct and a class in C#?', options: [
      QuizOption(text: 'Structs are value types (copied on assignment); classes are reference types (shared)', correct: true),
      QuizOption(text: 'Structs can inherit from other structs; classes cannot', correct: false),
      QuizOption(text: 'Classes are stored on the stack; structs on the heap', correct: false),
      QuizOption(text: 'Structs can have methods; classes cannot', correct: false),
    ]),
    Quiz(question: 'What does the [Flags] attribute on an enum enable?', options: [
      QuizOption(text: 'Combining multiple enum values with bitwise OR and checking them with HasFlag()', correct: true),
      QuizOption(text: 'Sorting enum values automatically', correct: false),
      QuizOption(text: 'Making enum values start at 1 instead of 0', correct: false),
      QuizOption(text: 'Allowing string values in the enum', correct: false),
    ]),
    Quiz(question: 'When is a struct preferable to a class?', options: [
      QuizOption(text: 'For small, simple, immutable data like coordinates or colors', correct: true),
      QuizOption(text: 'When you need inheritance', correct: false),
      QuizOption(text: 'When the data is large and complex', correct: false),
      QuizOption(text: 'When you need to store the object in a collection', correct: false),
    ]),
  ],
);
