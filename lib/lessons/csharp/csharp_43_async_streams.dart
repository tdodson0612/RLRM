// lib/lessons/csharp/csharp_43_async_streams.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson43 = Lesson(
  language: 'C#',
  title: 'Async Streams and IAsyncEnumerable',
  content: '''
🎯 METAPHOR:
IAsyncEnumerable is like a live news ticker.
Regular IEnumerable is like a printed newspaper — all items
exist when you start reading. Regular async (Task<List<T>>)
is like waiting for the WHOLE paper to be printed before
reading a single word. IAsyncEnumerable is the live ticker:
items appear one by one as they become available, and you
read each one as it arrives. You don't wait for all of them.
Each item might come from a slow database, an API, or a file
— and you process it the moment it arrives.

📖 EXPLANATION:
IAsyncEnumerable<T> (C# 8+) combines async/await with
lazy iteration. It lets you:
  - Stream results from a database query row by row
  - Process API paginated results page by page
  - Stream file contents chunk by chunk
  - React to events as they arrive

Key syntax:
  async IAsyncEnumerable<T> MyMethod()  — declare
  yield return item;                     — produce values
  await foreach (var item in source)    — consume values

With CancellationToken:
  Use [EnumeratorCancellation] attribute on the token parameter

💻 CODE:
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using System.Runtime.CompilerServices;

class Program
{
    // ─── BASIC ASYNC STREAM ───
    static async IAsyncEnumerable<int> GenerateNumbers(int count)
    {
        for (int i = 0; i < count; i++)
        {
            await Task.Delay(100);  // simulate async work (DB, API, etc.)
            yield return i;
        }
    }

    // ─── WITH CANCELLATION TOKEN ───
    static async IAsyncEnumerable<string> StreamLogs(
        int count,
        [EnumeratorCancellation] CancellationToken ct = default)
    {
        for (int i = 0; i < count; i++)
        {
            ct.ThrowIfCancellationRequested();
            await Task.Delay(200, ct);
            yield return \$"[LOG {DateTime.Now:HH:mm:ss.fff}] Entry {i + 1}";
        }
    }

    // ─── SIMULATE DATABASE STREAMING ───
    static async IAsyncEnumerable<User> StreamUsersFromDb(
        [EnumeratorCancellation] CancellationToken ct = default)
    {
        string[] names = { "Alice", "Bob", "Charlie", "Diana", "Eve" };

        foreach (string name in names)
        {
            ct.ThrowIfCancellationRequested();
            await Task.Delay(50, ct);  // simulate DB row fetch latency
            yield return new User { Name = name, Id = names.ToList().IndexOf(name) + 1 };
        }
    }

    // ─── ASYNC STREAM PROCESSING PIPELINE ───
    static async IAsyncEnumerable<T> FilterAsync<T>(
        IAsyncEnumerable<T> source,
        Func<T, bool> predicate,
        [EnumeratorCancellation] CancellationToken ct = default)
    {
        await foreach (T item in source.WithCancellation(ct))
        {
            if (predicate(item))
                yield return item;
        }
    }

    static async IAsyncEnumerable<TResult> SelectAsync<T, TResult>(
        IAsyncEnumerable<T> source,
        Func<T, TResult> selector,
        [EnumeratorCancellation] CancellationToken ct = default)
    {
        await foreach (T item in source.WithCancellation(ct))
            yield return selector(item);
    }

    static async Task Main()
    {
        // ─── BASIC CONSUMPTION ───
        Console.WriteLine("Generating numbers:");
        await foreach (int n in GenerateNumbers(5))
        {
            Console.Write(n + " ");  // 0 1 2 3 4 (one per 100ms)
        }
        Console.WriteLine();

        // ─── WITH CANCELLATION ───
        var cts = new CancellationTokenSource(TimeSpan.FromMilliseconds(700));
        Console.WriteLine("\nStreaming logs (cancel after 700ms):");
        try
        {
            await foreach (string log in StreamLogs(10, cts.Token))
            {
                Console.WriteLine(log);
            }
        }
        catch (OperationCanceledException)
        {
            Console.WriteLine("Stream cancelled!");
        }

        // ─── DATABASE STREAMING ───
        Console.WriteLine("\nStreaming users from DB:");
        await foreach (User user in StreamUsersFromDb())
        {
            Console.WriteLine(\$"  Processing user {user.Id}: {user.Name}");
            // Process each user AS it arrives — no waiting for all
        }

        // ─── PIPELINE ───
        Console.WriteLine("\nAsync pipeline:");
        var source = StreamUsersFromDb();
        var filtered = FilterAsync(source, u => u.Id % 2 == 0);
        var names = SelectAsync(filtered, u => u.Name.ToUpper());

        await foreach (string name in names)
            Console.WriteLine(\$"  {name}");

        // ─── COLLECT TO LIST (when you need all results) ───
        var allUsers = new List<User>();
        await foreach (User u in StreamUsersFromDb())
            allUsers.Add(u);
        Console.WriteLine(\$"\nTotal users collected: {allUsers.Count}");

        // ─── TOLISTASYNC WITH SYSTEM.LINQ.ASYNC (NuGet) ───
        // If you add System.Linq.Async NuGet package:
        // var list = await StreamUsersFromDb().ToListAsync();
    }
}

class User
{
    public int Id { get; set; }
    public string Name { get; set; }
}

─────────────────────────────────────
IEnumerable vs IAsyncEnumerable:
─────────────────────────────────────
IEnumerable<T>          synchronous, blocking
Task<IEnumerable<T>>    async but loads ALL at once
IAsyncEnumerable<T>     async AND lazy — one at a time

When to use IAsyncEnumerable:
  ✅ Database queries (stream rows as they arrive)
  ✅ API pagination (fetch one page at a time)
  ✅ Large file processing (chunk by chunk)
  ✅ Event streams (IoT sensors, logs, WebSocket messages)
─────────────────────────────────────

📝 KEY POINTS:
✅ Use "await foreach" to consume IAsyncEnumerable<T>
✅ Add [EnumeratorCancellation] to support WithCancellation()
✅ IAsyncEnumerable combines lazy evaluation with async — best of both
✅ You can build async LINQ-style pipelines with async streams
✅ Add System.Linq.Async NuGet package for ToListAsync(), WhereAsync() etc.
❌ Don't collect all items to a list if you can process them one by one
❌ Don't use IAsyncEnumerable for CPU-bound work — use Parallel/PLINQ instead
''',
  quiz: [
    Quiz(question: 'What is the key difference between Task<IEnumerable<T>> and IAsyncEnumerable<T>?', options: [
      QuizOption(text: 'Task<IEnumerable<T>> loads all items at once; IAsyncEnumerable yields them one at a time', correct: true),
      QuizOption(text: 'IAsyncEnumerable is faster because it uses multiple threads', correct: false),
      QuizOption(text: 'Task<IEnumerable<T>> supports cancellation; IAsyncEnumerable does not', correct: false),
      QuizOption(text: 'They are identical in behavior', correct: false),
    ]),
    Quiz(question: 'What syntax is used to consume an IAsyncEnumerable<T>?', options: [
      QuizOption(text: 'await foreach (var item in source)', correct: true),
      QuizOption(text: 'foreach (var item in await source)', correct: false),
      QuizOption(text: 'async foreach (var item in source)', correct: false),
      QuizOption(text: 'for await (var item in source)', correct: false),
    ]),
    Quiz(question: 'What does the [EnumeratorCancellation] attribute do?', options: [
      QuizOption(text: 'Allows the CancellationToken to flow through WithCancellation() calls', correct: true),
      QuizOption(text: 'Automatically cancels the enumeration after a timeout', correct: false),
      QuizOption(text: 'Prevents the stream from being cancelled', correct: false),
      QuizOption(text: 'Makes the CancellationToken parameter required', correct: false),
    ]),
  ],
);
