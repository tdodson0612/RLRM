// lib/lessons/csharp/csharp_11_collections.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson11 = Lesson(
  language: 'C#',
  title: 'Collections',
  content: '''
🎯 METAPHOR:
Collections are like different types of storage furniture.
A List<T> is a bookshelf — ordered, indexed, add anywhere.
A Dictionary<K,V> is a filing cabinet — find anything
instantly by its label (key).
A HashSet<T> is a bouncer's guest list — each name appears
exactly once, and checking "is this person on the list?"
is nearly instant.
A Queue<T> is a deli counter line — first person in line
gets served first.
A Stack<T> is a spring-loaded plate dispenser — last plate
placed is the first one taken.
Pick the right furniture for the job.

📖 EXPLANATION:
The System.Collections.Generic namespace provides the
main collection types. Always use the generic versions —
never the non-generic ArrayList, Hashtable, etc.

─────────────────────────────────────
COLLECTION        BEST FOR
─────────────────────────────────────
List<T>           ordered, indexed, variable size
Dictionary<K,V>   key-value lookup
HashSet<T>        unique values, fast contains check
SortedList<K,V>   sorted key-value pairs
SortedSet<T>      sorted unique values
Queue<T>          FIFO processing
Stack<T>          LIFO / undo history
LinkedList<T>     fast insert/remove anywhere
─────────────────────────────────────

💻 CODE:
using System;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        // ─── LIST<T> ───
        var scores = new List<int> { 95, 87, 92, 78 };
        scores.Add(88);
        scores.Insert(0, 100);       // insert at index 0
        scores.Remove(78);           // remove by value
        scores.RemoveAt(0);          // remove by index

        Console.WriteLine(scores.Count);         // 4
        Console.WriteLine(scores.Contains(88));  // True
        Console.WriteLine(scores.IndexOf(87));   // 0
        scores.Sort();
        scores.Reverse();

        foreach (var s in scores) Console.Write(s + " ");
        Console.WriteLine();

        // List to array and back
        int[] arr = scores.ToArray();
        var list2 = new List<int>(arr);

        // ─── DICTIONARY<K,V> ───
        var ages = new Dictionary<string, int>
        {
            { "Alice", 30 },
            { "Bob",   25 },
            ["Charlie"] = 35   // alternative syntax
        };

        ages["Diana"] = 28;     // add new entry
        ages["Alice"] = 31;     // update existing

        Console.WriteLine(ages["Alice"]);  // 31

        // Safe access
        if (ages.TryGetValue("Bob", out int bobAge))
            Console.WriteLine(\$"Bob is {bobAge}");

        // Iterate
        foreach (var (name, age) in ages)
            Console.WriteLine(\$"{name}: {age}");

        Console.WriteLine(ages.ContainsKey("Eve"));    // False
        ages.Remove("Charlie");
        Console.WriteLine(ages.Count);                 // 3

        // ─── HASHSET<T> ───
        var unique = new HashSet<string> { "apple", "banana", "apple" };
        unique.Add("cherry");
        unique.Add("apple");   // duplicate — ignored
        Console.WriteLine(unique.Count);   // 3 (apple only counted once)

        Console.WriteLine(unique.Contains("banana"));  // True

        // Set operations
        var setA = new HashSet<int> { 1, 2, 3, 4, 5 };
        var setB = new HashSet<int> { 3, 4, 5, 6, 7 };

        setA.IntersectWith(setB);              // {3, 4, 5}
        Console.WriteLine(string.Join(", ", setA));

        var setC = new HashSet<int> { 1, 2, 3 };
        var setD = new HashSet<int> { 3, 4, 5 };
        setC.UnionWith(setD);                  // {1, 2, 3, 4, 5}

        // ─── QUEUE<T> ───
        var queue = new Queue<string>();
        queue.Enqueue("Alice");
        queue.Enqueue("Bob");
        queue.Enqueue("Charlie");

        Console.WriteLine(queue.Peek());       // Alice (don't remove)
        Console.WriteLine(queue.Dequeue());    // Alice (remove)
        Console.WriteLine(queue.Count);        // 2

        // ─── STACK<T> ───
        var stack = new Stack<int>();
        stack.Push(1);
        stack.Push(2);
        stack.Push(3);

        Console.WriteLine(stack.Peek());   // 3 (top, don't remove)
        Console.WriteLine(stack.Pop());    // 3 (remove top)
        Console.WriteLine(stack.Count);    // 2

        // ─── COLLECTION INITIALIZERS ───
        var dict2 = new Dictionary<int, string>
        {
            [1] = "one",
            [2] = "two",
            [3] = "three"
        };
    }
}

─────────────────────────────────────
CHOOSING THE RIGHT COLLECTION:
─────────────────────────────────────
Need index access?          → List<T>
Need key-value lookup?      → Dictionary<K,V>
Need uniqueness?            → HashSet<T>
Need sorted keys?           → SortedDictionary<K,V>
Need FIFO processing?       → Queue<T>
Need LIFO / undo?           → Stack<T>
Need fast insert in middle? → LinkedList<T>
─────────────────────────────────────

📝 KEY POINTS:
✅ Always use generic collections — never ArrayList or Hashtable
✅ TryGetValue is safer than indexing a Dictionary directly
✅ HashSet is the fastest way to check "does this value exist?"
✅ Dictionary throws KeyNotFoundException for missing keys — use TryGetValue
✅ List.Sort() sorts in place; use LINQ .OrderBy() for a new sorted list
❌ Don't use List when you need uniqueness — use HashSet
❌ Don't iterate a collection while modifying it — use a copy or LINQ
''',
  quiz: [
    Quiz(question: 'What happens if you try to add a duplicate to a HashSet<T>?', options: [
      QuizOption(text: 'The duplicate is silently ignored — the set stays unchanged', correct: true),
      QuizOption(text: 'An exception is thrown', correct: false),
      QuizOption(text: 'The old value is replaced', correct: false),
      QuizOption(text: 'The set grows to hold both copies', correct: false),
    ]),
    Quiz(question: 'Why should you use TryGetValue instead of [] when reading from a Dictionary?', options: [
      QuizOption(text: '[] throws KeyNotFoundException if the key is missing; TryGetValue returns false safely', correct: true),
      QuizOption(text: 'TryGetValue is faster than [] for all lookups', correct: false),
      QuizOption(text: '[] only works for string keys', correct: false),
      QuizOption(text: 'TryGetValue works on non-generic collections too', correct: false),
    ]),
    Quiz(question: 'Which collection processes items in First-In-First-Out order?', options: [
      QuizOption(text: 'Queue<T>', correct: true),
      QuizOption(text: 'Stack<T>', correct: false),
      QuizOption(text: 'LinkedList<T>', correct: false),
      QuizOption(text: 'SortedSet<T>', correct: false),
    ]),
  ],
);
