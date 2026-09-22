// lib/lessons/csharp/csharp_34_span_memory.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson34 = Lesson(
  language: 'C#',
  title: 'Span<T> and Memory<T>',
  content: '''
🎯 METAPHOR:
Span<T> is like a window into a wall of bookshelves.
The bookshelf is the actual array in memory. The window
lets you see and interact with a portion of the shelves
without moving any books. You can look at shelves 10-20
(Span over a slice), read book titles, even swap books —
all without creating a new shelf unit. Zero copies.
Zero allocations. Just a view.

Memory<T> is like a photo of that window that you can
email to a colleague. Span<T> can't leave the current
stack frame — too dangerous. Memory<T> is the safe
asynchronous-friendly version you can store and pass around.

📖 EXPLANATION:
Span<T> (C# 7.2+) — a stack-allocated view over contiguous memory.
  - Zero allocation — no heap allocation
  - Can view arrays, stack memory, or unmanaged memory
  - Cannot be stored on the heap (stack-only struct)
  - Cannot be used with async/await
  - Used for high-performance parsing and manipulation

Memory<T> — heap-safe version of Span<T>.
  - Can be stored in fields, used with async
  - Slight overhead vs Span
  - Access .Span to get a Span from it

ReadOnlySpan<T> and ReadOnlyMemory<T> — read-only versions.
  - Strings can be wrapped as ReadOnlySpan<char>
  - Zero-copy string operations

💻 CODE:
using System;
using System.Buffers;
using System.Text;

class Program
{
    static void Main()
    {
        // ─── SPAN OVER ARRAY ───
        int[] array = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

        Span<int> span = array;           // entire array
        Span<int> slice = array.AsSpan(2, 5);  // elements 2-6: {3,4,5,6,7}

        Console.WriteLine(slice[0]);      // 3
        slice[0] = 99;                    // modifies original array!
        Console.WriteLine(array[2]);      // 99

        // ─── SPAN AVOIDS ARRAY ALLOCATION ───
        // Without Span: creates a new sub-array
        int[] subArray = new int[5];
        Array.Copy(array, 2, subArray, 0, 5);  // heap allocation!

        // With Span: zero allocation
        Span<int> subSpan = array.AsSpan(2, 5);  // no allocation

        // ─── READONLY SPAN OVER STRING ───
        // Strings are immutable — ReadOnlySpan<char> is the safe view
        string text = "Hello, World!";
        ReadOnlySpan<char> chars = text.AsSpan();

        ReadOnlySpan<char> hello = text.AsSpan(0, 5);  // "Hello"
        ReadOnlySpan<char> world = text.AsSpan(7, 5);  // "World"

        Console.WriteLine(hello.ToString());  // Hello
        Console.WriteLine(world.ToString());  // World

        // Parse without allocating substrings!
        bool foundComma = chars.IndexOf(',') >= 0;
        Console.WriteLine(foundComma);  // True

        // ─── STACK ALLOCATION WITH SPAN ───
        // Allocate on stack — zero heap pressure
        Span<int> stackBuf = stackalloc int[10];
        for (int i = 0; i < stackBuf.Length; i++)
            stackBuf[i] = i * i;

        foreach (int n in stackBuf)
            Console.Write(n + " ");  // 0 1 4 9 16 25 36 49 64 81
        Console.WriteLine();

        // ─── SPAN SLICING ───
        string csv = "Alice,30,Engineer";
        ReadOnlySpan<char> csvSpan = csv.AsSpan();

        int comma1 = csvSpan.IndexOf(',');
        ReadOnlySpan<char> name = csvSpan[..comma1];

        ReadOnlySpan<char> rest = csvSpan[(comma1 + 1)..];
        int comma2 = rest.IndexOf(',');
        ReadOnlySpan<char> age = rest[..comma2];

        Console.WriteLine(name.ToString());  // Alice
        Console.WriteLine(age.ToString());   // 30

        // ─── MEMORY<T> — async-friendly ───
        Memory<byte> buffer = new byte[1024];
        // Can be stored, passed to async methods
        // buffer.Span to access as Span when needed

        // ─── ARRAYPOOL (reduce allocations) ───
        // Rent a buffer from shared pool
        byte[] rented = ArrayPool<byte>.Shared.Rent(256);
        try
        {
            // Use rented as a regular array
            Span<byte> rentedSpan = rented.AsSpan(0, 256);
            for (int i = 0; i < rentedSpan.Length; i++)
                rentedSpan[i] = (byte)(i % 256);

            Console.WriteLine(\$"Rented buffer[0]: {rented[0]}");
        }
        finally
        {
            ArrayPool<byte>.Shared.Return(rented);  // MUST return!
        }

        // ─── PRACTICAL: Parse integers without allocation ───
        static int ParseInt(ReadOnlySpan<char> s)
        {
            int result = 0;
            foreach (char c in s)
            {
                result = result * 10 + (c - '0');
            }
            return result;
        }

        string numStr = "12345";
        int parsed = ParseInt(numStr.AsSpan());
        Console.WriteLine(parsed);  // 12345
    }
}

─────────────────────────────────────
WHEN TO USE:
─────────────────────────────────────
Span<T>        high-perf sync code, stack work, no async
Memory<T>      when you need to store/pass spans async
ReadOnlySpan   string parsing, zero-copy reads
ArrayPool      large buffers you need temporarily
─────────────────────────────────────

📝 KEY POINTS:
✅ Span<T> provides zero-copy, zero-allocation views over contiguous memory
✅ AsSpan() on strings and arrays creates read access without copying
✅ stackalloc + Span<T> allocates on the stack — fastest possible allocation
✅ Memory<T> is the async-safe alternative when Span cannot be used
✅ ArrayPool<T> reuses large buffers to avoid GC pressure
❌ Span<T> cannot be stored as a field or used with async/await
❌ Always return rented ArrayPool buffers — they are shared resources
''',
  quiz: [
    Quiz(question: 'What is the main advantage of Span<T> over creating a sub-array?', options: [
      QuizOption(text: 'Span<T> creates a view with zero heap allocation — no copy is made', correct: true),
      QuizOption(text: 'Span<T> is thread-safe; arrays are not', correct: false),
      QuizOption(text: 'Span<T> automatically resizes when needed', correct: false),
      QuizOption(text: 'Span<T> supports LINQ operations directly', correct: false),
    ]),
    Quiz(question: 'Why can\'t Span<T> be used with async/await?', options: [
      QuizOption(text: 'Span<T> is a stack-only struct — it cannot be stored on the heap between await points', correct: true),
      QuizOption(text: 'Span<T> is not thread-safe', correct: false),
      QuizOption(text: 'async methods require reference types', correct: false),
      QuizOption(text: 'Span<T> does not support the IAsyncEnumerable interface', correct: false),
    ]),
    Quiz(question: 'What should you always do after renting from ArrayPool<T>.Shared?', options: [
      QuizOption(text: 'Return the buffer with ArrayPool<T>.Shared.Return() when done', correct: true),
      QuizOption(text: 'Call Dispose() on the buffer', correct: false),
      QuizOption(text: 'Set the array reference to null', correct: false),
      QuizOption(text: 'Call GC.Collect() to free the pool memory', correct: false),
    ]),
  ],
);
