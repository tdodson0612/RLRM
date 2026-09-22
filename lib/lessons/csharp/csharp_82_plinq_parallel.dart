// lib/lessons/csharp/csharp_82_plinq_parallel.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson82 = Lesson(
  language: 'C#',
  title: 'PLINQ and Parallel Programming',
  content: '''
🎯 METAPHOR:
PLINQ is like upgrading a one-lane highway to an eight-lane
freeway. The same cars (data items) travel the same route
(your LINQ query), but now eight cars travel simultaneously
instead of one at a time. The journey is faster — but only
if the route is long enough to justify building the freeway.
For short routes (small data), the construction overhead
costs more than the time saved.

Parallel.For and Parallel.ForEach are the crew foreman telling
eight workers to work on eight sections of the road simultaneously.
Each worker is independent. When all eight finish, the job is done.
The foreman (Parallel) handles assigning workers and waiting.

📖 EXPLANATION:
PLINQ (Parallel LINQ):
  .AsParallel()          enable parallel execution
  .WithDegreeOfParallelism(n)  limit thread count
  .AsOrdered()           maintain source order
  .WithCancellation(ct)  support cancellation
  .ForAll(action)        parallel terminal operation

Parallel class:
  Parallel.For(from, to, body)
  Parallel.ForEach(source, body)
  Parallel.Invoke(actions)   run multiple actions concurrently

ParallelOptions:
  MaxDegreeOfParallelism  limit thread count
  CancellationToken       cancellation support

WHEN TO USE:
  ✅ CPU-bound work with large data sets
  ✅ Independent operations (no shared state)
  ✅ Processing time >> parallelization overhead
  ❌ I/O-bound work (use async/await instead)
  ❌ Very small datasets (overhead > benefit)
  ❌ Operations with shared mutable state

💻 CODE:
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Diagnostics;

class Program
{
    // CPU-intensive work
    static double HeavyComputation(int n)
    {
        double result = 0;
        for (int i = 0; i < 10_000; i++)
            result += Math.Sqrt(n * i);
        return result;
    }

    static void Main()
    {
        var data = Enumerable.Range(1, 10_000).ToList();

        // ─── PLINQ vs LINQ COMPARISON ───
        var sw = Stopwatch.StartNew();

        // Sequential LINQ
        var seqResult = data.Where(n => n % 2 == 0)
                            .Select(n => HeavyComputation(n))
                            .ToList();
        Console.WriteLine(\$"Sequential: {sw.ElapsedMilliseconds}ms");

        sw.Restart();

        // Parallel LINQ — same code, just .AsParallel()
        var parResult = data.AsParallel()
                            .Where(n => n % 2 == 0)
                            .Select(n => HeavyComputation(n))
                            .ToList();
        Console.WriteLine(\$"Parallel:   {sw.ElapsedMilliseconds}ms");
        // ~4-8x faster on multi-core

        // ─── PLINQ OPTIONS ───
        var ordered = data.AsParallel()
                          .AsOrdered()                         // preserve input order
                          .WithDegreeOfParallelism(4)          // max 4 threads
                          .Where(n => n % 3 == 0)
                          .Select(n => n * n)
                          .ToList();
        Console.WriteLine(\$"Ordered parallel: {ordered.Take(3).Last()}");

        // ─── PLINQ WITH CANCELLATION ───
        var cts = new CancellationTokenSource(TimeSpan.FromMilliseconds(500));
        try
        {
            var cancelled = data.AsParallel()
                               .WithCancellation(cts.Token)
                               .Select(n => { Thread.Sleep(1); return HeavyComputation(n); })
                               .ToList();
        }
        catch (OperationCanceledException)
        {
            Console.WriteLine("PLINQ cancelled!");
        }

        // ─── PLINQ FORALL (most parallel-friendly terminal) ───
        var results = new ConcurrentBag<double>();
        data.AsParallel()
            .Where(n => n % 100 == 0)
            .ForAll(n => results.Add(HeavyComputation(n)));
        Console.WriteLine(\$"ForAll results: {results.Count}");

        // ─── PARALLEL.FOR ───
        double[] squares = new double[1000];
        sw.Restart();
        Parallel.For(0, 1000, i =>
        {
            squares[i] = HeavyComputation(i);  // independent — no locking needed
        });
        Console.WriteLine(\$"Parallel.For: {sw.ElapsedMilliseconds}ms");

        // ─── PARALLEL.FOREACH ───
        var names = new[] { "Alice", "Bob", "Charlie", "Diana", "Eve" };
        var processed = new ConcurrentBag<string>();

        Parallel.ForEach(names, new ParallelOptions { MaxDegreeOfParallelism = 2 }, name =>
        {
            Thread.Sleep(50);  // simulate CPU work
            processed.Add(name.ToUpper());
        });
        Console.WriteLine(\$"Processed: {string.Join(", ", processed)}");

        // ─── PARALLEL.INVOKE ───
        // Run multiple independent operations concurrently
        sw.Restart();
        Parallel.Invoke(
            () => { Thread.Sleep(200); Console.WriteLine("Task A done"); },
            () => { Thread.Sleep(100); Console.WriteLine("Task B done"); },
            () => { Thread.Sleep(150); Console.WriteLine("Task C done"); }
        );
        Console.WriteLine(\$"All tasks: {sw.ElapsedMilliseconds}ms");  // ~200ms (longest)

        // ─── PARALLEL WITH AGGREGATION ───
        // Use thread-local state to avoid locking
        double grandTotal = 0;
        Parallel.For(0, 1000,
            localInit: () => 0.0,
            body: (i, state, localSum) => localSum + Math.Sqrt(i),
            localFinally: localSum => Interlocked.Exchange(ref grandTotal, grandTotal + localSum)
        );
        Console.WriteLine(\$"Grand total: {grandTotal:F2}");
    }
}

─────────────────────────────────────
PLINQ vs Parallel.ForEach:
─────────────────────────────────────
PLINQ:              query-style, composable, returns IEnumerable
Parallel.ForEach:   statement-style, side effects, no return value

Use PLINQ for:  data transformation pipelines
Use Parallel:   independent side-effecting operations
─────────────────────────────────────

📝 KEY POINTS:
✅ .AsParallel() is often the only change needed to parallelize a LINQ query
✅ .AsOrdered() preserves input order at the cost of some parallelism
✅ Use ConcurrentBag/ConcurrentDictionary for thread-safe collection in parallel code
✅ Parallel.For with localInit/localFinally pattern avoids locking in aggregation
✅ MaxDegreeOfParallelism prevents overwhelming CPU — default is processor count
❌ Don't parallelize I/O-bound work — use async/await instead
❌ Don't access shared mutable state without ConcurrentXxx or Interlocked
❌ Small data sets often run SLOWER with PLINQ due to partitioning overhead
''',
  quiz: [
    Quiz(question: 'What does .AsParallel() do to a LINQ query?', options: [
      QuizOption(text: 'Enables parallel execution across multiple threads', correct: true),
      QuizOption(text: 'Makes the query run asynchronously without blocking', correct: false),
      QuizOption(text: 'Optimizes the query for large datasets', correct: false),
      QuizOption(text: 'Caches the query results for reuse', correct: false),
    ]),
    Quiz(question: 'When should you NOT use PLINQ or Parallel?', options: [
      QuizOption(text: 'For I/O-bound work — use async/await instead', correct: true),
      QuizOption(text: 'For large data sets', correct: false),
      QuizOption(text: 'When MaxDegreeOfParallelism is set to 1', correct: false),
      QuizOption(text: 'When the data is already sorted', correct: false),
    ]),
    Quiz(question: 'What does .WithDegreeOfParallelism(4) do?', options: [
      QuizOption(text: 'Limits PLINQ to use at most 4 threads', correct: true),
      QuizOption(text: 'Splits the data into exactly 4 chunks', correct: false),
      QuizOption(text: 'Requires exactly 4 processors to run', correct: false),
      QuizOption(text: 'Processes 4 items at a time', correct: false),
    ]),
  ],
);
