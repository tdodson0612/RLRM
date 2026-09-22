// lib/lessons/csharp/csharp_44_expression_trees.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson44 = Lesson(
  language: 'C#',
  title: 'Expression Trees',
  content: '''
🎯 METAPHOR:
A regular lambda is like a baked cake — you get the result,
but you can't see the recipe anymore. An expression tree
is like having the recipe written out as a tree diagram:
"Take flour AND eggs, COMBINE them, THEN ADD sugar."
You can READ the structure, ANALYZE it, MODIFY it,
and COMPILE it to different output — like translating
that recipe into French or into a cooking robot's instructions.
This is exactly how Entity Framework translates C# LINQ
queries into SQL: it reads your lambda as an expression
tree and translates each node into SQL syntax.

📖 EXPLANATION:
An Expression<Func<T, TResult>> stores code as a DATA
STRUCTURE (a tree of nodes) rather than compiled IL.

Expression trees let you:
  - Inspect what a lambda does (node by node)
  - Translate lambdas to other languages (SQL, NoSQL queries)
  - Build queries dynamically at runtime
  - Implement custom query providers (like LINQ to SQL)

KEY EXPRESSION NODE TYPES:
  ConstantExpression     literal value
  ParameterExpression    a parameter (x in x => x + 1)
  BinaryExpression       +, -, *, ==, &&, etc.
  UnaryExpression        !, -, Convert
  MemberExpression       x.Name, x.Age
  MethodCallExpression   x.ToUpper(), Math.Abs(x)
  LambdaExpression       the whole lambda

💻 CODE:
using System;
using System.Linq.Expressions;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

class Program
{
    static void Main()
    {
        // ─── LAMBDA vs EXPRESSION ───
        // Lambda — compiled to IL, just a delegate
        Func<int, int> func = x => x * 2;
        Console.WriteLine(func(5));   // 10

        // Expression tree — stored as data, can be inspected
        Expression<Func<int, int>> expr = x => x * 2;

        // Inspect the tree
        Console.WriteLine(expr);              // x => (x * 2)
        Console.WriteLine(expr.NodeType);     // Lambda
        Console.WriteLine(expr.Body);         // (x * 2)
        Console.WriteLine(expr.Body.NodeType); // Multiply

        var binary = (BinaryExpression)expr.Body;
        Console.WriteLine(binary.Left);       // x
        Console.WriteLine(binary.Right);      // 2

        // Compile and run
        Func<int, int> compiled = expr.Compile();
        Console.WriteLine(compiled(5));       // 10

        // ─── BUILDING EXPRESSIONS MANUALLY ───
        // Build: x => x > 5 && x < 10
        ParameterExpression param = Expression.Parameter(typeof(int), "x");

        BinaryExpression greaterThan5 = Expression.GreaterThan(
            param,
            Expression.Constant(5)
        );
        BinaryExpression lessThan10 = Expression.LessThan(
            param,
            Expression.Constant(10)
        );
        BinaryExpression andCondition = Expression.AndAlso(greaterThan5, lessThan10);

        var lambda = Expression.Lambda<Func<int, bool>>(andCondition, param);
        Console.WriteLine(lambda);  // x => ((x > 5) AndAlso (x < 10))

        Func<int, bool> isBetween5And10 = lambda.Compile();
        Console.WriteLine(isBetween5And10(7));   // True
        Console.WriteLine(isBetween5And10(3));   // False

        // ─── DYNAMIC FILTER BUILDER ───
        var people = new List<Person>
        {
            new("Alice", 30), new("Bob", 17), new("Charlie", 25), new("Diana", 15)
        };

        // Build filter dynamically: Age > minAge
        int minAge = 18;
        var filter = BuildGreaterThanFilter<Person>(p => p.Age, minAge);
        var adults = people.AsQueryable().Where(filter).ToList();
        Console.WriteLine(string.Join(", ", adults.Select(p => p.Name)));
        // Alice, Charlie

        // ─── READING MEMBER EXPRESSIONS (used in ORMs) ───
        Expression<Func<Person, string>> nameExpr = p => p.Name;
        var memberExpr = (MemberExpression)nameExpr.Body;
        Console.WriteLine(memberExpr.Member.Name);  // "Name" — the property name as string!
        // This is how EF Core knows which column you're referring to

        // ─── VISITOR PATTERN ───
        var visitor = new ExpressionPrinter();
        visitor.Visit(expr);  // prints tree structure
    }

    // Build Expression<Func<T, bool>> dynamically
    static Expression<Func<T, bool>> BuildGreaterThanFilter<T>(
        Expression<Func<T, int>> propertySelector,
        int threshold)
    {
        var param = propertySelector.Parameters[0];
        var body = Expression.GreaterThan(
            propertySelector.Body,
            Expression.Constant(threshold)
        );
        return Expression.Lambda<Func<T, bool>>(body, param);
    }
}

record Person(string Name, int Age);

// ─── EXPRESSION VISITOR ───
class ExpressionPrinter : ExpressionVisitor
{
    protected override Expression VisitBinary(BinaryExpression node)
    {
        Console.WriteLine(\$"Binary: {node.NodeType}");
        return base.VisitBinary(node);
    }

    protected override Expression VisitParameter(ParameterExpression node)
    {
        Console.WriteLine(\$"Parameter: {node.Name} ({node.Type.Name})");
        return base.VisitParameter(node);
    }

    protected override Expression VisitConstant(ConstantExpression node)
    {
        Console.WriteLine(\$"Constant: {node.Value}");
        return base.VisitConstant(node);
    }
}

─────────────────────────────────────
WHERE EXPRESSION TREES ARE USED:
─────────────────────────────────────
Entity Framework Core   → translates LINQ to SQL
LINQ to XML/Objects     → query providers
AutoMapper              → mapping configuration
Moq (testing)           → setup expressions
Dynamic query builders  → filter/sort at runtime
─────────────────────────────────────

📝 KEY POINTS:
✅ Expression<Func<T>> stores code as data — can be analyzed and translated
✅ Call .Compile() to turn an expression tree into an executable delegate
✅ MemberExpression lets you extract property names as strings (type-safe)
✅ ExpressionVisitor is the correct way to traverse and transform expression trees
✅ This is the foundation of how EF Core translates LINQ to SQL
❌ Don't use expression trees for simple lambda use — just use Func<T>
❌ Expression tree compilation is slow — cache compiled delegates
''',
  quiz: [
    Quiz(question: 'What is the main difference between Func<T> and Expression<Func<T>>?', options: [
      QuizOption(text: 'Func<T> is compiled code; Expression<Func<T>> stores the code as a data structure', correct: true),
      QuizOption(text: 'Expression<Func<T>> runs faster than Func<T>', correct: false),
      QuizOption(text: 'Func<T> stores code as data; Expression<Func<T>> is compiled', correct: false),
      QuizOption(text: 'They are identical — just different syntax', correct: false),
    ]),
    Quiz(question: 'How does Entity Framework use expression trees?', options: [
      QuizOption(text: 'It reads the expression tree and translates each node into SQL syntax', correct: true),
      QuizOption(text: 'It compiles the expression and runs it in-memory', correct: false),
      QuizOption(text: 'It serializes the expression to JSON for the database', correct: false),
      QuizOption(text: 'It uses reflection to find matching SQL stored procedures', correct: false),
    ]),
    Quiz(question: 'What does calling .Compile() on an expression tree do?', options: [
      QuizOption(text: 'Converts the expression tree into an executable delegate', correct: true),
      QuizOption(text: 'Validates the expression for correctness', correct: false),
      QuizOption(text: 'Translates the expression to SQL', correct: false),
      QuizOption(text: 'Optimizes the expression for faster execution', correct: false),
    ]),
  ],
);
