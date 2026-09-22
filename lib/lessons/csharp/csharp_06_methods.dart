// lib/lessons/csharp/csharp_06_methods.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson06 = Lesson(
  language: 'C#',
  title: 'Methods',
  content: '''
🎯 METAPHOR:
A method is like a named recipe card.
You write the recipe once: "How to make a sandwich —
take bread, add filling, close it up." Then anytime
someone is hungry (anywhere in the code), they just say
"make me a sandwich" instead of re-explaining every step.
The recipe card (method) handles the details. The caller
just names what they want and optionally hands over
ingredients (parameters).

📖 EXPLANATION:
In C#, all code must live inside a class, and executable
code lives inside methods. Methods define reusable behavior.

ANATOMY OF A METHOD:
  accessModifier returnType MethodName(parameters)
  {
      // body
      return value;  // if not void
  }

C# ACCESS MODIFIERS:
  public     — accessible from anywhere
  private    — only within this class (default)
  protected  — this class + subclasses
  internal   — this assembly (project)

C# SPECIAL METHOD FEATURES:
  Optional parameters (default values)
  Named arguments
  params (variable number of arguments)
  out / ref parameters
  Expression-bodied methods (=>)

💻 CODE:
using System;

class Program
{
    // Basic method
    static void Greet(string name)
    {
        Console.WriteLine(\$"Hello, {name}!");
    }

    // Return value
    static int Add(int a, int b)
    {
        return a + b;
    }

    // Expression-bodied (C# 6+) — for simple one-liners
    static int Square(int x) => x * x;
    static string Shout(string s) => s.ToUpper() + "!";

    // Optional parameters (must come last)
    static void CreateUser(string name, int age = 18, bool isAdmin = false)
    {
        Console.WriteLine(\$"{name}, age {age}, admin: {isAdmin}");
    }

    // Named arguments — caller specifies which parameter
    static void DrawRect(int width, int height, string color = "black")
    {
        Console.WriteLine(\$"Drawing {width}x{height} in {color}");
    }

    // params — variable argument count
    static int Sum(params int[] numbers)
    {
        int total = 0;
        foreach (int n in numbers) total += n;
        return total;
    }

    // out parameter — return multiple values
    static bool Divide(int a, int b, out double result)
    {
        if (b == 0) { result = 0; return false; }
        result = (double)a / b;
        return true;
    }

    // ref parameter — modify caller's variable
    static void Double(ref int value)
    {
        value *= 2;
    }

    // Method overloading
    static double Area(double radius) => Math.PI * radius * radius;
    static double Area(double width, double height) => width * height;

    static void Main()
    {
        Greet("Alice");                   // Hello, Alice!
        Console.WriteLine(Add(3, 4));     // 7
        Console.WriteLine(Square(5));     // 25
        Console.WriteLine(Shout("hello")); // HELLO!

        // Optional params
        CreateUser("Alice");               // Alice, age 18, admin: False
        CreateUser("Bob", 25);             // Bob, age 25, admin: False
        CreateUser("Charlie", 30, true);   // Charlie, age 30, admin: True

        // Named arguments — any order, skip optional ones
        DrawRect(width: 100, height: 50);
        DrawRect(height: 200, width: 300, color: "red");

        // params
        Console.WriteLine(Sum(1, 2, 3));          // 6
        Console.WriteLine(Sum(10, 20, 30, 40));   // 100

        // out parameter
        if (Divide(10, 3, out double quotient))
            Console.WriteLine(\$"Result: {quotient:F2}");  // 3.33

        // ref parameter
        int x = 10;
        Double(ref x);
        Console.WriteLine(x);  // 20

        // Overloading
        Console.WriteLine(Area(5.0));        // circle: 78.54
        Console.WriteLine(Area(4.0, 6.0));   // rectangle: 24
    }
}

─────────────────────────────────────
EXPRESSION-BODIED MEMBERS:
─────────────────────────────────────
static int Add(int a, int b) => a + b;
static string Name => "Alice";       // property
static void Print() => Console.WriteLine("hi");
─────────────────────────────────────

📝 KEY POINTS:
✅ Expression-bodied methods => are clean for simple one-liners
✅ Named arguments make call sites self-documenting
✅ params lets methods accept any number of arguments
✅ out is for returning multiple values (like TryParse)
✅ ref passes by reference — both caller and method see the same variable
❌ Optional parameters must come after required ones
❌ Don't overuse ref — it makes code harder to reason about
''',
  quiz: [
    Quiz(question: 'What does the "params" keyword allow?', options: [
      QuizOption(text: 'A method to accept a variable number of arguments of the same type', correct: true),
      QuizOption(text: 'A method to accept parameters in any order', correct: false),
      QuizOption(text: 'A method to return multiple values', correct: false),
      QuizOption(text: 'A method to skip optional parameters', correct: false),
    ]),
    Quiz(question: 'What is the difference between "ref" and "out" parameters?', options: [
      QuizOption(text: 'ref requires the variable to be initialized before calling; out does not', correct: true),
      QuizOption(text: 'out requires initialization; ref does not', correct: false),
      QuizOption(text: 'They are identical', correct: false),
      QuizOption(text: 'ref is read-only; out allows writing', correct: false),
    ]),
    Quiz(question: 'What does an expression-bodied method use instead of { return ... }?', options: [
      QuizOption(text: 'The => fat arrow operator', correct: true),
      QuizOption(text: 'The -> arrow operator', correct: false),
      QuizOption(text: 'A colon :', correct: false),
      QuizOption(text: 'The :: scope operator', correct: false),
    ]),
  ],
);
