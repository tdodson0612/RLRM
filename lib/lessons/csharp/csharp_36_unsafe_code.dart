// lib/lessons/csharp/csharp_36_unsafe_code.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson36 = Lesson(
  language: 'C#',
  title: 'Unsafe Code and Pointers',
  content: '''
🎯 METAPHOR:
Unsafe code is like switching your car from automatic to
manual transmission — with no guardrails on the road.
C#'s managed code is automatic: the runtime handles memory,
prevents crashes, and keeps you safe. Unsafe code hands
you the stick shift and says "you are on your own."
Direct pointer access, no bounds checking, no GC assistance.
You unlock tremendous power and performance — but one
wrong move and the car goes off a cliff.
Most developers never need this. Game engine core,
cryptography, and device drivers are where it lives.

📖 EXPLANATION:
Unsafe code in C# allows:
  - Pointer arithmetic
  - Direct memory access
  - Fixed-size buffers
  - Interop with native C/C++ code

Requires:
  - unsafe keyword on method/block/class
  - /unsafe compiler flag (or <AllowUnsafeBlocks>true</AllowUnsafeBlocks> in .csproj)

fixed statement — pins an object in memory so the GC
cannot move it while you hold a pointer to it.

Most C# developers will never write unsafe code.
Understanding it helps you read performance-critical library code.

💻 CODE:
using System;
using System.Runtime.InteropServices;

class Program
{
    // ─── UNSAFE METHOD ───
    static unsafe void PointerBasics()
    {
        int value = 42;
        int* ptr = &value;   // & = address of

        Console.WriteLine(*ptr);   // 42 — dereference
        *ptr = 99;
        Console.WriteLine(value);  // 99 — modified through pointer

        // Pointer arithmetic
        int[] arr = { 10, 20, 30, 40, 50 };
        fixed (int* p = arr)   // pin array in memory
        {
            for (int i = 0; i < 5; i++)
                Console.Write(*(p + i) + " ");  // 10 20 30 40 50
            Console.WriteLine();

            // Direct element access
            Console.WriteLine(p[2]);  // 30
        }
    }

    // ─── FAST BYTE MANIPULATION ───
    static unsafe void FastCopy(byte[] src, byte[] dst, int count)
    {
        fixed (byte* pSrc = src, pDst = dst)
        {
            Buffer.MemoryCopy(pSrc, pDst, dst.Length, count);
        }
    }

    // ─── STRUCT WITH FIXED BUFFER ───
    unsafe struct Packet
    {
        public int Length;
        public fixed byte Data[64];  // inline fixed-size buffer
    }

    // ─── INTEROP WITH NATIVE CODE ───
    // Calling C library functions
    [DllImport("libc", EntryPoint = "strlen")]
    static extern unsafe int NativeStrLen(byte* str);

    // ─── CASTING THROUGH POINTER (bit reinterpretation) ───
    static unsafe float IntBitsToFloat(int bits)
    {
        return *(float*)&bits;
    }

    // Safer C# 8+ alternative using Unsafe.As:
    static float IntBitsToFloatSafe(int bits)
    {
        return System.Runtime.CompilerServices.Unsafe.As<int, float>(ref bits);
    }

    static unsafe void Main()
    {
        PointerBasics();

        // ─── FAST ARRAY COPY ───
        byte[] source = { 1, 2, 3, 4, 5 };
        byte[] dest = new byte[5];
        FastCopy(source, dest, 5);
        Console.WriteLine(string.Join(", ", dest));  // 1, 2, 3, 4, 5

        // ─── FIXED BUFFER STRUCT ───
        Packet packet;
        packet.Length = 3;
        packet.Data[0] = 0x48;  // 'H'
        packet.Data[1] = 0x69;  // 'i'
        packet.Data[2] = 0x21;  // '!'
        Console.WriteLine(\$"Packet length: {packet.Length}");

        // ─── BIT MANIPULATION ───
        // IEEE 754 — integer bits of PI
        int piAsInt = 0x40490FDB;
        float piFloat = IntBitsToFloat(piAsInt);
        Console.WriteLine(\$"Pi from bits: {piFloat}");  // 3.14159...

        // ─── SAFE ALTERNATIVES (prefer these) ───
        // BitConverter — safe way to do bit conversions
        byte[] floatBytes = BitConverter.GetBytes(3.14159f);
        float backToFloat = BitConverter.ToSingle(floatBytes, 0);
        Console.WriteLine(backToFloat);

        // System.Runtime.CompilerServices.Unsafe
        // MemoryMarshal for Span<T> reinterpretation
        float[] floats = { 1.0f, 2.0f, 3.0f };
        Span<byte> bytes = MemoryMarshal.Cast<float, byte>(floats.AsSpan());
        Console.WriteLine(\$"Bytes in float array: {bytes.Length}");  // 12
    }
}

using System.Runtime.InteropServices;

─────────────────────────────────────
SAFE ALTERNATIVES TO UNSAFE:
─────────────────────────────────────
Pointer arithmetic   → Span<T> slicing
memcpy               → Buffer.BlockCopy / Array.Copy
Bit reinterpretation → BitConverter / MemoryMarshal
Native interop       → P/Invoke with safe marshaling
─────────────────────────────────────

📝 KEY POINTS:
✅ unsafe code requires the /unsafe compiler flag or project setting
✅ fixed pins an object in memory so GC cannot move it during pointer access
✅ Prefer Span<T> and MemoryMarshal for zero-copy operations — no unsafe needed
✅ P/Invoke ([DllImport]) lets you call native C libraries from C#
✅ Unsafe code is never needed for typical application development
❌ Never use unsafe code without understanding the consequences — buffer overflows are real
❌ Don't use unsafe to work around the type system — find a safe solution
''',
  quiz: [
    Quiz(question: 'What does the "fixed" statement do in unsafe C# code?', options: [
      QuizOption(text: 'Pins the object in memory so the GC cannot move it while you hold a pointer', correct: true),
      QuizOption(text: 'Makes the variable constant — cannot be reassigned', correct: false),
      QuizOption(text: 'Fixes a bug in the code at compile time', correct: false),
      QuizOption(text: 'Allocates the object on the stack instead of the heap', correct: false),
    ]),
    Quiz(question: 'What compiler setting is required to use unsafe code in C#?', options: [
      QuizOption(text: '<AllowUnsafeBlocks>true</AllowUnsafeBlocks> in the project file', correct: true),
      QuizOption(text: '<EnableUnsafe>true</EnableUnsafe> in the project file', correct: false),
      QuizOption(text: '#pragma unsafe enable at the top of the file', correct: false),
      QuizOption(text: 'No special setting — unsafe is always available', correct: false),
    ]),
    Quiz(question: 'What is the modern safe alternative to pointer arithmetic for working with array slices?', options: [
      QuizOption(text: 'Span<T> — provides zero-copy views without unsafe code', correct: true),
      QuizOption(text: 'List<T> — always the preferred container', correct: false),
      QuizOption(text: 'ArraySegment<T> — the original slice type', correct: false),
      QuizOption(text: 'IntPtr — a platform-native integer for addresses', correct: false),
    ]),
  ],
);
