// lib/lessons/csharp/csharp_02_setup_and_syntax.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson02 = Lesson(
  language: 'C#',
  title: 'Setup and Basic Syntax',
  content: '''
🎯 METAPHOR:
Setting up C# is like getting a driver's license.
You need the vehicle (the .NET SDK), a place to practice
(an IDE or terminal), and to learn the basic rules of the
road (syntax). Once you have all three, you can drive
anywhere. The SDK is free, the IDE options are excellent,
and the "road rules" are clean and consistent.

📖 EXPLANATION:
WHAT YOU NEED:
  1. .NET SDK — download from dotnet.microsoft.com (free)
  2. IDE — Visual Studio (Windows), VS Code (all platforms),
            or Rider (JetBrains, cross-platform)

CREATING AND RUNNING A PROJECT:
  dotnet new console -n MyApp   create a new console project
  cd MyApp
  dotnet run                    compile and run

─────────────────────────────────────
C# FILE STRUCTURE:
─────────────────────────────────────
// 1. Using directives (imports)
using System;
using System.Collections.Generic;

// 2. Namespace
namespace MyApp
{
    // 3. Class
    class Program
    {
        // 4. Main method — entry point
        static void Main(string[] args)
        {
            // 5. Code goes here
        }
    }
}
─────────────────────────────────────

C# 9+ TOP-LEVEL STATEMENTS:
You can skip the class/Main boilerplate entirely in
one file per project:
  Console.WriteLine("Hello!");
  var x = 42;

💻 CODE:
using System;

namespace BasicSyntax
{
    class Program
    {
        static void Main(string[] args)
        {
            // Output to console
            Console.WriteLine("Hello, World!");    // with newline
            Console.Write("No newline here. ");    // without newline
            Console.WriteLine("Same line!");

            // Variables
            int age = 25;
            double price = 9.99;
            string name = "Alice";
            bool isActive = true;

            // String interpolation (the C# way)
            Console.WriteLine(\$"Name: {name}, Age: {age}");

            // Reading input
            Console.Write("Enter your name: ");
            string input = Console.ReadLine();
            Console.WriteLine(\$"Hello, {input}!");

            // Comments
            // Single line comment
            /* Multi-line
               comment */

            // Verbatim string (raw, no escape needed)
            string path = @"C:\\Users\\Alice\\Documents";
            Console.WriteLine(path);  // C:\\Users\\Alice\\Documents

            // Multiline string (C# 11+)
            string multiline = """
                Hello,
                World!
                """;
            Console.WriteLine(multiline);
        }
    }
}

─────────────────────────────────────
NAMING CONVENTIONS:
─────────────────────────────────────
PascalCase    ClassName, MethodName, PropertyName
camelCase     localVariable, parameterName
_camelCase    private field (_myField)
UPPER_CASE    constants (rare — usually PascalCase)
─────────────────────────────────────

📝 KEY POINTS:
✅ C# uses semicolons to end statements
✅ String interpolation: \$"text {variable} text"
✅ Console.WriteLine adds a newline; Console.Write does not
✅ @ prefix creates a verbatim string — backslashes are literal
✅ dotnet run compiles and executes in one command
❌ C# is case-sensitive — String and string are different (string is preferred)
❌ Don't forget using System; — Console lives there
''',
  quiz: [
    Quiz(question: 'What does \$"Hello, {name}!" demonstrate?', options: [
      QuizOption(text: 'String interpolation — embedding variables inside a string', correct: true),
      QuizOption(text: 'A verbatim string literal', correct: false),
      QuizOption(text: 'A format string like printf', correct: false),
      QuizOption(text: 'A raw string literal', correct: false),
    ]),
    Quiz(question: 'What does the @ prefix do to a string in C#?', options: [
      QuizOption(text: 'Makes it a verbatim string — backslashes are treated as literal characters', correct: true),
      QuizOption(text: 'Enables string interpolation', correct: false),
      QuizOption(text: 'Makes the string immutable', correct: false),
      QuizOption(text: 'Creates a multiline string', correct: false),
    ]),
    Quiz(question: 'What command runs a C# console application?', options: [
      QuizOption(text: 'dotnet run', correct: true),
      QuizOption(text: 'csc run', correct: false),
      QuizOption(text: 'dotnet execute', correct: false),
      QuizOption(text: 'cs run', correct: false),
    ]),
  ],
);
