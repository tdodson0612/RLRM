// lib/lessons/csharp/csharp_59_threading_primitives.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson59 = Lesson(
  language: 'C#',
  title: 'Threading Primitives',
  content: '''
🎯 METAPHOR:
Threading primitives are traffic control devices for threads.
A Mutex is a one-lane bridge — only one car (thread) crosses
at a time, and it must signal when it leaves.
A Semaphore is a parking garage with N spaces — up to N cars
can park simultaneously; any more must wait outside.
A ManualResetEvent is a traffic light — RED blocks everyone,
GREEN lets everyone through at once until manually reset.
An AutoResetEvent is a turnstile — it lets exactly ONE person
through, then automatically resets to locked.
A Monitor is a room with a key — one person holds the key
at a time, and others queue up to wait for it.

📖 EXPLANATION:
These are the low-level synchronization tools. In modern C#
you rarely use them directly — prefer async/await, Channel<T>,
and concurrent collections. But you'll encounter them in
existing code and need to understand them.

Mutex          — OS-level lock, can be named (cross-process)
Semaphore      — limited concurrent access (N slots), OS-level
SemaphoreSlim  — async-friendly semaphore, same-process only
Monitor        — lock statement sugar, Wait/Pulse
ManualResetEvent / ManualResetEventSlim  — gate for multiple threads
AutoResetEvent — turnstile (one thread at a time, auto-resets)
CountdownEvent — wait for N events to complete
Barrier        — synchronize N threads at a phase boundary
SpinLock       — busy-wait lock (for very short critical sections)
ReaderWriterLockSlim — multiple readers OR one writer

💻 CODE:
using System;
using System.Threading;
using System.Collections.Generic;

class Program
{
    // ─── MUTEX ───
    static void MutexDemo()
    {
        using var mutex = new Mutex();

        var threads = new List<Thread>();
        for (int i = 0; i < 3; i++)
        {
            int id = i;
            var t = new Thread(() =>
            {
                mutex.WaitOne();   // acquire
                try
                {
                    Console.WriteLine(\$"Thread {id} in critical section");
                    Thread.Sleep(100);
                }
                finally
                {
                    mutex.ReleaseMutex();  // release
                }
            });
            threads.Add(t);
            t.Start();
        }
        foreach (var t in threads) t.Join();
    }

    // ─── SEMAPHORE SLIM (async) ───
    static async System.Threading.Tasks.Task SemaphoreDemo()
    {
        var sem = new SemaphoreSlim(2, 2);  // max 2 concurrent
        var tasks = new List<System.Threading.Tasks.Task>();

        for (int i = 0; i < 6; i++)
        {
            int id = i;
            tasks.Add(System.Threading.Tasks.Task.Run(async () =>
            {
                await sem.WaitAsync();
                try
                {
                    Console.WriteLine(\$"Task {id} running (available: {sem.CurrentCount})");
                    await System.Threading.Tasks.Task.Delay(200);
                }
                finally { sem.Release(); }
            }));
        }
        await System.Threading.Tasks.Task.WhenAll(tasks);
    }

    // ─── MONITOR / LOCK ───
    static int _counter = 0;
    static readonly object _lock = new();

    static void MonitorDemo()
    {
        // lock statement = Monitor.Enter + Monitor.Exit in finally
        lock (_lock) { _counter++; }

        // Equivalent manual Monitor:
        Monitor.Enter(_lock);
        try { _counter++; }
        finally { Monitor.Exit(_lock); }

        // Monitor.Wait / Pulse (producer-consumer)
        var queue = new Queue<int>();
        var producerThread = new Thread(() =>
        {
            for (int i = 0; i < 5; i++)
            {
                lock (queue)
                {
                    queue.Enqueue(i);
                    Monitor.Pulse(queue);  // signal consumer
                }
                Thread.Sleep(50);
            }
        });

        var consumerThread = new Thread(() =>
        {
            for (int i = 0; i < 5; i++)
            {
                lock (queue)
                {
                    while (queue.Count == 0)
                        Monitor.Wait(queue);  // release lock and wait
                    Console.WriteLine(\$"Consumed: {queue.Dequeue()}");
                }
            }
        });

        consumerThread.Start();
        producerThread.Start();
        producerThread.Join();
        consumerThread.Join();
    }

    // ─── MANUAL RESET EVENT ───
    static void ManualResetEventDemo()
    {
        // False = initially closed (blocking)
        using var gate = new ManualResetEventSlim(false);

        var threads = new List<Thread>();
        for (int i = 0; i < 3; i++)
        {
            int id = i;
            var t = new Thread(() =>
            {
                Console.WriteLine(\$"Thread {id} waiting at gate");
                gate.Wait();  // all threads block here
                Console.WriteLine(\$"Thread {id} passed through!");
            });
            threads.Add(t);
            t.Start();
        }

        Thread.Sleep(200);
        Console.WriteLine("Opening gate for ALL threads!");
        gate.Set();  // all threads released simultaneously

        foreach (var t in threads) t.Join();
        // gate stays open until Reset() is called
    }

    // ─── COUNTDOWN EVENT ───
    static void CountdownDemo()
    {
        using var countdown = new CountdownEvent(3);

        for (int i = 0; i < 3; i++)
        {
            int id = i;
            new Thread(() =>
            {
                Thread.Sleep(id * 100);
                Console.WriteLine(\$"Worker {id} done");
                countdown.Signal();  // decrement count
            }).Start();
        }

        countdown.Wait();  // wait for all 3 signals
        Console.WriteLine("All workers finished!");
    }

    // ─── READERWRITER LOCK ───
    static readonly ReaderWriterLockSlim _rwLock = new();
    static string _sharedData = "initial";

    static void ReadData(int id)
    {
        _rwLock.EnterReadLock();    // multiple readers OK
        try { Console.WriteLine(\$"Reader {id}: {_sharedData}"); }
        finally { _rwLock.ExitReadLock(); }
    }

    static void WriteData(string value)
    {
        _rwLock.EnterWriteLock();   // exclusive write
        try { _sharedData = value; Console.WriteLine(\$"Wrote: {value}"); }
        finally { _rwLock.ExitWriteLock(); }
    }

    static async System.Threading.Tasks.Task Main()
    {
        Console.WriteLine("=== Mutex ===");
        MutexDemo();

        Console.WriteLine("\n=== SemaphoreSlim ===");
        await SemaphoreDemo();

        Console.WriteLine("\n=== Monitor ===");
        MonitorDemo();

        Console.WriteLine("\n=== ManualResetEvent ===");
        ManualResetEventDemo();

        Console.WriteLine("\n=== CountdownEvent ===");
        CountdownDemo();

        Console.WriteLine("\n=== ReaderWriterLock ===");
        var threads = new List<Thread>();
        for (int i = 0; i < 3; i++) { int id = i; threads.Add(new Thread(() => ReadData(id))); }
        threads.Add(new Thread(() => WriteData("updated")));
        foreach (var t in threads) { t.Start(); t.Join(); }
    }
}

📝 KEY POINTS:
✅ lock() is syntactic sugar for Monitor.Enter/Exit — use it for simple mutual exclusion
✅ SemaphoreSlim is the async-friendly choice for limiting concurrency
✅ ManualResetEvent lets ALL waiting threads through at once when Set()
✅ AutoResetEvent lets EXACTLY ONE waiting thread through, then resets
✅ ReaderWriterLockSlim is ideal for read-heavy, write-rare data
✅ CountdownEvent is clean for "wait for N tasks to complete"
❌ Don't use Mutex unless you need cross-process synchronization — use lock instead
❌ Always release synchronization primitives in finally blocks
''',
  quiz: [
    Quiz(question: 'What is the difference between ManualResetEvent and AutoResetEvent?', options: [
      QuizOption(text: 'ManualResetEvent releases all waiting threads; AutoResetEvent releases exactly one and resets', correct: true),
      QuizOption(text: 'AutoResetEvent releases all threads; ManualResetEvent releases one', correct: false),
      QuizOption(text: 'They are identical — just different names', correct: false),
      QuizOption(text: 'ManualResetEvent requires manual thread management; AutoResetEvent does not', correct: false),
    ]),
    Quiz(question: 'What does ReaderWriterLockSlim allow that a regular lock does not?', options: [
      QuizOption(text: 'Multiple threads to read simultaneously while still preventing concurrent writes', correct: true),
      QuizOption(text: 'Async/await usage inside the lock', correct: false),
      QuizOption(text: 'Cross-process synchronization', correct: false),
      QuizOption(text: 'Unlimited concurrent write access', correct: false),
    ]),
    Quiz(question: 'What does CountdownEvent.Wait() do?', options: [
      QuizOption(text: 'Blocks until Signal() has been called the required number of times', correct: true),
      QuizOption(text: 'Waits for a countdown timer to expire', correct: false),
      QuizOption(text: 'Cancels all threads after a countdown', correct: false),
      QuizOption(text: 'Waits for one specific thread to finish', correct: false),
    ]),
  ],
);
