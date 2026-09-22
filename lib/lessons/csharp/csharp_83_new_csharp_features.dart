// lib/lessons/csharp/csharp_83_new_csharp_features.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson83 = Lesson(
  language: 'C#',
  title: 'C# 13 and Latest Language Features',
  content: '''
🎯 METAPHOR:
Each C# release is like a new edition of a dictionary.
The core words (fundamentals) are the same, but new words
are added for concepts that have become common enough to
deserve their own dedicated entry. C# 13 adds words like
"params collections," "Lock type," and "partial properties"
— things developers kept writing workarounds for that now
have first-class support.

📖 EXPLANATION:
C# 13 (.NET 9, 2024) adds:

params COLLECTIONS:
  params can now work with any collection type, not just arrays.
  params IEnumerable<T>, params List<T>, params Span<T>

Lock TYPE (System.Threading.Lock):
  New Lock class optimized for the .NET runtime.
  Better performance than "lock (object)" in hot paths.

PARTIAL PROPERTIES AND INDEXERS:
  Partial members now work for properties and indexers.
  Used with source generators.

ref/unsafe in ITERATORS and ASYNC:
  ref locals can now be used in iterators.
  Allows ref struct usage in async methods in some cases.

OVERLOAD RESOLUTION PRIORITY:
  [OverloadResolutionPriority] attribute lets library authors
  prefer one overload over another.

ALLOWS REF STRUCT:
  Generic constraint: where T : allows ref struct
  Allows Span<T> and other ref structs as type arguments.

COLLECTION EXPRESSIONS IMPROVEMENTS:
  Spread operator (..) works with more collection types.

💻 CODE:
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Runtime.CompilerServices;

// ─── PARAMS COLLECTIONS (C# 13) ───
class DataProcessor
{
    // Works with IEnumerable<T> now, not just arrays
    public static int Sum(params IEnumerable<int> numbers)
        => numbers.Sum();

    public static string Join(params ReadOnlySpan<string> values)
        => string.Join(", ", values.ToArray());

    // Still works with array (backward compat)
    public static double Average(params double[] values)
        => values.Average();
}

// ─── LOCK TYPE (C# 13) ───
class ThreadSafeCounter
{
    private readonly Lock _lock = new Lock();  // new System.Threading.Lock
    private int _count = 0;

    public void Increment()
    {
        lock (_lock)  // same syntax — but uses Lock's optimized Enter/Exit
        {
            _count++;
        }
    }

    // Or using the scoped form:
    public void IncrementScoped()
    {
        using (_lock.EnterScope())  // IDisposable scope
        {
            _count++;
        }
    }

    public int Count => _count;
}

// ─── PARTIAL PROPERTIES (C# 13) ───
// Declaration (typically in a partial class alongside source generator output)
partial class ViewModel
{
    // Declaration side
    public partial string Name { get; set; }
}

// Implementation side (generated or hand-written)
partial class ViewModel
{
    private string _name = "";

    public partial string Name
    {
        get => _name;
        set
        {
            if (_name != value)
            {
                _name = value;
                Console.WriteLine(\$"Name changed to {value}");
                // Fire PropertyChanged etc.
            }
        }
    }
}

// ─── OVERLOAD RESOLUTION PRIORITY (C# 13) ───
class Formatter
{
    // Lower priority — old overload
    public string Format(object value) => \$"object: {value}";

    // Higher priority — preferred when both match
    [OverloadResolutionPriority(1)]
    public string Format(string value) => \$"string: {value}";
}

// ─── ALLOWS REF STRUCT (C# 13) ───
// Generic method that can accept ref structs (like Span<T>)
static T FirstOrDefault<T>(params ReadOnlySpan<T> items)
    where T : allows ref struct
{
    return items.Length > 0 ? items[0] : default;
}

// ─── COLLECTION EXPRESSIONS (C# 12 + improvements) ───
class CollectionDemo
{
    public static void Run()
    {
        // Collection expression for any collection type
        List<int>    list    = [1, 2, 3, 4, 5];
        int[]        array   = [1, 2, 3];
        HashSet<int> set     = [1, 2, 3, 2, 1];  // {1,2,3}

        // Spread operator
        int[] first  = [1, 2, 3];
        int[] second = [4, 5, 6];
        int[] all    = [..first, ..second, 7, 8];  // [1,2,3,4,5,6,7,8]

        // Nested spread
        int[][] pages = [[1,2,3], [4,5,6], [7,8,9]];
        int[] flat = [..pages[0], ..pages[1], ..pages[2]];

        Console.WriteLine(string.Join(",", all));
        Console.WriteLine(string.Join(",", flat));
    }
}

// ─── C# 12: PRIMARY CONSTRUCTORS DEEP DIVE ───
class Service(ILogger logger, string name)
{
    // Parameters available throughout the class
    public string Name => name;

    public void DoWork()
    {
        logger.Log(\$"{name} working...");
    }

    // Dependency injection friendly
    public Service WithName(string newName) => new(logger, newName);
}

interface ILogger { void Log(string msg); }
class ConsoleLog : ILogger { public void Log(string m) => Console.WriteLine(\$"[LOG] {m}"); }

class Program
{
    static void Main()
    {
        // params collections
        Console.WriteLine(DataProcessor.Sum([1, 2, 3, 4, 5]));  // 15
        Console.WriteLine(DataProcessor.Sum(Enumerable.Range(1, 10)));  // 55
        Console.WriteLine(DataProcessor.Join("Hello", "World", "C#"));

        // Lock type
        var counter = new ThreadSafeCounter();
        Parallel.For(0, 1000, _ => counter.Increment());
        Console.WriteLine(\$"Count: {counter.Count}");  // 1000

        // Partial property
        var vm = new ViewModel();
        vm.Name = "Alice";   // Name changed to Alice
        vm.Name = "Alice";   // No change — no event

        // Overload resolution priority
        var fmt = new Formatter();
        Console.WriteLine(fmt.Format("hello"));  // string: hello (preferred)
        Console.WriteLine(fmt.Format((object)"hello"));  // object: hello (explicit)

        // Collection expressions
        CollectionDemo.Run();

        // Primary constructor
        var svc = new Service(new ConsoleLog(), "MyService");
        svc.DoWork();  // [LOG] MyService working...
        var svc2 = svc.WithName("OtherService");
        svc2.DoWork();
    }
}

📝 KEY POINTS:
✅ params now works with IEnumerable<T>, List<T>, Span<T>, and more in C# 13
✅ System.Threading.Lock is more efficient than locking on a plain object
✅ Partial properties enable source generators to add property behavior
✅ [OverloadResolutionPriority] lets library authors guide overload selection
✅ allows ref struct constraint enables generic algorithms to accept Span<T>
❌ Lock type requires .NET 9+ — use the classic object lock for older targets
❌ Partial properties only work in partial classes — they need both halves compiled
''',
  quiz: [
    Quiz(question: 'What new collection types does C# 13 allow with the params keyword?', options: [
      QuizOption(text: 'Any collection type including IEnumerable<T>, List<T>, and Span<T>', correct: true),
      QuizOption(text: 'Only arrays — params always required arrays', correct: false),
      QuizOption(text: 'Only IList<T> and ICollection<T>', correct: false),
      QuizOption(text: 'Only generic interfaces, not concrete types', correct: false),
    ]),
    Quiz(question: 'What advantage does System.Threading.Lock have over "lock (object)"?', options: [
      QuizOption(text: 'It is optimized by the runtime for better performance in high-contention scenarios', correct: true),
      QuizOption(text: 'It supports async/await inside the lock block', correct: false),
      QuizOption(text: 'It prevents deadlocks automatically', correct: false),
      QuizOption(text: 'It is lighter than a regular object in memory', correct: false),
    ]),
    Quiz(question: 'What does "where T : allows ref struct" enable?', options: [
      QuizOption(text: 'Allows ref struct types like Span<T> to be used as type arguments', correct: true),
      QuizOption(text: 'Prevents reference types from being used as type arguments', correct: false),
      QuizOption(text: 'Allows the method to return a ref struct', correct: false),
      QuizOption(text: 'Enables unsafe code within the generic method', correct: false),
    ]),
  ],
);
