// lib/lessons/csharp/csharp_45_preprocessor_caller_info.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson45 = Lesson(
  language: 'C#',
  title: 'Preprocessor Directives and Caller Info Attributes',
  content: '''
🎯 METAPHOR:
Preprocessor directives are like conditional assembly
instructions. "If you are building the DEBUG edition of
this car, include the diagnostic panel. If RELEASE, leave
it out." The source stays the same, but the compiled
output differs based on what symbols are defined.
It is the build system talking to the compiler before
the actual compilation starts.

Caller info attributes are like automatic return address
labels on a letter. When someone calls your method,
C# can automatically stamp the letter with who sent it,
what file it came from, and which line it was on —
without the caller having to write that information.
Perfect for logging, diagnostics, and assertion helpers.

📖 EXPLANATION:
PREPROCESSOR DIRECTIVES:
  #define       define a symbol
  #undef        remove a symbol
  #if / #elif / #else / #endif   conditional compilation
  #region / #endregion   code folding (IDE only)
  #warning      emit a compiler warning
  #error        emit a compile error (stops build)
  #pragma       suppress warnings, checksum
  #nullable     control nullable reference type analysis
  #line         change reported line numbers (generated code)

Built-in conditional symbols:
  DEBUG    defined in Debug builds
  RELEASE  defined in Release builds
  TRACE    for trace output

CALLER INFO ATTRIBUTES (System.Runtime.CompilerServices):
  [CallerMemberName]   name of calling method/property
  [CallerFilePath]     source file path of caller
  [CallerLineNumber]   line number in source file
  [CallerArgumentExpression("param")]  the expression passed (C# 10)

💻 CODE:
using System;
using System.Runtime.CompilerServices;
using System.Diagnostics;

// ─── PREPROCESSOR DIRECTIVES ───
#define FEATURE_DARK_MODE
// #define BETA_BUILD

class AppConfig
{
    public static string Theme
    {
        get
        {
#if FEATURE_DARK_MODE
            return "dark";
#else
            return "light";
#endif
        }
    }

    public static void PrintBuildInfo()
    {
#if DEBUG
        Console.WriteLine("DEBUG build — extra logging enabled");
#elif RELEASE
        Console.WriteLine("RELEASE build — optimized");
#else
        Console.WriteLine("Unknown build configuration");
#endif

#if BETA_BUILD
        Console.WriteLine("⚠️  BETA BUILD — not for production!");
#endif
    }
}

// ─── CALLER INFO ATTRIBUTES ───
class Logger
{
    // Compiler fills in default values from the CALL SITE automatically
    public static void Log(
        string message,
        [CallerMemberName] string memberName = "",
        [CallerFilePath]   string filePath   = "",
        [CallerLineNumber] int    lineNumber  = 0)
    {
        string fileName = System.IO.Path.GetFileName(filePath);
        Console.WriteLine(\$"[{fileName}:{lineNumber}] {memberName}() — {message}");
    }

    public static void Assert(
        bool condition,
        string message = "Assertion failed",
        [CallerMemberName] string memberName  = "",
        [CallerFilePath]   string filePath    = "",
        [CallerLineNumber] int    lineNumber   = 0,
        [CallerArgumentExpression("condition")] string conditionExpr = "")
    {
        if (!condition)
        {
            string fileName = System.IO.Path.GetFileName(filePath);
            throw new Exception(
                \$"Assertion failed at {fileName}:{lineNumber} in {memberName}()\\n" +
                \$"Expression: {conditionExpr}\\n" +
                \$"Message: {message}");
        }
    }
}

// ─── INotifyPropertyChanged with CallerMemberName ───
class ViewModel : System.ComponentModel.INotifyPropertyChanged
{
    public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

    private string _title;
    public string Title
    {
        get => _title;
        set
        {
            _title = value;
            OnPropertyChanged();  // no need to pass "Title" as string!
        }
    }

    // [CallerMemberName] captures "Title" automatically
    protected void OnPropertyChanged([CallerMemberName] string name = null)
        => PropertyChanged?.Invoke(this, new System.ComponentModel.PropertyChangedEventArgs(name));
}

// ─── CONDITIONAL ATTRIBUTE ───
class DiagnosticHelper
{
    // Only included in DEBUG builds
    [Conditional("DEBUG")]
    public static void DumpState(object obj)
    {
        Console.WriteLine(\$"DEBUG DUMP: {obj}");
    }

    [Conditional("TRACE")]
    public static void Trace(string message)
    {
        Console.WriteLine(\$"TRACE: {message}");
    }
}

class Program
{
    static void Main()
    {
        // Preprocessor
        Console.WriteLine(\$"Theme: {AppConfig.Theme}");  // dark
        AppConfig.PrintBuildInfo();

        // Caller info — call from here
        Logger.Log("Application started");
        // Prints: [Program.cs:XX] Main() — Application started

        DoSomething();

        // Assert with expression
        int x = 5;
        Logger.Assert(x > 0, "x must be positive");
        // If false, error shows: Expression: x > 0

        // Conditional method — only called in DEBUG builds
        DiagnosticHelper.DumpState("current state here");

        // ViewModel
        var vm = new ViewModel();
        vm.PropertyChanged += (s, e) => Console.WriteLine(\$"Changed: {e.PropertyName}");
        vm.Title = "Hello";  // fires with "Title" automatically
    }

    static void DoSomething()
    {
        Logger.Log("Inside DoSomething");
        // Prints: [Program.cs:XX] DoSomething() — Inside DoSomething
    }
}

─────────────────────────────────────
#pragma warning:
─────────────────────────────────────
#pragma warning disable CS0168  // suppress "variable declared but not used"
    int unused;
#pragma warning restore CS0168  // re-enable

#pragma warning disable nullable  // suppress all nullable warnings in block
─────────────────────────────────────

📝 KEY POINTS:
✅ [CallerMemberName] eliminates hardcoded method name strings in logging/INotifyPropertyChanged
✅ #if DEBUG is the standard way to include debug-only code
✅ [Conditional("DEBUG")] marks entire methods as debug-only — cleaner than #if inside methods
✅ [CallerArgumentExpression] captures the expression text — great for assertion helpers
✅ #region/#endregion are IDE folding helpers — use sparingly
❌ Don't abuse #define — prefer runtime configuration for feature flags
❌ Don't use preprocessor for large sections of different logic — too hard to test both paths
''',
  quiz: [
    Quiz(question: 'What does [CallerMemberName] do when used as a default parameter?', options: [
      QuizOption(text: 'The compiler automatically fills in the name of the calling method or property', correct: true),
      QuizOption(text: 'It captures the name of the class the method belongs to', correct: false),
      QuizOption(text: 'It requires the caller to explicitly pass their method name', correct: false),
      QuizOption(text: 'It is only available in debug builds', correct: false),
    ]),
    Quiz(question: 'What does [Conditional("DEBUG")] on a method do?', options: [
      QuizOption(text: 'All calls to the method are removed by the compiler in non-DEBUG builds', correct: true),
      QuizOption(text: 'The method body is only compiled in DEBUG builds', correct: false),
      QuizOption(text: 'The method throws in non-DEBUG builds', correct: false),
      QuizOption(text: 'It enables extra logging inside the method', correct: false),
    ]),
    Quiz(question: 'What preprocessor symbol is defined in Debug builds?', options: [
      QuizOption(text: 'DEBUG', correct: true),
      QuizOption(text: 'RELEASE', correct: false),
      QuizOption(text: 'DEVELOP', correct: false),
      QuizOption(text: 'DBG', correct: false),
    ]),
  ],
);
