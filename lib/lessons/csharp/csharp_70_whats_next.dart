// lib/lessons/csharp/csharp_70_whats_next.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson70 = Lesson(
  language: 'C#',
  title: 'What\'s Next: The C# Ecosystem',
  content: '''
🎯 METAPHOR:
Learning C# is like getting a driver's license.
You now know how to operate the vehicle. But the real world
has highways (ASP.NET Core), race tracks (game engines),
cargo routes (enterprise systems), and off-road trails
(IoT, embedded). Each road type has its own rules and tools.
Your license gets you on ANY road — now you choose where to drive.

📖 EXPLANATION:
You have learned the C# language. Now here is the ecosystem
map — the major frameworks and tools built on top of C#.

─────────────────────────────────────
WEB DEVELOPMENT:
─────────────────────────────────────
ASP.NET Core        cross-platform web framework
  Controllers       MVC pattern for web APIs
  Minimal APIs      lightweight endpoints (C# 6+)
  Razor Pages       server-rendered HTML
  Blazor            C# running in the browser (WebAssembly)
  SignalR           real-time WebSockets

─────────────────────────────────────
GAME DEVELOPMENT:
─────────────────────────────────────
Unity               world's most popular game engine
  MonoBehaviour     Unity component lifecycle
  Coroutines        Unity's async-like system
  DOTS              Data-Oriented Tech Stack (ECS)

─────────────────────────────────────
MOBILE / DESKTOP:
─────────────────────────────────────
.NET MAUI           cross-platform mobile + desktop
Xamarin             predecessor to MAUI (still in use)
WPF                 Windows desktop (XAML + MVVM)
WinForms            Windows desktop (classic)
Uno Platform        cross-platform XAML

─────────────────────────────────────
DATA ACCESS:
─────────────────────────────────────
Entity Framework Core  ORM — C# to SQL
Dapper              micro-ORM — raw SQL + mapping
ADO.NET             low-level database access
Azure Cosmos SDK    NoSQL (Cosmos DB)
MongoDB Driver      MongoDB

─────────────────────────────────────
CLOUD AND MICROSERVICES:
─────────────────────────────────────
Azure SDK           Microsoft cloud services
AWS SDK             Amazon cloud services
gRPC                high-performance RPC
MassTransit         message bus abstraction
Dapr                distributed app runtime
Orleans             actor model for distributed systems

─────────────────────────────────────
TESTING:
─────────────────────────────────────
xUnit               most popular test framework
NUnit               alternative test framework
MSTest              Microsoft test framework
Moq / NSubstitute   mocking libraries
FluentAssertions    readable test assertions
Testcontainers      integration tests with Docker

─────────────────────────────────────
TOOLS AND LIBRARIES:
─────────────────────────────────────
NuGet               package manager (npm for .NET)
AutoMapper          object-to-object mapping
MediatR             mediator pattern / CQRS
Polly               resilience (retry, circuit breaker)
Newtonsoft.Json     JSON (older, still widely used)
Serilog / NLog      structured logging
Hangfire            background job scheduling
BenchmarkDotNet     precise performance benchmarking

💻 CODE:
// ─── MINIMAL WEB API EXAMPLE ───
// dotnet new web -n MyApi
// Program.cs:

// var builder = WebApplication.CreateBuilder(args);
// var app = builder.Build();
//
// app.MapGet("/", () => "Hello World!");
//
// app.MapGet("/users/{id}", (int id) =>
//     new { Id = id, Name = "Alice", Email = "alice@example.com" });
//
// app.MapPost("/users", (UserDto user) => Results.Created(\$"/users/1", user));
//
// app.Run();
//
// record UserDto(string Name, string Email);

// ─── ENTITY FRAMEWORK CORE EXAMPLE ───
// public class AppDbContext : DbContext
// {
//     public DbSet<User> Users => Set<User>();
//
//     protected override void OnConfiguring(DbContextOptionsBuilder b)
//         => b.UseSqlite("Data Source=app.db");
// }
//
// // Query:
// var users = await db.Users
//     .Where(u => u.Age > 18)
//     .OrderBy(u => u.Name)
//     .ToListAsync();
//
// // Command:
// db.Users.Add(new User { Name = "Alice", Age = 30 });
// await db.SaveChangesAsync();

// ─── UNITY (game) ───
// public class PlayerController : MonoBehaviour
// {
//     [SerializeField] float speed = 5f;
//
//     void Update()
//     {
//         float h = Input.GetAxis("Horizontal");
//         float v = Input.GetAxis("Vertical");
//         transform.Translate(new Vector3(h, 0, v) * speed * Time.deltaTime);
//     }
// }

// ─── XUNIT TEST EXAMPLE ───
// public class CalculatorTests
// {
//     [Fact]
//     public void Add_TwoNumbers_ReturnsSum()
//     {
//         var calc = new Calculator();
//         int result = calc.Add(3, 4);
//         Assert.Equal(7, result);
//     }
//
//     [Theory]
//     [InlineData(2, 3, 5)]
//     [InlineData(-1, 1, 0)]
//     public void Add_Theory(int a, int b, int expected)
//         => Assert.Equal(expected, new Calculator().Add(a, b));
// }

─────────────────────────────────────
RECOMMENDED LEARNING PATH:
─────────────────────────────────────
1. C# language (done! ✅)
2. ASP.NET Core (build web APIs)
3. Entity Framework Core (database)
4. xUnit testing
5. Docker + deployment
6. Choose specialization:
   → Web: Blazor, React + .NET API
   → Games: Unity
   → Cloud: Azure + microservices
   → Mobile: .NET MAUI
─────────────────────────────────────

📝 KEY POINTS:
✅ ASP.NET Core is the primary web framework — learn it after the language
✅ Entity Framework Core is the standard ORM for database work
✅ xUnit is the most popular testing framework for .NET
✅ NuGet is the package manager — nuget.org has 300,000+ packages
✅ The .NET ecosystem is massive and deeply integrated with Microsoft Azure
✅ Unity is C# but with its own lifecycle — learn MonoBehaviour after core C#
❌ Don't try to learn everything at once — pick one track and go deep
❌ Don't skip testing — writing tests makes you a better developer
''',
  quiz: [
    Quiz(question: 'What is the primary web framework for building APIs in C#?', options: [
      QuizOption(text: 'ASP.NET Core', correct: true),
      QuizOption(text: 'WPF', correct: false),
      QuizOption(text: 'WinForms', correct: false),
      QuizOption(text: 'MAUI', correct: false),
    ]),
    Quiz(question: 'What does Entity Framework Core provide?', options: [
      QuizOption(text: 'An ORM — lets you query and update databases using C# objects and LINQ', correct: true),
      QuizOption(text: 'A framework for building entity-component systems in games', correct: false),
      QuizOption(text: 'A dependency injection container', correct: false),
      QuizOption(text: 'A code generation tool for CRUD operations', correct: false),
    ]),
    Quiz(question: 'What is NuGet in the .NET ecosystem?', options: [
      QuizOption(text: 'The package manager for .NET — used to add third-party libraries', correct: true),
      QuizOption(text: 'A build system for .NET projects', correct: false),
      QuizOption(text: 'A testing framework', correct: false),
      QuizOption(text: 'A code formatter tool', correct: false),
    ]),
  ],
);
