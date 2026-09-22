// lib/lessons/csharp/csharp_72_configureawait_synccontext.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson72 = Lesson(
  language: 'C#',
  title: 'ConfigureAwait and SynchronizationContext',
  content: '''
🎯 METAPHOR:
SynchronizationContext is like a specific desk at work where
certain tasks MUST be done. In a GUI app, UI updates MUST
happen on the UI thread — that thread is the desk.
When you await something, by default C# politely returns to
that specific desk when the await completes. "I'll finish
this paperwork, but I'll bring it back to your desk."

ConfigureAwait(false) says: "Don't bother coming back to
my desk — just continue wherever is convenient." For library
code that doesn't need the UI thread, this avoids the
expensive context-switch and prevents deadlocks in certain
frameworks (ASP.NET classic, WPF with .Wait() calls).

📖 EXPLANATION:
SYNCHRONIZATIONCONTEXT:
  - Abstract mechanism for scheduling work to a specific thread
  - UI frameworks install one: WPF, WinForms, Blazor, MAUI
  - ASP.NET classic had one; ASP.NET Core does NOT
  - After await, by default execution resumes on the original context

CONFIGUREAWAIT(bool continueOnCapturedContext):
  - true (default): resume on original SynchronizationContext
  - false: resume on any thread pool thread (no context capture)

WHEN TO USE ConfigureAwait(false):
  ✅ Library/utility code — you don't need UI context
  ✅ Prevents deadlocks in frameworks with sync context + .Wait()
  ✅ Slight performance improvement (avoids context switch)

WHEN NOT to use ConfigureAwait(false):
  ❌ If you update UI after the await
  ❌ ASP.NET Core (no sync context — no effect anyway)
  ❌ When you need HttpContext, ClaimsPrincipal etc. after await

DEADLOCK SCENARIO:
  Button_Click calls .Result or .Wait() on a Task
  Task tries to resume on UI thread
  UI thread is blocked waiting for Task
  → Deadlock!

💻 CODE:
using System;
using System.Threading;
using System.Threading.Tasks;

// ─── CUSTOM SYNCHRONIZATION CONTEXT ───
class SingleThreadContext : SynchronizationContext
{
    private readonly Thread _thread;
    private readonly System.Collections.Concurrent.BlockingCollection<(SendOrPostCallback, object)> _queue = new();

    public SingleThreadContext()
    {
        _thread = new Thread(Run) { IsBackground = true };
        _thread.Start();
    }

    public override void Post(SendOrPostCallback d, object state)
        => _queue.Add((d, state));

    public override void Send(SendOrPostCallback d, object state)
        => d(state);  // simplified

    private void Run()
    {
        SetSynchronizationContext(this);
        foreach (var (callback, state) in _queue.GetConsumingEnumerable())
            callback(state);
    }
}

// ─── LIBRARY CODE — use ConfigureAwait(false) ───
class DatabaseLibrary
{
    public async Task<string> QueryAsync(string sql)
    {
        // ConfigureAwait(false) — don't need to return to caller's context
        await Task.Delay(100).ConfigureAwait(false);

        // This runs on a thread pool thread — NOT the UI/caller thread
        return \$"Result of: {sql}";
    }

    public async Task<int> CountAsync()
    {
        var result = await QueryAsync("SELECT COUNT(*)").ConfigureAwait(false);
        // Still on thread pool thread — fine for pure computation
        return result.Length;
    }
}

// ─── APPLICATION CODE — don't use ConfigureAwait(false) ───
class UserInterface
{
    private string _statusText = "";

    public async Task LoadDataAsync()
    {
        var db = new DatabaseLibrary();

        // Await without ConfigureAwait(false)
        // After this await, we're back on the UI/caller thread
        string data = await db.QueryAsync("SELECT * FROM users");

        // Safe to update UI here — we're on the right thread
        _statusText = \$"Loaded: {data}";
        Console.WriteLine(\$"[UI Thread {Thread.CurrentThread.ManagedThreadId}] {_statusText}");
    }
}

class Program
{
    static async Task Main()
    {
        // ─── THREAD ID TRACKING ───
        Console.WriteLine(\$"Main thread: {Thread.CurrentThread.ManagedThreadId}");

        // Default: resumes on same context
        await Task.Delay(10);
        Console.WriteLine(\$"After default await: {Thread.CurrentThread.ManagedThreadId}");

        // ConfigureAwait(false): may resume on different thread
        await Task.Delay(10).ConfigureAwait(false);
        Console.WriteLine(\$"After ConfigureAwait(false): {Thread.CurrentThread.ManagedThreadId}");

        // ─── LIBRARY CODE ───
        var db = new DatabaseLibrary();
        string result = await db.QueryAsync("SELECT 1");
        Console.WriteLine(\$"DB result: {result}");

        // ─── DEADLOCK DEMO (DON'T do this in real code!) ───
        // The following would deadlock in a UI app with sync context:
        // string bad = GetDataAsync().Result;  // DEADLOCK!

        // Safe alternatives:
        // 1. Always use await (preferred)
        // 2. Use Task.Run to offload: Task.Run(() => GetDataAsync()).Result

        // ─── CURRENT SYNC CONTEXT ───
        var ctx = SynchronizationContext.Current;
        Console.WriteLine(\$"Current SyncContext: {ctx?.GetType().Name ?? "null (thread pool)"}");

        // ─── VALUETASK CONFIGUREAWAIT ───
        ValueTask<int> vt = new ValueTask<int>(42);
        int val = await vt.ConfigureAwait(false);
        Console.WriteLine(val);  // 42

        // ─── TASK.RUN ALWAYS USES THREAD POOL (no sync context) ───
        await Task.Run(async () =>
        {
            var innerCtx = SynchronizationContext.Current;
            Console.WriteLine(\$"Inside Task.Run SyncContext: {innerCtx?.GetType().Name ?? "null"}");
            await Task.Delay(10);  // stays on thread pool
        });
    }
}

─────────────────────────────────────
RULES OF THUMB:
─────────────────────────────────────
Library code          → always use ConfigureAwait(false)
ASP.NET Core app      → ConfigureAwait(false) optional (no ctx)
WPF / WinForms / MAUI → omit ConfigureAwait if updating UI
                         use ConfigureAwait(false) for non-UI work
Console app           → no sync context, doesn't matter
─────────────────────────────────────

📝 KEY POINTS:
✅ Library code should always use ConfigureAwait(false)
✅ ConfigureAwait(false) avoids expensive context switches in hot paths
✅ Never use .Result or .Wait() in UI event handlers — use async all the way
✅ ASP.NET Core has no SynchronizationContext — ConfigureAwait(false) has no effect
✅ Task.Run always runs without a SynchronizationContext
❌ The classic deadlock: .Wait() on UI thread + task tries to resume on UI thread
❌ Don't use ConfigureAwait(false) before UI code — you'll update UI from wrong thread
''',
  quiz: [
    Quiz(question: 'What does ConfigureAwait(false) do?', options: [
      QuizOption(text: 'Tells the await not to capture the SynchronizationContext — resumes on any thread', correct: true),
      QuizOption(text: 'Makes the await non-blocking', correct: false),
      QuizOption(text: 'Disables cancellation for the awaited task', correct: false),
      QuizOption(text: 'Runs the continuation on a background thread specifically', correct: false),
    ]),
    Quiz(question: 'Why does calling .Result on a Task in a UI event handler cause a deadlock?', options: [
      QuizOption(text: 'The UI thread blocks waiting for the task, but the task needs the UI thread to resume — circular wait', correct: true),
      QuizOption(text: 'The UI framework does not support Tasks', correct: false),
      QuizOption(text: '.Result cannot be called from async contexts', correct: false),
      QuizOption(text: 'The task is cancelled when the UI thread is blocked', correct: false),
    ]),
    Quiz(question: 'Does ConfigureAwait(false) have any effect in ASP.NET Core?', options: [
      QuizOption(text: 'No — ASP.NET Core has no SynchronizationContext so there is nothing to skip', correct: true),
      QuizOption(text: 'Yes — it significantly improves ASP.NET Core performance', correct: false),
      QuizOption(text: 'Yes — it prevents request context from being lost', correct: false),
      QuizOption(text: 'No — it is not supported in ASP.NET Core', correct: false),
    ]),
  ],
);
