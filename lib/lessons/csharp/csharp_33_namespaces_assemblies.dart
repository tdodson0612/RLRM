// lib/lessons/csharp/csharp_33_namespaces_assemblies.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson33 = Lesson(
  language: 'C#',
  title: 'Namespaces, Assemblies, and Access Modifiers',
  content: '''
🎯 METAPHOR:
Namespaces are like city districts.
"Baker Street" means one thing in London, another in New York.
The city (namespace) clarifies which Baker Street you mean.
System.Console vs MyApp.Console — the namespace prevents
confusion when two things have the same name.

Assemblies are like shipping containers.
A .dll or .exe file is a sealed container of compiled code.
You can load another team's container into your project
(add a reference or NuGet package) and use what is inside.
The container boundary is the deployment unit.

Access modifiers are building security levels.
public: open to the street — anyone can walk in.
internal: office-building keycard — same company only.
private: executive suite — this floor only.
protected: family members — you and your children only.

📖 EXPLANATION:
NAMESPACES — logical grouping of related types.
  Prevent naming collisions.
  Organize large codebases.
  Mirror folder structure (convention, not required).

ASSEMBLIES — physical compilation unit (.dll / .exe).
  A project compiles to one assembly.
  NuGet packages are assemblies.
  Access modifiers control visibility across assemblies.

ACCESS MODIFIERS:
  public            — anyone, anywhere
  private           — same class only (default for members)
  protected         — same class + derived classes
  internal          — same assembly only (default for types)
  protected internal — same assembly OR derived classes
  private protected  — same class + derived classes in same assembly
  file              — same file only (C# 11)

💻 CODE:
// ─── NAMESPACES ───
namespace MyApp.Models
{
    public class User
    {
        public string Name { get; set; }
        public string Email { get; set; }
    }
}

namespace MyApp.Services
{
    using MyApp.Models;  // import namespace

    public class UserService
    {
        public User CreateUser(string name, string email)
            => new User { Name = name, Email = email };
    }
}

// ─── FILE-SCOPED NAMESPACES (C# 10+) ───
// Apply to entire file — no braces needed:
// namespace MyApp.Controllers;   ← at top of file, no { }

// ─── GLOBAL USING (C# 10+) ───
// In a dedicated file (e.g., GlobalUsings.cs):
// global using System;
// global using System.Collections.Generic;
// global using System.Linq;
// Now available in ALL files in the project

// ─── ACCESS MODIFIERS ───
namespace AccessDemo
{
    // internal class — visible only within this assembly
    internal class InternalHelper
    {
        // private — only accessible in this class
        private int _value = 0;

        // public — accessible from anywhere
        public int Value => _value;

        // internal — accessible anywhere in this assembly
        internal void Reset() => _value = 0;
    }

    public class BankAccount
    {
        // private fields
        private decimal _balance;
        private string _owner;

        // public properties
        public string Owner => _owner;

        // protected — subclasses can access
        protected decimal Balance
        {
            get => _balance;
            set => _balance = value >= 0 ? value : throw new ArgumentException("Negative balance");
        }

        public BankAccount(string owner, decimal initial)
        {
            _owner = owner;
            _balance = initial;
        }

        // public method
        public virtual void Deposit(decimal amount)
        {
            Balance += amount;
        }
    }

    public class SavingsAccount : BankAccount
    {
        private decimal _interestRate;

        public SavingsAccount(string owner, decimal initial, decimal rate)
            : base(owner, initial)
        {
            _interestRate = rate;
        }

        public void ApplyInterest()
        {
            Balance += Balance * _interestRate;  // can access protected Balance!
        }
    }
}

using System;

class Program
{
    static void Main()
    {
        // ─── NAMESPACE USAGE ───
        var user = new MyApp.Models.User { Name = "Alice", Email = "alice@example.com" };
        Console.WriteLine(user.Name);

        // Using directive avoids long names
        var service = new MyApp.Services.UserService();
        var u2 = service.CreateUser("Bob", "bob@example.com");

        // ─── ACCESS MODIFIER DEMONSTRATION ───
        var account = new AccessDemo.BankAccount("Alice", 1000m);
        account.Deposit(500m);
        Console.WriteLine(account.Owner);    // Alice
        // account.Balance = 100m;  // ERROR: protected — can't access from here
        // account._balance = 100m; // ERROR: private

        var savings = new AccessDemo.SavingsAccount("Bob", 1000m, 0.05m);
        savings.ApplyInterest();  // accesses protected Balance internally

        // ─── TYPEOF AND ASSEMBLY INFO ───
        Type t = typeof(string);
        Console.WriteLine(t.Assembly.FullName);   // mscorlib or System.Private.CoreLib
        Console.WriteLine(t.Namespace);            // System
        Console.WriteLine(t.FullName);             // System.String

        // Runtime assembly info
        var assembly = System.Reflection.Assembly.GetExecutingAssembly();
        Console.WriteLine(assembly.GetName().Name);  // your project name
    }
}

─────────────────────────────────────
ACCESS MODIFIER CHEAT SHEET:
─────────────────────────────────────
Modifier           Same class  Same assembly  Derived  Anywhere
private              ✅          ❌             ❌        ❌
private protected    ✅          ❌             ✅*       ❌
internal             ✅          ✅             ❌        ❌
protected            ✅          ❌             ✅        ❌
protected internal   ✅          ✅             ✅        ❌
public               ✅          ✅             ✅        ✅
* only derived classes in same assembly
─────────────────────────────────────

📝 KEY POINTS:
✅ File-scoped namespaces (C# 10) eliminate one level of indentation
✅ Global usings (C# 10) reduce boilerplate across the project
✅ internal is the default for types — not visible outside the assembly
✅ private is the default for class members — not visible outside the class
✅ Use the most restrictive access level that still works — principle of least privilege
❌ Don't make everything public — it creates fragile public APIs
❌ Namespace doesn't have to match folder structure — but should by convention
''',
  quiz: [
    Quiz(question: 'What is the default access modifier for a class member in C#?', options: [
      QuizOption(text: 'private', correct: true),
      QuizOption(text: 'internal', correct: false),
      QuizOption(text: 'public', correct: false),
      QuizOption(text: 'protected', correct: false),
    ]),
    Quiz(question: 'What does the "internal" access modifier mean?', options: [
      QuizOption(text: 'Accessible anywhere within the same assembly (project)', correct: true),
      QuizOption(text: 'Accessible only within the same class', correct: false),
      QuizOption(text: 'Accessible from anywhere including other assemblies', correct: false),
      QuizOption(text: 'Accessible from derived classes only', correct: false),
    ]),
    Quiz(question: 'What does a file-scoped namespace declaration look like in C# 10+?', options: [
      QuizOption(text: 'namespace MyApp.Models; at the top of the file with no braces', correct: true),
      QuizOption(text: 'namespace MyApp.Models { } wrapping the entire file', correct: false),
      QuizOption(text: 'using namespace MyApp.Models;', correct: false),
      QuizOption(text: '#namespace MyApp.Models', correct: false),
    ]),
  ],
);
