// lib/lessons/csharp/csharp_79_design_patterns.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson79 = Lesson(
  language: 'C#',
  title: 'Design Patterns in C#',
  content: '''
🎯 METAPHOR:
Design patterns are the named solutions to recurring
architectural problems — like named chess openings.
"Ruy Lopez" means a specific sequence every chess player
knows. "Singleton" means "exactly one instance, globally
accessible" — every developer knows what that means.
Patterns are a shared vocabulary. They don't tell you WHAT
to build, they describe HOW to structure what you build
so it's maintainable, extensible, and testable.

📖 EXPLANATION:
CREATIONAL — how objects are created:
  Singleton, Factory, Abstract Factory, Builder, Prototype

STRUCTURAL — how objects are composed:
  Adapter, Decorator, Facade, Proxy, Composite

BEHAVIORAL — how objects communicate:
  Observer, Strategy, Command, Template Method, Iterator,
  State, Mediator, Chain of Responsibility

💻 CODE:
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

// ─── SINGLETON ───
sealed class AppConfig
{
    // Lazy<T> is thread-safe by default
    private static readonly Lazy<AppConfig> _instance = new(() => new AppConfig());
    public static AppConfig Instance => _instance.Value;

    public string Theme { get; set; } = "dark";
    public int MaxConnections { get; set; } = 100;

    private AppConfig() { Console.WriteLine("Config initialized"); }
}

// ─── FACTORY METHOD ───
abstract class Logger
{
    public abstract void Log(string message);

    // Factory method
    public static Logger Create(string type) => type switch
    {
        "console" => new ConsoleLogger(),
        "file"    => new FileLogger(),
        _         => throw new ArgumentException(\$"Unknown logger: {type}")
    };
}
class ConsoleLogger : Logger { public override void Log(string m) => Console.WriteLine(\$"[CON] {m}"); }
class FileLogger    : Logger { public override void Log(string m) => Console.WriteLine(\$"[FIL] {m}"); }

// ─── BUILDER ───
class QueryBuilder
{
    private string _table = "";
    private readonly List<string> _conditions = new();
    private readonly List<string> _columns = new();
    private int? _limit;

    public QueryBuilder From(string table)       { _table = table; return this; }
    public QueryBuilder Select(params string[] cols) { _columns.AddRange(cols); return this; }
    public QueryBuilder Where(string condition)  { _conditions.Add(condition); return this; }
    public QueryBuilder Limit(int n)             { _limit = n; return this; }

    public string Build()
    {
        string cols = _columns.Count > 0 ? string.Join(", ", _columns) : "*";
        string sql  = \$"SELECT {cols} FROM {_table}";
        if (_conditions.Count > 0) sql += \$" WHERE {string.Join(" AND ", _conditions)}";
        if (_limit.HasValue)       sql += \$" LIMIT {_limit}";
        return sql;
    }
}

// ─── OBSERVER ───
interface IEventHandler<T> { void Handle(T eventData); }

class EventBus
{
    private readonly Dictionary<Type, List<object>> _handlers = new();

    public void Subscribe<T>(IEventHandler<T> handler)
    {
        var type = typeof(T);
        if (!_handlers.ContainsKey(type)) _handlers[type] = new();
        _handlers[type].Add(handler);
    }

    public void Publish<T>(T eventData)
    {
        if (_handlers.TryGetValue(typeof(T), out var handlers))
            foreach (var h in handlers)
                ((IEventHandler<T>)h).Handle(eventData);
    }
}

record OrderPlaced(int OrderId, string Customer, decimal Total);
class EmailNotifier : IEventHandler<OrderPlaced>
{
    public void Handle(OrderPlaced e)
        => Console.WriteLine(\$"Email: Order {e.OrderId} for {e.Customer} - {e.Total:C}");
}
class AuditLogger : IEventHandler<OrderPlaced>
{
    public void Handle(OrderPlaced e)
        => Console.WriteLine(\$"Audit: Order {e.OrderId} placed at {DateTime.UtcNow:O}");
}

// ─── DECORATOR ───
interface IDataService { string GetData(string key); }

class DatabaseDataService : IDataService
{
    public string GetData(string key) { Console.WriteLine(\$"DB lookup: {key}"); return \$"data_{key}"; }
}

class CachingDecorator : IDataService
{
    private readonly IDataService _inner;
    private readonly Dictionary<string, string> _cache = new();

    public CachingDecorator(IDataService inner) => _inner = inner;

    public string GetData(string key)
    {
        if (_cache.TryGetValue(key, out string cached)) { Console.WriteLine("Cache hit!"); return cached; }
        string result = _inner.GetData(key);
        _cache[key] = result;
        return result;
    }
}

class LoggingDecorator : IDataService
{
    private readonly IDataService _inner;
    public LoggingDecorator(IDataService inner) => _inner = inner;
    public string GetData(string key)
    {
        Console.WriteLine(\$"[LOG] Getting {key}");
        var result = _inner.GetData(key);
        Console.WriteLine(\$"[LOG] Got {result}");
        return result;
    }
}

// ─── COMMAND ───
interface ICommand { void Execute(); void Undo(); }

class TextEditor
{
    private string _text = "";
    private readonly Stack<ICommand> _history = new();

    public void Execute(ICommand cmd) { cmd.Execute(); _history.Push(cmd); }
    public void Undo() { if (_history.Count > 0) _history.Pop().Undo(); }
    public string Text => _text;

    public class InsertCommand : ICommand
    {
        private readonly TextEditor _editor;
        private readonly string _text;
        public InsertCommand(TextEditor e, string t) { _editor = e; _text = t; }
        public void Execute() => _editor._text += _text;
        public void Undo()    => _editor._text = _editor._text[..^_text.Length];
    }
}

class Program
{
    static void Main()
    {
        // Singleton
        AppConfig.Instance.Theme = "light";
        Console.WriteLine(AppConfig.Instance.Theme);  // light

        // Factory
        Logger log = Logger.Create("console");
        log.Log("App started");

        // Builder
        string sql = new QueryBuilder()
            .From("users")
            .Select("name", "email")
            .Where("age > 18")
            .Where("active = 1")
            .Limit(10)
            .Build();
        Console.WriteLine(sql);

        // Observer
        var bus = new EventBus();
        bus.Subscribe<OrderPlaced>(new EmailNotifier());
        bus.Subscribe<OrderPlaced>(new AuditLogger());
        bus.Publish(new OrderPlaced(42, "Alice", 99.99m));

        // Decorator chain
        IDataService svc = new LoggingDecorator(
                           new CachingDecorator(
                           new DatabaseDataService()));
        svc.GetData("user_1");  // DB lookup
        svc.GetData("user_1");  // Cache hit

        // Command
        var editor = new TextEditor();
        editor.Execute(new TextEditor.InsertCommand(editor, "Hello"));
        editor.Execute(new TextEditor.InsertCommand(editor, " World"));
        Console.WriteLine(editor.Text);  // Hello World
        editor.Undo();
        Console.WriteLine(editor.Text);  // Hello
    }
}

📝 KEY POINTS:
✅ Singleton with Lazy<T> is thread-safe — the preferred modern approach
✅ Builder pattern is excellent for complex object construction — fluent API
✅ Observer/EventBus decouples publishers from subscribers completely
✅ Decorator adds behavior without modifying the original class — open/closed principle
✅ Command encapsulates operations — enables undo/redo and queuing
❌ Don't overuse Singleton — it makes unit testing hard (global state)
❌ Don't use patterns for simple problems — YAGNI (You Aren't Gonna Need It)
''',
  quiz: [
    Quiz(question: 'What problem does the Decorator pattern solve?', options: [
      QuizOption(text: 'Adding behavior to an object without modifying its class', correct: true),
      QuizOption(text: 'Ensuring only one instance of a class exists', correct: false),
      QuizOption(text: 'Creating families of related objects', correct: false),
      QuizOption(text: 'Providing a simplified interface to a complex subsystem', correct: false),
    ]),
    Quiz(question: 'Why is Lazy<T> preferred for Singleton initialization?', options: [
      QuizOption(text: 'It is thread-safe and only creates the instance when first accessed', correct: true),
      QuizOption(text: 'It makes the singleton faster than static initialization', correct: false),
      QuizOption(text: 'It prevents the singleton from being garbage collected', correct: false),
      QuizOption(text: 'It allows multiple instances to be created in tests', correct: false),
    ]),
    Quiz(question: 'What is the key benefit of the Observer/EventBus pattern?', options: [
      QuizOption(text: 'Publishers and subscribers are decoupled — publishers don\'t know who is listening', correct: true),
      QuizOption(text: 'Events are guaranteed to be delivered in order', correct: false),
      QuizOption(text: 'Only one subscriber can handle each event', correct: false),
      QuizOption(text: 'Events are persisted automatically', correct: false),
    ]),
  ],
);
