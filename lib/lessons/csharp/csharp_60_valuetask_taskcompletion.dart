// lib/lessons/csharp/csharp_60_valuetask_taskcompletion.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson60 = Lesson(
  language: 'C#',
  title: 'ValueTask, TaskCompletionSource, and Task Internals',
  content: '''
🎯 METAPHOR:
ValueTask is like ordering coffee at a café.
Sometimes the barista grabs a cup that was already brewed
(synchronous fast path — no allocation, immediate result).
Other times they make it fresh (actual async wait).
Task always makes fresh coffee even if there was already
a cup ready. ValueTask checks the counter first — and only
makes fresh when genuinely needed. This saves significant
allocation overhead in hot paths.

TaskCompletionSource is like a custom promise slip.
Instead of async/await or Task.Run, you hold a slip that
says "this task will complete when I say so." You give the
slip (Task) to whoever needs to wait, and later you call
SetResult or SetException to fulfill the promise — like
completing a transaction from your side of the counter.

📖 EXPLANATION:
VALUETASK<T>:
  - Struct — no heap allocation when result is already available
  - Use in high-performance code called frequently
  - Cannot be awaited twice
  - Pool-friendly with IValueTaskSource

TASKCOMPLETIONSOURCE<T>:
  - Create a Task that is completed manually
  - Bridges callback-based APIs to async/await
  - Essential for wrapping event-based code as Tasks

TASK INTERNALS:
  Task.WhenAll        wait for all tasks
  Task.WhenAny        wait for first to complete
  Task.WhenEach       async stream of completions (C# 13)
  Task.Delay          timer
  Task.Yield          yield control back to scheduler
  Task.Run            queue CPU work on thread pool
  Task.FromResult     synchronously completed Task
  Task.CompletedTask  completed void Task

💻 CODE:
using System;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;

class Program
{
    // ─── VALUETASK: FAST PATH ───
    static ValueTask<int> GetCachedOrFetch(int key)
    {
        // Synchronous fast path — no allocation!
        if (_cache.TryGetValue(key, out int cached))
            return new ValueTask<int>(cached);

        // Async slow path — actual async work
        return new ValueTask<int>(FetchFromDbAsync(key));
    }

    private static Dictionary<int, int> _cache = new() { [1] = 42 };

    static async Task<int> FetchFromDbAsync(int key)
    {
        await Task.Delay(100);  // simulate DB call
        int result = key * 10;
        _cache[key] = result;
        return result;
    }

    // ─── TASKCOMPLETIONSOURCE ───
    // Wrap a callback-based API as a Task
    static Task<string> WrapCallbackApi(string input)
    {
        var tcs = new TaskCompletionSource<string>();

        // Simulate a callback-based API
        ThreadPool.QueueUserWorkItem(_ =>
        {
            try
            {
                Thread.Sleep(100);  // simulate work
                string result = input.ToUpper();
                tcs.SetResult(result);         // complete the task
            }
            catch (Exception ex)
            {
                tcs.SetException(ex);          // fail the task
            }
        });

        return tcs.Task;  // caller awaits this
    }

    // ─── TASKCOMPLETIONSOURCE FOR EVENTS ───
    static Task WaitForButtonClick(MockButton button)
    {
        var tcs = new TaskCompletionSource();
        button.Clicked += () => tcs.TrySetResult();
        return tcs.Task;
    }

    // ─── TASK COMBINATORS ───
    static async Task CombinatorDemo()
    {
        // WhenAll — wait for ALL
        var sw = System.Diagnostics.Stopwatch.StartNew();
        int[] results = await Task.WhenAll(
            FetchFromDbAsync(2),
            FetchFromDbAsync(3),
            FetchFromDbAsync(4)
        );
        Console.WriteLine(\$"WhenAll: {sw.ElapsedMilliseconds}ms, results: {string.Join(",", results)}");

        // WhenAny — first to complete wins
        sw.Restart();
        var fast = Task.Delay(100);
        var slow = Task.Delay(500);
        Task winner = await Task.WhenAny(fast, slow);
        Console.WriteLine(\$"WhenAny: first finished in {sw.ElapsedMilliseconds}ms");

        // Task.FromResult — already-completed Task (no allocation of state machine)
        Task<int> immediate = Task.FromResult(42);
        int val = await immediate;  // completes synchronously
        Console.WriteLine(val);

        // Task.CompletedTask
        await Task.CompletedTask;  // no-op, useful as a return value

        // Task.Yield — give up current execution slice
        await Task.Yield();  // lets other tasks run before continuing

        // Timeout pattern
        var longTask = Task.Delay(2000);
        var timeout  = Task.Delay(500);
        Task finished = await Task.WhenAny(longTask, timeout);
        if (finished == timeout)
            Console.WriteLine("Operation timed out!");
    }

    // ─── CANCELLATION WITH TCS ───
    static Task<string> CancellableOperation(CancellationToken ct)
    {
        var tcs = new TaskCompletionSource<string>();

        ct.Register(() => tcs.TrySetCanceled(ct));

        // Start the actual work
        Task.Run(async () =>
        {
            try
            {
                await Task.Delay(1000, ct);
                tcs.TrySetResult("Done!");
            }
            catch (OperationCanceledException)
            {
                tcs.TrySetCanceled(ct);
            }
        }, ct);

        return tcs.Task;
    }

    static async Task Main()
    {
        // ValueTask — fast path (cached, no alloc)
        int v1 = await GetCachedOrFetch(1);   // synchronous!
        Console.WriteLine(\$"Cached: {v1}");   // 42

        int v2 = await GetCachedOrFetch(5);   // async fetch
        Console.WriteLine(\$"Fetched: {v2}");  // 50

        // TaskCompletionSource
        string upper = await WrapCallbackApi("hello world");
        Console.WriteLine(upper);  // HELLO WORLD

        // Combinators
        await CombinatorDemo();

        // Cancellation
        var cts = new CancellationTokenSource(300);
        try
        {
            string result = await CancellableOperation(cts.Token);
            Console.WriteLine(result);
        }
        catch (OperationCanceledException)
        {
            Console.WriteLine("Cancelled!");
        }
    }
}

class MockButton
{
    public event Action Clicked;
    public void SimulateClick() => Clicked?.Invoke();
}

📝 KEY POINTS:
✅ Use ValueTask<T> for frequently-called async methods with common synchronous fast paths
✅ Use TaskCompletionSource to bridge callback/event APIs to async/await
✅ Task.WhenAny for timeout patterns — race the operation against Task.Delay
✅ Task.FromResult creates a pre-completed Task — no state machine overhead
✅ Use TrySetResult (not SetResult) in TCS when multiple code paths might complete it
❌ Don't await a ValueTask more than once — it is not safe
❌ Don't leave TaskCompletionSource tasks uncompleted — memory leak
''',
  quiz: [
    Quiz(question: 'What is the main advantage of ValueTask<T> over Task<T>?', options: [
      QuizOption(text: 'No heap allocation when the result is available synchronously', correct: true),
      QuizOption(text: 'ValueTask is faster for all async operations', correct: false),
      QuizOption(text: 'ValueTask supports cancellation; Task does not', correct: false),
      QuizOption(text: 'ValueTask can be awaited multiple times', correct: false),
    ]),
    Quiz(question: 'What is TaskCompletionSource used for?', options: [
      QuizOption(text: 'Manually controlling when a Task completes — useful for wrapping callback-based APIs', correct: true),
      QuizOption(text: 'Creating Tasks that run on specific threads', correct: false),
      QuizOption(text: 'Composing multiple Tasks into one', correct: false),
      QuizOption(text: 'Cancelling a running Task', correct: false),
    ]),
    Quiz(question: 'How do you implement a timeout using Task.WhenAny?', options: [
      QuizOption(text: 'Race the operation task against Task.Delay(timeout) and check which won', correct: true),
      QuizOption(text: 'Set a property on the Task object', correct: false),
      QuizOption(text: 'Use Task.WhenAny with a CancellationToken', correct: false),
      QuizOption(text: 'Task.WhenAny automatically handles timeouts', correct: false),
    ]),
  ],
);
