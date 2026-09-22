// lib/lessons/csharp/csharp_61_ref_structs_ref_returns.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson61 = Lesson(
  language: 'C#',
  title: 'ref Structs, ref Returns, and ref Locals',
  content: '''
🎯 METAPHOR:
A ref return is like handing someone a remote control for
your TV — not a copy of the TV, the actual remote that
controls YOUR TV. When they press a button (assign a value),
your TV changes. You gave them a REFERENCE to your data,
not a copy of it.

A ref struct is like a message that can ONLY exist in
this room right now — it cannot be put in a box, mailed,
or stored somewhere for later. It lives on the stack and
ONLY on the stack. This is the key restriction of Span<T>
— you cannot put a Span in a class field or use it with
async/await because it must stay on the stack.

📖 EXPLANATION:
REF LOCALS:
  ref int x = ref someArray[0];  — x is an alias for that element
  Modifying x modifies the original.

REF RETURNS:
  return ref someField;  — caller gets a reference to your field
  Caller can read AND write through it.

REF STRUCTS (C# 7.2+):
  struct that can ONLY live on the stack.
  Cannot be:
    - A field in a class or non-ref struct
    - Boxed (assigned to object/interface)
    - Used in async methods or iterators
    - Captured by a lambda
  Span<T> and ReadOnlySpan<T> are ref structs.

READONLY REF RETURNS:
  ref readonly — caller can read but not write through the reference.

💻 CODE:
using System;
using System.Runtime.CompilerServices;

class Program
{
    // ─── REF RETURN ───
    static int[] _data = { 10, 20, 30, 40, 50 };

    static ref int GetElement(int index)
    {
        if (index < 0 || index >= _data.Length)
            throw new IndexOutOfRangeException();
        return ref _data[index];  // return reference to array element
    }

    // ─── REF READONLY RETURN ───
    static ref readonly int GetReadOnly(int index)
        => ref _data[index];  // caller can read but not write

    // ─── REF IN METHODS (pass large structs without copy) ───
    struct BigStruct
    {
        public double A, B, C, D, E, F, G, H;  // 64 bytes
        public double Sum() => A + B + C + D + E + F + G + H;
    }

    static double ProcessLarge(in BigStruct bs)  // 'in' = ref readonly parameter
        => bs.Sum();  // no copy of 64 bytes — just a reference

    static void Increment(ref int value) => value++;

    // ─── REF STRUCT ───
    ref struct StackBuffer
    {
        private Span<int> _span;

        public StackBuffer(Span<int> span) { _span = span; }

        public int this[int i]
        {
            get => _span[i];
            set => _span[i] = value;
        }

        public int Length => _span.Length;

        public void Fill(int value) => _span.Fill(value);
    }

    // ─── SPAN<T> IS A REF STRUCT ───
    static void SpanRefStructDemo()
    {
        // Stack allocation — no heap at all
        Span<int> stackData = stackalloc int[10];
        stackData.Fill(7);
        Console.WriteLine(stackData[0]);  // 7

        // Can slice without allocation
        Span<int> middle = stackData.Slice(3, 4);
        middle[0] = 99;
        Console.WriteLine(stackData[3]);  // 99 — same memory!

        // Span over array
        int[] arr = { 1, 2, 3, 4, 5 };
        Span<int> arrSpan = arr;
        arrSpan[0] = 42;
        Console.WriteLine(arr[0]);  // 42 — modified original

        // Span over string (ReadOnlySpan)
        ReadOnlySpan<char> text = "Hello, World!".AsSpan();
        ReadOnlySpan<char> hello = text[..5];
        Console.WriteLine(hello.ToString());  // Hello

        // CANNOT do this (ref struct restriction):
        // Func<int> capture = () => stackData[0];  // ERROR: cannot capture
        // await SomeAsync();  // ERROR: cannot use across await
    }

    static void Main()
    {
        // ─── REF LOCAL ───
        int[] arr = { 1, 2, 3, 4, 5 };
        ref int element = ref arr[2];  // alias for arr[2]
        Console.WriteLine(element);    // 3
        element = 99;
        Console.WriteLine(arr[2]);     // 99 — original changed!

        // ─── REF RETURN ───
        ref int el = ref GetElement(1);
        Console.WriteLine(el);         // 20
        el = 200;                      // modify original array!
        Console.WriteLine(_data[1]);   // 200

        // ─── REF READONLY — cannot write ───
        ref readonly int ro = ref GetReadOnly(0);
        Console.WriteLine(ro);  // 10
        // ro = 5;              // ERROR: ref readonly

        // ─── IN PARAMETER (readonly ref) ───
        var big = new BigStruct { A = 1, B = 2, C = 3, D = 4 };
        double sum = ProcessLarge(in big);  // no 64-byte copy!
        Console.WriteLine(sum);

        // ─── REF PARAMETER ───
        int x = 5;
        Increment(ref x);
        Console.WriteLine(x);  // 6

        // ─── CUSTOM REF STRUCT ───
        Span<int> buffer = stackalloc int[5];
        var sb2 = new StackBuffer(buffer);
        sb2.Fill(7);
        sb2[2] = 42;
        Console.WriteLine(\$"[{sb2[0]}, {sb2[1]}, {sb2[2]}, ...]");  // [7, 7, 42, ...]

        SpanRefStructDemo();
    }
}

📝 KEY POINTS:
✅ ref returns let callers modify your private data through a reference — use carefully
✅ ref readonly returns give read access without a copy — great for large structs
✅ in parameters pass by reference but prevent modification — zero-copy read-only
✅ ref structs (Span, StackBuffer) are stack-only — cannot escape to heap
✅ stackalloc + Span gives you stack memory with bounds checking — zero GC pressure
❌ Never return ref to a local variable — the local is gone when the method returns
❌ ref structs cannot be used across await points or captured in lambdas
''',
  quiz: [
    Quiz(question: 'What does a ref return from a method allow the caller to do?', options: [
      QuizOption(text: 'Read and write the original variable through the returned reference', correct: true),
      QuizOption(text: 'Get a copy of the variable with faster access', correct: false),
      QuizOption(text: 'Call methods on the returned value without null checks', correct: false),
      QuizOption(text: 'Return multiple values from a method', correct: false),
    ]),
    Quiz(question: 'Why can\'t a ref struct be used in an async method?', options: [
      QuizOption(text: 'Ref structs are stack-only and cannot survive across await points where the stack changes', correct: true),
      QuizOption(text: 'Async methods require reference types', correct: false),
      QuizOption(text: 'Ref structs do not implement IAsyncDisposable', correct: false),
      QuizOption(text: 'The compiler does not support ref structs in async context yet', correct: false),
    ]),
    Quiz(question: 'What does the "in" parameter modifier do?', options: [
      QuizOption(text: 'Passes the argument by reference but prevents the method from modifying it', correct: true),
      QuizOption(text: 'Passes the argument by value into the method', correct: false),
      QuizOption(text: 'Marks the parameter as optional', correct: false),
      QuizOption(text: 'Requires the argument to implement an interface', correct: false),
    ]),
  ],
);
