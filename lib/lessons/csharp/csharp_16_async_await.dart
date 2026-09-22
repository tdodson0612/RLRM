// lib/lessons/csharp/csharp_16_async_await.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson16 = Lesson(
  language: 'C#',
  title: 'Async and Await',
  content: '''
🎯 METAPHOR:
Synchronous code is like a restaurant with one waiter.
The waiter takes order 1, goes to the kitchen, stands there
waiting for the food, brings it back, THEN takes order 2.
Everyone waits. The restaurant is inefficient.

Async code is the same waiter, but smarter.
They take order 1, submit it to the kitchen (start the task),
then go take order 2 while the kitchen is working.
When order 1 is ready, the kitchen signals and the waiter
picks it up. Multiple orders in flight simultaneously.
Same one waiter — radically more productive.
await says "come back to me when this is ready."

📖 EXPLANATION:
async/await is C#'s built-in system for writing asynchronous
code that READS like synchronous code.

  async — marks a method as asynchronous
  await — suspend this method until the awaited task completes,
          but DON'T block the thread while waiting

Task      — represents an async operation (like void)
Task<T>   — represents an async operation that returns T

The thread is released back to the pool while waiting,
allowing it to do other work. This is NOT the same as
multi-threading — it is concurrency without multiple threads.

💻 CODE:
using System;
using System.Net.Http;
using System.Threading.Tasks;
using System.Collections.Generic;

class Program
{
    // ─── BASIC ASYNC METHOD ───
    static async Task<string> FetchDataAsync(string url)
    {
        using var client = new HttpClient();
        // await suspends HERE, releases thread, resumes when done
        string data = await client.GetStringAsync(url);
        return data;
    }

    // ─── SIMULATED DELAY (like a database call) ───
    static async Task<int> GetUserScoreAsync(int userId)
    {
        Console.WriteLine(\$"Fetching score for user {userId}...");
        await Task.Delay(500);  // simulate 500ms database query
        Console.WriteLine(\$"Got score for user {userId}");
        return userId * 100;    // simulated score
    }

    // ─── ASYNC VOID (only for event handlers!) ───
    static async void ButtonClicked(object sender, EventArgs e)
    {
        await Task.Delay(100);
        Console.WriteLine("Button handler done");
    }

    // ─── RUNNING TASKS IN PARALLEL ───
    static async Task RunParallelAsync()
    {
        // SEQUENTIAL — one after another
        var sw = System.Diagnostics.Stopwatch.StartNew();
        int s1 = await GetUserScoreAsync(1);  // waits 500ms
        int s2 = await GetUserScoreAsync(2);  // waits another 500ms
        Console.WriteLine(\$"Sequential: {sw.ElapsedMilliseconds}ms");  // ~1000ms

        // PARALLEL — both run simultaneously
        sw.Restart();
        Task<int> t1 = GetUserScoreAsync(3);  // starts immediately
        Task<int> t2 = GetUserScoreAsync(4);  // starts immediately
        int r1 = await t1;   // wait for first
        int r2 = await t2;   // wait for second (probably already done)
        Console.WriteLine(\$"Parallel: {sw.ElapsedMilliseconds}ms");  // ~500ms

        // WhenAll — await multiple tasks together
        sw.Restart();
        int[] results = await Task.WhenAll(
            GetUserScoreAsync(5),
            GetUserScoreAsync(6),
            GetUserScoreAsync(7)
        );
        Console.WriteLine(\$"WhenAll: {sw.ElapsedMilliseconds}ms");  // ~500ms
        Console.WriteLine(\$"Scores: {string.Join(", ", results)}");
    }

    // ─── ERROR HANDLING WITH ASYNC ───
    static async Task<string> SafeFetchAsync(string url)
    {
        try
        {
            using var client = new HttpClient();
            client.Timeout = TimeSpan.FromSeconds(5);
            return await client.GetStringAsync(url);
        }
        catch (HttpRequestException ex)
        {
            Console.WriteLine(\$"Network error: {ex.Message}");
            return null;
        }
        catch (TaskCanceledException)
        {
            Console.WriteLine("Request timed out");
            return null;
        }
    }

    // ─── CANCELLATION TOKEN ───
    static async Task LongOperationAsync(System.Threading.CancellationToken ct)
    {
        for (int i = 0; i < 10; i++)
        {
            ct.ThrowIfCancellationRequested();  // check if cancelled
            await Task.Delay(200, ct);           // also respects cancellation
            Console.WriteLine(\$"Step {i + 1}");
        }
    }

    static async Task Main()
    {
        // Basic usage
        int score = await GetUserScoreAsync(1);
        Console.WriteLine(\$"Score: {score}");

        // Parallel
        await RunParallelAsync();

        // Cancellation
        var cts = new System.Threading.CancellationTokenSource();
        var task = LongOperationAsync(cts.Token);
        await Task.Delay(700);  // let it run for 700ms
        cts.Cancel();           // cancel it
        try { await task; }
        catch (OperationCanceledException)
        {
            Console.WriteLine("Operation was cancelled");
        }
    }
}

─────────────────────────────────────
ASYNC RULES:
─────────────────────────────────────
✅ async methods should return Task or Task<T>
✅ await can only be used inside async methods
✅ Use Task.WhenAll for parallel async operations
✅ Always pass CancellationToken for cancellable operations
❌ async void is only for event handlers
❌ Never use .Result or .Wait() — they block the thread (deadlock risk)
❌ Don't do CPU-intensive work in async — use Task.Run for that
─────────────────────────────────────

📝 KEY POINTS:
✅ async/await makes async code read like synchronous code
✅ await releases the thread while waiting — the program stays responsive
✅ Task.WhenAll runs multiple async operations in parallel
✅ CancellationToken lets callers cancel long-running operations
✅ Exception handling with try/catch works normally inside async methods
❌ Don't use async void except for event handlers — exceptions are uncatchable
❌ .Result and .Wait() on tasks can cause deadlocks in UI/ASP.NET contexts
''',
  quiz: [
    Quiz(question: 'What does "await" do when it encounters an async operation?', options: [
      QuizOption(text: 'Suspends the current method and releases the thread until the operation completes', correct: true),
      QuizOption(text: 'Blocks the thread until the operation completes', correct: false),
      QuizOption(text: 'Starts the operation on a new thread', correct: false),
      QuizOption(text: 'Cancels the operation if it takes too long', correct: false),
    ]),
    Quiz(question: 'What should async methods return instead of void?', options: [
      QuizOption(text: 'Task or Task<T>', correct: true),
      QuizOption(text: 'Promise or Promise<T>', correct: false),
      QuizOption(text: 'Async or Async<T>', correct: false),
      QuizOption(text: 'void is fine for all async methods', correct: false),
    ]),
    Quiz(question: 'What does Task.WhenAll() do?', options: [
      QuizOption(text: 'Runs multiple tasks in parallel and waits for ALL to complete', correct: true),
      QuizOption(text: 'Runs tasks one after another in sequence', correct: false),
      QuizOption(text: 'Returns when the FIRST task completes', correct: false),
      QuizOption(text: 'Cancels all tasks if any one fails', correct: false),
    ]),
  ],
);
