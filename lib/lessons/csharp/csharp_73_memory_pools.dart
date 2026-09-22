// lib/lessons/csharp/csharp_73_memory_pools.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson73 = Lesson(
  language: 'C#',
  title: 'MemoryPool, ObjectPool, and Allocation Optimization',
  content: '''
🎯 METAPHOR:
Object pooling is like a library instead of a bookstore.
Every time you need a book (buffer, object), instead of
buying a new one (heap allocation), you check it out from
the library (pool). When done, you return it. The library
reuses the same books — dramatically reducing printing costs
(GC pressure). The key rule: ALWAYS return what you borrow.
A book never returned is a memory leak.

MemoryPool is the same idea but for memory buffers specifically —
a shared pool of byte arrays that can be rented, used, and
returned. Eliminates the #1 source of GC pressure in
high-throughput systems: short-lived large arrays.

📖 EXPLANATION:
ARRAYPOOL<T>:
  - Shared pool of arrays
  - Rent: ArrayPool<T>.Shared.Rent(minLength)
  - Return: ArrayPool<T>.Shared.Return(array)
  - Returned arrays MAY be larger than requested
  - Clear on return is optional (default: false, for perf)

MEMORYPOOL<T>:
  - Returns IMemoryOwner<T> — IDisposable wrapper
  - Safer than ArrayPool — using statement ensures return
  - MemoryPool<byte>.Shared is the standard shared pool

OBJECTPOOL<T> (Microsoft.Extensions.ObjectPool):
  - For expensive objects: StringBuilder, regex, DB connections
  - Get() / Return() pattern
  - DefaultObjectPool<T> with configurable policies

STACKALLOC + SPAN:
  - Zero allocation — stack memory
  - Prefer for small, short-lived buffers < 1KB

💻 CODE:
using System;
using System.Buffers;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.ObjectPool;

class Program
{
    static void Main()
    {
        // ─── ARRAYPOOL ───
        // Rent a buffer (may be larger than requested)
        byte[] buffer = ArrayPool<byte>.Shared.Rent(1024);
        Console.WriteLine(\$"Rented: {buffer.Length} bytes");

        try
        {
            // Use buffer
            buffer[0] = 42;
            buffer[1] = 99;
            Console.WriteLine(\$"{buffer[0]}, {buffer[1]}");
        }
        finally
        {
            // MUST return — even if exception
            ArrayPool<byte>.Shared.Return(buffer, clearArray: true);
            Console.WriteLine("Buffer returned");
        }

        // ─── ARRAYPOOL WITH SPAN ───
        byte[] rented = ArrayPool<byte>.Shared.Rent(256);
        Span<byte> span = rented.AsSpan(0, 256);  // work within rented size
        span.Fill(7);
        Console.WriteLine(\$"span[0] = {span[0]}");  // 7
        ArrayPool<byte>.Shared.Return(rented);

        // ─── MEMORYPOOL ───
        // IMemoryOwner<T> is IDisposable — using ensures return
        using IMemoryOwner<byte> owner = MemoryPool<byte>.Shared.Rent(512);
        Memory<byte> memory = owner.Memory;
        Console.WriteLine(\$"Memory length: {memory.Length}");

        Span<byte> memSpan = memory.Span;
        memSpan[0] = 1; memSpan[1] = 2;
        Console.WriteLine(\$"{memSpan[0]}, {memSpan[1]}");
        // Returned automatically when owner is disposed

        // ─── OBJECTPOOL (StringBuilder) ───
        var provider = new DefaultObjectPoolProvider();
        ObjectPool<StringBuilder> sbPool = provider.CreateStringBuilderPool();

        StringBuilder sb = sbPool.Get();
        try
        {
            sb.Append("Hello ");
            sb.Append("World");
            Console.WriteLine(sb.ToString());
        }
        finally
        {
            sbPool.Return(sb);  // StringBuilder is cleared and returned
        }

        // ─── CUSTOM OBJECT POOL ───
        var expensivePool = new DefaultObjectPool<ExpensiveObject>(
            new DefaultPooledObjectPolicy<ExpensiveObject>());

        ExpensiveObject obj = expensivePool.Get();
        obj.DoWork();
        expensivePool.Return(obj);

        // ─── STACKALLOC FOR SMALL BUFFERS ───
        // Zero allocation — on the stack
        Span<int> small = stackalloc int[16];
        for (int i = 0; i < small.Length; i++) small[i] = i;
        Console.WriteLine(\$"stackalloc[0..4]: {small[0]},{small[1]},{small[2]},{small[3]}");

        // Threshold: use stackalloc for small, ArrayPool for large
        const int StackAllocThreshold = 128;
        int size = 200;

        if (size <= StackAllocThreshold)
        {
            Span<byte> stackBuf = stackalloc byte[size];
            ProcessBuffer(stackBuf);
        }
        else
        {
            byte[] heapBuf = ArrayPool<byte>.Shared.Rent(size);
            try { ProcessBuffer(heapBuf.AsSpan(0, size)); }
            finally { ArrayPool<byte>.Shared.Return(heapBuf); }
        }

        // ─── MEASURING ALLOCATION (BenchmarkDotNet approach) ───
        long before = GC.GetAllocatedBytesForCurrentThread();

        // Zero-allocation string parsing
        ReadOnlySpan<char> text = "Alice,30,Engineer".AsSpan();
        int comma1 = text.IndexOf(',');
        ReadOnlySpan<char> name = text[..comma1];
        Console.WriteLine(name.ToString());  // Alice

        long after = GC.GetAllocatedBytesForCurrentThread();
        Console.WriteLine(\$"Allocated: {after - before} bytes");  // ~28 (just the ToString)
    }

    static void ProcessBuffer(Span<byte> buffer)
    {
        buffer.Fill(0xFF);
        Console.WriteLine(\$"Processed {buffer.Length} bytes");
    }
}

class ExpensiveObject
{
    public ExpensiveObject() { Console.WriteLine("ExpensiveObject created"); }
    public void DoWork() => Console.WriteLine("Working...");
}

─────────────────────────────────────
ALLOCATION OPTIMIZATION HIERARCHY:
─────────────────────────────────────
Cheapest:  stackalloc (stack, no GC)
Cheap:     ArrayPool<T>.Shared (reuse)
Medium:    MemoryPool<T>.Shared (safer reuse)
Expensive: new byte[] (heap, GC pressure)
─────────────────────────────────────

📝 KEY POINTS:
✅ Use ArrayPool<T>.Shared for temporary large arrays — dramatically reduces GC
✅ Always return rented arrays in a finally block
✅ MemoryPool<T> with IMemoryOwner<T> uses IDisposable — safer than ArrayPool
✅ Use stackalloc for small short-lived buffers (< ~1KB)
✅ ObjectPool<T> is ideal for expensive-to-create objects like StringBuilder
❌ Never use a rented array after returning it — it may be given to another caller
❌ Don't return dirty arrays to ArrayPool without clearArray: true when data is sensitive
''',
  quiz: [
    Quiz(question: 'What does ArrayPool<T>.Shared.Rent(1024) guarantee about the returned array?', options: [
      QuizOption(text: 'The array has at least 1024 elements — it may be larger', correct: true),
      QuizOption(text: 'The array has exactly 1024 elements', correct: false),
      QuizOption(text: 'The array is initialized to zero', correct: false),
      QuizOption(text: 'The array is on the stack', correct: false),
    ]),
    Quiz(question: 'Why is IMemoryOwner<T> preferred over directly using ArrayPool in some cases?', options: [
      QuizOption(text: 'It implements IDisposable so "using" ensures the memory is returned automatically', correct: true),
      QuizOption(text: 'It provides better performance than ArrayPool', correct: false),
      QuizOption(text: 'It works with async methods while ArrayPool does not', correct: false),
      QuizOption(text: 'It allocates on the stack instead of the heap', correct: false),
    ]),
    Quiz(question: 'When should you use stackalloc instead of ArrayPool?', options: [
      QuizOption(text: 'For small, short-lived buffers under ~1KB where zero allocation is critical', correct: true),
      QuizOption(text: 'For all array operations — stackalloc is always faster', correct: false),
      QuizOption(text: 'When working with async methods', correct: false),
      QuizOption(text: 'When the array needs to be passed to async methods', correct: false),
    ]),
  ],
);
