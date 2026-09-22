// lib/lessons/csharp/csharp_35_dependency_injection.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson35 = Lesson(
  language: 'C#',
  title: 'Dependency Injection',
  content: '''
🎯 METAPHOR:
Dependency Injection is like a restaurant with a prep kitchen.
The chef (your class) needs ingredients (dependencies).
Without DI: the chef goes to the grocery store THEMSELVES,
selects a specific brand, pays, and brings it back.
The chef is tightly coupled to that exact store and brand.
With DI: the prep kitchen hands the chef the ingredients
already measured and prepared. The chef just cooks.
The chef doesn't care WHERE the carrots came from —
they just need carrots. You can swap fresh for frozen;
the chef never knows. This is loose coupling.

📖 EXPLANATION:
Dependency Injection (DI) is a design pattern where a class
receives its dependencies from outside rather than creating them.

THREE TYPES OF INJECTION:
  Constructor injection — most common, dependencies passed in constructor
  Property injection    — set through a property after construction
  Method injection      — passed as method parameters

DI LIFETIME (in .NET DI container):
  Transient   — new instance every time requested
  Scoped      — one instance per request/scope
  Singleton   — one instance for entire application lifetime

BENEFITS:
  - Testability (inject mock/fake dependencies in tests)
  - Loose coupling (depend on interfaces, not implementations)
  - Easy to swap implementations

💻 CODE:
using System;
using System.Collections.Generic;
using Microsoft.Extensions.DependencyInjection;  // add NuGet pkg if needed

// ─── INTERFACES (the contracts) ───
interface ILogger
{
    void Log(string message);
}

interface IEmailService
{
    void SendEmail(string to, string subject, string body);
}

interface IUserRepository
{
    User GetById(int id);
    void Save(User user);
}

// ─── IMPLEMENTATIONS ───
class ConsoleLogger : ILogger
{
    public void Log(string message)
        => Console.WriteLine(\$"[LOG] {message}");
}

class FileLogger : ILogger
{
    private string _path;
    public FileLogger(string path) => _path = path;

    public void Log(string message)
        => Console.WriteLine(\$"[FILE:{_path}] {message}");  // simplified
}

class SmtpEmailService : IEmailService
{
    private ILogger _logger;

    // Constructor injection — ILogger is injected
    public SmtpEmailService(ILogger logger)
    {
        _logger = logger;
    }

    public void SendEmail(string to, string subject, string body)
    {
        _logger.Log(\$"Sending email to {to}: {subject}");
        // actual SMTP logic here
    }
}

class InMemoryUserRepository : IUserRepository
{
    private Dictionary<int, User> _store = new();
    private ILogger _logger;

    public InMemoryUserRepository(ILogger logger)
    {
        _logger = logger;
    }

    public User GetById(int id)
    {
        _logger.Log(\$"Getting user {id}");
        return _store.GetValueOrDefault(id);
    }

    public void Save(User user)
    {
        _logger.Log(\$"Saving user {user.Id}");
        _store[user.Id] = user;
    }
}

class User
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Email { get; set; }
}

// ─── SERVICE THAT USES MULTIPLE DEPENDENCIES ───
class UserService
{
    private readonly IUserRepository _repo;
    private readonly IEmailService _email;
    private readonly ILogger _logger;

    // Constructor injection — all dependencies injected
    public UserService(IUserRepository repo, IEmailService email, ILogger logger)
    {
        _repo = repo;
        _email = email;
        _logger = logger;
    }

    public void RegisterUser(string name, string email)
    {
        var user = new User { Id = new Random().Next(1000), Name = name, Email = email };
        _repo.Save(user);
        _email.SendEmail(email, "Welcome!", \$"Hi {name}, welcome aboard!");
        _logger.Log(\$"User {name} registered successfully");
    }
}

class Program
{
    static void Main()
    {
        // ─── MANUAL DI (without container) ───
        ILogger logger = new ConsoleLogger();
        IEmailService emailService = new SmtpEmailService(logger);
        IUserRepository repo = new InMemoryUserRepository(logger);
        UserService service = new UserService(repo, emailService, logger);

        service.RegisterUser("Alice", "alice@example.com");

        // ─── WITH .NET DI CONTAINER ───
        var services = new ServiceCollection();

        // Register services
        services.AddSingleton<ILogger, ConsoleLogger>();          // one instance
        services.AddTransient<IEmailService, SmtpEmailService>(); // new per request
        services.AddScoped<IUserRepository, InMemoryUserRepository>(); // per scope
        services.AddTransient<UserService>();

        var provider = services.BuildServiceProvider();

        // Resolve — container wires everything up automatically
        var userSvc = provider.GetRequiredService<UserService>();
        userSvc.RegisterUser("Bob", "bob@example.com");

        // ─── SWAP IMPLEMENTATION ───
        // To use FileLogger instead, just change one line:
        // services.AddSingleton<ILogger>(_ => new FileLogger("app.log"));
        // All classes using ILogger automatically get FileLogger!
    }
}

📝 KEY POINTS:
✅ Program to interfaces — depend on ILogger, not ConsoleLogger
✅ Constructor injection is the most common and testable pattern
✅ DI containers (ServiceCollection) wire up dependencies automatically
✅ Singleton: one instance; Scoped: one per request; Transient: new each time
✅ DI makes unit testing easy — inject mock implementations in tests
❌ Don't create dependencies inside classes — inject them from outside
❌ Don't use the DI container directly in business logic (Service Locator anti-pattern)
''',
  quiz: [
    Quiz(question: 'What is the main benefit of constructor injection?', options: [
      QuizOption(text: 'Dependencies are explicit and the class cannot be created without them', correct: true),
      QuizOption(text: 'It is the fastest injection method at runtime', correct: false),
      QuizOption(text: 'It prevents the class from being inherited', correct: false),
      QuizOption(text: 'It automatically disposes dependencies', correct: false),
    ]),
    Quiz(question: 'What does "Transient" lifetime mean in the .NET DI container?', options: [
      QuizOption(text: 'A new instance is created every time the service is requested', correct: true),
      QuizOption(text: 'One instance is shared for the entire application', correct: false),
      QuizOption(text: 'One instance per HTTP request or scope', correct: false),
      QuizOption(text: 'The instance is disposed after 30 seconds', correct: false),
    ]),
    Quiz(question: 'Why should you depend on interfaces (ILogger) rather than concrete classes (ConsoleLogger)?', options: [
      QuizOption(text: 'You can swap implementations without changing the dependent class', correct: true),
      QuizOption(text: 'Interfaces are faster to instantiate', correct: false),
      QuizOption(text: 'Concrete classes cannot be used with DI containers', correct: false),
      QuizOption(text: 'Interfaces use less memory', correct: false),
    ]),
  ],
);
