// lib/lessons/csharp/csharp_77_configuration.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson77 = Lesson(
  language: 'C#',
  title: 'Configuration and App Settings',
  content: '''
🎯 METAPHOR:
Configuration is like the settings menu of your application.
Some settings come from the factory (appsettings.json —
your defaults). Some come from the local store (environment
variables — the deployment environment overrides). Some
come from the manager's override (command-line arguments —
highest priority). The configuration system layers them all,
with later sources winning, so you can have sensible defaults
that the environment can override without changing code.

📖 EXPLANATION:
Microsoft.Extensions.Configuration

CONFIGURATION SOURCES (lower = lower priority):
  appsettings.json           base settings
  appsettings.{env}.json     environment-specific overrides
  Environment variables      deployment overrides
  Command-line arguments     highest priority
  User secrets (dev only)    local dev secrets (not committed)
  Azure Key Vault            production secrets

IConfiguration:
  config["Key"]              get by path
  config["Section:Key"]      nested key
  config.GetSection("X")     get a section
  config.GetValue<T>("Key")  typed get with default

IOptions<T> pattern:
  Bind a config section to a typed class.
  Inject IOptions<MySettings> into services.

💻 CODE:
using System;
using System.IO;
using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

// ─── SETTINGS CLASSES ───
class DatabaseSettings
{
    public string ConnectionString { get; set; }
    public int MaxPoolSize { get; set; } = 100;
    public int CommandTimeout { get; set; } = 30;
}

class EmailSettings
{
    public string SmtpHost { get; set; }
    public int SmtpPort { get; set; } = 587;
    public string FromAddress { get; set; }
    public bool UseSsl { get; set; } = true;
}

class AppSettings
{
    public string AppName { get; set; }
    public string Environment { get; set; }
    public DatabaseSettings Database { get; set; } = new();
    public EmailSettings Email { get; set; } = new();
}

// ─── SERVICE USING IOPTIONS ───
class EmailService
{
    private readonly EmailSettings _settings;

    public EmailService(IOptions<EmailSettings> options)
    {
        _settings = options.Value;
    }

    public void SendEmail(string to, string subject)
    {
        Console.WriteLine(\$"Sending email via {_settings.SmtpHost}:{_settings.SmtpPort}");
        Console.WriteLine(\$"  From: {_settings.FromAddress}");
        Console.WriteLine(\$"  To: {to}, Subject: {subject}");
    }
}

class Program
{
    static void Main(string[] args)
    {
        // ─── CREATE SAMPLE CONFIG FILES ───
        string appSettings = """
        {
            "AppName": "MyApp",
            "Environment": "Development",
            "Database": {
                "ConnectionString": "Server=localhost;Database=mydb",
                "MaxPoolSize": 50,
                "CommandTimeout": 60
            },
            "Email": {
                "SmtpHost": "smtp.example.com",
                "SmtpPort": 587,
                "FromAddress": "app@example.com",
                "UseSsl": true
            },
            "Logging": {
                "LogLevel": {
                    "Default": "Information",
                    "Microsoft": "Warning"
                }
            }
        }
        """;
        File.WriteAllText("appsettings.json", appSettings);

        // ─── BUILD CONFIGURATION ───
        IConfiguration config = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: false)
            .AddJsonFile("appsettings.Development.json", optional: true)
            .AddEnvironmentVariables()           // env vars override
            .AddCommandLine(args)                // CLI args highest priority
            .Build();

        // ─── READ VALUES ───
        string appName = config["AppName"];
        Console.WriteLine(\$"App: {appName}");

        // Nested key with colon separator
        string connStr = config["Database:ConnectionString"];
        Console.WriteLine(\$"DB: {connStr}");

        int maxPool = config.GetValue<int>("Database:MaxPoolSize", defaultValue: 100);
        Console.WriteLine(\$"MaxPool: {maxPool}");

        // ─── BIND TO TYPED CLASS ───
        var dbSettings = new DatabaseSettings();
        config.GetSection("Database").Bind(dbSettings);
        Console.WriteLine(\$"Bound: {dbSettings.ConnectionString}, timeout: {dbSettings.CommandTimeout}s");

        // GetSection returns IConfigurationSection
        IConfigurationSection emailSection = config.GetSection("Email");
        var emailSettings = emailSection.Get<EmailSettings>();
        Console.WriteLine(\$"SMTP: {emailSettings.SmtpHost}:{emailSettings.SmtpPort}");

        // ─── DI WITH IOPTIONS ───
        var services = new ServiceCollection();

        // Add configuration
        services.AddSingleton<IConfiguration>(config);

        // Bind settings to options
        services.Configure<DatabaseSettings>(config.GetSection("Database"));
        services.Configure<EmailSettings>(config.GetSection("Email"));

        // Register services
        services.AddTransient<EmailService>();

        var provider = services.BuildServiceProvider();

        // Use service — EmailSettings injected via IOptions
        var emailSvc = provider.GetRequiredService<EmailService>();
        emailSvc.SendEmail("alice@example.com", "Hello!");

        // Direct IOptions access
        var dbOptions = provider.GetRequiredService<IOptions<DatabaseSettings>>();
        Console.WriteLine(\$"MaxPoolSize: {dbOptions.Value.MaxPoolSize}");

        // ─── ENVIRONMENT VARIABLE OVERRIDE ───
        // Set env var: Database__ConnectionString=Server=prod;Database=proddb
        // (double underscore __ replaces colon : in env vars)
        string envConn = Environment.GetEnvironmentVariable("Database__ConnectionString");
        if (envConn != null)
            Console.WriteLine(\$"Env override: {envConn}");

        // ─── RELOADABLE CONFIGURATION ───
        // IOptionsMonitor<T> — updates when config file changes
        // IOptionsSnapshot<T> — scoped, re-reads per request
    }
}

─────────────────────────────────────
IOPTIONS VARIANTS:
─────────────────────────────────────
IOptions<T>         read once at startup, singleton lifetime
IOptionsSnapshot<T> re-read per scope (per request in web)
IOptionsMonitor<T>  live reload when config changes
─────────────────────────────────────

📝 KEY POINTS:
✅ Use appsettings.json for defaults, environment variables for deployment overrides
✅ Double underscore __ in env var names maps to : in config paths
✅ IOptions<T> is the standard way to inject typed settings into services
✅ Use User Secrets for local dev secrets — never commit secrets to source control
✅ GetValue<T>("Key", defaultValue) is safe — returns default if key missing
❌ Never put production secrets in appsettings.json — use env vars or Key Vault
❌ Don't read IConfiguration directly in deep services — use IOptions<T>
''',
  quiz: [
    Quiz(question: 'How do you represent a nested configuration key "Database:ConnectionString" as an environment variable?', options: [
      QuizOption(text: 'Database__ConnectionString (double underscore replaces colon)', correct: true),
      QuizOption(text: 'Database.ConnectionString (dot notation)', correct: false),
      QuizOption(text: 'DATABASE_CONNECTIONSTRING (uppercase with underscore)', correct: false),
      QuizOption(text: 'Database-ConnectionString (hyphen)', correct: false),
    ]),
    Quiz(question: 'What is the difference between IOptions<T> and IOptionsMonitor<T>?', options: [
      QuizOption(text: 'IOptions<T> is read once at startup; IOptionsMonitor<T> updates when the config file changes', correct: true),
      QuizOption(text: 'IOptionsMonitor<T> is read-only; IOptions<T> allows writes', correct: false),
      QuizOption(text: 'They are identical — different names for the same thing', correct: false),
      QuizOption(text: 'IOptions<T> is for JSON only; IOptionsMonitor<T> works with all sources', correct: false),
    ]),
    Quiz(question: 'Which configuration source has the highest priority?', options: [
      QuizOption(text: 'Command-line arguments — they override all other sources', correct: true),
      QuizOption(text: 'appsettings.json — it is loaded first', correct: false),
      QuizOption(text: 'Environment variables — deployment settings win', correct: false),
      QuizOption(text: 'All sources have equal priority', correct: false),
    ]),
  ],
);
