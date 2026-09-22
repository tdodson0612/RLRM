// lib/lessons/csharp/csharp_17_strings.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson17 = Lesson(
  language: 'C#',
  title: 'Strings in Depth',
  content: '''
🎯 METAPHOR:
A C# string is like a message carved in stone.
Once carved, it cannot be changed — you can only carve
a NEW stone. When you "modify" a string in C#, you are
actually creating a brand new string. This is called
immutability. The old stone sits in memory until garbage
collection comes along to clear it.
StringBuilder is like a whiteboard — you can erase and
rewrite as many times as you want without wasting stones.
Use StringBuilder when building strings in loops.

📖 EXPLANATION:
string in C# is:
  - Immutable — operations create NEW strings
  - A reference type — but behaves like a value type for ==
  - An alias for System.String
  - Unicode (UTF-16) — every char is 2 bytes

Key operations: interpolation, formatting, searching,
splitting, trimming, replacing, comparing.

💻 CODE:
using System;
using System.Text;

class Program
{
    static void Main()
    {
        // ─── CREATION ───
        string s1 = "Hello";
        string s2 = new string('*', 10);   // "**********"
        string s3 = string.Empty;          // ""
        string s4 = null;

        // ─── INTERPOLATION ───
        string name = "Alice";
        int age = 30;
        string msg = \$"Name: {name}, Age: {age}";
        string fmt = \$"Pi = {Math.PI:F4}";     // Pi = 3.1416
        string pad = \$"{'Hello',10}";           // right-aligned in 10 chars
        Console.WriteLine(fmt);

        // ─── VERBATIM AND RAW ───
        string path    = @"C:\\Users\\Alice";         // verbatim
        string raw     = """He said "hello" today."""; // raw (C# 11)
        string multiRaw = """
            Line 1
            Line 2
            """;  // raw multiline

        // ─── COMMON METHODS ───
        string text = "  Hello, World!  ";
        Console.WriteLine(text.Trim());           // "Hello, World!"
        Console.WriteLine(text.TrimStart());      // "Hello, World!  "
        Console.WriteLine(text.ToUpper());        // "  HELLO, WORLD!  "
        Console.WriteLine(text.ToLower());        // "  hello, world!  "
        Console.WriteLine(text.Contains("World")); // True
        Console.WriteLine(text.StartsWith("  H")); // True
        Console.WriteLine(text.EndsWith("!  "));   // True
        Console.WriteLine(text.Replace("World", "C#")); // "  Hello, C#!  "
        Console.WriteLine(text.Length);            // 17

        // ─── SUBSTRING AND INDEXING ───
        string word = "Hello";
        Console.WriteLine(word[0]);              // H
        Console.WriteLine(word[^1]);             // o (from end, C# 8)
        Console.WriteLine(word.Substring(1, 3)); // ell
        Console.WriteLine(word[1..4]);           // ell (range, C# 8)
        Console.WriteLine(word[..3]);            // Hel
        Console.WriteLine(word[2..]);            // llo

        // ─── SPLIT AND JOIN ───
        string csv = "Alice,Bob,Charlie,Diana";
        string[] names = csv.Split(',');
        foreach (var n in names) Console.Write(n + " ");
        Console.WriteLine();

        string joined = string.Join(" | ", names);
        Console.WriteLine(joined);  // Alice | Bob | Charlie | Diana

        // ─── FORMAT ───
        string formatted = string.Format("{0} is {1} years old", "Alice", 30);
        Console.WriteLine(formatted);

        // Format specifiers
        double pi = Math.PI;
        Console.WriteLine(\$"{pi:F2}");   // 3.14 (2 decimal places)
        Console.WriteLine(\$"{pi:E2}");   // 3.14E+000 (scientific)
        Console.WriteLine(\$"{1234567:N0}"); // 1,234,567 (number with commas)
        Console.WriteLine(\$"{0.75:P0}");   // 75% (percent)
        Console.WriteLine(\$"{255:X}");     // FF (hex)

        // ─── COMPARISON ───
        string a = "Apple";
        string b = "apple";
        Console.WriteLine(a == b);                               // False
        Console.WriteLine(string.Equals(a, b, StringComparison.OrdinalIgnoreCase)); // True
        Console.WriteLine(a.CompareTo(b));  // negative (A < a in ordinal)

        // ─── STRINGBUILDER (efficient concatenation) ───
        var sb = new StringBuilder();
        for (int i = 0; i < 5; i++)
        {
            sb.Append(\$"Item {i}");
            sb.AppendLine();
        }
        sb.Insert(0, "=== List ===\\n");
        sb.Replace("Item 3", "SPECIAL");
        Console.WriteLine(sb.ToString());

        // Performance rule:
        // string concat in loop = O(n²) allocations
        // StringBuilder in loop = O(n) allocations
    }
}

📝 KEY POINTS:
✅ Strings are immutable — every "modification" creates a new string
✅ Use StringBuilder for string building in loops (performance)
✅ == compares string content in C# (not references like Java)
✅ Use StringComparison.OrdinalIgnoreCase for case-insensitive comparison
✅ Ranges and indices (s[1..4], s[^1]) are clean C# 8+ features
❌ Don't concatenate strings in a loop with + — use StringBuilder
❌ Don't use == for culture-sensitive comparisons — use StringComparison
''',
  quiz: [
    Quiz(question: 'Why is StringBuilder preferred over string concatenation in loops?', options: [
      QuizOption(text: 'String concatenation creates a new string each time; StringBuilder mutates in place', correct: true),
      QuizOption(text: 'StringBuilder is thread-safe; string is not', correct: false),
      QuizOption(text: 'StringBuilder supports Unicode; string does not', correct: false),
      QuizOption(text: 'Strings cannot be concatenated in loops at all', correct: false),
    ]),
    Quiz(question: 'What does s[^1] mean in C# 8+?', options: [
      QuizOption(text: 'The last character of the string (index from the end)', correct: true),
      QuizOption(text: 'The second character', correct: false),
      QuizOption(text: 'A null-safe access of character at index 1', correct: false),
      QuizOption(text: 'Removing the last character', correct: false),
    ]),
    Quiz(question: 'How does C# compare string equality with ==?', options: [
      QuizOption(text: 'By content (value) — two strings with the same text are equal', correct: true),
      QuizOption(text: 'By reference — only the exact same object is equal', correct: false),
      QuizOption(text: 'By hash code — strings with same hash are equal', correct: false),
      QuizOption(text: 'Case-insensitively by default', correct: false),
    ]),
  ],
);
