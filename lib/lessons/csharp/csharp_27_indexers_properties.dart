// lib/lessons/csharp/csharp_27_indexers_properties.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson27 = Lesson(
  language: 'C#',
  title: 'Indexers and Advanced Properties',
  content: '''
🎯 METAPHOR:
An indexer is like giving your own class the ability to use
square bracket notation — just like arrays and dictionaries.
Instead of myObj.GetItem(3), you write myObj[3].
It is syntax sugar that makes your custom collection-like
classes feel as natural as the built-in ones.

Advanced properties are like smart electrical outlets.
A basic outlet just delivers power (field). A smart outlet
can log usage, enforce limits, notify other devices when
power is drawn (property with logic). Same plug, much more
control behind the wall.

📖 EXPLANATION:
INDEXERS — let objects be indexed like arrays.
  Defined with "this[type parameter]" syntax.
  Can have get and/or set.
  Can be overloaded with different index types.

ADVANCED PROPERTY PATTERNS:
  init-only properties (C# 9)
  required properties (C# 11)
  Computed / calculated properties
  Lazy initialization properties
  Property change notification

💻 CODE:
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;

// ─── INDEXER ───
class WordCollection
{
    private List<string> _words = new();

    // Integer indexer
    public string this[int index]
    {
        get => _words[index];
        set => _words[index] = value;
    }

    // String indexer (overload)
    public bool this[string word]
    {
        get => _words.Contains(word);
    }

    public void Add(string word) => _words.Add(word);
    public int Count => _words.Count;
}

// ─── MATRIX WITH INDEXER ───
class Matrix
{
    private double[,] _data;
    public int Rows { get; }
    public int Cols { get; }

    public Matrix(int rows, int cols)
    {
        Rows = rows; Cols = cols;
        _data = new double[rows, cols];
    }

    // 2D indexer
    public double this[int row, int col]
    {
        get => _data[row, col];
        set => _data[row, col] = value;
    }
}

// ─── INIT-ONLY PROPERTIES (C# 9) ───
class ImmutableConfig
{
    public string Host { get; init; }
    public int Port { get; init; }
    public bool UseSsl { get; init; } = true;

    // Can be set in object initializer but NOT after
}

// ─── REQUIRED PROPERTIES (C# 11) ───
class UserProfile
{
    public required string Username { get; init; }  // MUST be set
    public required string Email { get; init; }
    public string DisplayName { get; set; }
}

// ─── PROPERTY CHANGE NOTIFICATION ───
class ObservableItem : INotifyPropertyChanged
{
    public event PropertyChangedEventHandler PropertyChanged;

    private string _name;
    public string Name
    {
        get => _name;
        set
        {
            if (_name != value)
            {
                _name = value;
                OnPropertyChanged();  // notify listeners
            }
        }
    }

    private decimal _price;
    public decimal Price
    {
        get => _price;
        set
        {
            if (_price != value)
            {
                _price = value;
                OnPropertyChanged();
            }
        }
    }

    protected void OnPropertyChanged([CallerMemberName] string name = null)
        => PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
}

// ─── LAZY INITIALIZATION ───
class ExpensiveResource
{
    // Only computed on first access
    private Lazy<string> _data = new(() =>
    {
        Console.WriteLine("(computing expensive data...)");
        return string.Join(",", System.Linq.Enumerable.Range(1, 1000));
    });

    public string Data => _data.Value;
}

class Program
{
    static void Main()
    {
        // ─── INDEXER USAGE ───
        var words = new WordCollection();
        words.Add("hello");
        words.Add("world");
        words.Add("foo");

        Console.WriteLine(words[0]);         // hello
        Console.WriteLine(words[1]);         // world
        words[1] = "C#";
        Console.WriteLine(words[1]);         // C#

        Console.WriteLine(words["hello"]);   // True (string indexer)
        Console.WriteLine(words["java"]);    // False

        // ─── MATRIX ───
        var matrix = new Matrix(3, 3);
        matrix[0, 0] = 1; matrix[1, 1] = 5; matrix[2, 2] = 9;
        Console.WriteLine(matrix[1, 1]);  // 5

        // ─── INIT-ONLY ───
        var config = new ImmutableConfig
        {
            Host = "localhost",
            Port = 5432,
            UseSsl = false
        };
        Console.WriteLine(\$"{config.Host}:{config.Port}");
        // config.Host = "other";  // ERROR: init-only!

        // ─── REQUIRED ───
        var profile = new UserProfile
        {
            Username = "alice",
            Email = "alice@example.com"
        };
        // new UserProfile { Email = "x" }  // ERROR: Username is required!

        // ─── PROPERTY CHANGE ───
        var item = new ObservableItem();
        item.PropertyChanged += (s, e) =>
            Console.WriteLine(\$"Property changed: {e.PropertyName}");

        item.Name = "Widget";   // fires PropertyChanged
        item.Price = 9.99m;     // fires PropertyChanged
        item.Name = "Widget";   // no change — no event

        // ─── LAZY ───
        var resource = new ExpensiveResource();
        Console.WriteLine("Resource created (no computation yet)");
        Console.WriteLine(resource.Data[..20]);  // NOW it computes
        Console.WriteLine(resource.Data[..20]);  // cached — no recompute
    }
}

📝 KEY POINTS:
✅ Indexers let custom classes support [] syntax naturally
✅ Indexers can be overloaded with different parameter types
✅ init-only properties can only be set during object initialization
✅ required properties (C# 11) force callers to provide values
✅ INotifyPropertyChanged is the foundation of data binding in WPF/MAUI
✅ Lazy<T> defers expensive computation until first access
❌ Don't put heavy computation in property getters — callers don't expect it
❌ Don't make indexers do unexpected things — keep them collection-like
''',
  quiz: [
    Quiz(question: 'What syntax defines an indexer in C#?', options: [
      QuizOption(text: 'public T this[int index] { get; set; }', correct: true),
      QuizOption(text: 'public T Index(int i) { get; set; }', correct: false),
      QuizOption(text: 'public T operator[](int i)', correct: false),
      QuizOption(text: 'public T GetItem(int index)', correct: false),
    ]),
    Quiz(question: 'What does an init-only property ({ get; init; }) allow?', options: [
      QuizOption(text: 'Setting the property in object initializer syntax but not after construction', correct: true),
      QuizOption(text: 'Setting the property only from within the class', correct: false),
      QuizOption(text: 'The property can never be set after declaration', correct: false),
      QuizOption(text: 'Setting the property only once anywhere in the program', correct: false),
    ]),
    Quiz(question: 'What does Lazy<T> do?', options: [
      QuizOption(text: 'Defers computation of the value until the first time it is accessed', correct: true),
      QuizOption(text: 'Makes a property read-only after first assignment', correct: false),
      QuizOption(text: 'Runs the initialization on a background thread', correct: false),
      QuizOption(text: 'Prevents the value from being garbage collected', correct: false),
    ]),
  ],
);
