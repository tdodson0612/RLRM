// lib/lessons/csharp/csharp_52_generic_constraints.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson52 = Lesson(
  language: 'C#',
  title: 'Generic Constraints In Depth',
  content: '''
🎯 METAPHOR:
Generic constraints are like job requirements.
"Any candidate welcome" (no constraints) means you cannot
assume any skills — you can only say "hello."
"Must have a driver's license" (where T : class) means
you know they can drive. "Must be a doctor" (where T :
IDoctor) means they can diagnose. The more specific your
requirements, the more you can do with whoever shows up.
Constraints let generics do real work instead of just
holding things.

📖 EXPLANATION:
Constraints restrict what types can be used as T,
and in return unlock operations you can perform on T.

─────────────────────────────────────
ALL CONSTRAINT TYPES:
─────────────────────────────────────
where T : class         T must be a reference type
where T : struct        T must be a value type (non-nullable)
where T : notnull       T cannot be a nullable type (C# 8+)
where T : unmanaged     T must be unmanaged (no managed refs)
where T : new()         T must have a parameterless constructor
where T : BaseClass     T must inherit from BaseClass
where T : IInterface    T must implement the interface
where T : U             T must be same as or derive from U
where T : default       override struct/class constraint (C# 9+)

Multiple constraints on one type:
  where T : class, IComparable<T>, new()

Multiple type parameters each with constraints:
  where T : class where U : struct
─────────────────────────────────────

💻 CODE:
using System;
using System.Collections.Generic;
using System.Numerics;

// ─── class CONSTRAINT ───
class Repository<T> where T : class
{
    private List<T> _items = new();
    public void Add(T item) { if (item != null) _items.Add(item); }
    public T Find(Predicate<T> match) => _items.Find(match);
    // T can be null here — reference type
}

// ─── struct CONSTRAINT ───
struct NullableValue<T> where T : struct
{
    private T _value;
    public bool HasValue { get; private set; }

    public T Value
    {
        get => HasValue ? _value : throw new InvalidOperationException("No value");
        set { _value = value; HasValue = true; }
    }

    public T GetValueOrDefault(T defaultVal = default)
        => HasValue ? _value : defaultVal;
}

// ─── new() CONSTRAINT — can create instances ───
class Factory<T> where T : new()
{
    public T Create() => new T();  // only works because of new() constraint

    public List<T> CreateMany(int count)
    {
        var list = new List<T>();
        for (int i = 0; i < count; i++) list.Add(new T());
        return list;
    }
}

// ─── INTERFACE CONSTRAINT — unlock interface members ───
class SortedCollection<T> where T : IComparable<T>
{
    private List<T> _items = new();

    public void Add(T item)
    {
        _items.Add(item);
        _items.Sort();  // works because T implements IComparable<T>
    }

    public T Min() => _items.Count > 0 ? _items[0] : default;
    public T Max() => _items.Count > 0 ? _items[^1] : default;
}

// ─── MULTIPLE CONSTRAINTS ───
class EntityRepository<T> where T : class, IComparable<T>, new()
{
    private List<T> _items = new();

    public T CreateAndAdd()
    {
        var item = new T();       // new() constraint
        _items.Add(item);
        _items.Sort();            // IComparable constraint
        return item;
    }

    public T FindFirst(Predicate<T> pred)
        => _items.Find(pred);     // class constraint — result can be null
}

// ─── UNMANAGED CONSTRAINT — low-level / interop ───
static class LowLevel
{
    public static unsafe int SizeOf<T>() where T : unmanaged
    {
        return sizeof(T);  // only works with unmanaged types
    }

    public static unsafe void WriteToSpan<T>(Span<byte> dest, T value)
        where T : unmanaged
    {
        System.Runtime.InteropServices.MemoryMarshal.Write(dest, ref value);
    }
}

// ─── notnull CONSTRAINT ───
class Cache<TKey, TValue>
    where TKey : notnull      // cannot use nullable key
    where TValue : notnull    // cannot use nullable value
{
    private Dictionary<TKey, TValue> _store = new();
    public void Set(TKey key, TValue value) => _store[key] = value;
    public TValue Get(TKey key) => _store[key];
}

// ─── GENERIC MATH (C# 11 — INumber<T>) ───
static T Sum<T>(IEnumerable<T> values) where T : INumber<T>
{
    T total = T.Zero;
    foreach (T v in values) total += v;
    return total;
}

static T Average<T>(IEnumerable<T> values) where T : INumber<T>
{
    var list = new List<T>(values);
    T total = Sum<T>(list);
    return total / T.CreateChecked(list.Count);
}

class Program
{
    static void Main()
    {
        // class constraint
        var repo = new Repository<string>();
        repo.Add("Alice"); repo.Add("Bob");

        // struct constraint
        var nv = new NullableValue<int>();
        Console.WriteLine(nv.HasValue);  // False
        nv.Value = 42;
        Console.WriteLine(nv.Value);     // 42

        // new() constraint
        var factory = new Factory<List<int>>();
        var newList = factory.Create();  // creates new List<int>()

        // IComparable constraint
        var sorted = new SortedCollection<int>();
        sorted.Add(5); sorted.Add(1); sorted.Add(3);
        Console.WriteLine(sorted.Min()); // 1
        Console.WriteLine(sorted.Max()); // 5

        // unmanaged constraint
        Console.WriteLine(LowLevel.SizeOf<int>());     // 4
        Console.WriteLine(LowLevel.SizeOf<double>());  // 8

        // Generic math
        int[]    ints   = { 1, 2, 3, 4, 5 };
        double[] dbs    = { 1.1, 2.2, 3.3 };
        Console.WriteLine(Sum(ints));        // 15
        Console.WriteLine(Sum(dbs));         // 6.6
        Console.WriteLine(Average(ints));    // 3
    }
}

📝 KEY POINTS:
✅ Constraints unlock operations on T — without them you can only call object methods
✅ class constraint allows null and reference semantics
✅ struct constraint prevents null and enables value semantics
✅ new() lets you call new T() inside the generic method
✅ INumber<T> (C# 11) enables generic math that works on int, double, decimal, etc.
❌ unmanaged constraint means no reference types inside T at all
❌ You cannot combine class and struct constraints on the same type parameter
''',
  quiz: [
    Quiz(question: 'What does "where T : new()" allow inside a generic method?', options: [
      QuizOption(text: 'Creating instances of T with new T()', correct: true),
      QuizOption(text: 'Accessing all constructors of T', correct: false),
      QuizOption(text: 'Cloning existing T instances', correct: false),
      QuizOption(text: 'Calling static methods on T', correct: false),
    ]),
    Quiz(question: 'What does "where T : IComparable<T>" unlock?', options: [
      QuizOption(text: 'The ability to compare and sort T values using CompareTo()', correct: true),
      QuizOption(text: 'The ability to use == on T values', correct: false),
      QuizOption(text: 'The ability to create T with new T()', correct: false),
      QuizOption(text: 'The ability to assign null to T', correct: false),
    ]),
    Quiz(question: 'Can you combine "where T : class" and "where T : struct" on the same type parameter?', options: [
      QuizOption(text: 'No — a type cannot be both a reference type and a value type', correct: true),
      QuizOption(text: 'Yes — it creates a hybrid type', correct: false),
      QuizOption(text: 'Yes — struct takes priority', correct: false),
      QuizOption(text: 'Only in C# 10+', correct: false),
    ]),
  ],
);
