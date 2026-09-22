// lib/lessons/csharp/csharp_18_nullable_types.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson18 = Lesson(
  language: 'C#',
  title: 'Nullable Types and Null Safety',
  content: '''
🎯 METAPHOR:
null is like an empty envelope.
You can pass it around, but when someone opens it expecting
a letter and finds nothing — crash. NullReferenceException
is C#'s most common runtime error, nicknamed "the billion
dollar mistake" by its inventor Tony Hoare.

Nullable value types (int?) are like a gift box with a
"might be empty" label. You have to check before opening.
Nullable reference types (C# 8+ NRT) are like a postal
system that refuses to deliver unlabeled envelopes —
it forces you to acknowledge what might be empty upfront.

📖 EXPLANATION:
TWO kinds of nullable in C#:

1. Nullable VALUE TYPES (int?, bool?, double?)
   Value types (int, bool, etc.) normally cannot be null.
   The ? suffix wraps them so they CAN be null.
   Use for: optional data, database NULL values, missing values.

2. Nullable REFERENCE TYPES (C# 8+ feature, enabled in project)
   Adds compiler warnings when reference types might be null.
   string? means "this string might be null"
   string  means "this string is guaranteed non-null"
   Use #nullable enable to turn this feature on.

💻 CODE:
using System;

class Program
{
    static void Main()
    {
        // ─── NULLABLE VALUE TYPES ───
        int? age = null;
        double? weight = 72.5;
        bool? agreed = null;

        // Check before using
        if (age.HasValue)
            Console.WriteLine(\$"Age: {age.Value}");
        else
            Console.WriteLine("Age not provided");

        // GetValueOrDefault
        int displayAge = age.GetValueOrDefault(0);  // 0 if null
        int displayAge2 = age ?? 0;                  // same with ??
        Console.WriteLine(displayAge);               // 0

        // Nullable arithmetic (propagates null)
        int? a = 5;
        int? b = null;
        Console.WriteLine(a + b);  // null (not 5!)
        Console.WriteLine(a + 3);  // 8

        // Casting nullable
        int? n = 42;
        int nonNull = (int)n;      // throws if n is null!
        int safe    = n ?? -1;     // -1 if null (safe)

        // ─── NULL COALESCING CHAIN ───
        string first  = null;
        string second = null;
        string third  = "Found it!";
        string result = first ?? second ?? third;
        Console.WriteLine(result);  // Found it!

        // ─── NULL CONDITIONAL OPERATOR (?.) ───
        string text = null;
        int? len = text?.Length;   // null — no crash
        Console.WriteLine(len);    // (blank)

        string upper = text?.ToUpper() ?? "DEFAULT";
        Console.WriteLine(upper);  // DEFAULT

        // ─── NULL COALESCING ASSIGNMENT (??=) ───
        string config = null;
        config ??= "default_config";  // assign only if null
        Console.WriteLine(config);    // default_config

        config ??= "other";           // config is NOT null now — skip
        Console.WriteLine(config);    // default_config

        // ─── NULLABLE REFERENCE TYPES (C# 8+) ───
        // #nullable enable  ← add to top of file or project

        // With NRT enabled:
        // string name = null;     // Warning: null assigned to non-nullable
        // string? name = null;    // OK: explicitly nullable

        // ─── PATTERN MATCHING WITH NULL ───
        object obj = null;
        string description = obj switch
        {
            null   => "it's null",
            int i  => \$"integer: {i}",
            string s => \$"string: {s}",
            _      => "something else"
        };
        Console.WriteLine(description);  // it's null

        // is null vs == null
        object o = null;
        Console.WriteLine(o is null);     // True (safe, no operator overload)
        Console.WriteLine(o == null);     // True (but can be overloaded!)

        // ─── NULLABLE IN CLASSES ───
        var person = new Person("Alice", null);
        Console.WriteLine(person.Email ?? "No email");  // No email
    }
}

class Person
{
    public string Name { get; }       // guaranteed non-null
    public string? Email { get; }     // might be null

    public Person(string name, string? email)
    {
        Name = name ?? throw new ArgumentNullException(nameof(name));
        Email = email;
    }
}

─────────────────────────────────────
NULL OPERATOR CHEAT SHEET:
─────────────────────────────────────
??    null coalescing:    a ?? b   → a if not null, else b
??=   null assign:        a ??= b  → a = b if a is null
?.    null conditional:   a?.b     → null if a is null
!     null forgiving:     a!.b     → suppress null warning
is null   safe null check (no operator overload)
─────────────────────────────────────

📝 KEY POINTS:
✅ int? allows value types to represent "no value"
✅ Always use ?? or HasValue before accessing a nullable value
✅ ?. prevents NullReferenceException — use it on any possibly-null reference
✅ ??= is clean for "initialize if not already set" patterns
✅ Use "is null" rather than "== null" for reliable null checks
❌ (int)n throws if n is null — use n.Value only after HasValue check
❌ Nullable arithmetic propagates null — n + 3 is null if n is null
''',
  quiz: [
    Quiz(question: 'What does "int?" mean in C#?', options: [
      QuizOption(text: 'A nullable int — can hold an integer value or null', correct: true),
      QuizOption(text: 'An optional int that defaults to zero', correct: false),
      QuizOption(text: 'An int that throws if accessed when not set', correct: false),
      QuizOption(text: 'A pointer to an int', correct: false),
    ]),
    Quiz(question: 'What does the ??= operator do?', options: [
      QuizOption(text: 'Assigns the right value only if the left variable is currently null', correct: true),
      QuizOption(text: 'Checks if both sides are null', correct: false),
      QuizOption(text: 'Throws if the right side is null', correct: false),
      QuizOption(text: 'Compares two nullable values', correct: false),
    ]),
    Quiz(question: 'Why is "is null" preferred over "== null" for null checks?', options: [
      QuizOption(text: 'is null cannot be overloaded — always a reliable null check', correct: true),
      QuizOption(text: 'is null works with value types; == null does not', correct: false),
      QuizOption(text: 'is null is faster at runtime', correct: false),
      QuizOption(text: 'is null is required for nullable reference types', correct: false),
    ]),
  ],
);
