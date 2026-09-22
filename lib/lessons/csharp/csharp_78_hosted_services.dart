// lib/lessons/csharp/csharp_78_hosted_services.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson78 = Lesson(
  language: 'C#',
  title: 'Hosted Services and Background Workers',
  content: '''
🎯 METAPHOR:
A hosted service is like a security guard at a building.
The building (your app host) starts up, and the guard
(hosted service) starts their shift automatically. They
run throughout the building's operating hours, doing their
rounds (processing a queue, sending emails, refreshing cache).
When the building closes (app shutdown), the guard is told
"wrap up" — they finish their current round and clock out.
The building doesn't leave until the guard signals they're done.

📖 EXPLANATION:
IHostedService — runs alongside your application:
  StartAsync(CancellationToken) — called when host starts
  StopAsync(CancellationToken)  — called when host stops

BackgroundService (abstract base) — simplifies IHostedService:
  ExecuteAsync(CancellationToken) — your background loop

IHost / IHostBuilder — the application host:
  Manages the lifetime of hosted services
  Handles startup, shutdown, and cancellation
  Used by ASP.NET Core, Worker Service, console apps

Worker Service template:
  dotnet new worker  — creates a background worker project

COMMON USES:
  - Process a message queue (RabbitMQ, Azure Service Bus)
  - Periodic cleanup tasks
  - Cache warming
  - Health check broadcasting
  - Polling external APIs

💻 CODE:
using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

// ─── SIMPLE BACKGROUND SERVICE ───
class HeartbeatService : BackgroundService
{
    private readonly ILogger<HeartbeatService> _logger;
    private int _beatCount = 0;

    public HeartbeatService(ILogger<HeartbeatService> logger)
        => _logger = logger;

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("HeartbeatService starting");

        while (!stoppingToken.IsCancellationRequested)
        {
            _beatCount++;
            _logger.LogInformation("Heartbeat #{Count} at {Time}", _beatCount, DateTime.UtcNow);

            try
            {
                await Task.Delay(TimeSpan.FromSeconds(5), stoppingToken);
            }
            catch (OperationCanceledException)
            {
                // Normal shutdown — don't rethrow
                break;
            }
        }

        _logger.LogInformation("HeartbeatService stopping after {Count} beats", _beatCount);
    }
}

// ─── QUEUE PROCESSING SERVICE ───
class QueueProcessorService : BackgroundService
{
    private readonly ILogger<QueueProcessorService> _logger;
    private readonly System.Collections.Concurrent.ConcurrentQueue<string> _queue = new();

    public QueueProcessorService(ILogger<QueueProcessorService> logger)
        => _logger = logger;

    // Public method to enqueue work
    public void Enqueue(string item) => _queue.Enqueue(item);

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Queue processor started");

        while (!stoppingToken.IsCancellationRequested)
        {
            if (_queue.TryDequeue(out string item))
            {
                try
                {
                    await ProcessItemAsync(item, stoppingToken);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error processing item: {Item}", item);
                }
            }
            else
            {
                // Queue empty — wait before checking again
                await Task.Delay(100, stoppingToken).ConfigureAwait(false);
            }
        }
    }

    private async Task ProcessItemAsync(string item, CancellationToken ct)
    {
        _logger.LogInformation("Processing: {Item}", item);
        await Task.Delay(50, ct);  // simulate processing
    }
}

// ─── SCHEDULED SERVICE (periodic timer) ───
class ScheduledCleanupService : BackgroundService
{
    private readonly ILogger<ScheduledCleanupService> _logger;
    private readonly TimeSpan _period = TimeSpan.FromMinutes(60);

    public ScheduledCleanupService(ILogger<ScheduledCleanupService> logger)
        => _logger = logger;

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        // C# 8: PeriodicTimer is the modern approach
        using var timer = new PeriodicTimer(_period);

        // Run once immediately, then on schedule
        await DoCleanupAsync(stoppingToken);

        while (await timer.WaitForNextTickAsync(stoppingToken))
        {
            await DoCleanupAsync(stoppingToken);
        }
    }

    private async Task DoCleanupAsync(CancellationToken ct)
    {
        _logger.LogInformation("Running scheduled cleanup at {Time}", DateTime.UtcNow);
        await Task.Delay(100, ct);  // simulate work
        _logger.LogInformation("Cleanup complete");
    }
}

// ─── HOST SETUP ───
class Program
{
    static async Task Main(string[] args)
    {
        IHost host = Host.CreateDefaultBuilder(args)
            .ConfigureServices(services =>
            {
                // Register hosted services
                services.AddHostedService<HeartbeatService>();
                services.AddHostedService<QueueProcessorService>();
                services.AddHostedService<ScheduledCleanupService>();
            })
            .Build();

        // Run the host (blocks until shutdown)
        // In a real app: await host.RunAsync();

        // For demo — start, do work, stop
        await host.StartAsync();

        // Simulate some work
        var processor = host.Services.GetRequiredService<QueueProcessorService>();
        processor.Enqueue("item-1");
        processor.Enqueue("item-2");
        processor.Enqueue("item-3");

        await Task.Delay(2000);  // let services run for 2s

        await host.StopAsync();  // graceful shutdown
        Console.WriteLine("Host stopped");
    }
}

─────────────────────────────────────
BACKGROUND SERVICE LIFECYCLE:
─────────────────────────────────────
Host.StartAsync()  → StartAsync() → ExecuteAsync() starts
Host.StopAsync()   → CancellationToken fired
                   → ExecuteAsync() sees cancellation, exits
                   → StopAsync() called
─────────────────────────────────────

📝 KEY POINTS:
✅ BackgroundService simplifies IHostedService — just implement ExecuteAsync()
✅ Always respect the CancellationToken — check it in loops and pass to delays
✅ Use PeriodicTimer for scheduled work — it's await-friendly and cancellable
✅ Catch OperationCanceledException in loops — it's the normal shutdown signal
✅ Use IHostedService for startup/shutdown hooks without a loop
❌ Don't throw from ExecuteAsync on normal cancellation — catch the exception
❌ Don't do heavy startup work in StartAsync — use ExecuteAsync instead
''',
  quiz: [
    Quiz(question: 'What method do you implement in BackgroundService for your background work?', options: [
      QuizOption(text: 'ExecuteAsync(CancellationToken stoppingToken)', correct: true),
      QuizOption(text: 'RunAsync(CancellationToken token)', correct: false),
      QuizOption(text: 'StartAsync(CancellationToken token)', correct: false),
      QuizOption(text: 'ProcessAsync()', correct: false),
    ]),
    Quiz(question: 'What does PeriodicTimer provide over Task.Delay in a loop?', options: [
      QuizOption(text: 'A cleaner API with WaitForNextTickAsync that is cancellable and does not drift', correct: true),
      QuizOption(text: 'More precise timing down to microseconds', correct: false),
      QuizOption(text: 'Automatic retry on failure', correct: false),
      QuizOption(text: 'Multi-threaded execution of the periodic work', correct: false),
    ]),
    Quiz(question: 'What happens when the host calls StopAsync()?', options: [
      QuizOption(text: 'The stoppingToken is cancelled, signalling ExecuteAsync to finish gracefully', correct: true),
      QuizOption(text: 'ExecuteAsync is immediately terminated', correct: false),
      QuizOption(text: 'The host waits indefinitely for ExecuteAsync to finish', correct: false),
      QuizOption(text: 'The hosted service is immediately removed from the container', correct: false),
    ]),
  ],
);
