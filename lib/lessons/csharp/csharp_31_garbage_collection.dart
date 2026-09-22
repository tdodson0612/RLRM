// lib/lessons/csharp/csharp_31_garbage_collection.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson31 = Lesson(
  language: 'C#',
  title: 'Garbage Collection and Memory Management',
  content: '''
🎯 METAPHOR:
The garbage collector is like a night cleaning crew in
an office building. You work all day, leave coffee cups,
paper scraps, sticky notes everywhere. The crew comes
through after hours — identifies what is clearly trash
(unreachable objects), cleans it all up, and the office
is fresh again. You never personally throw anything away.
The key is: the crew only takes things that are CLEARLY
no longer needed. If you have even one sticky note pointing
to a coffee cup (a reference), the crew leaves it alone.

IDisposable is the trash can you use for items too
dangerous to leave for the cleaning crew — file handles,
network connections, unmanaged resources. You throw these
away YOURSELF as soon as you are done, not whenever the
crew happens to come through.

📖 EXPLANATION:
C# uses AUTOMATIC GARBAGE COLLECTION:
  - Tracks all object references
  - Periodically finds objects with no references
  - Frees that memory automatically
  - Three generations (Gen0, Gen1, Gen2) for efficiency

You do NOT manually free managed objects.
BUT you must manually release UNMANAGED resources:
  - File handles
  - Network connections
  - Database connections
  - Native memory (unsafe code)

IDisposable — the pattern for releasing unmanaged resources.
Finalizer (~ClassName) — last resort cleanup called by GC.
using statement — ensures Dispose() is always called.

💻 CODE:
using System;
using System.IO;
using System.Runtime.InteropServices;

// ─── IDISPOSABLE PATTERN ───
class DatabaseConnection : IDisposable
{
    private bool _disposed = false;
    private IntPtr _nativeHandle;  // simulated unmanaged resource

    public DatabaseConnection(string connectionString)
    {
        Console.WriteLine(\$"Opening connection: {connectionString}");
        _nativeHandle = new IntPtr(42);  // simulate native handle
    }

    public void Query(string sql)
    {
        ObjectDisposedException.ThrowIf(_disposed, this);
        Console.WriteLine(\$"Executing: {sql}");
    }

    // Main Dispose: called by user or using statement
    public void Dispose()
    {
        Dispose(disposing: true);
        GC.SuppressFinalize(this);  // no need for finalizer now
    }

    // Protected virtual Dispose pattern
    protected virtual void Dispose(bool disposing)
    {
        if (_disposed) return;

        if (disposing)
        {
            // Release managed resources here
            Console.WriteLine("Releasing managed resources");
        }

        // Always release unmanaged resources
        if (_nativeHandle != IntPtr.Zero)
        {
            Console.WriteLine("Closing native database handle");
            _nativeHandle = IntPtr.Zero;
        }

        _disposed = true;
    }

    // Finalizer — safety net if user forgets to Dispose
    ~DatabaseConnection()
    {
        Dispose(disposing: false);
        Console.WriteLine("Finalizer ran (should have called Dispose!)");
    }
}

// ─── SIMPLE IDISPOSABLE (no unmanaged resources) ───
class FileLogger : IDisposable
{
    private StreamWriter _writer;

    public FileLogger(string path)
    {
        _writer = new StreamWriter(path, append: true);
    }

    public void Log(string message)
    {
        _writer.WriteLine(\$"[{DateTime.Now:HH:mm:ss}] {message}");
    }

    public void Dispose()
    {
        _writer?.Dispose();
        _writer = null;
        Console.WriteLine("FileLogger disposed");
    }
}

class Program
{
    static void Main()
    {
        // ─── USING STATEMENT (auto-dispose) ───
        using (var db = new DatabaseConnection("Server=localhost"))
        {
            db.Query("SELECT * FROM users");
            db.Query("SELECT * FROM orders");
        }  // Dispose() called here automatically — even if exception thrown
        Console.WriteLine("After using block");

        // ─── USING DECLARATION (C# 8+) — cleaner syntax ───
        using var logger = new FileLogger("app.log");
        logger.Log("Application started");
        logger.Log("Processing data");
        // Dispose() called when logger goes out of scope (end of method)

        // ─── MULTIPLE USING ───
        using var reader = new StringReader("Hello\\nWorld");
        using var writer = new StringWriter();
        string line;
        while ((line = reader.ReadLine()) != null)
            writer.WriteLine(line.ToUpper());
        Console.WriteLine(writer.ToString());

        // ─── GC INSIGHTS ───
        Console.WriteLine(\$"Gen0 collections: {GC.CollectionCount(0)}");
        Console.WriteLine(\$"Gen1 collections: {GC.CollectionCount(1)}");
        Console.WriteLine(\$"Gen2 collections: {GC.CollectionCount(2)}");
        Console.WriteLine(\$"Total memory: {GC.GetTotalMemory(false):N0} bytes");

        // Force GC (almost never do this in production!)
        GC.Collect();
        GC.WaitForPendingFinalizers();

        // ─── WEAK REFERENCES ───
        // Object can be GC'd even if weak reference exists
        var obj = new object();
        var weak = new WeakReference(obj);

        Console.WriteLine(weak.IsAlive);  // True
        obj = null;  // remove strong reference
        GC.Collect();
        Console.WriteLine(weak.IsAlive);  // likely False (GC'd)
    }
}

─────────────────────────────────────
GENERATIONS:
─────────────────────────────────────
Gen0 — short-lived objects (collected most often, fastest)
Gen1 — medium-lived objects
Gen2 — long-lived objects (collected least often)

New objects start in Gen0. Survivors are promoted.
LOH (Large Object Heap) — objects > 85,000 bytes, Gen2 only
─────────────────────────────────────

📝 KEY POINTS:
✅ Use "using" for any IDisposable — files, streams, connections, timers
✅ Implement IDisposable when your class holds unmanaged resources
✅ Call GC.SuppressFinalize() in Dispose() to prevent double-cleanup
✅ Finalizers are a safety net — do not rely on them for deterministic cleanup
✅ WeakReference lets GC collect an object even if you hold a reference
❌ Never call GC.Collect() in production code — the GC knows better
❌ Don't use a disposed object — throw ObjectDisposedException
''',
  quiz: [
    Quiz(question: 'What is the purpose of the IDisposable interface?', options: [
      QuizOption(text: 'To provide a Dispose() method for releasing unmanaged resources deterministically', correct: true),
      QuizOption(text: 'To allow the garbage collector to collect the object immediately', correct: false),
      QuizOption(text: 'To mark objects that should never be garbage collected', correct: false),
      QuizOption(text: 'To enable weak references to the object', correct: false),
    ]),
    Quiz(question: 'What does the "using" statement guarantee?', options: [
      QuizOption(text: 'Dispose() is called when the block exits — even if an exception is thrown', correct: true),
      QuizOption(text: 'The object is immediately garbage collected after the block', correct: false),
      QuizOption(text: 'The object cannot be modified inside the block', correct: false),
      QuizOption(text: 'Memory is allocated on the stack instead of the heap', correct: false),
    ]),
    Quiz(question: 'What is a finalizer in C# used for?', options: [
      QuizOption(text: 'As a safety net to release resources if Dispose() was never called', correct: true),
      QuizOption(text: 'As the primary way to release unmanaged resources', correct: false),
      QuizOption(text: 'To run code when the program exits normally', correct: false),
      QuizOption(text: 'To prevent the object from being garbage collected', correct: false),
    ]),
  ],
);
