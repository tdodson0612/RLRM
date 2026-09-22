// lib/lessons/csharp/csharp_81_iprogress_weak_events.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson81 = Lesson(
  language: 'C#',
  title: 'IProgress<T>, Weak Events, and ConditionalWeakTable',
  content: '''
🎯 METAPHOR:
IProgress<T> is like a progress bar update messenger.
You hand a long-running task a messenger (IProgress<int>).
Whenever the task reaches a milestone, it calls Report(50)
— "50% done." The messenger knows how to get that back to
the UI thread (or wherever). The task doesn't know or care
about the UI — it just reports. Clean separation.

Weak events are like subscription cards with an expiry.
Normal events hold a strong reference — the subscriber
stays alive AS LONG AS the publisher is alive, even if
nobody else holds the subscriber. This is a memory leak.
Weak events hold a WeakReference — when nobody else needs
the subscriber, it gets garbage collected. The publisher
moves on without the dead subscriber.

📖 EXPLANATION:
IProgress<T>:
  - Standard interface for reporting progress
  - Progress<T> implementation dispatches to captured SynchronizationContext
  - Task receives IProgress<T>, calls Report() to push updates
  - Caller creates Progress<T> with a callback

WEAK EVENTS:
  - Normal events prevent GC of subscribers
  - WeakEventManager (WPF) or manual WeakReference pattern
  - Essential in GUI: model outlives the view but shouldn't prevent GC

ConditionalWeakTable<TKey, TValue>:
  - Associate data with objects WITHOUT preventing GC
  - When the key object is collected, the value is too
  - Used to "attach" metadata to objects you don't own

💻 CODE:
using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using System.Threading;
using System.Threading.Tasks;

// ─── IPROGRESS<T> ───
class FileProcessor
{
    // Task accepts IProgress — reports without knowing about UI
    public async Task ProcessFilesAsync(
        string[] files,
        IProgress<(int current, int total, string fileName)> progress = null,
        CancellationToken ct = default)
    {
        for (int i = 0; i < files.Length; i++)
        {
            ct.ThrowIfCancellationRequested();
            await Task.Delay(100, ct);  // simulate file processing
            progress?.Report((i + 1, files.Length, files[i]));
        }
    }
}

// ─── WEAK EVENT PATTERN ───
class WeakEventSource<TEventArgs>
{
    private readonly List<WeakReference<EventHandler<TEventArgs>>> _handlers = new();

    public void AddHandler(EventHandler<TEventArgs> handler)
    {
        CleanupDead();
        _handlers.Add(new WeakReference<EventHandler<TEventArgs>>(handler));
    }

    public void RemoveHandler(EventHandler<TEventArgs> handler)
    {
        _handlers.RemoveAll(wr =>
            !wr.TryGetTarget(out var h) || h == handler);
    }

    public void Raise(object sender, TEventArgs args)
    {
        CleanupDead();
        foreach (var wr in _handlers.ToArray())
        {
            if (wr.TryGetTarget(out var handler))
                handler(sender, args);
        }
    }

    private void CleanupDead()
        => _handlers.RemoveAll(wr => !wr.TryGetTarget(out _));
}

class DataModel
{
    public WeakEventSource<EventArgs> DataChanged { get; } = new();

    public void UpdateData()
    {
        Console.WriteLine("Data updated");
        DataChanged.Raise(this, EventArgs.Empty);
    }
}

class ViewController
{
    private readonly string _name;
    public ViewController(string name, DataModel model)
    {
        _name = name;
        // Subscribe with strong reference — but model holds only weak ref
        model.DataChanged.AddHandler(OnDataChanged);
    }

    private void OnDataChanged(object sender, EventArgs e)
        => Console.WriteLine(\$"[{_name}] Refreshing view");

    // When ViewController is GC'd, the weak reference becomes dead
    // DataModel.DataChanged.Raise() will skip dead handlers
}

// ─── CONDITIONALWEAKTABLE ───
// Attach data to objects you don't own
class ObjectAnnotator
{
    // Key = any object, Value = our metadata
    private static readonly ConditionalWeakTable<object, ObjectMetadata> _table = new();

    public static void Annotate(object obj, string tag)
    {
        var meta = _table.GetOrCreateValue(obj);
        meta.Tag = tag;
        meta.CreatedAt = DateTime.UtcNow;
    }

    public static ObjectMetadata GetAnnotation(object obj)
    {
        _table.TryGetValue(obj, out var meta);
        return meta;
    }
}

class ObjectMetadata
{
    public string Tag { get; set; }
    public DateTime CreatedAt { get; set; }
}

class Program
{
    static async Task Main()
    {
        // ─── IPROGRESS ───
        var processor = new FileProcessor();
        string[] files = { "a.txt", "b.txt", "c.txt", "d.txt", "e.txt" };

        // Progress<T> captures current SynchronizationContext
        // Callback is invoked on the correct thread
        var progress = new Progress<(int current, int total, string fileName)>(p =>
        {
            double pct = (double)p.current / p.total * 100;
            Console.WriteLine(\$"Progress: {pct:F0}% - Processing {p.fileName} ({p.current}/{p.total})");
        });

        await processor.ProcessFilesAsync(files, progress);
        Console.WriteLine("All files processed!");

        // ─── WEAK EVENTS ───
        var model = new DataModel();

        {
            var view1 = new ViewController("View1", model);
            var view2 = new ViewController("View2", model);
            model.UpdateData();  // Both views respond
        }
        // view1 and view2 go out of scope here
        GC.Collect();
        GC.WaitForPendingFinalizers();

        model.UpdateData();  // Dead refs cleaned up — no more view notifications
        Console.WriteLine("(Views were GC'd — no more updates)");

        // ─── CONDITIONALWEAKTABLE ───
        var obj1 = new object();
        var obj2 = new object();

        ObjectAnnotator.Annotate(obj1, "Primary");
        ObjectAnnotator.Annotate(obj2, "Secondary");

        var meta1 = ObjectAnnotator.GetAnnotation(obj1);
        Console.WriteLine(\$"obj1 tag: {meta1?.Tag}");   // Primary

        // When obj1 is GC'd, its metadata is also GC'd automatically
        obj1 = null;
        GC.Collect();
        Console.WriteLine("obj1 GC'd — metadata cleaned up automatically");
    }
}

📝 KEY POINTS:
✅ IProgress<T> keeps tasks free of UI concerns — clean separation
✅ Progress<T> automatically marshals Report() to the captured SynchronizationContext
✅ Weak events prevent memory leaks when subscribers don't explicitly unsubscribe
✅ ConditionalWeakTable attaches metadata to objects without preventing GC
✅ Always call GC.Collect() + WaitForPendingFinalizers() in tests to verify weak ref cleanup
❌ Don't use weak events for short-lived publishers — overhead is not worth it
❌ ConditionalWeakTable is not a general-purpose dictionary — keys are by reference identity
''',
  quiz: [
    Quiz(question: 'What does Progress<T> do with the callback when Report() is called?', options: [
      QuizOption(text: 'Dispatches the callback to the SynchronizationContext captured at construction time', correct: true),
      QuizOption(text: 'Calls the callback immediately on the current thread', correct: false),
      QuizOption(text: 'Queues the callback to run on a thread pool thread', correct: false),
      QuizOption(text: 'Stores the progress value until the task completes', correct: false),
    ]),
    Quiz(question: 'What problem do weak events solve?', options: [
      QuizOption(text: 'Normal events hold strong references to subscribers — preventing GC even when nobody else needs them', correct: true),
      QuizOption(text: 'Normal events do not support multiple subscribers', correct: false),
      QuizOption(text: 'Weak events are faster than normal events', correct: false),
      QuizOption(text: 'Normal events can only be used on the UI thread', correct: false),
    ]),
    Quiz(question: 'What happens to ConditionalWeakTable entries when the key object is garbage collected?', options: [
      QuizOption(text: 'The entry is automatically removed — the value is also eligible for GC', correct: true),
      QuizOption(text: 'The entry stays in the table with a null key', correct: false),
      QuizOption(text: 'An exception is thrown when accessing the entry', correct: false),
      QuizOption(text: 'The value keeps the key alive and prevents GC', correct: false),
    ]),
  ],
);
