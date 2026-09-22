// lib/lessons/csharp/csharp_71_idisposable_iasync.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson71 = Lesson(
  language: 'C#',
  title: 'IDisposable and IAsyncDisposable In Depth',
  content: '''
🎯 METAPHOR:
IDisposable is a rental agreement with a strict return policy.
When you rent a car (acquire a resource), you MUST return it
when done — not whenever the impound lot (GC) decides to
tow it. The "using" statement is your automated return
reminder: walk out the door and the car is automatically
returned. Miss it and you've left a running engine in the
parking lot forever (resource leak).

IAsyncDisposable is the same contract but for async resources
— like returning a streaming video you've been watching. The
close operation itself is async (buffering, flushing to server),
so you need "await using" to wait for it to fully complete.

📖 EXPLANATION:
IDisposable:
  - Defines void Dispose()
  - use with "using" statement or "using" declaration
  - For synchronous cleanup: file handles, DB connections, mutexes

IAsyncDisposable (C# 8+):
  - Defines ValueTask DisposeAsync()
  - Use with "await using"
  - For async cleanup: network streams, async DB connections

FULL DISPOSE PATTERN:
  - Handles both managed and unmanaged resources
  - Handles both Dispose() calls and GC finalizer calls
  - Uses a "disposed" flag to prevent double-dispose

💻 CODE:
using System;
using System.IO;
using System.Threading.Tasks;

// ─── SIMPLE IDISPOSABLE ───
class SimpleResource : IDisposable
{
    private bool _disposed = false;
    private readonly string _name;

    public SimpleResource(string name)
    {
        _name = name;
        Console.WriteLine(\$"[{_name}] Acquired");
    }

    public void DoWork()
    {
        ObjectDisposedException.ThrowIf(_disposed, this);
        Console.WriteLine(\$"[{_name}] Working...");
    }

    public void Dispose()
    {
        if (_disposed) return;
        Console.WriteLine(\$"[{_name}] Released");
        _disposed = true;
    }
}

// ─── FULL DISPOSE PATTERN (unmanaged + managed) ───
class FullResource : IDisposable
{
    private bool _disposed = false;
    private Stream _stream;           // managed resource
    private IntPtr _nativeHandle;     // unmanaged resource

    public FullResource()
    {
        _stream = new MemoryStream();
        _nativeHandle = new IntPtr(42); // simulate native handle
    }

    public void Dispose()
    {
        Dispose(disposing: true);
        GC.SuppressFinalize(this); // no need for finalizer now
    }

    protected virtual void Dispose(bool disposing)
    {
        if (_disposed) return;

        if (disposing)
        {
            // Release MANAGED resources
            _stream?.Dispose();
            _stream = null;
        }

        // Release UNMANAGED resources (always)
        if (_nativeHandle != IntPtr.Zero)
        {
            _nativeHandle = IntPtr.Zero;
        }

        _disposed = true;
    }

    ~FullResource()
    {
        // Safety net: if user forgot to call Dispose()
        Dispose(disposing: false);
    }
}

// ─── IASYNC DISPOSABLE ───
class AsyncResource : IAsyncDisposable
{
    private bool _disposed = false;
    private readonly string _name;

    public AsyncResource(string name)
    {
        _name = name;
        Console.WriteLine(\$"[{_name}] Async resource opened");
    }

    public async Task DoWorkAsync()
    {
        ObjectDisposedException.ThrowIf(_disposed, this);
        await Task.Delay(50);
        Console.WriteLine(\$"[{_name}] Async work done");
    }

    public async ValueTask DisposeAsync()
    {
        if (_disposed) return;
        await Task.Delay(10); // simulate async flush/close
        Console.WriteLine(\$"[{_name}] Async resource closed");
        _disposed = true;
    }
}

// ─── BOTH INTERFACES ───
class DualResource : IDisposable, IAsyncDisposable
{
    private bool _disposed = false;

    public void Dispose()
    {
        if (_disposed) return;
        Console.WriteLine("Sync dispose");
        _disposed = true;
    }

    public async ValueTask DisposeAsync()
    {
        if (_disposed) return;
        await Task.Delay(10);
        Console.WriteLine("Async dispose");
        _disposed = true;
        GC.SuppressFinalize(this);
    }
}

class Program
{
    static async Task Main()
    {
        // ─── USING STATEMENT ───
        using (var r = new SimpleResource("DB"))
        {
            r.DoWork();
        } // Dispose() called here

        // ─── USING DECLARATION (C# 8) ───
        using var r2 = new SimpleResource("File");
        r2.DoWork();
        // Dispose() called at end of enclosing scope

        // ─── MULTIPLE USING ───
        using var a = new SimpleResource("A");
        using var b = new SimpleResource("B");
        // Disposed in reverse order: B then A

        // ─── AWAIT USING ───
        await using var ar = new AsyncResource("Stream");
        await ar.DoWorkAsync();
        // DisposeAsync() called here with await

        // ─── AWAIT USING STATEMENT ───
        await using (var ar2 = new AsyncResource("Network"))
        {
            await ar2.DoWorkAsync();
        }

        // ─── EXCEPTION SAFETY ───
        try
        {
            using var safe = new SimpleResource("Safe");
            safe.DoWork();
            throw new Exception("Something went wrong");
        }
        catch (Exception ex)
        {
            Console.WriteLine(\$"Caught: {ex.Message}");
            // Dispose() was still called despite the exception!
        }

        // ─── DUAL RESOURCE ───
        await using var dual = new DualResource();
        // Uses async path when available
    }
}

─────────────────────────────────────
USING PATTERN CHEAT SHEET:
─────────────────────────────────────
using (var r = new R()) { }         old style
using var r = new R();              C# 8 declaration
await using (var r = new AR()) { }  async old style
await using var r = new AR();       async C# 8 declaration
─────────────────────────────────────

📝 KEY POINTS:
✅ Always use "using" for IDisposable — never rely on GC to call Dispose()
✅ Use "await using" for IAsyncDisposable — it awaits DisposeAsync()
✅ The full dispose pattern handles both user calls and GC finalizer calls
✅ Set _disposed = true and check it at the start — prevent double-dispose
✅ GC.SuppressFinalize(this) skips the finalizer when Dispose() already ran
❌ Never use a disposed object — check _disposed and throw ObjectDisposedException
❌ Don't do heavy work in finalizers — they run on the GC finalizer thread
''',
  quiz: [
    Quiz(question: 'What does "await using" do differently from "using"?', options: [
      QuizOption(text: 'It calls DisposeAsync() and awaits it — for async cleanup', correct: true),
      QuizOption(text: 'It disposes the resource on a background thread', correct: false),
      QuizOption(text: 'It is identical to "using" — just newer syntax', correct: false),
      QuizOption(text: 'It disposes the resource only if no exception occurred', correct: false),
    ]),
    Quiz(question: 'Why call GC.SuppressFinalize(this) in Dispose()?', options: [
      QuizOption(text: 'To prevent the finalizer from running again after Dispose() already cleaned up', correct: true),
      QuizOption(text: 'To force garbage collection immediately', correct: false),
      QuizOption(text: 'To prevent the object from being garbage collected', correct: false),
      QuizOption(text: 'To suppress any exceptions from the finalizer', correct: false),
    ]),
    Quiz(question: 'What is the purpose of the "disposed" flag in the dispose pattern?', options: [
      QuizOption(text: 'Prevents double-dispose and allows ObjectDisposedException to be thrown on reuse', correct: true),
      QuizOption(text: 'Tracks whether the object was created with "using"', correct: false),
      QuizOption(text: 'Controls whether managed or unmanaged resources are released', correct: false),
      QuizOption(text: 'Signals the GC that the object is ready for collection', correct: false),
    ]),
  ],
);
