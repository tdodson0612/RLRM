// lib/lessons/csharp/csharp_65_function_pointers.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson65 = Lesson(
  language: 'C#',
  title: 'Function Pointers and Module Initializers',
  content: '''
🎯 METAPHOR:
A function pointer (delegate*) is like a hardwired phone
connection versus a switchboard. A regular delegate is like
a switchboard operator — it routes your call, but there is
overhead. A function pointer is the direct wire — no operator,
no overhead, no allocation. The call goes straight through.
This is for performance-critical interop code where every
nanosecond counts and you cannot afford delegate allocation.

A module initializer is like a building's master power switch
that flips on automatically when the building opens —
before any tenant (type) turns on their own lights.
It runs before any other code in the assembly, guaranteed.

📖 EXPLANATION:
FUNCTION POINTERS (C# 9, unsafe):
  delegate* <params, return>
  - No allocation — unlike delegate
  - No virtual dispatch
  - Requires unsafe context
  - Perfect for P/Invoke callbacks, hot-path callbacks

CALLING CONVENTIONS:
  delegate* managed    — .NET managed calling convention
  delegate* unmanaged  — any platform calling convention
  delegate* unmanaged[Cdecl]    — C calling convention
  delegate* unmanaged[Stdcall]  — Win32 calling convention
  delegate* unmanaged[Thiscall] — C++ this-call

MODULE INITIALIZERS (C# 9):
  [ModuleInitializer] on a static void method
  - Runs before any code in the assembly
  - Exactly once per assembly load
  - Use for: registering factories, initializing native libraries,
    setting up static state

STATIC ABSTRACT INTERFACE MEMBERS (C# 11):
  static abstract in interfaces — enables generic math

💻 CODE:
using System;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

// ─── MODULE INITIALIZER ───
class AppStartup
{
    [ModuleInitializer]
    internal static void Initialize()
    {
        // Runs before ANYTHING else in this assembly
        Console.WriteLine("[ModuleInitializer] Assembly loaded — running setup");
        // Register codecs, initialize native libraries, set defaults, etc.
        AppDomain.CurrentDomain.UnhandledException += (s, e) =>
            Console.WriteLine(\$"Unhandled: {e.ExceptionObject}");
    }
}

// ─── FUNCTION POINTERS (unsafe) ───
class FunctionPointerDemo
{
    // Methods to point at
    static int Add(int a, int b) => a + b;
    static int Multiply(int a, int b) => a * b;
    static int Max(int a, int b) => a > b ? a : b;

    static unsafe void RunDemo()
    {
        // Function pointer — no delegate allocation!
        delegate*<int, int, int> fp = &Add;
        Console.WriteLine(fp(3, 4));   // 7

        fp = &Multiply;
        Console.WriteLine(fp(3, 4));   // 12

        fp = &Max;
        Console.WriteLine(fp(3, 4));   // 4

        // Array of function pointers
        delegate*<int, int, int>[] ops = { &Add, &Multiply, &Max };
        foreach (var op in ops)
            Console.Write(op(5, 3) + " ");   // 8 15 5
        Console.WriteLine();

        // Function pointer with void return
        delegate*<string, void> printer = &Print;
        printer("Hello from function pointer!");
    }

    static void Print(string s) => Console.WriteLine(s);

    // ─── UNMANAGED FUNCTION POINTER (P/Invoke style) ───
    // For calling or receiving C callbacks
    static unsafe void UnmanagedExample()
    {
        // Receive a C callback as delegate*<int, int, int> unmanaged[Cdecl]
        // (used when passing .NET method to C qsort etc.)
    }
}

// ─── STATIC ABSTRACT INTERFACE MEMBERS (C# 11) ───
interface ICalculator<T> where T : ICalculator<T>
{
    // Static abstract — must be implemented in T
    static abstract T Add(T a, T b);
    static abstract T Multiply(T a, T b);
    static abstract T Zero { get; }
    static abstract T One { get; }
}

struct IntCalc : ICalculator<IntCalc>
{
    public int Value;
    public IntCalc(int v) => Value = v;

    public static IntCalc Add(IntCalc a, IntCalc b) => new(a.Value + b.Value);
    public static IntCalc Multiply(IntCalc a, IntCalc b) => new(a.Value * b.Value);
    public static IntCalc Zero => new(0);
    public static IntCalc One  => new(1);

    public override string ToString() => Value.ToString();
}

static T SumAll<T>(T[] items) where T : ICalculator<T>
{
    T result = T.Zero;
    foreach (T item in items) result = T.Add(result, item);
    return result;
}

// ─── RUNTIME HELPERS ───
class RuntimeHelperExamples
{
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    static int FastAdd(int a, int b) => a + b;  // hint: please inline this

    [MethodImpl(MethodImplOptions.NoInlining)]
    static void DontInlineMe() { }  // keep as a real call site

    [MethodImpl(MethodImplOptions.AggressiveOptimization)]
    static void HotPath()
    {
        // JIT: apply tier-2 optimizations immediately
    }
}

class Program
{
    static unsafe void Main()
    {
        // Module initializer already ran before this
        Console.WriteLine("Main() running");

        FunctionPointerDemo.RunDemo();

        // Static abstract interface members
        var items = new[] { new IntCalc(1), new IntCalc(2), new IntCalc(3), new IntCalc(4) };
        IntCalc sum = SumAll(items);
        Console.WriteLine(\$"Sum: {sum}");  // 10
    }
}

─────────────────────────────────────
DELEGATE vs FUNCTION POINTER:
─────────────────────────────────────
delegate        heap allocation, virtual dispatch, safe
delegate*<>     no allocation, direct call, unsafe
Func<>          delegate wrapper, LINQ-friendly
─────────────────────────────────────

📝 KEY POINTS:
✅ Function pointers have zero allocation overhead — use in hot P/Invoke paths
✅ [ModuleInitializer] runs before all other code — once per assembly load
✅ Static abstract interface members enable generic math without boxing
✅ [MethodImpl(AggressiveInlining)] hints to JIT to inline small methods
✅ Function pointers require unsafe context — use only when performance demands it
❌ Function pointers cannot be stored in managed object fields easily
❌ Module initializers run in any order — don't depend on another assembly's initializer
''',
  quiz: [
    Quiz(question: 'What is the main advantage of delegate* over delegate?', options: [
      QuizOption(text: 'No heap allocation and direct call — no delegate object created', correct: true),
      QuizOption(text: 'delegate* supports more calling conventions', correct: false),
      QuizOption(text: 'delegate* can be used without unsafe context', correct: false),
      QuizOption(text: 'delegate* works with virtual methods', correct: false),
    ]),
    Quiz(question: 'When does a [ModuleInitializer] method run?', options: [
      QuizOption(text: 'Before any other code in the assembly runs — once on assembly load', correct: true),
      QuizOption(text: 'When the first instance of the containing class is created', correct: false),
      QuizOption(text: 'At program shutdown', correct: false),
      QuizOption(text: 'When explicitly called by the program entry point', correct: false),
    ]),
    Quiz(question: 'What do static abstract interface members (C# 11) enable?', options: [
      QuizOption(text: 'Writing generic algorithms that work on any type implementing the interface\'s static operations', correct: true),
      QuizOption(text: 'Calling static methods without an instance', correct: false),
      QuizOption(text: 'Sharing static state between all implementing types', correct: false),
      QuizOption(text: 'Creating interfaces with default static method implementations', correct: false),
    ]),
  ],
);
