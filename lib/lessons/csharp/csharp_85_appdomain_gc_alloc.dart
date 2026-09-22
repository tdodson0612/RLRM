// lib/lessons/csharp/csharp_85_appdomain_gc_alloc.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson85 = Lesson(
  language: 'C#',
  title: 'AppDomain, GC Allocation APIs, and Performance',
  content: '''
🎯 METAPHOR:
AppDomain is like a fenced yard inside your property.
Your process (the land) can have one or more yards (domains).
Code in one yard is isolated from the next — different
security zones, different loaded assemblies, separate state.
In .NET Framework, AppDomains were used for plugin isolation.
In .NET Core / .NET 5+, there is only ONE AppDomain per process
— AssemblyLoadContext took over the isolation role.

GC.AllocateUninitializedArray is like being handed a parking
lot before the lines are painted. Normally the GC hands you
a clean, zeroed array. Uninitialized gives you raw asphalt —
faster, but you must paint every space yourself before
letting anyone park (writing before reading).

📖 EXPLANATION:
APPDOMAIN (legacy but still present):
  - .NET Framework: multiple per process
  - .NET Core/.NET 5+: always ONE (AppDomain.CurrentDomain)
  - Still used for: unhandled exception events, assembly info
  - Isolation: use AssemblyLoadContext instead

GC ALLOCATION APIS:
  GC.Collect(gen, mode, blocking)   force collection
  GC.GetTotalMemory(forceCollect)   total managed heap bytes
  GC.GetAllocatedBytesForCurrentThread()  bytes allocated by this thread
  GC.AllocateArray<T>(length, pinned)     allocate with options
  GC.AllocateUninitializedArray<T>(length) allocate without zeroing (faster)
  GC.TryStartNoGCRegion(size)             suppress GC for latency-critical section
  GC.EndNoGCRegion()                      re-enable GC

GC CONFIGURATION:
  Server GC vs Workstation GC
  Background GC
  GCSettings.LatencyMode

💻 CODE:
using System;
using System.Runtime;
using System.Threading;
using System.Diagnostics;

class Program
{
    static void Main()
    {
        // ─── APPDOMAIN ───
        AppDomain domain = AppDomain.CurrentDomain;
        Console.WriteLine(\$"Domain: {domain.FriendlyName}");
        Console.WriteLine(\$"Base dir: {domain.BaseDirectory}");
        Console.WriteLine(\$"Is default: {domain == AppDomain.CurrentDomain}");

        // Unhandled exception handler (useful for logging)
        domain.UnhandledException += (sender, e) =>
        {
            Console.WriteLine(\$"FATAL: {e.ExceptionObject}");
            Console.WriteLine(\$"Is terminating: {e.IsTerminating}");
        };

        // Assembly loaded event
        domain.AssemblyLoad += (sender, e) =>
            Console.WriteLine(\$"Loaded: {e.LoadedAssembly.GetName().Name}");

        // List loaded assemblies
        Console.WriteLine("\nLoaded assemblies:");
        foreach (var asm in domain.GetAssemblies().Take(5))
            Console.WriteLine(\$"  {asm.GetName().Name} v{asm.GetName().Version}");

        // ─── GC BASICS ───
        long before = GC.GetTotalMemory(false);
        Console.WriteLine(\$"\nHeap before: {before:N0} bytes");

        // Allocate some objects
        var list = new System.Collections.Generic.List<byte[]>();
        for (int i = 0; i < 100; i++)
            list.Add(new byte[1024]);

        long after = GC.GetTotalMemory(false);
        Console.WriteLine(\$"Heap after 100KB: {after:N0} bytes");
        Console.WriteLine(\$"Delta: {after - before:N0} bytes");

        // Force collection
        list = null;
        GC.Collect(2, GCCollectionMode.Forced, blocking: true);
        GC.WaitForPendingFinalizers();
        Console.WriteLine(\$"Heap after GC: {GC.GetTotalMemory(false):N0} bytes");

        // GC generation counts
        Console.WriteLine(\$"Gen0 collections: {GC.CollectionCount(0)}");
        Console.WriteLine(\$"Gen1 collections: {GC.CollectionCount(1)}");
        Console.WriteLine(\$"Gen2 collections: {GC.CollectionCount(2)}");

        // ─── THREAD ALLOCATION TRACKING ───
        long allocBefore = GC.GetAllocatedBytesForCurrentThread();

        string s = "Hello " + "World " + DateTime.Now.ToString();
        int[] arr = new int[1000];

        long allocAfter = GC.GetAllocatedBytesForCurrentThread();
        Console.WriteLine(\$"\nThis thread allocated: {allocAfter - allocBefore:N0} bytes");

        // ─── ALLOCATE UNINITIALIZED ARRAY (perf-critical code) ───
        var sw = Stopwatch.StartNew();

        // Normal: zeroed allocation
        for (int i = 0; i < 10_000; i++)
        {
            byte[] zeroed = new byte[1024];
            // All bytes are guaranteed zero
            _ = zeroed[0];
        }
        Console.WriteLine(\$"Zeroed alloc: {sw.ElapsedMilliseconds}ms");

        sw.Restart();
        // Faster: uninitialized (you MUST write before reading)
        for (int i = 0; i < 10_000; i++)
        {
            byte[] raw = GC.AllocateUninitializedArray<byte>(1024);
            // Fill before use — contents are undefined!
            Array.Fill(raw, (byte)0);
            _ = raw[0];
        }
        Console.WriteLine(\$"Uninit alloc: {sw.ElapsedMilliseconds}ms");

        // ─── PINNED ARRAY (for interop) ───
        byte[] pinned = GC.AllocateArray<byte>(256, pinned: true);
        // Pinned arrays don't move during GC — safe to pass to native code
        // Use sparingly — pinning fragments the heap
        Console.WriteLine(\$"Pinned array allocated: {pinned.Length} bytes");

        // ─── NO-GC REGION (latency critical) ───
        long regionSize = 1024 * 1024;  // 1MB — must fit in this budget
        if (GC.TryStartNoGCRegion(regionSize))
        {
            try
            {
                // GC will NOT run in this region (if allocations stay under budget)
                for (int i = 0; i < 100; i++)
                {
                    // Latency-critical work here
                }
            }
            finally
            {
                GC.EndNoGCRegion();
            }
        }

        // ─── GC SETTINGS ───
        Console.WriteLine(\$"\nServer GC: {GCSettings.IsServerGC}");
        Console.WriteLine(\$"Latency mode: {GCSettings.LatencyMode}");

        // Reduce GC pressure during latency-sensitive operations
        GCSettings.LatencyMode = GCLatencyMode.LowLatency;
        // ... latency-sensitive work ...
        GCSettings.LatencyMode = GCLatencyMode.Interactive;  // restore

        // ─── GEN2 SIZE AND MEMORY INFO ───
        var gcInfo = GC.GetGCMemoryInfo();
        Console.WriteLine(\$"Total available memory: {gcInfo.TotalAvailableMemoryBytes:N0}");
        Console.WriteLine(\$"High memory threshold: {gcInfo.HighMemoryLoadThresholdBytes:N0}");
    }

    static System.Collections.Generic.IEnumerable<T> Take<T>(
        System.Collections.Generic.IEnumerable<T> src, int n)
    {
        int count = 0;
        foreach (var item in src) { if (count++ >= n) yield break; yield return item; }
    }
}

📝 KEY POINTS:
✅ AppDomain.CurrentDomain.UnhandledException is the global crash handler
✅ Use AppDomain.GetAssemblies() to inspect loaded assemblies at runtime
✅ GC.AllocateUninitializedArray is faster but you MUST write before reading
✅ GC.TryStartNoGCRegion suppresses GC for latency-critical sections — use sparingly
✅ GCSettings.LatencyMode can reduce GC pauses during time-sensitive work
✅ GC.GetAllocatedBytesForCurrentThread() is great for allocation tracking in tests
❌ Never create new AppDomains in .NET Core — use AssemblyLoadContext instead
❌ Don't overuse GC.Collect() — it disrupts the generational GC strategy
❌ Pinned arrays fragment the heap — use as little as possible
''',
  quiz: [
    Quiz(question: 'What is the key difference between AppDomain in .NET Framework and .NET Core?', options: [
      QuizOption(text: '.NET Core always has exactly one AppDomain per process — use AssemblyLoadContext for isolation', correct: true),
      QuizOption(text: '.NET Core removed AppDomain entirely', correct: false),
      QuizOption(text: '.NET Core AppDomains are faster than .NET Framework ones', correct: false),
      QuizOption(text: '.NET Core supports unlimited AppDomains per thread', correct: false),
    ]),
    Quiz(question: 'What must you do before reading from a GC.AllocateUninitializedArray result?', options: [
      QuizOption(text: 'Write to every element you will read — contents are undefined until written', correct: true),
      QuizOption(text: 'Call Array.Clear() first', correct: false),
      QuizOption(text: 'Pin the array to prevent GC movement', correct: false),
      QuizOption(text: 'Nothing — the JIT guarantees the contents are safe', correct: false),
    ]),
    Quiz(question: 'What does GC.TryStartNoGCRegion() do?', options: [
      QuizOption(text: 'Prevents the GC from running while allocations stay within the specified budget', correct: true),
      QuizOption(text: 'Allocates a region of memory that will never be collected', correct: false),
      QuizOption(text: 'Starts a new generation 0 region for faster allocations', correct: false),
      QuizOption(text: 'Forces all allocations to happen on the stack', correct: false),
    ]),
  ],
);
