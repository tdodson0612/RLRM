// lib/lessons/csharp/csharp_47_checked_overflow.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson47 = Lesson(
  language: 'C#',
  title: 'checked, unchecked, and Numeric Overflow',
  content: '''
🎯 METAPHOR:
Integer overflow is like an odometer that wraps around.
When it reaches 999,999, the next mile shows 000,000.
No error, no warning — it silently wraps to zero.
In code, this can mean a deposit that goes negative,
a counter that wraps to a huge negative number, or a
security check that passes when it should fail.

checked is like adding an alarm to that odometer.
The moment it would wrap, it screams instead of silently
rolling over. Overflow becomes a detectable exception.

unchecked is for when you WANT the wrap behavior —
hash functions, bit manipulation — and you want to
be explicit that you know what you are doing.

📖 EXPLANATION:
By default, C# integer arithmetic is UNCHECKED:
  int.MaxValue + 1 = int.MinValue (wraps silently, no exception)

CHECKED — throws OverflowException if overflow occurs:
  checked { int result = int.MaxValue + 1; }  // throws!

UNCHECKED — explicit: "I know this might overflow, that's OK":
  unchecked { int result = int.MaxValue + 1; }  // -2147483648

Project-wide: add <CheckForOverflowUnderflow>true</CheckForOverflowUnderflow>
to .csproj to make checked the default everywhere.

ALSO:
  float/double NEVER throw on overflow — they produce Infinity or NaN
  decimal ALWAYS throws on overflow (checked by design)

💻 CODE:
using System;

class Program
{
    static void Main()
    {
        // ─── DEFAULT: UNCHECKED (wraps silently) ───
        int max = int.MaxValue;
        Console.WriteLine(max);          // 2147483647
        Console.WriteLine(max + 1);      // -2147483648 (wraps!)
        Console.WriteLine(max + 1 > 0);  // FALSE — dangerous bug!

        byte b = 255;
        b++;  // wraps to 0 silently
        Console.WriteLine(b);  // 0

        // ─── CHECKED BLOCK ───
        try
        {
            checked
            {
                int result = int.MaxValue + 1;  // throws!
                Console.WriteLine(result);       // never reached
            }
        }
        catch (OverflowException ex)
        {
            Console.WriteLine(\$"Overflow caught: {ex.Message}");
        }

        // ─── CHECKED EXPRESSION ───
        try
        {
            int x = checked(int.MaxValue + 1);
        }
        catch (OverflowException)
        {
            Console.WriteLine("Single expression overflow caught");
        }

        // ─── UNCHECKED (explicit) ───
        int wrapped = unchecked(int.MaxValue + 1);
        Console.WriteLine(wrapped);  // -2147483648

        // Hash function — intentional overflow is fine here
        static int BadHash(string s)
        {
            unchecked
            {
                int hash = 17;
                foreach (char c in s)
                    hash = hash * 31 + c;  // overflow is intentional!
                return hash;
            }
        }
        Console.WriteLine(BadHash("hello"));

        // ─── FLOAT/DOUBLE OVERFLOW — NO EXCEPTION ───
        double big = double.MaxValue;
        Console.WriteLine(big * 2);       // Infinity
        Console.WriteLine(double.IsInfinity(big * 2));  // True
        Console.WriteLine(0.0 / 0.0);     // NaN
        Console.WriteLine(double.IsNaN(0.0 / 0.0));    // True

        // ─── DECIMAL ALWAYS THROWS ───
        try
        {
            decimal d = decimal.MaxValue;
            decimal overflow = d + 1m;  // always throws
        }
        catch (OverflowException)
        {
            Console.WriteLine("decimal overflow caught");
        }

        // ─── CHECKED CONVERSIONS ───
        try
        {
            int big2 = 300;
            byte small = checked((byte)big2);  // 300 > 255 — throws!
        }
        catch (OverflowException)
        {
            Console.WriteLine("Conversion overflow caught");
        }

        // ─── INT LIMITS ───
        Console.WriteLine(\$"int.MinValue:  {int.MinValue}");   // -2147483648
        Console.WriteLine(\$"int.MaxValue:  {int.MaxValue}");   //  2147483647
        Console.WriteLine(\$"long.MaxValue: {long.MaxValue}");  //  9223372036854775807
        Console.WriteLine(\$"byte range:    0 to {byte.MaxValue}");   // 0 to 255

        // ─── SAFE MATH ALTERNATIVES ───
        // Math.BigMul: multiply two ints, get long result (no overflow)
        long big3 = Math.BigMul(int.MaxValue, 2);
        Console.WriteLine(big3);  // 4294967294

        // Use long when you expect large values
        long population = 8_000_000_000L;
        Console.WriteLine(population * 100);  // no overflow — long has room
    }
}

─────────────────────────────────────
OVERFLOW BEHAVIOR SUMMARY:
─────────────────────────────────────
Type       Default     checked         unchecked
int/long   wraps       throws          wraps (explicit)
byte/short wraps       throws          wraps (explicit)
float      Infinity    no effect       no effect
double     Infinity    no effect       no effect
decimal    throws      throws (same)   throws (same)
─────────────────────────────────────

📝 KEY POINTS:
✅ Use checked in financial calculations or security-sensitive code
✅ Use unchecked explicitly in hash functions and bit manipulation
✅ decimal always throws on overflow — safest for money
✅ double/float produce Infinity or NaN on overflow — check with IsInfinity/IsNaN
✅ Enable <CheckForOverflowUnderflow>true in .csproj for global checked behavior
❌ Silent integer overflow is a real security vulnerability — NEVER ignore it in critical code
❌ Don't assume +1 to MaxValue produces a reasonable positive number
''',
  quiz: [
    Quiz(question: 'What happens by default when an int overflows in C#?', options: [
      QuizOption(text: 'It wraps around silently — no exception is thrown', correct: true),
      QuizOption(text: 'An OverflowException is thrown', correct: false),
      QuizOption(text: 'The value is clamped to int.MaxValue', correct: false),
      QuizOption(text: 'The program terminates', correct: false),
    ]),
    Quiz(question: 'What does the checked keyword do?', options: [
      QuizOption(text: 'Throws an OverflowException if an integer arithmetic operation overflows', correct: true),
      QuizOption(text: 'Checks the value is within range before assigning', correct: false),
      QuizOption(text: 'Enables bounds checking on array accesses', correct: false),
      QuizOption(text: 'Validates that all variables are initialized', correct: false),
    ]),
    Quiz(question: 'What does double.MaxValue * 2 produce in C#?', options: [
      QuizOption(text: 'Infinity — doubles do not throw on overflow', correct: true),
      QuizOption(text: 'An OverflowException', correct: false),
      QuizOption(text: 'double.MaxValue (clamped)', correct: false),
      QuizOption(text: 'NaN', correct: false),
    ]),
  ],
);
