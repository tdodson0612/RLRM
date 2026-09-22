// lib/lessons/csharp/csharp_46_arrays.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson46 = Lesson(
  language: 'C#',
  title: 'Arrays In Depth',
  content: '''
🎯 METAPHOR:
A one-dimensional array is a row of numbered lockers.
A multidimensional array is a grid of lockers — rows and
columns, like a spreadsheet. Locker [2,3] is row 2, column 3.
A jagged array is a building where each floor has a
DIFFERENT number of lockers. Floor 0 has 3 lockers,
floor 1 has 5, floor 2 has 2. Each floor is its own
separate row. More flexible but more complex to navigate.

📖 EXPLANATION:
C# arrays come in three flavors:

1. Single-dimensional: int[] arr = new int[5]
2. Multidimensional (rectangular): int[,] grid = new int[3,4]
3. Jagged: int[][] jagged = new int[3][]

KEY DIFFERENCES:
  Multidimensional — true single block of memory, rectangular
  Jagged — array of arrays, each row independent size

Array class provides static helpers: Sort, Copy, Find, etc.
Arrays implement IEnumerable<T> — LINQ works on them.
All arrays are reference types — default null until initialized.

💻 CODE:
using System;
using System.Linq;

class Program
{
    static void Main()
    {
        // ─── SINGLE-DIMENSIONAL ───
        int[] nums = new int[5];         // all zeros
        int[] init = { 1, 2, 3, 4, 5 }; // initialized
        int[] also = new int[] { 1, 2, 3 };
        int[] c12  = [1, 2, 3];          // C# 12 collection expression

        Console.WriteLine(init[0]);      // 1
        Console.WriteLine(init[^1]);     // 5 (last, C# 8+)
        Console.WriteLine(init[1..4]);   // System.Int32[] (slice)
        Console.WriteLine(string.Join(",", init[1..4]));  // 2,3,4

        Console.WriteLine(init.Length);  // 5
        Console.WriteLine(init.Rank);    // 1 (dimensions)

        // ─── ARRAY METHODS ───
        Array.Sort(init);
        Array.Reverse(init);
        Console.WriteLine(string.Join(",", init));  // 5,4,3,2,1

        int idx = Array.IndexOf(init, 3);  // 2 (index of value 3)
        Console.WriteLine(idx);

        int[] copy = new int[5];
        Array.Copy(init, copy, 5);

        int[] found = Array.FindAll(init, x => x > 2);
        Console.WriteLine(string.Join(",", found));  // 5,4,3

        // ─── MULTIDIMENSIONAL (rectangular) ───
        int[,] grid = new int[3, 3];
        grid[0, 0] = 1;
        grid[1, 1] = 5;
        grid[2, 2] = 9;

        // Initialize with values
        int[,] matrix = {
            { 1, 2, 3 },
            { 4, 5, 6 },
            { 7, 8, 9 }
        };

        Console.WriteLine(matrix[1, 2]);     // 6
        Console.WriteLine(matrix.GetLength(0)); // 3 (rows)
        Console.WriteLine(matrix.GetLength(1)); // 3 (cols)
        Console.WriteLine(matrix.Rank);         // 2

        // Iterate multidimensional
        for (int r = 0; r < matrix.GetLength(0); r++)
        {
            for (int c = 0; c < matrix.GetLength(1); c++)
                Console.Write(matrix[r, c] + " ");
            Console.WriteLine();
        }

        // ─── JAGGED ARRAY ───
        int[][] jagged = new int[3][];   // 3 rows, each uninitialized
        jagged[0] = new int[] { 1, 2, 3 };
        jagged[1] = new int[] { 4, 5 };        // different length!
        jagged[2] = new int[] { 6, 7, 8, 9 };

        Console.WriteLine(jagged[0][2]);  // 3
        Console.WriteLine(jagged[1][0]);  // 4
        Console.WriteLine(jagged[2].Length); // 4

        // Initialize jagged with initializer
        int[][] jag2 =
        {
            new[] { 1, 2 },
            new[] { 3, 4, 5 },
            new[] { 6 }
        };

        // Iterate jagged
        foreach (int[] row in jag2)
        {
            foreach (int n in row)
                Console.Write(n + " ");
            Console.WriteLine();
        }

        // ─── LINQ ON ARRAYS ───
        int[] data = { 5, 3, 8, 1, 9, 2, 7 };
        var sorted = data.OrderBy(x => x).ToArray();
        var evens  = data.Where(x => x % 2 == 0).ToArray();
        int max    = data.Max();
        double avg = data.Average();

        Console.WriteLine(string.Join(",", sorted)); // 1,2,3,5,7,8,9
        Console.WriteLine(max);   // 9
        Console.WriteLine(avg);   // ~5

        // ─── MULTI-DIMENSIONAL vs JAGGED PERFORMANCE ───
        // Multidimensional: single contiguous block → cache-friendly
        // Jagged: separate heap allocations per row → more flexible, less cache-friendly

        // ─── ARRAY COVARIANCE (dangerous!) ───
        string[] strings = { "hello", "world" };
        object[] objects = strings;   // array covariance — works but DANGEROUS
        // objects[0] = 42;  // ArrayTypeMismatchException at runtime!
    }
}

─────────────────────────────────────
int[] vs int[,] vs int[][]:
─────────────────────────────────────
int[]     1D, most common
int[,]    rectangular 2D grid, single allocation
int[][]   jagged, each row independent, different lengths
int[,,]   3D rectangular (rare)

Access:
  1D:   arr[i]
  2D:   arr[i, j]
  Jag:  arr[i][j]
─────────────────────────────────────

📝 KEY POINTS:
✅ Use int[] for simple sequences — most common array type
✅ Use int[,] for true matrices where all rows have the same length
✅ Use int[][] for jagged data where rows vary in length
✅ Array.Sort, Array.Copy, Array.Find are static helpers on the Array class
✅ C# 8+ index-from-end (^1) and ranges (1..4) work on arrays
❌ Array covariance (object[] = string[]) compiles but throws at runtime on write
❌ Arrays are fixed-size — use List<T> when you need to grow
''',
  quiz: [
    Quiz(question: 'What is the difference between int[,] and int[][]?', options: [
      QuizOption(text: 'int[,] is rectangular with equal-length rows; int[][] is jagged with variable-length rows', correct: true),
      QuizOption(text: 'int[,] is jagged; int[][] is rectangular', correct: false),
      QuizOption(text: 'They are identical — just different syntax', correct: false),
      QuizOption(text: 'int[,] stores doubles; int[][] stores integers', correct: false),
    ]),
    Quiz(question: 'What does init[^1] return for an array?', options: [
      QuizOption(text: 'The last element of the array', correct: true),
      QuizOption(text: 'The element at index -1 (wraps around)', correct: false),
      QuizOption(text: 'A compile error — negative indices are invalid', correct: false),
      QuizOption(text: 'The length of the array minus 1', correct: false),
    ]),
    Quiz(question: 'What is array covariance and why is it dangerous?', options: [
      QuizOption(text: 'Assigning string[] to object[] compiles but throws at runtime when writing wrong types', correct: true),
      QuizOption(text: 'Arrays automatically grow when elements are added', correct: false),
      QuizOption(text: 'Multidimensional arrays can be used as jagged arrays', correct: false),
      QuizOption(text: 'Array indices wrap around when they exceed the length', correct: false),
    ]),
  ],
);
