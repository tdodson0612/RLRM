// lib/lessons/csharp/csharp_66_diagnostics.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson66 = Lesson(
  language: 'C#',
  title: 'Diagnostics, Logging, and Observability',
  content: '''
🎯 METAPHOR:
Diagnostics in software are like the instrument panel in an
aircraft cockpit. You cannot see inside the engine while
flying. But the gauges (metrics), flight recorder (logs),
and radar (traces) tell you exactly what is happening and
what happened when something went wrong. Modern observability
means every request, every error, and every slow operation
leaves a trace — so you can diagnose production issues
without a debugger attached.

📖 EXPLANATION:
.NET DIAGNOSTICS STACK:

Logging: ILogger<T>
  - Structured logging
  - Multiple providers (Console, File, Azure, Seq, etc.)
  - Log levels: Trace, Debug, Info, Warning, Error, Critical

Metrics: System.Diagnostics.Metrics
  - Counter, Histogram, Gauge, ObservableCounter
  - Exported to Prometheus, Azure Monitor, etc.

Tracing: System.Diagnostics.Activity
  - OpenTelemetry compatible
  - Distributed traces across services

Debug/Trace:
  Debug.Assert, Debug.WriteLine (debug builds only)
  Trace.WriteLine (configurable)

Stopwatch: precise timing
Process: system process info

💻 CODE:
using System;
using System.Diagnostics;
using System.Diagnostics.Metrics;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.DependencyInjection;

// ─── STRUCTURED LOGGING ───
class OrderService
{
    private readonly ILogger<OrderService> _logger;
    private static readonly ActivitySource _activitySource = new("MyApp.Orders");

    // Metrics
    private static readonly Meter _meter = new("MyApp.Orders");
    private static readonly Counter<int> _ordersProcessed = _meter.CreateCounter<int>("orders_processed");
    private static readonly Histogram<double> _processingTime = _meter.CreateHistogram<double>("order_processing_ms");

    public OrderService(ILogger<OrderService> logger) => _logger = logger;

    public async System.Threading.Tasks.Task ProcessOrder(int orderId)
    {
        // Activity = distributed trace span
        using var activity = _activitySource.StartActivity("ProcessOrder");
        activity?.SetTag("order.id", orderId);

        var sw = Stopwatch.StartNew();
        _logger.LogInformation("Processing order {OrderId}", orderId);

        try
        {
            await System.Threading.Tasks.Task.Delay(50);  // simulate work

            // Structured log with properties
            _logger.LogInformation(
                "Order {OrderId} processed successfully in {ElapsedMs}ms",
                orderId, sw.ElapsedMilliseconds);

            _ordersProcessed.Add(1, new TagList { { "status", "success" } });
            _processingTime.Record(sw.ElapsedMilliseconds);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to process order {OrderId}", orderId);
            _ordersProcessed.Add(1, new TagList { { "status", "failed" } });
            throw;
        }
        finally
        {
            activity?.SetTag("duration_ms", sw.ElapsedMilliseconds);
        }
    }
}

class Program
{
    static async System.Threading.Tasks.Task Main()
    {
        // ─── DI + LOGGING SETUP ───
        var services = new ServiceCollection();
        services.AddLogging(builder =>
        {
            builder.AddConsole();
            builder.SetMinimumLevel(LogLevel.Debug);
        });
        services.AddScoped<OrderService>();
        var provider = services.BuildServiceProvider();

        var orderSvc = provider.GetRequiredService<OrderService>();
        await orderSvc.ProcessOrder(42);

        // ─── STOPWATCH ───
        var sw = Stopwatch.StartNew();
        long t1 = sw.ElapsedMilliseconds;
        System.Threading.Thread.Sleep(100);
        long t2 = sw.ElapsedMilliseconds;
        Console.WriteLine(\$"Elapsed: {t2 - t1}ms");

        // High-precision timing
        long before = Stopwatch.GetTimestamp();
        for (int i = 0; i < 1_000_000; i++) { var _ = i * i; }
        long after = Stopwatch.GetTimestamp();
        double microseconds = (after - before) / (double)Stopwatch.Frequency * 1_000_000;
        Console.WriteLine(\$"Loop took {microseconds:F1} microseconds");

        // ─── DEBUG / TRACE ───
        Debug.Assert(1 + 1 == 2, "Math is broken");
        Debug.WriteLine("Only in DEBUG builds");

        Trace.TraceInformation("Information message");
        Trace.TraceWarning("Warning message");
        Trace.TraceError("Error message");

        // ─── PROCESS INFO ───
        var proc = Process.GetCurrentProcess();
        Console.WriteLine(\$"PID: {proc.Id}");
        Console.WriteLine(\$"Memory: {proc.WorkingSet64 / 1024 / 1024}MB");
        Console.WriteLine(\$"CPU time: {proc.TotalProcessorTime.TotalMilliseconds:F0}ms");
        Console.WriteLine(\$"Threads: {proc.Threads.Count}");

        // List other processes
        foreach (var p in Process.GetProcessesByName("dotnet"))
            Console.WriteLine(\$"  dotnet: PID {p.Id}");

        // ─── ENVIRONMENT AND RUNTIME INFO ───
        Console.WriteLine(\$".NET version: {Environment.Version}");
        Console.WriteLine(\$"OS: {Environment.OSVersion}");
        Console.WriteLine(\$"CPU count: {Environment.ProcessorCount}");
        Console.WriteLine(\$"64-bit: {Environment.Is64BitProcess}");
        Console.WriteLine(\$"Machine: {Environment.MachineName}");
        Console.WriteLine(\$"User: {Environment.UserName}");

        // ─── ACTIVITY (distributed tracing) ───
        using var source = new ActivitySource("MyApp");
        using var rootActivity = source.StartActivity("Root");
        rootActivity?.SetTag("user.id", "alice");
        rootActivity?.SetTag("request.url", "/api/orders");

        using var childActivity = source.StartActivity("Database Query");
        childActivity?.SetTag("db.statement", "SELECT * FROM orders");
        childActivity?.SetTag("db.rows_affected", 5);
        // Activities are automatically exported to OpenTelemetry exporters
    }
}

─────────────────────────────────────
LOG LEVELS:
─────────────────────────────────────
Trace     → most verbose, dev only
Debug     → debugging info
Information → normal app flow
Warning   → unexpected but handled
Error     → failures that need attention
Critical  → fatal, app unusable
─────────────────────────────────────

📝 KEY POINTS:
✅ Use structured logging — LogInformation("User {UserId}", id) not string interpolation
✅ ILogger<T> is the standard — inject it, don't use static logging
✅ Use Activity for distributed tracing — OpenTelemetry compatible
✅ Use System.Diagnostics.Metrics for counters and histograms
✅ Stopwatch.GetTimestamp() is more precise than ElapsedMilliseconds
❌ Don't use string.Format or \$ in log messages — use structured logging placeholders
❌ Don't log at Debug level in production — it is expensive and verbose
''',
  quiz: [
    Quiz(question: 'Why should you use structured logging placeholders instead of string interpolation?', options: [
      QuizOption(text: 'Structured logging preserves the values as typed properties for querying in log systems', correct: true),
      QuizOption(text: 'String interpolation causes a compile error in logging methods', correct: false),
      QuizOption(text: 'Placeholders are faster to parse at runtime', correct: false),
      QuizOption(text: 'String interpolation evaluates too eagerly regardless of log level', correct: false),
    ]),
    Quiz(question: 'What is System.Diagnostics.Activity used for?', options: [
      QuizOption(text: 'Distributed tracing — tracking a request across multiple services', correct: true),
      QuizOption(text: 'Measuring CPU time for a code block', correct: false),
      QuizOption(text: 'Creating background threads', correct: false),
      QuizOption(text: 'Scheduling periodic tasks', correct: false),
    ]),
    Quiz(question: 'What does Debug.Assert() do in a Release build?', options: [
      QuizOption(text: 'Nothing — Debug.Assert calls are removed entirely in Release builds', correct: true),
      QuizOption(text: 'Throws an exception if the condition is false', correct: false),
      QuizOption(text: 'Logs a warning instead of asserting', correct: false),
      QuizOption(text: 'Behaves identically to Debug builds', correct: false),
    ]),
  ],
);
