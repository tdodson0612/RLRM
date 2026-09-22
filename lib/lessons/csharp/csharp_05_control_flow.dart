// lib/lessons/csharp/csharp_05_control_flow.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson05 = Lesson(
  language: 'C#',
  title: 'Control Flow: if, switch, loops',
  content: '''
🎯 METAPHOR:
Control flow is the story structure of your program.
Without it, your program is a single paragraph read from
start to finish every time. With control flow, it becomes
a Choose Your Own Adventure book — decisions branch the
story, loops let you repeat chapters, and breaks jump
to a new section. The logic of your program IS its flow.

📖 EXPLANATION:
C# has all the classic control flow structures plus
some modern additions.

IF / ELSE IF / ELSE — same as most languages
SWITCH — classic and pattern-matching versions
FOR — counted loops
WHILE — condition loops
DO-WHILE — guaranteed first run
FOREACH — iterate collections
BREAK / CONTINUE — loop control

💻 CODE:
using System;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        // ─── IF / ELSE ───
        int score = 85;
        if (score >= 90)
            Console.WriteLine("A");
        else if (score >= 80)
            Console.WriteLine("B");   // prints this
        else if (score >= 70)
            Console.WriteLine("C");
        else
            Console.WriteLine("F");

        // ─── SWITCH (classic) ───
        int day = 3;
        switch (day)
        {
            case 1:
                Console.WriteLine("Monday");
                break;
            case 2:
                Console.WriteLine("Tuesday");
                break;
            case 3:
                Console.WriteLine("Wednesday");  // prints this
                break;
            default:
                Console.WriteLine("Other");
                break;
        }

        // ─── SWITCH EXPRESSION (C# 8+) ───
        string dayName = day switch
        {
            1 => "Monday",
            2 => "Tuesday",
            3 => "Wednesday",
            _ => "Other"
        };

        // ─── PATTERN MATCHING IN SWITCH (C# 9+) ───
        object obj = 3.14;
        string type = obj switch
        {
            int i    => \$"Integer: {i}",
            double d => \$"Double: {d}",
            string s => \$"String: {s}",
            null     => "null",
            _        => "unknown"
        };
        Console.WriteLine(type);  // Double: 3.14

        // ─── FOR LOOP ───
        for (int i = 0; i < 5; i++)
            Console.Write(i + " ");   // 0 1 2 3 4
        Console.WriteLine();

        // ─── WHILE LOOP ───
        int count = 0;
        while (count < 3)
        {
            Console.WriteLine(\$"count = {count}");
            count++;
        }

        // ─── DO-WHILE ───
        int attempts = 0;
        do
        {
            Console.WriteLine(\$"Attempt {attempts + 1}");
            attempts++;
        } while (attempts < 3);

        // ─── FOREACH ───
        var names = new List<string> { "Alice", "Bob", "Charlie" };
        foreach (string name in names)
        {
            Console.WriteLine(\$"Hello, {name}!");
        }

        // ─── BREAK AND CONTINUE ───
        for (int i = 0; i < 10; i++)
        {
            if (i == 3) continue;   // skip 3
            if (i == 7) break;      // stop at 7
            Console.Write(i + " "); // 0 1 2 4 5 6
        }

        // ─── WHEN CLAUSE IN SWITCH (guard) ───
        int number = 15;
        string description = number switch
        {
            < 0          => "negative",
            0            => "zero",
            < 10         => "small",
            var n when n % 2 == 0 => "large even",
            _            => "large odd"
        };
        Console.WriteLine(description);  // large odd
    }
}

📝 KEY POINTS:
✅ Switch expressions with => are cleaner than switch statements for simple mappings
✅ Pattern matching in switch handles type checks elegantly
✅ foreach is preferred over for when you don't need the index
✅ when clauses add conditions to switch cases
✅ C# switch does NOT fall through by default — no break needed in switch expressions
❌ Classic switch still requires break — forgetting it is a compile error in C#
❌ Don't use goto — it exists in C# but is almost never appropriate
''',
  quiz: [
    Quiz(question: 'What does the _ pattern mean in a C# switch expression?', options: [
      QuizOption(text: 'It is the default case — matches anything not matched above', correct: true),
      QuizOption(text: 'It matches null values only', correct: false),
      QuizOption(text: 'It matches the underscore character', correct: false),
      QuizOption(text: 'It causes a compile error', correct: false),
    ]),
    Quiz(question: 'What is the difference between a switch statement and a switch expression?', options: [
      QuizOption(text: 'Switch expressions return a value and use => syntax; statements execute code blocks', correct: true),
      QuizOption(text: 'Switch statements are C# 8+; expressions are older', correct: false),
      QuizOption(text: 'They are identical — just different syntax styles', correct: false),
      QuizOption(text: 'Switch expressions require a default case; statements do not', correct: false),
    ]),
    Quiz(question: 'Which loop is guaranteed to execute its body at least once?', options: [
      QuizOption(text: 'do-while', correct: true),
      QuizOption(text: 'while', correct: false),
      QuizOption(text: 'for', correct: false),
      QuizOption(text: 'foreach', correct: false),
    ]),
  ],
);
