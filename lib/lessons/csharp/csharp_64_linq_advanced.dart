// lib/lessons/csharp/csharp_64_linq_advanced.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson64 = Lesson(
  language: 'C#',
  title: 'LINQ Advanced: Joins, Aggregates, and Custom Providers',
  content: '''
🎯 METAPHOR:
Advanced LINQ is like becoming a SQL expert after learning
SELECT. You already know WHERE and ORDER BY. Now you learn
JOIN (merge two tables), GROUP BY (aggregate), HAVING
(filter groups), subqueries, and window functions.
The same concepts exist in LINQ — just with C# syntax.
And because LINQ is lazy and composable, you can build
complex data pipelines that read like English sentences.

📖 EXPLANATION:
LINQ JOINS:
  Join        — inner join (matching pairs only)
  GroupJoin   — left outer join (all left + matching right)

AGGREGATION:
  Aggregate(seed, func)  — fold/reduce
  Sum, Count, Min, Max, Average — with optional predicate

GROUPING:
  GroupBy → IGrouping<Key, Element>
  ToLookup → fast multi-value dictionary

SET OPERATIONS:
  Distinct, Union, Intersect, Except

PARTITIONING:
  Take, Skip, TakeLast, SkipLast
  TakeWhile, SkipWhile

ELEMENT OPERATIONS:
  First/FirstOrDefault, Last/LastOrDefault
  Single/SingleOrDefault, ElementAt

CONVERSION:
  ToList, ToArray, ToDictionary, ToHashSet, ToLookup

GENERATION:
  Enumerable.Range, Repeat, Empty

💻 CODE:
using System;
using System.Collections.Generic;
using System.Linq;

record Student(int Id, string Name, int DeptId, double GPA);
record Department(int Id, string Name);
record Enrollment(int StudentId, string Course, int Grade);

class Program
{
    static void Main()
    {
        var students = new List<Student>
        {
            new(1, "Alice",   1, 3.8),
            new(2, "Bob",     2, 3.2),
            new(3, "Charlie", 1, 3.9),
            new(4, "Diana",   3, 3.5),
            new(5, "Eve",     2, 2.8),
        };

        var departments = new List<Department>
        {
            new(1, "Computer Science"),
            new(2, "Mathematics"),
            new(3, "Physics"),
            new(4, "Chemistry"),  // no students!
        };

        var enrollments = new List<Enrollment>
        {
            new(1, "Algorithms", 95),
            new(1, "Databases",  88),
            new(2, "Calculus",   75),
            new(3, "Algorithms", 98),
            new(3, "AI",         92),
        };

        // ─── INNER JOIN ───
        var studentWithDept = students.Join(
            departments,
            s => s.DeptId,          // outer key
            d => d.Id,              // inner key
            (s, d) => new { s.Name, Dept = d.Name, s.GPA }
        );
        foreach (var r in studentWithDept)
            Console.WriteLine(\$"{r.Name} ({r.Dept}): {r.GPA}");

        // ─── LEFT OUTER JOIN (GroupJoin) ───
        var deptWithStudents = departments.GroupJoin(
            students,
            d => d.Id,
            s => s.DeptId,
            (d, sGroup) => new
            {
                Dept     = d.Name,
                Students = sGroup.ToList(),
                Count    = sGroup.Count()
            }
        );
        foreach (var d in deptWithStudents)
            Console.WriteLine(\$"{d.Dept}: {d.Count} students");
        // Chemistry: 0 students (included because GroupJoin is left outer)

        // ─── MULTI-JOIN ───
        var fullData = from s in students
                       join d in departments on s.DeptId equals d.Id
                       join e in enrollments on s.Id equals e.StudentId into es
                       from e in es.DefaultIfEmpty()
                       select new
                       {
                           s.Name,
                           Dept   = d.Name,
                           Course = e?.Course ?? "No enrollment",
                           Grade  = e?.Grade ?? 0
                       };

        foreach (var r in fullData)
            Console.WriteLine(\$"{r.Name} | {r.Dept} | {r.Course}: {r.Grade}");

        // ─── GROUPBY + AGGREGATION ───
        var deptStats = students
            .GroupBy(s => s.DeptId)
            .Select(g => new
            {
                DeptId  = g.Key,
                Count   = g.Count(),
                AvgGPA  = g.Average(s => s.GPA),
                MaxGPA  = g.Max(s => s.GPA),
                TopStudent = g.OrderByDescending(s => s.GPA).First().Name
            });

        foreach (var stat in deptStats)
            Console.WriteLine(\$"Dept {stat.DeptId}: {stat.Count} students, avg GPA {stat.AvgGPA:F2}, top: {stat.TopStudent}");

        // ─── AGGREGATE (fold) ───
        var names = students.Select(s => s.Name).ToList();
        string csv = names.Aggregate((acc, name) => acc + ", " + name);
        Console.WriteLine(csv);  // Alice, Bob, Charlie, Diana, Eve

        // Aggregate with seed
        int totalGradePoints = enrollments.Aggregate(0, (sum, e) => sum + e.Grade);
        Console.WriteLine(\$"Total grade points: {totalGradePoints}");

        // ─── TOLOOKUP (multi-value dictionary) ───
        ILookup<int, string> deptStudents = students
            .ToLookup(s => s.DeptId, s => s.Name);

        foreach (string name in deptStudents[1])
            Console.WriteLine(\$"CS dept: {name}");

        // ─── SET OPERATIONS ───
        var highGPA    = students.Where(s => s.GPA >= 3.5).Select(s => s.Name);
        var csStudents = students.Where(s => s.DeptId == 1).Select(s => s.Name);

        Console.WriteLine(string.Join(", ", highGPA.Intersect(csStudents)));  // high GPA AND CS
        Console.WriteLine(string.Join(", ", highGPA.Union(csStudents)));      // high GPA OR CS
        Console.WriteLine(string.Join(", ", highGPA.Except(csStudents)));     // high GPA but NOT CS

        // ─── GENERATION ───
        var range    = Enumerable.Range(1, 10);
        var repeated = Enumerable.Repeat("hello", 3);
        var empty    = Enumerable.Empty<int>();

        // ─── TAKEWHILE / SKIPWHILE ───
        var nums = new[] { 2, 4, 6, 7, 8, 10 };
        var evensUntilOdd = nums.TakeWhile(n => n % 2 == 0);
        Console.WriteLine(string.Join(",", evensUntilOdd));  // 2,4,6

        // ─── ZIP ───
        var first  = new[] { "a", "b", "c" };
        var second = new[] { 1, 2, 3 };
        var zipped = first.Zip(second, (f, s) => \$"{f}{s}");
        Console.WriteLine(string.Join(",", zipped));  // a1,b2,c3

        // ─── CHUNK (C# 8) ───
        var pages = Enumerable.Range(1, 10).Chunk(3);
        foreach (var page in pages)
            Console.WriteLine(string.Join(",", page));  // [1,2,3] [4,5,6] [7,8,9] [10]
    }
}

📝 KEY POINTS:
✅ Join is inner join — only matching pairs
✅ GroupJoin is left outer join — all left items with optional right matches
✅ ToLookup builds a multi-value lookup — like Dictionary<K, IEnumerable<V>>
✅ Aggregate is the general fold/reduce — use for custom accumulation
✅ Chunk (C# 6+) splits a sequence into fixed-size pages
✅ Zip pairs elements from two sequences together
❌ Don't call Count() twice on expensive IEnumerable — ToList() first
❌ GroupBy doesn't sort — use OrderBy after GroupBy if order matters
''',
  quiz: [
    Quiz(question: 'What is the difference between Join and GroupJoin in LINQ?', options: [
      QuizOption(text: 'Join is inner join (only matches); GroupJoin is left outer join (all left items)', correct: true),
      QuizOption(text: 'GroupJoin returns only matching items; Join returns all', correct: false),
      QuizOption(text: 'They are identical — different names for the same operation', correct: false),
      QuizOption(text: 'Join works on IEnumerable; GroupJoin only works on IQueryable', correct: false),
    ]),
    Quiz(question: 'What does ToLookup create?', options: [
      QuizOption(text: 'A multi-value lookup where each key maps to multiple elements', correct: true),
      QuizOption(text: 'A dictionary with case-insensitive keys', correct: false),
      QuizOption(text: 'A sorted dictionary', correct: false),
      QuizOption(text: 'An inverse index mapping values back to keys', correct: false),
    ]),
    Quiz(question: 'What does Aggregate(seed, (acc, item) => ...) do?', options: [
      QuizOption(text: 'Applies a function to each element cumulatively, building a single result', correct: true),
      QuizOption(text: 'Sums all numeric elements', correct: false),
      QuizOption(text: 'Groups elements by the accumulator value', correct: false),
      QuizOption(text: 'Creates a running average', correct: false),
    ]),
  ],
);
