// lib/lessons/csharp/csharp_68_top_level_statements.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson68 = Lesson(
  language: 'C#',
  title: 'Top-Level Statements, Program Entry Point, and Global Usings',
  content: '''
🎯 METAPHOR:
Top-level statements are like writing a recipe on a card
versus in a formal cookbook. The cookbook requires chapters,
a table of contents, a proper introduction (namespace, class,
Main method). The recipe card just has the steps: heat pan,
add oil, cook eggs. Both produce the same meal. For small
programs and scripts, the recipe card approach is cleaner.
C# 9 lets you write the recipe card — just the code,
no ceremony. The compiler adds the cookbook structure silently.

📖 EXPLANATION:
TOP-LEVEL STATEMENTS (C# 9+):
  Eliminate the Program class and Main() method boilerplate.
  The compiler generates them automatically.
  Only ONE file per project can use top-level statements.
  args variable is available automatically.

GLOBAL USINGS (C# 10+):
  global using System;  — applies to ALL files in the project
  Put in a dedicated file (e.g., GlobalUsings.cs).
  .NET 6+ projects have implicit global usings by default.

IMPLICIT GLOBAL USINGS:
  Enabled in .NET 6+ projects with:
    <ImplicitUsings>enable</ImplicitUsings>
  Automatically adds common namespaces based on project type:
    Console: System, Collections.Generic, IO, Linq, etc.
    Web:     adds Microsoft.AspNetCore.* namespaces

ENTRY POINT RULES:
  Async Main: async Task Main(string[] args)
  Return code: return 42;  — becomes the process exit code
  args: string[] automatically available

💻 CODE:
// ─── Program.cs (top-level statements) ───
// No "using System;" needed in .NET 6+ (implicit global usings)
// No "namespace MyApp;" needed
// No "class Program {" needed
// No "static void Main(string[] args) {" needed

// These are just top-level statements:
Console.WriteLine("Hello from top-level statements!");

// args is automatically available
if (args.Length > 0)
    Console.WriteLine(\$"First argument: {args[0]}");

// You can use await at the top level
await Task.Delay(10);
Console.WriteLine("After await");

// Local functions work here
void Greet(string name) => Console.WriteLine(\$"Hello, {name}!");
Greet("Alice");

// Local classes work here
class Point { public int X, Y; }
var p = new Point { X = 1, Y = 2 };

// Return an exit code
// return 0;  // Process.ExitCode

// ─── GlobalUsings.cs ───
// global using System;
// global using System.Collections.Generic;
// global using System.Linq;
// global using System.Threading.Tasks;
// global using System.Text.Json;
// (These apply to ALL .cs files in the project)

// ─── WHAT THE COMPILER GENERATES ───
// The above top-level code compiles to approximately:
//
// using System;
// using System.Threading.Tasks;
//
// internal class Program
// {
//     static async Task<int> Main(string[] args)
//     {
//         Console.WriteLine("Hello from top-level statements!");
//         if (args.Length > 0)
//             Console.WriteLine(\$"First argument: {args[0]}");
//         await Task.Delay(10);
//         Console.WriteLine("After await");
//         Greet("Alice");
//         var p = new Point { X = 1, Y = 2 };
//         return 0;
//
//         void Greet(string name) => Console.WriteLine(\$"Hello, {name}!");
//     }
// }
//
// partial class Program { }  // allows partial methods/classes in other files

// ─── MIXING: Some files use top-level, rest use classes ───
// Program.cs: top-level statements
// Services/UserService.cs: regular class in namespace MyApp.Services
// Models/User.cs: regular record in namespace MyApp.Models
// This is the recommended modern project structure

using System;
using System.Collections.Generic;
using System.Linq;

class FullExampleProgram
{
    // Traditional Main for reference — SAME as top-level statements
    static async Task<int> Main(string[] args)
    {
        Console.WriteLine(\$"Running with {args.Length} args");
        await Task.Delay(10);
        return 0;  // exit code
    }
}

─────────────────────────────────────
IMPLICIT GLOBAL USINGS (Console app):
─────────────────────────────────────
System
System.Collections.Generic
System.IO
System.Linq
System.Net.Http
System.Threading
System.Threading.Tasks
─────────────────────────────────────

📝 KEY POINTS:
✅ Top-level statements eliminate boilerplate for simple programs and scripts
✅ Only ONE file per project can have top-level statements
✅ args, await, and return are all available in top-level statement files
✅ global using in a shared file eliminates repeated using statements across files
✅ .NET 6+ enables implicit global usings automatically — check your .csproj
✅ The generated Program class is partial — you can add partial methods to it
❌ Top-level statements are only for the entry point file — other files use normal class syntax
❌ Don't use global using for namespaces that cause naming conflicts
''',
  quiz: [
    Quiz(question: 'How many files in a project can use top-level statements?', options: [
      QuizOption(text: 'Exactly one — only the entry point file', correct: true),
      QuizOption(text: 'Any number of files', correct: false),
      QuizOption(text: 'Up to five', correct: false),
      QuizOption(text: 'None — top-level statements require a class', correct: false),
    ]),
    Quiz(question: 'What does "global using System;" do in GlobalUsings.cs?', options: [
      QuizOption(text: 'Makes the System namespace available in every .cs file in the project', correct: true),
      QuizOption(text: 'Makes System available only in GlobalUsings.cs', correct: false),
      QuizOption(text: 'Imports System globally at the OS level', correct: false),
      QuizOption(text: 'Prevents other files from needing to reference System', correct: false),
    ]),
    Quiz(question: 'What does the compiler generate from top-level statements?', options: [
      QuizOption(text: 'An internal partial Program class with a static Main method', correct: true),
      QuizOption(text: 'A global function with no class wrapper', correct: false),
      QuizOption(text: 'A public static class with a Run() method', correct: false),
      QuizOption(text: 'Nothing — top-level statements are interpreted at runtime', correct: false),
    ]),
  ],
);
