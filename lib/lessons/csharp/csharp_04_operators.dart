// lib/lessons/csharp/csharp_04_operators.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson04 = Lesson(
  language: 'C#',
  title: 'Operators',
  content: '''
🎯 METAPHOR:
Operators are the action words of programming — the verbs
that make things happen to your data. Just like a carpenter
has different tools for different jobs (hammer, saw, drill),
C# has different operators for different operations.
Using the wrong one — like sawing where you should hammer —
gives you unexpected results. Know your tools.

📖 EXPLANATION:
C# operators fall into categories. Most are shared with C++,
but C# adds some powerful modern ones.

─────────────────────────────────────
ARITHMETIC:
─────────────────────────────────────
+   addition          5 + 3 = 8
-   subtraction       5 - 3 = 2
*   multiplication    5 * 3 = 15
/   division          7 / 2 = 3  (integer!) 7.0 / 2 = 3.5
%   modulo            7 % 2 = 1
++  increment         x++ or ++x
--  decrement         x-- or --x

COMPARISON (return bool):
==  equal             5 == 5 → true
!=  not equal         5 != 3 → true
<   less than         3 < 5  → true
>   greater than      5 > 3  → true
<=  less or equal
>=  greater or equal

LOGICAL:
&&  AND    true && false → false
||  OR     true || false → true
!   NOT    !true → false

ASSIGNMENT:
=   assign
+=  add assign       x += 3
-=  subtract assign
*=  multiply assign
/=  divide assign
%=  modulo assign

C# SPECIAL OPERATORS:
??  null coalescing      a ?? b  → a if not null, else b
?.  null conditional     obj?.Method()  → call only if not null
!   null forgiving       obj!.Method()  → suppress null warning
is  type check           x is string
as  safe cast            x as string (null if fails)
=>  lambda / expression  x => x * x
─────────────────────────────────────

💻 CODE:
using System;

class Program
{
    static void Main()
    {
        // Arithmetic
        int a = 10, b = 3;
        Console.WriteLine(a / b);       // 3 (integer division)
        Console.WriteLine(a % b);       // 1 (remainder)
        Console.WriteLine((double)a / b); // 3.333...

        // Compound assignment
        int score = 100;
        score += 50;    // 150
        score *= 2;     // 300
        score -= 100;   // 200

        // ─── NULL COALESCING (??) ───
        // Returns left side if not null, else right side
        string name = null;
        string displayName = name ?? "Anonymous";
        Console.WriteLine(displayName);  // Anonymous

        string title = "Alice";
        string result = title ?? "Unknown";
        Console.WriteLine(result);  // Alice

        // ??= null coalescing assignment (C# 8+)
        string label = null;
        label ??= "Default";
        Console.WriteLine(label);  // Default

        // ─── NULL CONDITIONAL (?.) ───
        // Calls method/property only if object is not null
        string text = null;
        int? length = text?.Length;  // null, not a crash!
        Console.WriteLine(length);   // (blank — null)

        string text2 = "Hello";
        Console.WriteLine(text2?.ToUpper());  // HELLO

        // Chain them
        string[] arr = null;
        int? firstLen = arr?[0]?.Length;  // null — no crash

        // ─── IS OPERATOR ───
        object obj = "hello";
        if (obj is string s)   // pattern matching is
        {
            Console.WriteLine(s.ToUpper());  // HELLO
        }

        // ─── AS OPERATOR ───
        object obj2 = 42;
        string str = obj2 as string;   // null — not a string
        Console.WriteLine(str ?? "not a string");

        // ─── TERNARY ───
        int age = 20;
        string status = age >= 18 ? "adult" : "minor";
        Console.WriteLine(status);  // adult

        // ─── SWITCH EXPRESSION (C# 8+) ───
        int day = 3;
        string dayName = day switch
        {
            1 => "Monday",
            2 => "Tuesday",
            3 => "Wednesday",
            4 => "Thursday",
            5 => "Friday",
            _ => "Weekend"   // _ is the default
        };
        Console.WriteLine(dayName);  // Wednesday
    }
}

📝 KEY POINTS:
✅ ?? is one of C#'s most useful operators — use it constantly for null handling
✅ ?. prevents NullReferenceException — the most common C# runtime error
✅ is with pattern matching assigns to a variable in the same expression
✅ as returns null instead of throwing — use when failure is expected
✅ Switch expressions (=>) are cleaner than switch statements for simple mapping
❌ Don't use == to compare strings containing null — use ?? or ?. first
❌ (int)obj throws if wrong type; obj as int? returns null — pick based on intent
''',
  quiz: [
    Quiz(question: 'What does the ?? operator do in C#?', options: [
      QuizOption(text: 'Returns the left value if not null, otherwise returns the right value', correct: true),
      QuizOption(text: 'Checks if both values are null', correct: false),
      QuizOption(text: 'Throws an exception if the left value is null', correct: false),
      QuizOption(text: 'Converts null to an empty string', correct: false),
    ]),
    Quiz(question: 'What does obj?.Method() do when obj is null?', options: [
      QuizOption(text: 'Returns null without throwing an exception', correct: true),
      QuizOption(text: 'Throws a NullReferenceException', correct: false),
      QuizOption(text: 'Calls the method on a default object', correct: false),
      QuizOption(text: 'Returns false', correct: false),
    ]),
    Quiz(question: 'What is the difference between (Type)obj and obj as Type?', options: [
      QuizOption(text: '(Type)obj throws on failure; "as" returns null on failure', correct: true),
      QuizOption(text: '"as" throws on failure; (Type)obj returns null', correct: false),
      QuizOption(text: 'They are identical', correct: false),
      QuizOption(text: '"as" only works with value types', correct: false),
    ]),
  ],
);
