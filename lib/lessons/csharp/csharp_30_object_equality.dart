// lib/lessons/csharp/csharp_30_object_equality.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson30 = Lesson(
  language: 'C#',
  title: 'The Object Class and Equality',
  content: '''
🎯 METAPHOR:
System.Object is like the first ancestor in every family tree.
No matter how exotic the family (class hierarchy), everyone
traces back to the same great-great-grandparent: object.
Every class in C# inherits from object, whether you write
it or not. That ancestor donates a set of basic behaviors
to every descendant: the ability to describe yourself
(ToString), prove your identity (GetHashCode), and determine
if you are the same as someone else (Equals).

📖 EXPLANATION:
System.Object is the root of C#'s type hierarchy.
Every class implicitly inherits from it.

KEY METHODS ON OBJECT:
  ToString()      — text representation
  Equals()        — equality check
  GetHashCode()   — hash code (used in Dictionary, HashSet)
  GetType()       — runtime type information
  MemberwiseClone() — shallow copy (protected)

THE EQUALITY CONTRACT:
  If a == b, then:
    a.Equals(b) must return true
    a.GetHashCode() == b.GetHashCode() must be true
  Objects that are Equal MUST have the same hash code.
  Objects with the same hash code MAY NOT be equal (collision).

IEquatable<T> — strongly-typed equality interface.
  Avoids boxing and provides type-safe Equals(T other).

IComparable<T> — for ordering/sorting.
  Returns negative, zero, or positive.

💻 CODE:
using System;
using System.Collections.Generic;

// ─── PROPER EQUALITY IMPLEMENTATION ───
class Point : IEquatable<Point>
{
    public int X { get; }
    public int Y { get; }

    public Point(int x, int y) { X = x; Y = y; }

    // IEquatable<T> — strongly typed, avoids boxing
    public bool Equals(Point other)
    {
        if (other is null) return false;
        return X == other.X && Y == other.Y;
    }

    // Override object.Equals for general equality
    public override bool Equals(object obj) => Equals(obj as Point);

    // MUST override GetHashCode when overriding Equals!
    // Equal objects MUST have equal hash codes
    public override int GetHashCode() => HashCode.Combine(X, Y);

    // Operator overloads for natural syntax
    public static bool operator ==(Point a, Point b)
    {
        if (a is null && b is null) return true;
        if (a is null || b is null) return false;
        return a.Equals(b);
    }
    public static bool operator !=(Point a, Point b) => !(a == b);

    public override string ToString() => \$"Point({X}, {Y})";
}

// ─── COMPARABLE (for sorting) ───
class Student : IComparable<Student>, IEquatable<Student>
{
    public string Name { get; }
    public double GPA { get; }

    public Student(string name, double gpa) { Name = name; GPA = gpa; }

    // IComparable: negative = this before other, 0 = equal, positive = after
    public int CompareTo(Student other)
    {
        if (other is null) return 1;
        return GPA.CompareTo(other.GPA);  // sort by GPA ascending
    }

    public bool Equals(Student other)
        => other is not null && Name == other.Name && GPA == other.GPA;

    public override bool Equals(object obj) => Equals(obj as Student);
    public override int GetHashCode() => HashCode.Combine(Name, GPA);

    public override string ToString() => \$"{Name} ({GPA:F1})";
}

class Program
{
    static void Main()
    {
        // ─── DEFAULT OBJECT BEHAVIOR ───
        object o = new object();
        Console.WriteLine(o.ToString());      // System.Object
        Console.WriteLine(o.GetType().Name);  // Object
        Console.WriteLine(o.GetHashCode());   // some int

        // ─── CUSTOM EQUALITY ───
        var p1 = new Point(3, 4);
        var p2 = new Point(3, 4);
        var p3 = new Point(1, 2);

        Console.WriteLine(p1.Equals(p2));  // True
        Console.WriteLine(p1 == p2);       // True
        Console.WriteLine(p1 == p3);       // False
        Console.WriteLine(p1 != p3);       // True

        // Works correctly in Dictionary and HashSet
        var dict = new Dictionary<Point, string>();
        dict[p1] = "origin-ish";
        Console.WriteLine(dict[p2]);  // "origin-ish" — p2 found via p1's hash!

        var set = new HashSet<Point> { p1, p2, p3 };
        Console.WriteLine(set.Count);  // 2 (p1 and p2 are equal)

        // ─── COMPARABLE — sorting ───
        var students = new List<Student>
        {
            new("Alice", 3.8),
            new("Bob",   2.9),
            new("Charlie", 3.5),
            new("Diana", 3.8),
        };

        students.Sort();  // uses IComparable<Student>
        foreach (var s in students)
            Console.WriteLine(s);
        // Bob (2.9), Charlie (3.5), Alice (3.8), Diana (3.8)

        // ─── REFERENCE vs VALUE EQUALITY ───
        object obj1 = new object();
        object obj2 = obj1;
        object obj3 = new object();

        Console.WriteLine(ReferenceEquals(obj1, obj2));  // True (same object)
        Console.WriteLine(ReferenceEquals(obj1, obj3));  // False (different objects)

        // ─── OBJECT CLONE (shallow) ───
        // MemberwiseClone is protected — expose it if needed
        // Deep copy requires manual implementation or serialization
    }
}

─────────────────────────────────────
EQUALITY CONTRACT SUMMARY:
─────────────────────────────────────
Override Equals()      → define what makes two objects equal
Override GetHashCode() → REQUIRED when overriding Equals
Override ==, !=        → for natural syntax
Implement IEquatable<T> → type-safe, avoids boxing
Implement IComparable<T> → for Sort(), OrderBy()
─────────────────────────────────────

📝 KEY POINTS:
✅ Always override GetHashCode() when you override Equals()
✅ Equal objects MUST have equal hash codes — Dictionary/HashSet depend on this
✅ Implement IEquatable<T> for type-safe equality without boxing
✅ Implement IComparable<T> to make your type sortable
✅ Use ReferenceEquals() to check if two references point to the exact same object
❌ Breaking the Equals/GetHashCode contract causes silent bugs in collections
❌ Never include mutable fields in GetHashCode — changing them breaks dictionary keys
''',
  quiz: [
    Quiz(question: 'What is the contract between Equals() and GetHashCode()?', options: [
      QuizOption(text: 'If two objects are Equal, they must have the same hash code', correct: true),
      QuizOption(text: 'If two objects have the same hash code, they must be Equal', correct: false),
      QuizOption(text: 'GetHashCode must always return a unique value per object', correct: false),
      QuizOption(text: 'Equals and GetHashCode are independent — no relationship', correct: false),
    ]),
    Quiz(question: 'Why implement IEquatable<T> in addition to overriding object.Equals()?', options: [
      QuizOption(text: 'It provides a type-safe Equals(T) overload that avoids boxing', correct: true),
      QuizOption(text: 'It is required by the compiler when overriding Equals()', correct: false),
      QuizOption(text: 'It enables the == operator automatically', correct: false),
      QuizOption(text: 'It makes the class sortable', correct: false),
    ]),
    Quiz(question: 'What does IComparable<T>.CompareTo() return when "this" comes before "other"?', options: [
      QuizOption(text: 'A negative integer', correct: true),
      QuizOption(text: 'A positive integer', correct: false),
      QuizOption(text: 'Zero', correct: false),
      QuizOption(text: 'false', correct: false),
    ]),
  ],
);
