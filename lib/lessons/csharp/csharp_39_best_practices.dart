// lib/lessons/csharp/csharp_39_best_practices.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson39 = Lesson(
  language: 'C#',
  title: 'C# Best Practices and Idioms',
  content: '''
🎯 METAPHOR:
Best practices are the unwritten rules of a professional
kitchen. You CAN put dirty knives blade-up in the drawer.
You CAN leave the stove on when you leave. You CAN store
raw chicken next to ready-to-eat food. None of these are
illegal — but every professional chef knows they lead to
injury, fire, and food poisoning. C# best practices exist
because thousands of developers were burned so you don't
have to be. Follow them and your code will be safe, readable,
maintainable, and ready for the team to work on.

📖 EXPLANATION:
These are the most important idioms and practices from the
official C# design guidelines, Microsoft's framework design
guidelines, and the collective wisdom of the C# community.

💻 CODE:
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

// ─── NAMING CONVENTIONS ───
// PascalCase:  Types, Methods, Properties, Events, Namespaces
// camelCase:   local variables, parameters
// _camelCase:  private fields
// IPascalCase: interfaces
// ALL_CAPS:    rarely used; prefer PascalCase constants

class NamingExample
{
    private readonly string _connectionString;  // private field
    private static int _instanceCount;          // static field

    public string DisplayName { get; set; }     // property
    public event EventHandler DataChanged;      // event

    public NamingExample(string connectionString)  // parameter
    {
        _connectionString = connectionString;
        int localCount = ++_instanceCount;         // local variable
    }

    public async Task<string> FetchDataAsync()     // async method
    {
        await Task.Delay(10);
        return "data";
    }
}

// ─── PREFER READONLY ───
class Config
{
    // readonly fields cannot be changed after constructor
    private readonly string _host;
    private readonly int _port;

    // init-only properties (immutable after creation)
    public string ApiKey { get; init; }

    // const for compile-time constants
    public const int MaxRetries = 3;
    public const string DefaultProtocol = "https";

    public Config(string host, int port)
    {
        _host = host;
        _port = port;
    }
}

// ─── EXPRESSION BODIES FOR SIMPLE MEMBERS ───
class Circle
{
    private double _radius;
    public Circle(double r) => _radius = r;

    public double Area       => Math.PI * _radius * _radius;
    public double Perimeter  => 2 * Math.PI * _radius;
    public bool IsUnit       => _radius == 1.0;

    public Circle Scale(double factor) => new(_radius * factor);
    public override string ToString()  => \$"Circle(r={_radius})";
}

// ─── NULL HANDLING BEST PRACTICES ───
class OrderService
{
    public string GetCustomerName(int? customerId)
    {
        // Validate early — guard clauses at top
        if (customerId is null or <= 0)
            throw new ArgumentException("Invalid customer ID", nameof(customerId));

        // Use ?. and ?? liberally
        var customer = FindCustomer(customerId.Value);
        return customer?.Name ?? "Unknown";
    }

    // Use ArgumentNullException.ThrowIfNull (C# 10+)
    public void ProcessOrder(object order)
    {
        ArgumentNullException.ThrowIfNull(order);
        // proceed
    }

    private dynamic FindCustomer(int id) => null;
}

// ─── PROPER ASYNC PATTERNS ───
class DataService
{
    // ✅ Return Task, not void (except event handlers)
    public async Task<List<string>> GetItemsAsync()
    {
        await Task.Delay(10);
        return new List<string> { "a", "b", "c" };
    }

    // ✅ Accept CancellationToken
    public async Task<string> FetchAsync(string url, System.Threading.CancellationToken ct = default)
    {
        await Task.Delay(100, ct);
        return "result";
    }

    // ✅ ConfigureAwait(false) in libraries (not UI)
    public async Task<int> LibraryMethodAsync()
    {
        await Task.Delay(10).ConfigureAwait(false);
        return 42;
    }
}

class Program
{
    static void Main()
    {
        // ─── PREFER var WHEN TYPE IS OBVIOUS ───
        var list = new List<string>();           // obvious: List<string>
        var dict = new Dictionary<int, string>(); // obvious: Dictionary

        // ─── PREFER COLLECTION EXPRESSIONS (C# 12) ───
        List<int> nums = [1, 2, 3, 4, 5];

        // ─── PREFER LINQ FOR QUERIES ───
        var evens = nums.Where(n => n % 2 == 0).ToList();

        // ─── PREFER PATTERN MATCHING ───
        object obj = "hello";
        if (obj is string { Length: > 3 } s)
            Console.WriteLine(\$"Long string: {s}");

        // ─── DISPOSE PROPERLY ───
        using var reader = new System.IO.StringReader("test");
        Console.WriteLine(reader.ReadToEnd());

        // ─── THROW CORRECT EXCEPTIONS ───
        static void ValidateAge(int age)
        {
            if (age < 0)
                throw new ArgumentOutOfRangeException(nameof(age), "Age must be non-negative");
            if (age > 150)
                throw new ArgumentOutOfRangeException(nameof(age), "Age unrealistically large");
        }

        // ─── STRING BEST PRACTICES ───
        string a = null;
        bool empty = string.IsNullOrWhiteSpace(a);   // safe for null
        string display = a ?? "default";             // null coalescing

        // Use StringBuilder for loops
        var sb = new System.Text.StringBuilder();
        for (int i = 0; i < 100; i++) sb.Append(i);
    }
}

─────────────────────────────────────
TOP C# DO'S AND DON'TS:
─────────────────────────────────────
✅ DO use properties over public fields
✅ DO use readonly for fields that don't change after ctor
✅ DO name async methods with Async suffix
✅ DO use var when the type is obvious from the right side
✅ DO validate parameters at method entry
✅ DO use IEnumerable<T> for read-only collection params
✅ DO override ToString() on domain objects
✅ DO use using for IDisposable

❌ DON'T use magic numbers — use named constants
❌ DON'T catch Exception and swallow it silently
❌ DON'T use .Result or .Wait() on tasks
❌ DON'T use public fields — use properties
❌ DON'T write methods longer than ~30 lines
❌ DON'T use dynamic unless absolutely necessary
─────────────────────────────────────

📝 KEY POINTS:
✅ Async methods should return Task/Task<T> and have the Async suffix
✅ readonly fields prevent accidental mutation after construction
✅ Guard clauses (early returns/throws) make methods easier to read
✅ Validate all public method parameters — throw ArgumentException or ArgumentNullException
✅ ConfigureAwait(false) in library code to avoid deadlocks
❌ Never silently swallow exceptions — at minimum log them
❌ Never mix async and sync code with .Result/.Wait() — deadlock risk
''',
  quiz: [
    Quiz(question: 'What naming convention should async methods follow in C#?', options: [
      QuizOption(text: 'They should end with the Async suffix (e.g., GetDataAsync)', correct: true),
      QuizOption(text: 'They should start with "async" (e.g., asyncGetData)', correct: false),
      QuizOption(text: 'They use ALL_CAPS to indicate they are special', correct: false),
      QuizOption(text: 'No special convention — async is indicated by the return type', correct: false),
    ]),
    Quiz(question: 'What should you do at the start of a public method to protect against invalid inputs?', options: [
      QuizOption(text: 'Use guard clauses — validate parameters early and throw appropriate exceptions', correct: true),
      QuizOption(text: 'Wrap the entire method in a try/catch', correct: false),
      QuizOption(text: 'Use debug assertions only', correct: false),
      QuizOption(text: 'Return null or default values for invalid inputs', correct: false),
    ]),
    Quiz(question: 'What is the recommended way to pass a read-only collection to a method?', options: [
      QuizOption(text: 'IEnumerable<T> — allows any collection type and signals read-only intent', correct: true),
      QuizOption(text: 'List<T> — most common collection type', correct: false),
      QuizOption(text: 'T[] — arrays are the most efficient', correct: false),
      QuizOption(text: 'ICollection<T> — most flexible interface', correct: false),
    ]),
  ],
);
