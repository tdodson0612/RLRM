// lib/lessons/csharp/csharp_56_regex.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson56 = Lesson(
  language: 'C#',
  title: 'Regular Expressions',
  content: '''
🎯 METAPHOR:
A regular expression is a bloodhound trained to sniff
for patterns in text. You describe the scent (the pattern):
"find something that smells like an email address —
some word characters, an @ sign, more word characters,
a dot, more word characters." The hound runs through
the hay (your text) and finds every match. Regex is
extraordinarily precise — it finds exactly what you
describe, no more, no less. But like training a hound,
writing the pattern takes skill and practice.

📖 EXPLANATION:
System.Text.RegularExpressions.Regex

KEY METHODS:
  IsMatch(input)           true/false — does pattern match?
  Match(input)             first match object
  Matches(input)           all matches
  Replace(input, replace)  substitute matches
  Split(input)             split by pattern

KEY PATTERN SYNTAX:
  .     any character (except newline)
  \\d    digit [0-9]
  \\D    non-digit
  \\w    word char [a-zA-Z0-9_]
  \\W    non-word
  \\s    whitespace
  \\S    non-whitespace
  ^     start of string
  \$     end of string
  *     0 or more
  +     1 or more
  ?     0 or 1 (optional)
  {n}   exactly n times
  {n,m} between n and m times
  [abc] character class
  [^ab] negated class
  (ab)  capture group
  (?:ab) non-capturing group
  (?<name>ab) named capture group
  |     alternation (OR)
  \\b    word boundary

OPTIONS:
  IgnoreCase, Multiline, Singleline, IgnorePatternWhitespace

💻 CODE:
using System;
using System.Text.RegularExpressions;
using System.Collections.Generic;

class Program
{
    // ─── GENERATED REGEX (C# 11 — preferred) ───
    [GeneratedRegex(@"^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}\$")]
    private static partial Regex EmailRegex();

    [GeneratedRegex(@"\b\d{4}-\d{2}-\d{2}\b")]
    private static partial Regex DateRegex();

    static void Main()
    {
        // ─── IS MATCH ───
        Console.WriteLine(Regex.IsMatch("alice@example.com", @"^[\w.]+@[\w.]+\.\w+\$")); // True
        Console.WriteLine(Regex.IsMatch("not-an-email", @"^[\w.]+@[\w.]+\.\w+\$"));      // False

        // ─── MATCH (first) ───
        string text = "Call us at 555-1234 or 800-555-9876";
        Match m = Regex.Match(text, @"\d{3}-\d{4}");
        Console.WriteLine(m.Value);    // 555-1234
        Console.WriteLine(m.Index);    // 11
        Console.WriteLine(m.Length);   // 8

        // ─── MATCHES (all) ───
        MatchCollection all = Regex.Matches(text, @"\d{3}-\d{4}");
        foreach (Match match in all)
            Console.WriteLine(match.Value);  // 555-1234, 555-9876

        // ─── CAPTURE GROUPS ───
        string date = "Event on 2024-03-15 ends 2024-04-01";
        var dateRegex = new Regex(@"(\d{4})-(\d{2})-(\d{2})");

        foreach (Match dm in dateRegex.Matches(date))
        {
            Console.WriteLine(\$"Full: {dm.Value}");
            Console.WriteLine(\$"  Year:  {dm.Groups[1].Value}");
            Console.WriteLine(\$"  Month: {dm.Groups[2].Value}");
            Console.WriteLine(\$"  Day:   {dm.Groups[3].Value}");
        }

        // ─── NAMED CAPTURE GROUPS ───
        var namedRegex = new Regex(@"(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})");
        Match nd = namedRegex.Match("Birth date: 1990-06-15");
        if (nd.Success)
        {
            Console.WriteLine(nd.Groups["year"].Value);   // 1990
            Console.WriteLine(nd.Groups["month"].Value);  // 06
            Console.WriteLine(nd.Groups["day"].Value);    // 15
        }

        // ─── REPLACE ───
        string messy = "Hello   World  foo   bar";
        string clean = Regex.Replace(messy, @"\s+", " ");
        Console.WriteLine(clean);  // Hello World foo bar

        // Replace with group reference
        string name = "Smith, John";
        string swapped = Regex.Replace(name, @"(\w+),\s*(\w+)", "\$2 \$1");
        Console.WriteLine(swapped);  // John Smith

        // Replace with evaluator (custom logic)
        string nums = "one 1 two 2 three 3";
        string doubled = Regex.Replace(nums, @"\d+",
            m2 => (int.Parse(m2.Value) * 2).ToString());
        Console.WriteLine(doubled);  // one 2 two 4 three 6

        // ─── SPLIT ───
        string csv = "Alice , Bob , Charlie ,Diana";
        string[] parts = Regex.Split(csv, @"\s*,\s*");
        Console.WriteLine(string.Join(" | ", parts));
        // Alice | Bob | Charlie | Diana

        // ─── OPTIONS ───
        bool found = Regex.IsMatch("Hello World", @"hello world",
                                   RegexOptions.IgnoreCase);
        Console.WriteLine(found);  // True

        // Multiline: ^ and \$ match start/end of each LINE
        string multiline = "line1\nline2\nline3";
        var lineStarts = Regex.Matches(multiline, @"^\w+",
                                       RegexOptions.Multiline);
        foreach (Match lm in lineStarts)
            Console.Write(lm.Value + " ");  // line1 line2 line3
        Console.WriteLine();

        // ─── COMPILED (pre-C# 11) — cached instance ───
        var compiled = new Regex(@"\d+", RegexOptions.Compiled);
        // Reuse 'compiled' — don't create new Regex in hot loops

        // ─── GENERATED REGEX (best for known patterns) ───
        Console.WriteLine(EmailRegex().IsMatch("test@example.com")); // True

        // ─── COMMON PATTERNS ───
        string[] patterns =
        {
            @"^\d+\$",                        // all digits
            @"^[a-zA-Z]+\$",                  // all letters
            @"^\w{3,20}\$",                   // username 3-20 chars
            @"^(?=.*[A-Z])(?=.*\d).{8,}\$",  // password: 1 uppercase, 1 digit, 8+ chars
            @"^\+?[\d\s\-().]{7,15}\$",       // phone number
            @"^https?://[\w\-./]+\$",         // URL
        };
    }
}

📝 KEY POINTS:
✅ Use [GeneratedRegex] for known compile-time patterns — faster and AOT-compatible
✅ Cache Regex instances (static field) when not using GeneratedRegex
✅ Named groups ((?<name>...)) make complex patterns self-documenting
✅ Use verbatim strings @"pattern" to avoid double-escaping backslashes
✅ RegexOptions.Compiled pre-compiles the pattern — good for hot paths
❌ Don't create new Regex() inside a loop — it recompiles every time
❌ Catastrophic backtracking is a real risk with nested quantifiers — test with ReDoS checker
''',
  quiz: [
    Quiz(question: 'What does \\d match in a regular expression?', options: [
      QuizOption(text: 'Any single digit character [0-9]', correct: true),
      QuizOption(text: 'Any word character', correct: false),
      QuizOption(text: 'Any whitespace character', correct: false),
      QuizOption(text: 'The letter d', correct: false),
    ]),
    Quiz(question: 'What is the advantage of [GeneratedRegex] over new Regex()?', options: [
      QuizOption(text: 'The regex is compiled at build time — faster at runtime and AOT-compatible', correct: true),
      QuizOption(text: 'GeneratedRegex supports more pattern syntax', correct: false),
      QuizOption(text: 'It automatically escapes special characters', correct: false),
      QuizOption(text: 'It prevents catastrophic backtracking', correct: false),
    ]),
    Quiz(question: 'What does a named capture group (?<year>\\d{4}) give you?', options: [
      QuizOption(text: 'Access to the matched value by name: match.Groups["year"].Value', correct: true),
      QuizOption(text: 'A named variable in the current scope', correct: false),
      QuizOption(text: 'A reusable pattern that can be referenced elsewhere', correct: false),
      QuizOption(text: 'An automatically extracted and parsed integer', correct: false),
    ]),
  ],
);
