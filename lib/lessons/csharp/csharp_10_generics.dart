// lib/lessons/csharp/csharp_10_generics.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson10 = Lesson(
  language: 'C#',
  title: 'Generics',
  content: '''
🎯 METAPHOR:
Generics are like a shipping container with a label.
A plain container (object type) can hold anything —
but you open it and you don't know if it's books, fish,
or electronics. Risky. A labeled container (generic) says
"ONLY electronics." When you open it, you KNOW what's inside.
No guessing, no accidental type errors, no casting needed.
List<string> is a container labeled "strings only."

📖 EXPLANATION:
Generics let you write code that works with any type
while maintaining type safety at compile time.

Without generics: you'd use object and cast everything.
With generics: the type is a parameter — the compiler
tracks it and prevents misuse.

C# generics are a first-class language feature, not an
afterthought like Java's generics. They work with value
types too (List<int> stores real ints, not boxed objects).

GENERIC CONSTRAINTS (where T : ...):
  where T : class        T must be a reference type
  where T : struct       T must be a value type
  where T : new()        T must have a default constructor
  where T : BaseClass    T must inherit from BaseClass
  where T : IInterface   T must implement interface

💻 CODE:
using System;
using System.Collections.Generic;

// ─── GENERIC CLASS ───
class Box<T>
{
    private T _value;
    public bool HasValue { get; private set; }

    public void Put(T item)
    {
        _value = item;
        HasValue = true;
        Console.WriteLine(\$"Box now contains: {item}");
    }

    public T Take()
    {
        if (!HasValue) throw new InvalidOperationException("Box is empty!");
        HasValue = false;
        return _value;
    }
}

// ─── GENERIC CLASS WITH CONSTRAINT ───
class SortedList<T> where T : IComparable<T>
{
    private List<T> _items = new();

    public void Add(T item)
    {
        _items.Add(item);
        _items.Sort();
    }

    public void Display()
    {
        Console.WriteLine(string.Join(", ", _items));
    }
}

// ─── GENERIC METHOD ───
class Utilities
{
    // Generic method — T is a type parameter of the method
    public static T Max<T>(T a, T b) where T : IComparable<T>
    {
        return a.CompareTo(b) >= 0 ? a : b;
    }

    // Swap any two values
    public static void Swap<T>(ref T a, ref T b)
    {
        T temp = a;
        a = b;
        b = temp;
    }

    // Filter a list by predicate
    public static List<T> Filter<T>(List<T> items, Func<T, bool> predicate)
    {
        var result = new List<T>();
        foreach (var item in items)
            if (predicate(item)) result.Add(item);
        return result;
    }
}

// ─── GENERIC INTERFACE ───
interface IRepository<T>
{
    void Add(T item);
    T Get(int id);
    IEnumerable<T> GetAll();
}

class InMemoryRepository<T> : IRepository<T>
{
    private Dictionary<int, T> _store = new();
    private int _nextId = 1;

    public void Add(T item) => _store[_nextId++] = item;
    public T Get(int id) => _store[id];
    public IEnumerable<T> GetAll() => _store.Values;
}

class Program
{
    static void Main()
    {
        // Generic class
        var intBox = new Box<int>();
        intBox.Put(42);
        int val = intBox.Take();
        Console.WriteLine(val);  // 42

        var stringBox = new Box<string>();
        stringBox.Put("Hello");
        // intBox and stringBox are different types — type safe!

        // Sorted list
        var sorted = new SortedList<int>();
        sorted.Add(5); sorted.Add(2); sorted.Add(8); sorted.Add(1);
        sorted.Display();  // 1, 2, 5, 8

        var sortedStr = new SortedList<string>();
        sortedStr.Add("banana"); sortedStr.Add("apple"); sortedStr.Add("cherry");
        sortedStr.Display();  // apple, banana, cherry

        // Generic method — type inferred
        Console.WriteLine(Utilities.Max(3, 7));             // 7
        Console.WriteLine(Utilities.Max("apple", "banana")); // banana

        // Explicit type parameter
        Console.WriteLine(Utilities.Max<double>(3.14, 2.71));  // 3.14

        // Swap
        int x = 1, y = 2;
        Utilities.Swap(ref x, ref y);
        Console.WriteLine(\$"x={x}, y={y}");  // x=2, y=1

        // Filter
        var numbers = new List<int> { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
        var evens = Utilities.Filter(numbers, n => n % 2 == 0);
        Console.WriteLine(string.Join(", ", evens));  // 2, 4, 6, 8, 10

        // Built-in generic collections
        var list = new List<string> { "a", "b", "c" };
        var dict = new Dictionary<string, int>();
        dict["one"] = 1;
        dict["two"] = 2;
        var stack = new Stack<int>();
        var queue = new Queue<double>();
    }
}

📝 KEY POINTS:
✅ Generics provide type safety without the overhead of casting to/from object
✅ Constraints (where T :) let you use specific operations on T
✅ The compiler infers the type argument when it can
✅ Generic value types (List<int>) store real ints — no boxing overhead
✅ IComparable<T> is the key constraint for sorting and comparing
❌ Don't use object when you can use generics — you lose compile-time safety
❌ Over-constraining generics defeats their purpose — use the minimum constraints needed
''',
  quiz: [
    Quiz(question: 'What does "where T : IComparable<T>" mean in a generic constraint?', options: [
      QuizOption(text: 'T must implement IComparable<T>, allowing comparison operations', correct: true),
      QuizOption(text: 'T must be comparable to other types', correct: false),
      QuizOption(text: 'T must be a numeric type', correct: false),
      QuizOption(text: 'T must have a default constructor', correct: false),
    ]),
    Quiz(question: 'What is the main advantage of generics over using "object" type?', options: [
      QuizOption(text: 'Type safety at compile time — no casting required', correct: true),
      QuizOption(text: 'Generics run faster at compile time', correct: false),
      QuizOption(text: 'Generics use less memory', correct: false),
      QuizOption(text: 'Generics work with more types than object', correct: false),
    ]),
    Quiz(question: 'In List<int>, are the ints stored as boxed objects in C#?', options: [
      QuizOption(text: 'No — C# generics store real value types without boxing', correct: true),
      QuizOption(text: 'Yes — all generics box value types internally', correct: false),
      QuizOption(text: 'Only if the list has more than 1000 elements', correct: false),
      QuizOption(text: 'It depends on the .NET runtime version', correct: false),
    ]),
  ],
);
