// lib/lessons/csharp/csharp_28_operator_overloading.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson28 = Lesson(
  language: 'C#',
  title: 'Operator Overloading',
  content: '''
🎯 METAPHOR:
Operator overloading is teaching C# what "plus" means
for YOUR type. For numbers, + is obvious. But what does
it mean to add two Vectors? Two Colors? Two Money amounts?
You define it. Once you do, vec1 + vec2 works naturally,
reads clearly, and feels like the language was built for it.
You are extending the vocabulary of C#'s operators to
speak your domain's language.

📖 EXPLANATION:
You can redefine how operators work for your custom types.

OVERLOADABLE operators:
  Arithmetic:   + - * / % ++ --
  Comparison:   == != < > <= >=
  Logical:      ! ~ & | ^ << >>
  Conversion:   implicit, explicit

RULES:
  - Must be a static method in the class/struct
  - At least one parameter must be the containing type
  - If you overload == you MUST overload !=
  - If you overload < you SHOULD overload >
  - Override Equals() and GetHashCode() when overloading ==

CONVERSION OPERATORS:
  implicit — automatic, no cast needed (safe, no data loss)
  explicit — requires cast (potential data loss)

💻 CODE:
using System;

struct Vector2D
{
    public double X { get; }
    public double Y { get; }

    public Vector2D(double x, double y) { X = x; Y = y; }

    // Arithmetic
    public static Vector2D operator +(Vector2D a, Vector2D b)
        => new(a.X + b.X, a.Y + b.Y);

    public static Vector2D operator -(Vector2D a, Vector2D b)
        => new(a.X - b.X, a.Y - b.Y);

    public static Vector2D operator *(Vector2D v, double scalar)
        => new(v.X * scalar, v.Y * scalar);

    public static Vector2D operator *(double scalar, Vector2D v)
        => v * scalar;  // delegate to above

    public static Vector2D operator -(Vector2D v)
        => new(-v.X, -v.Y);  // unary negation

    // Comparison — if you overload ==, must overload !=
    public static bool operator ==(Vector2D a, Vector2D b)
        => a.X == b.X && a.Y == b.Y;

    public static bool operator !=(Vector2D a, Vector2D b)
        => !(a == b);

    // Must override Equals and GetHashCode when overloading ==
    public override bool Equals(object obj)
        => obj is Vector2D v && this == v;

    public override int GetHashCode()
        => HashCode.Combine(X, Y);

    public double Length => Math.Sqrt(X * X + Y * Y);

    public override string ToString() => \$"({X}, {Y})";
}

// ─── CONVERSION OPERATORS ───
struct Celsius
{
    public double Degrees { get; }
    public Celsius(double d) => Degrees = d;

    // Implicit: Celsius → double (safe — just the number)
    public static implicit operator double(Celsius c) => c.Degrees;

    // Explicit: double → Celsius (could be any double, might be wrong)
    public static explicit operator Celsius(double d) => new(d);

    public override string ToString() => \$"{Degrees}°C";
}

struct Fahrenheit
{
    public double Degrees { get; }
    public Fahrenheit(double d) => Degrees = d;

    // Explicit conversion between temperature types
    public static explicit operator Celsius(Fahrenheit f)
        => new((f.Degrees - 32) * 5.0 / 9.0);

    public static explicit operator Fahrenheit(Celsius c)
        => new(c.Degrees * 9.0 / 5.0 + 32);

    public override string ToString() => \$"{Degrees}°F";
}

// ─── FULL EXAMPLE: Money type ───
struct Money
{
    public decimal Amount { get; }
    public string Currency { get; }

    public Money(decimal amount, string currency)
    {
        Amount = amount; Currency = currency;
    }

    public static Money operator +(Money a, Money b)
    {
        if (a.Currency != b.Currency)
            throw new InvalidOperationException("Cannot add different currencies");
        return new(a.Amount + b.Amount, a.Currency);
    }

    public static Money operator *(Money m, decimal factor)
        => new(m.Amount * factor, m.Currency);

    public static bool operator >(Money a, Money b)
        => a.Amount > b.Amount;

    public static bool operator <(Money a, Money b)
        => a.Amount < b.Amount;

    public static bool operator ==(Money a, Money b)
        => a.Amount == b.Amount && a.Currency == b.Currency;

    public static bool operator !=(Money a, Money b) => !(a == b);

    public override bool Equals(object obj) => obj is Money m && this == m;
    public override int GetHashCode() => HashCode.Combine(Amount, Currency);
    public override string ToString() => \$"{Amount:F2} {Currency}";
}

class Program
{
    static void Main()
    {
        // ─── VECTOR ───
        var v1 = new Vector2D(3, 4);
        var v2 = new Vector2D(1, 2);

        Console.WriteLine(v1 + v2);    // (4, 6)
        Console.WriteLine(v1 - v2);    // (2, 2)
        Console.WriteLine(v1 * 2.0);   // (6, 8)
        Console.WriteLine(3.0 * v1);   // (9, 12)
        Console.WriteLine(-v1);         // (-3, -4)
        Console.WriteLine(v1.Length);  // 5
        Console.WriteLine(v1 == new Vector2D(3, 4));  // True

        // ─── CONVERSIONS ───
        Celsius boiling = new(100);
        double temp = boiling;  // implicit — no cast needed
        Console.WriteLine(temp);  // 100

        Celsius fromDouble = (Celsius)37.0;  // explicit cast required
        Console.WriteLine(fromDouble);  // 37°C

        Fahrenheit body = (Fahrenheit)new Celsius(37);
        Console.WriteLine(body);  // 98.6°F

        Celsius back = (Celsius)body;
        Console.WriteLine(back);  // ~37°C

        // ─── MONEY ───
        var price = new Money(10.00m, "USD");
        var tax   = new Money(0.80m, "USD");
        var total = price + tax;
        Console.WriteLine(total);        // 10.80 USD

        var doubled = price * 2m;
        Console.WriteLine(doubled);      // 20.00 USD

        Console.WriteLine(price < total);  // True
    }
}

📝 KEY POINTS:
✅ Always override Equals() and GetHashCode() when overloading ==
✅ If you overload ==, you must overload != too
✅ If you overload <, overload > as well for consistency
✅ Implicit conversion is for safe, lossless conversions
✅ Explicit conversion (cast required) signals potential data loss or failure
❌ Don't overload operators to mean unintuitive things — + should feel like addition
❌ Don't forget the commutative case: if v * 2 works, also define 2 * v
''',
  quiz: [
    Quiz(question: 'If you overload the == operator, what else MUST you overload?', options: [
      QuizOption(text: 'The != operator', correct: true),
      QuizOption(text: 'The Equals() method', correct: false),
      QuizOption(text: 'The > and < operators', correct: false),
      QuizOption(text: 'The GetHashCode() method', correct: false),
    ]),
    Quiz(question: 'What is the difference between implicit and explicit conversion operators?', options: [
      QuizOption(text: 'Implicit converts automatically; explicit requires a cast and signals potential data loss', correct: true),
      QuizOption(text: 'Explicit converts automatically; implicit requires a cast', correct: false),
      QuizOption(text: 'They are identical — just different naming conventions', correct: false),
      QuizOption(text: 'Implicit only works with value types; explicit with reference types', correct: false),
    ]),
    Quiz(question: 'What must be true about operator overload methods?', options: [
      QuizOption(text: 'They must be static and at least one parameter must be the containing type', correct: true),
      QuizOption(text: 'They must be instance methods with no parameters', correct: false),
      QuizOption(text: 'They must return the same type as the containing class', correct: false),
      QuizOption(text: 'They must be public and virtual', correct: false),
    ]),
  ],
);
