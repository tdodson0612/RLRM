// lib/lessons/csharp/csharp_62_numeric_types.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson62 = Lesson(
  language: 'C#',
  title: 'Advanced Numeric Types',
  content: '''
🎯 METAPHOR:
Most programming lives in the middle of the number line —
ints and doubles handle everyday math. But sometimes you
need the extremes. BigInteger is a number that can grow
as large as your RAM allows — no overflow possible, ever.
Half is a number so small it fits in 2 bytes — perfect for
ML models that need to pack millions of weights in memory.
Complex is a two-dimensional number for signal processing
and electrical engineering. BitOperations is the toolkit
for treating numbers as pure bit patterns — the deepest
level of numeric manipulation.

📖 EXPLANATION:
STANDARD NUMERICS (recap):
  byte, sbyte, short, ushort, int, uint, long, ulong
  float, double, decimal
  nint, nuint (C# 9 — native-size integers, platform-dependent)

SPECIAL NUMERIC TYPES:
  BigInteger (System.Numerics)  — arbitrary precision integer
  Complex    (System.Numerics)  — complex numbers (a + bi)
  Half       (System.Half)      — 16-bit float (ML/GPU)
  Int128/UInt128 (C# 11)       — 128-bit integers
  BitOperations (System.Numerics) — bit manipulation helpers

MATH HELPERS:
  Math         — double operations
  MathF        — float operations (avoids float→double cast)
  BitOperations — PopCount, LeadingZeroCount, Log2, etc.

💻 CODE:
using System;
using System.Numerics;

class Program
{
    static void Main()
    {
        // ─── BIGINTEGER ───
        BigInteger big = BigInteger.Parse("99999999999999999999999999999999");
        BigInteger bigger = big * big;  // no overflow!
        Console.WriteLine(bigger);

        BigInteger factorial = 1;
        for (int i = 1; i <= 50; i++)
            factorial *= i;
        Console.WriteLine(\$"50! = {factorial}");  // 50 digits!

        Console.WriteLine(BigInteger.IsPow2(1024));  // True
        Console.WriteLine(BigInteger.Log(big, 10));  // ~32 (digits)
        Console.WriteLine(BigInteger.GreatestCommonDivisor(12, 8));  // 4

        // ─── COMPLEX NUMBERS ───
        var c1 = new Complex(3, 4);   // 3 + 4i
        var c2 = new Complex(1, 2);   // 1 + 2i

        Console.WriteLine(c1 + c2);       // (4, 6)    = 4 + 6i
        Console.WriteLine(c1 * c2);       // (-5, 10)  = -5 + 10i
        Console.WriteLine(c1.Magnitude);  // 5.0 (|3+4i| = sqrt(9+16))
        Console.WriteLine(c1.Phase);      // angle in radians
        Console.WriteLine(Complex.Conjugate(c1));  // (3, -4)

        // Euler's formula: e^(iπ) + 1 = 0
        Complex ePi = Complex.Exp(new Complex(0, Math.PI));
        Console.WriteLine(\$"e^(iπ) = {ePi.Real:F6} + {ePi.Imaginary:F6}i");
        // ≈ -1 + 0i

        // ─── HALF (16-bit float) ───
        Half h1 = (Half)3.14f;
        Half h2 = (Half)2.71f;
        Console.WriteLine(h1);                           // 3.14
        Console.WriteLine((float)(h1 + h2));             // ~5.85
        Console.WriteLine(Half.MaxValue);                // 65504
        Console.WriteLine(sizeof(Half));                 // 2 bytes

        // ─── INT128 / UINT128 (C# 11) ───
        Int128 i128 = Int128.MaxValue;
        Console.WriteLine(i128);  // 170141183460469231731687303715884105727
        Int128 result = i128 - 1;
        Console.WriteLine(result);

        UInt128 u128 = new UInt128(0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF);
        Console.WriteLine(u128);  // max value

        // ─── NINT / NUINT (platform-native integer) ───
        nint native = 42;           // 4 bytes on 32-bit, 8 bytes on 64-bit
        nuint uNative = 100;
        Console.WriteLine(nint.Size);  // 8 (on 64-bit)

        // ─── MATHF (float operations — no casting) ───
        float angle = 45f;
        float radians = angle * MathF.PI / 180f;
        Console.WriteLine(MathF.Sin(radians));  // ~0.707
        Console.WriteLine(MathF.Sqrt(2f));      // 1.4142

        // ─── BITOPERATIONS ───
        uint x = 0b_1010_1100;
        Console.WriteLine(BitOperations.PopCount(x));         // 4 (bits set)
        Console.WriteLine(BitOperations.LeadingZeroCount(x)); // 24
        Console.WriteLine(BitOperations.TrailingZeroCount(x));// 2
        Console.WriteLine(BitOperations.Log2(64u));           // 6
        Console.WriteLine(BitOperations.IsPow2(64u));         // True

        // Round up to next power of 2
        Console.WriteLine(BitOperations.RoundUpToPowerOf2(7u));  // 8
        Console.WriteLine(BitOperations.RoundUpToPowerOf2(100u)); // 128

        // Rotate bits
        uint rotated = BitOperations.RotateLeft(x, 2);
        Console.WriteLine(Convert.ToString(rotated, 2).PadLeft(8, '0'));

        // ─── NUMERIC PARSING AND LIMITS ───
        Console.WriteLine(double.IsNaN(0.0 / 0.0));    // True
        Console.WriteLine(double.IsInfinity(1.0 / 0)); // True
        Console.WriteLine(double.IsFinite(42.0));       // True
        Console.WriteLine(double.Epsilon);              // smallest positive double
        Console.WriteLine(double.NaN == double.NaN);   // False! (NaN != NaN)
        Console.WriteLine(double.IsNaN(double.NaN));   // True — correct check
    }
}

📝 KEY POINTS:
✅ BigInteger never overflows — use for cryptography, factorials, large integers
✅ Complex enables signal processing, FFT, electrical engineering math
✅ Half uses 2 bytes — essential for ML model weights and GPU buffers
✅ Int128/UInt128 (C# 11) fills the gap between long and BigInteger
✅ BitOperations is the fast way to count bits, find log2, check powers of 2
✅ MathF avoids float→double promotion — use for float-heavy computation
❌ double.NaN != double.NaN always — use double.IsNaN() to check for NaN
❌ Half has limited precision (~3 decimal digits) — not for financial work
''',
  quiz: [
    Quiz(question: 'What is the main advantage of BigInteger over long?', options: [
      QuizOption(text: 'BigInteger can represent arbitrarily large integers without overflow', correct: true),
      QuizOption(text: 'BigInteger is faster for small numbers', correct: false),
      QuizOption(text: 'BigInteger supports decimal fractions', correct: false),
      QuizOption(text: 'BigInteger uses less memory than long', correct: false),
    ]),
    Quiz(question: 'Why use MathF instead of Math for float operations?', options: [
      QuizOption(text: 'MathF avoids implicit float-to-double promotion, keeping calculations in float precision', correct: true),
      QuizOption(text: 'MathF is more accurate than Math', correct: false),
      QuizOption(text: 'Math does not support float parameters', correct: false),
      QuizOption(text: 'MathF runs on the GPU automatically', correct: false),
    ]),
    Quiz(question: 'What does double.NaN == double.NaN return?', options: [
      QuizOption(text: 'false — NaN is never equal to anything including itself', correct: true),
      QuizOption(text: 'true — same value', correct: false),
      QuizOption(text: 'A NullReferenceException', correct: false),
      QuizOption(text: 'It depends on the platform', correct: false),
    ]),
  ],
);
