// lib/lessons/csharp/csharp_03_variables_types.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson03 = Lesson(
  language: 'C#',
  title: 'Variables and Data Types',
  content: '''
🎯 METAPHOR:
Types in C# are like containers at a restaurant supply store.
A shot glass (byte) holds a tiny amount.
A pint glass (int) holds a comfortable amount.
A pitcher (long) holds a lot.
A measuring cup (double) handles precise quantities.
Each container is the right size for its job — and you
cannot pour a pitcher into a shot glass without spilling
(overflow). The type system prevents those spills at compile time.

📖 EXPLANATION:
C# is strongly and statically typed. Every variable has
a type that is fixed at compile time.

─────────────────────────────────────
VALUE TYPES (stored on the stack):
─────────────────────────────────────
byte        1 byte    0 to 255
sbyte       1 byte    -128 to 127
short       2 bytes   -32,768 to 32,767
ushort      2 bytes   0 to 65,535
int         4 bytes   -2.1B to 2.1B          ← most common
uint        4 bytes   0 to 4.3B
long        8 bytes   very large integers
ulong       8 bytes   very large positive
float       4 bytes   ~7 decimal digits
double      8 bytes   ~15 decimal digits      ← most common
decimal     16 bytes  28-29 digits (financial!)
bool        1 byte    true / false
char        2 bytes   single Unicode character
─────────────────────────────────────

REFERENCE TYPES (stored on the heap):
  string    sequence of chars (immutable)
  object    base of all types
  dynamic   bypasses compile-time type checking
  arrays, classes, interfaces, delegates

VAR — type inference:
  var x = 42;       compiler deduces int
  var s = "hello";  compiler deduces string
  Type is still fixed at compile time — just inferred.

💻 CODE:
using System;

class Program
{
    static void Main()
    {
        // Integer types
        int age = 25;
        long population = 8_000_000_000L;   // digit separator
        byte level = 255;

        // Floating point
        float temperature = 36.6f;    // f suffix required for float
        double pi = 3.14159265358979;
        decimal price = 19.99m;       // m suffix for decimal (use for money!)

        // Boolean and char
        bool isOnline = true;
        char grade = 'A';

        // String
        string name = "Alice";
        string empty = "";
        string nullable = null;   // strings can be null

        // var — type inferred
        var count = 100;        // int
        var ratio = 0.75;       // double
        var message = "Hi!";    // string

        // Type checking
        Console.WriteLine(age.GetType());       // System.Int32
        Console.WriteLine(name.GetType());      // System.String

        // Implicit conversion (safe, no data loss)
        int x = 100;
        long y = x;       // int → long (widening)
        double z = x;     // int → double (widening)

        // Explicit cast (may lose data)
        double d = 9.99;
        int truncated = (int)d;   // 9 — decimal dropped!
        Console.WriteLine(truncated);

        // Convert class (safer conversions)
        string numStr = "42";
        int parsed = Convert.ToInt32(numStr);
        int parsed2 = int.Parse(numStr);        // throws if invalid
        bool ok = int.TryParse("abc", out int result); // safe parse
        Console.WriteLine(ok);      // false
        Console.WriteLine(result);  // 0 (default)

        // Constants
        const double TAX_RATE = 0.08;
        // TAX_RATE = 0.1;  // ERROR: const cannot be changed

        // Default values
        int defaultInt = default;        // 0
        bool defaultBool = default;      // false
        string defaultStr = default;     // null
    }
}

─────────────────────────────────────
DECIMAL vs DOUBLE for money:
─────────────────────────────────────
double price = 0.1 + 0.2;
Console.WriteLine(price);  // 0.30000000000000004 ← floating point error!

decimal price2 = 0.1m + 0.2m;
Console.WriteLine(price2); // 0.3 ← exact!
─────────────────────────────────────

📝 KEY POINTS:
✅ Use int for whole numbers, double for decimals, decimal for money
✅ Digit separators _ make large numbers readable: 1_000_000
✅ var infers the type — it is still static, not dynamic
✅ Use int.TryParse for user input — don't crash on bad input
✅ decimal is exact for base-10 fractions — always use for currency
❌ Don't use float — use double; float loses precision too easily
❌ double is NOT exact for base-10 decimals — never use for money
''',
  quiz: [
    Quiz(question: 'Which type should you use for currency calculations in C#?', options: [
      QuizOption(text: 'decimal', correct: true),
      QuizOption(text: 'double', correct: false),
      QuizOption(text: 'float', correct: false),
      QuizOption(text: 'long', correct: false),
    ]),
    Quiz(question: 'What does "var" do in C#?', options: [
      QuizOption(text: 'Lets the compiler infer the type — it is still statically typed', correct: true),
      QuizOption(text: 'Creates a dynamically typed variable', correct: false),
      QuizOption(text: 'Creates a variable that can change type at runtime', correct: false),
      QuizOption(text: 'Declares a variable without initializing it', correct: false),
    ]),
    Quiz(question: 'What is the difference between int.Parse() and int.TryParse()?', options: [
      QuizOption(text: 'Parse throws on invalid input; TryParse returns false and does not throw', correct: true),
      QuizOption(text: 'They are identical in all cases', correct: false),
      QuizOption(text: 'TryParse throws; Parse returns false', correct: false),
      QuizOption(text: 'Parse only works with strings; TryParse works with any type', correct: false),
    ]),
  ],
);
