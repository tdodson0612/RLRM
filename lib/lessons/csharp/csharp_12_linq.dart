// lib/lessons/csharp/csharp_12_linq.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson12 = Lesson(
  language: 'C#',
  title: 'LINQ: Language Integrated Query',
  content: '''
🎯 METAPHOR:
LINQ is like a high-powered blender for your data.
Before LINQ: you write loops, nested loops, if statements,
temporary lists — pages of code to filter, sort, and
transform collections. With LINQ: you describe WHAT you
want, not HOW to get it. "Give me all students over 18,
sorted by grade, return just their names." One line.
LINQ turns data processing from a chore into a declaration.

📖 EXPLANATION:
LINQ (Language Integrated Query) lets you query any
collection (or database, XML, etc.) using a consistent
syntax integrated right into C#.

Two syntaxes — they compile to the same thing:
  1. Method syntax (fluent) — chained extension methods
  2. Query syntax — SQL-like keywords

Method syntax is more commonly used in modern C#.

LINQ IS LAZY — queries are not executed until you
iterate or call a terminal operation (ToList, Count, etc.)

💻 CODE:
using System;
using System.Collections.Generic;
using System.Linq;

class Student
{
    public string Name { get; set; }
    public int Age { get; set; }
    public double GPA { get; set; }
    public string Major { get; set; }
}

class Program
{
    static void Main()
    {
        var students = new List<Student>
        {
            new() { Name = "Alice",   Age = 20, GPA = 3.8, Major = "CS" },
            new() { Name = "Bob",     Age = 22, GPA = 3.2, Major = "Math" },
            new() { Name = "Charlie", Age = 19, GPA = 3.9, Major = "CS" },
            new() { Name = "Diana",   Age = 21, GPA = 3.5, Major = "CS" },
            new() { Name = "Eve",     Age = 23, GPA = 2.8, Major = "Math" },
        };

        // ─── WHERE (filter) ───
        var csStudents = students.Where(s => s.Major == "CS");

        // ─── SELECT (transform / project) ───
        var names = students.Select(s => s.Name);
        var nameAndGPA = students.Select(s => new { s.Name, s.GPA });

        // ─── ORDERBY / ORDERBYDESCENDING ───
        var byGPA = students.OrderByDescending(s => s.GPA);
        var sorted = students.OrderBy(s => s.Major).ThenBy(s => s.Name);

        // ─── CHAIN THEM ───
        var topCS = students
            .Where(s => s.Major == "CS" && s.GPA >= 3.5)
            .OrderByDescending(s => s.GPA)
            .Select(s => \$"{s.Name} ({s.GPA})");

        foreach (var s in topCS) Console.WriteLine(s);
        // Charlie (3.9)
        // Alice (3.8)
        // Diana (3.5)

        // ─── AGGREGATE OPERATIONS ───
        Console.WriteLine(students.Count());                   // 5
        Console.WriteLine(students.Count(s => s.GPA > 3.5));  // 2
        Console.WriteLine(students.Sum(s => s.GPA));           // 17.2
        Console.WriteLine(students.Average(s => s.GPA));       // 3.44
        Console.WriteLine(students.Max(s => s.GPA));           // 3.9
        Console.WriteLine(students.Min(s => s.Age));           // 19

        // ─── FIRST / LAST / SINGLE ───
        var first = students.First(s => s.Major == "CS");       // Alice
        var last  = students.Last(s => s.Major == "CS");        // Diana
        // .Single() throws if more than one match
        // .FirstOrDefault() returns null if no match (safe)
        var maybe = students.FirstOrDefault(s => s.Name == "Zara");
        Console.WriteLine(maybe?.Name ?? "Not found");          // Not found

        // ─── ANY / ALL / NONE ───
        Console.WriteLine(students.Any(s => s.GPA > 3.8));      // True
        Console.WriteLine(students.All(s => s.GPA > 2.0));      // True
        Console.WriteLine(!students.Any(s => s.GPA > 4.0));     // True (none over 4)

        // ─── GROUPBY ───
        var byMajor = students.GroupBy(s => s.Major);
        foreach (var group in byMajor)
        {
            Console.WriteLine(\$"Major: {group.Key}");
            foreach (var s in group)
                Console.WriteLine(\$"  {s.Name}: {s.GPA}");
        }

        // ─── DISTINCT / UNION / INTERSECT ───
        var majors = students.Select(s => s.Major).Distinct();
        Console.WriteLine(string.Join(", ", majors));  // CS, Math

        // ─── TAKE / SKIP (pagination) ───
        var page1 = students.OrderBy(s => s.Name).Take(3);
        var page2 = students.OrderBy(s => s.Name).Skip(3).Take(3);

        // ─── QUERY SYNTAX (same result as method syntax) ───
        var query = from s in students
                    where s.Major == "CS"
                    orderby s.GPA descending
                    select s.Name;

        // ─── TOLIST / TOARRAY — materialize the query ───
        var resultList  = topCS.ToList();
        var resultArray = topCS.ToArray();

        // ─── TODICTIONARY ───
        var nameToGPA = students.ToDictionary(s => s.Name, s => s.GPA);
        Console.WriteLine(nameToGPA["Alice"]);  // 3.8
    }
}

📝 KEY POINTS:
✅ LINQ is lazy — it doesn't execute until you iterate or call ToList/ToArray
✅ Method syntax (.Where().OrderBy()) is more common than query syntax
✅ FirstOrDefault is safer than First — returns null/default instead of throwing
✅ GroupBy returns IGrouping<TKey, TElement> — use group.Key and foreach
✅ ToDictionary is great for creating fast-lookup maps from collections
❌ Calling Count() on LINQ queries re-executes the query — cache with ToList first
❌ Don't use Single() unless exactly one result is expected — it throws otherwise
''',
  quiz: [
    Quiz(question: 'What does "lazy evaluation" mean in LINQ?', options: [
      QuizOption(text: 'The query is not executed until you iterate the result or call ToList/ToArray', correct: true),
      QuizOption(text: 'LINQ runs slowly because it checks all items', correct: false),
      QuizOption(text: 'LINQ caches results for reuse', correct: false),
      QuizOption(text: 'The query runs on a background thread', correct: false),
    ]),
    Quiz(question: 'What is the difference between First() and FirstOrDefault()?', options: [
      QuizOption(text: 'First() throws if no match; FirstOrDefault() returns null/default', correct: true),
      QuizOption(text: 'FirstOrDefault() throws; First() returns null', correct: false),
      QuizOption(text: 'They are identical', correct: false),
      QuizOption(text: 'First() only works on sorted collections', correct: false),
    ]),
    Quiz(question: 'What does GroupBy() return for each group?', options: [
      QuizOption(text: 'An IGrouping with a Key property and the grouped elements', correct: true),
      QuizOption(text: 'A Dictionary<TKey, List<T>>', correct: false),
      QuizOption(text: 'A List<T> sorted by the group key', correct: false),
      QuizOption(text: 'A single element representing the group', correct: false),
    ]),
  ],
);
