// lib/lessons/csharp/csharp_37_concurrency_threading.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson37 = Lesson(
  language: 'C#',
  title: 'Concurrency and Threading',
  content: '''
🎯 METAPHOR:
A thread is like a worker in a factory.
One worker (single-threaded) does every task sequentially.
Multiple workers (multi-threaded) work simultaneously —
faster, but they need rules: two workers CANNOT use
the same machine at the same time (race condition).
They need locks (mutex/lock) to take turns.
A lock statement is like a "MACHINE IN USE" sign —
one worker hangs it up, does their work, removes the sign.

The thread pool is like a staffing agency. Instead of
hiring permanent workers for every tiny task (expensive),
you call the agency when needed, and return workers when done.
Task.Run() calls the agency.

📖 EXPLANATION:
C# threading tools:
  Thread             — raw OS thread (heavy, manual)
  ThreadPool         — reuse of existing threads (lighter)
  Task / Task.Run    — abstraction over thread pool (preferred)
  Parallel           — data parallelism (foreach, for)
  Interlocked        — atomic operations without locks
  lock / Monitor     — mutual exclusion (prevent data races)
  SemaphoreSlim      — limit concurrent access to N
  ConcurrentXxx      — thread-safe collection variants

💻 CODE:
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using System.Linq;

class Program
{
    static int _counter = 0;
    static readonly object _lock = new object();

    // ─── BASIC THREAD ───
    static void RunOnThread()
    {
        var t = new Thread(() =>
        {
            Console.WriteLine(\$"Running on thread {Thread.CurrentThread.ManagedThreadId}");
        });
        t.Start();
        t.Join();  // wait for completion
    }

    // ─── RACE CONDITION + FIX ───
    static void RaceConditionDemo()
    {
        int unsafeCounter = 0;
        var tasks = new List<Task>();

        for (int i = 0; i < 1000; i++)
        {
            tasks.Add(Task.Run(() => unsafeCounter++));  // RACE CONDITION!
        }
        Task.WaitAll(tasks.ToArray());
        Console.WriteLine(\$"Unsafe: {unsafeCounter}");  // probably not 1000!

        // Fix 1: lock
        int safeCounter = 0;
        var lockObj = new object();
        tasks.Clear();

        for (int i = 0; i < 1000; i++)
        {
            tasks.Add(Task.Run(() =>
            {
                lock (lockObj) { safeCounter++; }
            }));
        }
        Task.WaitAll(tasks.ToArray());
        Console.WriteLine(\$"Safe (lock): {safeCounter}");  // 1000

        // Fix 2: Interlocked (faster for simple ops)
        int atomicCounter = 0;
        tasks.Clear();

        for (int i = 0; i < 1000; i++)
            tasks.Add(Task.Run(() => Interlocked.Increment(ref atomicCounter)));

        Task.WaitAll(tasks.ToArray());
        Console.WriteLine(\$"Safe (Interlocked): {atomicCounter}");  // 1000
    }

    // ─── PARALLEL.FOR / FOREACH ───
    static void ParallelDemo()
    {
        // CPU-bound work on all cores
        var results = new int[10];
        Parallel.For(0, 10, i =>
        {
            results[i] = i * i;  // runs in parallel on multiple threads
        });
        Console.WriteLine(string.Join(", ", results));

        // Parallel LINQ (PLINQ)
        var numbers = Enumerable.Range(1, 1_000_000);
        var sum = numbers.AsParallel()
                         .Where(n => n % 7 == 0)
                         .Sum();
        Console.WriteLine(\$"Sum of multiples of 7: {sum}");
    }

    // ─── SEMAPHORE (limit concurrency) ───
    static async Task SemaphoreDemo()
    {
        var sem = new SemaphoreSlim(3);  // max 3 concurrent

        var tasks = Enumerable.Range(1, 10).Select(async i =>
        {
            await sem.WaitAsync();
            try
            {
                Console.WriteLine(\$"Task {i} started");
                await Task.Delay(500);
                Console.WriteLine(\$"Task {i} done");
            }
            finally
            {
                sem.Release();
            }
        });

        await Task.WhenAll(tasks);
    }

    // ─── CONCURRENT COLLECTIONS ───
    static void ConcurrentCollections()
    {
        // Thread-safe dictionary
        var dict = new ConcurrentDictionary<string, int>();
        dict["a"] = 1;
        dict.TryAdd("b", 2);
        dict.AddOrUpdate("a", 1, (key, old) => old + 1);  // atomic update
        Console.WriteLine(dict["a"]);  // 2

        // Thread-safe queue
        var queue = new ConcurrentQueue<int>();
        queue.Enqueue(1);
        queue.Enqueue(2);
        if (queue.TryDequeue(out int item))
            Console.WriteLine(\$"Dequeued: {item}");

        // BlockingCollection — producer/consumer
        var bc = new BlockingCollection<int>(boundedCapacity: 5);

        var producer = Task.Run(() =>
        {
            for (int i = 0; i < 10; i++)
            {
                bc.Add(i);
                Console.WriteLine(\$"Produced {i}");
            }
            bc.CompleteAdding();
        });

        var consumer = Task.Run(() =>
        {
            foreach (int item2 in bc.GetConsumingEnumerable())
                Console.WriteLine(\$"Consumed {item2}");
        });

        Task.WaitAll(producer, consumer);
    }

    static async Task Main()
    {
        Console.WriteLine("=== Thread Demo ===");
        RunOnThread();

        Console.WriteLine("\\n=== Race Condition Demo ===");
        RaceConditionDemo();

        Console.WriteLine("\\n=== Parallel Demo ===");
        ParallelDemo();

        Console.WriteLine("\\n=== Semaphore Demo ===");
        await SemaphoreDemo();

        Console.WriteLine("\\n=== Concurrent Collections ===");
        ConcurrentCollections();
    }
}

📝 KEY POINTS:
✅ Always protect shared mutable state with lock or Interlocked
✅ Prefer Task.Run() over Thread for CPU-bound work
✅ Use Parallel.For/ForEach for CPU-bound data parallelism
✅ Use async/await for I/O-bound work (not Parallel)
✅ ConcurrentDictionary/Queue are thread-safe collection alternatives
✅ SemaphoreSlim limits how many tasks run concurrently
❌ Don't use Thread directly — use Task/Task.Run instead
❌ Never access shared data from multiple threads without synchronization
❌ Don't use Parallel for I/O-bound work — use async/await instead
''',
  quiz: [
    Quiz(question: 'What is a race condition?', options: [
      QuizOption(text: 'Two threads accessing and modifying shared data simultaneously, causing unpredictable results', correct: true),
      QuizOption(text: 'Two threads competing to finish first', correct: false),
      QuizOption(text: 'A thread that runs faster than expected', correct: false),
      QuizOption(text: 'A deadlock where two threads wait for each other', correct: false),
    ]),
    Quiz(question: 'What does Interlocked.Increment() do?', options: [
      QuizOption(text: 'Atomically increments an integer — thread-safe without a lock', correct: true),
      QuizOption(text: 'Increments a counter and signals all waiting threads', correct: false),
      QuizOption(text: 'Creates a new thread and runs increment on it', correct: false),
      QuizOption(text: 'Same as ++ but slightly slower', correct: false),
    ]),
    Quiz(question: 'When should you use Parallel.For instead of async/await?', options: [
      QuizOption(text: 'For CPU-bound work that can be split across multiple cores', correct: true),
      QuizOption(text: 'For I/O-bound work like file or network operations', correct: false),
      QuizOption(text: 'Whenever you need to run code on a background thread', correct: false),
      QuizOption(text: 'Parallel.For is always faster than async/await', correct: false),
    ]),
  ],
);
