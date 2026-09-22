// lib/lessons/csharp/csharp_26_value_vs_reference.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson26 = Lesson(
  language: 'C#',
  title: 'Value Types vs Reference Types',
  content: '''
🎯 METAPHOR:
Value types are like cash. When you hand someone \$20,
they get their OWN \$20. You still have yours. Changes
to theirs do not affect yours — they are independent copies.

Reference types are like a shared Google Doc.
When you "hand" someone the document, you both have
the SAME document. If they edit it, you see the changes.
You did not give them a copy — you gave them the address.

Understanding this distinction prevents some of the most
confusing bugs in C# development.

📖 EXPLANATION:
─────────────────────────────────────
VALUE TYPES — stored directly on the stack (or inline)
─────────────────────────────────────
int, double, bool, char, float, decimal
All numeric types, struct, enum
DateTime, TimeSpan, Guid (all structs)

Assignment COPIES the value.
Passing to a method COPIES the value.
Two variables NEVER share the same value.

─────────────────────────────────────
REFERENCE TYPES — stored on the heap, variable holds address
─────────────────────────────────────
class, string, array, interface, delegate
object, dynamic

Assignment copies the REFERENCE (address).
Passing to a method copies the REFERENCE.
Two variables CAN point to the same object.
─────────────────────────────────────

💻 CODE:
using System;

class Counter
{
    public int Value { get; set; }
}

struct Point
{
    public int X, Y;
}

class Program
{
    static void ModifyValue(int n)
    {
        n = 999;  // changes LOCAL copy only
    }

    static void ModifyRef(Counter c)
    {
        c.Value = 999;  // changes the ACTUAL object!
    }

    static void ReplaceRef(Counter c)
    {
        c = new Counter { Value = 42 };  // changes local variable only
        // caller's reference is NOT changed
    }

    static void Main()
    {
        // ─── VALUE TYPE COPY ───
        int a = 10;
        int b = a;   // b is an independent copy
        b = 99;
        Console.WriteLine(a);  // 10 — unaffected

        Point p1 = new Point { X = 1, Y = 2 };
        Point p2 = p1;   // copy
        p2.X = 99;
        Console.WriteLine(p1.X);  // 1 — unaffected

        // ─── REFERENCE TYPE SHARING ───
        var c1 = new Counter { Value = 10 };
        var c2 = c1;   // both point to same object
        c2.Value = 99;
        Console.WriteLine(c1.Value);  // 99 — SAME object!

        // ─── METHOD PARAMETER BEHAVIOR ───
        int num = 5;
        ModifyValue(num);
        Console.WriteLine(num);  // 5 — unchanged (copy passed)

        var counter = new Counter { Value = 5 };
        ModifyRef(counter);
        Console.WriteLine(counter.Value);  // 999 — object was modified

        var counter2 = new Counter { Value = 5 };
        ReplaceRef(counter2);
        Console.WriteLine(counter2.Value);  // 5 — reference replacement didn't affect caller

        // ─── NULL ───
        // Value types CANNOT be null (without ?)
        // int x = null;  // ERROR
        int? x = null;    // OK — Nullable<int>

        // Reference types CAN be null
        Counter c = null;
        // c.Value;  // NullReferenceException!

        // ─── EQUALITY BEHAVIOR ───
        // Value types: == compares VALUES
        int i1 = 5, i2 = 5;
        Console.WriteLine(i1 == i2);  // True

        // Reference types: == compares REFERENCES by default
        var obj1 = new Counter { Value = 5 };
        var obj2 = new Counter { Value = 5 };
        Console.WriteLine(obj1 == obj2);  // False (different objects!)
        Console.WriteLine(obj1.Value == obj2.Value);  // True (same values)

        // string is special — == compares content
        string s1 = "hello";
        string s2 = "hello";
        Console.WriteLine(s1 == s2);  // True (content comparison)

        // ─── ARRAYS ARE REFERENCE TYPES ───
        int[] arr1 = { 1, 2, 3 };
        int[] arr2 = arr1;  // both reference same array
        arr2[0] = 99;
        Console.WriteLine(arr1[0]);  // 99 — same array!

        // To copy an array:
        int[] arr3 = (int[])arr1.Clone();
        arr3[0] = 0;
        Console.WriteLine(arr1[0]);  // 99 — unaffected

        // ─── BOXING AND UNBOXING ───
        int val = 42;
        object boxed = val;    // boxing: value type → reference type (heap allocation!)
        int unboxed = (int)boxed;  // unboxing: back to value type

        Console.WriteLine(unboxed);  // 42

        // Boxing is implicit, unboxing requires cast
        // Avoid in hot paths — heap allocation + cast overhead
    }
}

─────────────────────────────────────
QUICK REFERENCE:
─────────────────────────────────────
Type       Category   Null?   Copy on assign?   == compares
int/struct  value     no*     yes               values
class       reference  yes    no (copies ref)   references
string      reference  yes    no (copies ref)   content (special)
array       reference  yes    no (copies ref)   references
─────────────────────────────────────

📝 KEY POINTS:
✅ Value types copy data; reference types copy addresses
✅ Modifying an object through any reference affects ALL references
✅ Replacing a reference parameter inside a method does NOT affect the caller
✅ Arrays are reference types — arr2 = arr1 shares the same array
✅ Boxing wraps a value type in an object on the heap — avoid in hot loops
❌ Don't assume == compares content for classes — override Equals() if needed
❌ Don't confuse "passing a reference type" with "passing by reference" (ref keyword)
''',
  quiz: [
    Quiz(question: 'What happens when you assign one struct variable to another?', options: [
      QuizOption(text: 'A full copy is made — both variables are independent', correct: true),
      QuizOption(text: 'Both variables point to the same struct on the heap', correct: false),
      QuizOption(text: 'Only the reference is copied', correct: false),
      QuizOption(text: 'A shallow copy is made — nested objects are shared', correct: false),
    ]),
    Quiz(question: 'What is boxing in C#?', options: [
      QuizOption(text: 'Wrapping a value type in an object reference, allocating it on the heap', correct: true),
      QuizOption(text: 'Encapsulating a class in a struct', correct: false),
      QuizOption(text: 'Converting a reference type to a value type', correct: false),
      QuizOption(text: 'Storing a value type in a collection', correct: false),
    ]),
    Quiz(question: 'If you pass a class instance to a method and the method reassigns the parameter to a new object, what happens to the caller\'s variable?', options: [
      QuizOption(text: 'Nothing — the caller\'s reference is unchanged', correct: true),
      QuizOption(text: 'The caller\'s variable also points to the new object', correct: false),
      QuizOption(text: 'The caller\'s variable becomes null', correct: false),
      QuizOption(text: 'A compile error occurs', correct: false),
    ]),
  ],
);
