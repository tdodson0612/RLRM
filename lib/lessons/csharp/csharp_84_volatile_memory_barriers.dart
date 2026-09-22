// lib/lessons/csharp/csharp_84_volatile_memory_barriers.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson84 = Lesson(
  language: 'C#',
  title: 'Volatile, Memory Barriers, and Interlocked',
  content: '''
🎯 METAPHOR:
Modern CPUs and compilers are secretly optimistic — they
reorder instructions and cache values in registers to go
faster. This is normally invisible and safe for single-threaded
code. But in multi-threaded code, two threads might see
different "versions" of the same variable because one thread's
change is still sitting in a register or CPU cache, not yet
written to shared RAM.

volatile is like demanding someone read directly from the
official notice board — not their personal copy, not their
memory, not a cached version. Every read goes to the
source of truth. Every write immediately posts to the board.

Memory barriers are explicit checkpoints: "before you go
any further, make sure everything written before this point
is visible to everyone." Thread.MemoryBarrier() is the
enforcer that says "no reordering allowed here."

📖 EXPLANATION:
VOLATILE KEYWORD:
  Prevents compiler and CPU from caching a field in a register.
  Every read reads from main memory.
  Every write writes directly to main memory.
  Does NOT make compound operations atomic (++ is still unsafe).
  Use for: flags, status fields read/written by multiple threads.

THREAD.MEMORYBARRIER():
  Inserts a full memory fence.
  Prevents reads/writes from being moved across the barrier.
  Use when: you need ordering guarantees without a lock.

VOLATILE CLASS (System.Threading.Volatile):
  Volatile.Read<T>(ref field)   — volatile read
  Volatile.Write<T>(ref field, value) — volatile write
  More explicit than the volatile keyword.

INTERLOCKED CLASS:
  Atomic operations — safe without locks.
  Interlocked.Increment(ref int)
  Interlocked.Decrement(ref int)
  Interlocked.Add(ref int, int)
  Interlocked.Exchange(ref int, int)       — atomic swap
  Interlocked.CompareExchange(ref, val, comparand)  — CAS
  Interlocked.Read(ref long)               — atomic 64-bit read

💻 CODE:
using System;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;

class Program
{
    // ─── VOLATILE FIELD ───
    // Without volatile: compiler might cache _running in a register
    // Thread 1 sets _running = false but Thread 2 never sees the change
    private static volatile bool _running = true;

    static void VolatileDemo()
    {
        var worker = new Thread(() =>
        {
            int count = 0;
            // _running is re-read from memory each iteration (volatile)
            while (_running)
            {
                count++;
                Thread.SpinWait(100);
            }
            Console.WriteLine(\$"Worker stopped after {count} iterations");
        });

        worker.Start();
        Thread.Sleep(100);
        _running = false;  // visible to worker immediately (volatile)
        worker.Join();
    }

    // ─── VOLATILE CLASS (explicit, no keyword needed) ───
    private static int _status = 0;  // no volatile keyword needed

    static void VolatileClassDemo()
    {
        // Explicit volatile read/write
        int current = Volatile.Read(ref _status);
        Console.WriteLine(\$"Status: {current}");

        Volatile.Write(ref _status, 1);
        Console.WriteLine(\$"Status updated: {Volatile.Read(ref _status)}");
    }

    // ─── MEMORY BARRIER ───
    private static int _data = 0;
    private static bool _dataReady = false;

    static void MemoryBarrierDemo()
    {
        // Producer
        var producer = new Thread(() =>
        {
            _data = 42;
            Thread.MemoryBarrier();  // ensure _data write visible before _dataReady
            _dataReady = true;
        });

        // Consumer
        var consumer = new Thread(() =>
        {
            while (!_dataReady)
                Thread.SpinWait(10);
            Thread.MemoryBarrier();  // ensure _dataReady read visible before _data read
            Console.WriteLine(\$"Got data: {_data}");  // guaranteed to see 42
        });

        consumer.Start();
        producer.Start();
        producer.Join();
        consumer.Join();
    }

    // ─── INTERLOCKED FULL API ───
    private static int _counter = 0;
    private static long _longCounter = 0;

    static void InterlockedDemo()
    {
        // Increment/Decrement — atomic, returns NEW value
        int newVal = Interlocked.Increment(ref _counter);
        Console.WriteLine(\$"After increment: {newVal}");  // 1

        Interlocked.Decrement(ref _counter);
        Console.WriteLine(\$"After decrement: {_counter}");  // 0

        // Add — atomic add, returns new value
        int result = Interlocked.Add(ref _counter, 10);
        Console.WriteLine(\$"After add 10: {result}");  // 10

        // Exchange — atomic swap, returns OLD value
        int old = Interlocked.Exchange(ref _counter, 99);
        Console.WriteLine(\$"Old: {old}, New: {_counter}");  // Old: 10, New: 99

        // CompareExchange (CAS — Compare and Swap):
        // If _counter == 99, set it to 100 and return old value (99)
        // If _counter != 99, do nothing and return current value
        int prev = Interlocked.CompareExchange(ref _counter, 100, 99);
        Console.WriteLine(\$"CAS: prev={prev}, counter={_counter}");  // prev=99, counter=100

        // Read — atomic 64-bit read (important on 32-bit platforms)
        long val = Interlocked.Read(ref _longCounter);
        Console.WriteLine(\$"Long: {val}");

        // ─── LOCK-FREE COUNTER ───
        int sharedCounter = 0;
        var tasks = new List<Task>();
        for (int i = 0; i < 1000; i++)
            tasks.Add(Task.Run(() => Interlocked.Increment(ref sharedCounter)));
        Task.WaitAll(tasks.ToArray());
        Console.WriteLine(\$"Lock-free counter: {sharedCounter}");  // 1000

        // ─── CAS PATTERN: lock-free update ───
        int spinCounter = 0;
        tasks.Clear();
        for (int i = 0; i < 1000; i++)
        {
            tasks.Add(Task.Run(() =>
            {
                int current, newValue;
                do
                {
                    current = spinCounter;
                    newValue = current + 1;
                    // Retry if someone else changed it between read and write
                } while (Interlocked.CompareExchange(ref spinCounter, newValue, current) != current);
            }));
        }
        Task.WaitAll(tasks.ToArray());
        Console.WriteLine(\$"CAS counter: {spinCounter}");  // 1000
    }

    static void Main()
    {
        Console.WriteLine("=== Volatile ===");
        VolatileDemo();

        Console.WriteLine("\n=== Volatile Class ===");
        VolatileClassDemo();

        Console.WriteLine("\n=== Memory Barrier ===");
        MemoryBarrierDemo();

        Console.WriteLine("\n=== Interlocked ===");
        InterlockedDemo();
    }
}

─────────────────────────────────────
WHEN TO USE WHAT:
─────────────────────────────────────
volatile keyword    simple flag/status, no compound ops
Volatile class      same as keyword, more explicit
Thread.MemoryBarrier() ordering guarantees, no lock
Interlocked         atomic arithmetic, CAS patterns
lock                compound operations on shared state
─────────────────────────────────────

📝 KEY POINTS:
✅ volatile prevents caching but does NOT make operations atomic
✅ Interlocked.Increment is faster than lock for simple counters
✅ CompareExchange (CAS) is the building block for lock-free algorithms
✅ Thread.MemoryBarrier() is rarely needed — prefer lock or Interlocked
✅ Interlocked.Read is needed for atomic 64-bit reads on 32-bit systems
❌ volatile bool _flag; _flag++ is STILL a race condition — use Interlocked
❌ CAS loops can spin forever under extreme contention — use lock instead
''',
  quiz: [
    Quiz(question: 'What does the volatile keyword guarantee for a field?', options: [
      QuizOption(text: 'Every read comes from main memory and every write goes directly to main memory — no register caching', correct: true),
      QuizOption(text: 'Compound operations like ++ are atomic', correct: false),
      QuizOption(text: 'The field can only be read by one thread at a time', correct: false),
      QuizOption(text: 'The field value is synchronized across all CPUs instantly', correct: false),
    ]),
    Quiz(question: 'What does Interlocked.CompareExchange(ref location, value, comparand) do?', options: [
      QuizOption(text: 'If location equals comparand, sets location to value atomically — returns the original value', correct: true),
      QuizOption(text: 'Compares two values and exchanges them if they differ', correct: false),
      QuizOption(text: 'Always exchanges location with value regardless of current value', correct: false),
      QuizOption(text: 'Returns true if the exchange was successful', correct: false),
    ]),
    Quiz(question: 'Why is volatile insufficient for a thread-safe counter using ++?', options: [
      QuizOption(text: '++ is a read-modify-write — volatile only protects individual reads and writes, not the compound operation', correct: true),
      QuizOption(text: 'volatile does not work with integer types', correct: false),
      QuizOption(text: 'volatile only works on bool fields', correct: false),
      QuizOption(text: '++ is always atomic on modern hardware', correct: false),
    ]),
  ],
);
