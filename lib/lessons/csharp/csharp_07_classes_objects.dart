// lib/lessons/csharp/csharp_07_classes_objects.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson07 = Lesson(
  language: 'C#',
  title: 'Classes and Objects',
  content: '''
🎯 METAPHOR:
A class is a cookie cutter. An object is the cookie.
The cutter defines the shape — what fields exist, what
actions are possible. Each cookie made from it is its own
thing — it has the same structure but its own frosting
(field values). You can make a thousand cookies from one
cutter. In C#: one class, many objects. Each object is
independent but built on the same blueprint.

📖 EXPLANATION:
C# is a fully object-oriented language. Almost everything
is organized into classes. A class defines:
  - Fields     — data the object holds (state)
  - Properties — controlled access to fields
  - Methods    — actions the object can perform
  - Constructors — how to create the object

PROPERTIES vs FIELDS:
Fields are raw data. Properties are gateways — they can
have validation, computed values, and access control.
In C# you almost always use properties, not public fields.

AUTO-PROPERTIES: C# generates the backing field for you.
  public string Name { get; set; }

💻 CODE:
using System;

class BankAccount
{
    // ─── FIELDS (private — internal state) ───
    private string _owner;
    private decimal _balance;
    private static int _accountCount = 0;  // shared across all instances

    // ─── PROPERTIES ───
    // Auto-property — compiler generates backing field
    public string AccountNumber { get; private set; }

    // Full property with validation
    public decimal Balance
    {
        get => _balance;
        private set
        {
            if (value < 0)
                throw new ArgumentException("Balance cannot be negative");
            _balance = value;
        }
    }

    // Computed property — no setter, calculated from other data
    public bool IsRich => _balance > 1_000_000;

    // Read-only auto property
    public string Owner => _owner;

    // ─── CONSTRUCTORS ───
    public BankAccount(string owner, decimal initialDeposit = 0)
    {
        _owner = owner;
        _balance = initialDeposit;
        _accountCount++;
        AccountNumber = \$"ACC-{_accountCount:D4}";
    }

    // ─── METHODS ───
    public void Deposit(decimal amount)
    {
        if (amount <= 0) throw new ArgumentException("Amount must be positive");
        Balance += amount;
        Console.WriteLine(\$"Deposited {amount:C}. New balance: {Balance:C}");
    }

    public bool Withdraw(decimal amount)
    {
        if (amount > _balance)
        {
            Console.WriteLine("Insufficient funds!");
            return false;
        }
        Balance -= amount;
        Console.WriteLine(\$"Withdrew {amount:C}. New balance: {Balance:C}");
        return true;
    }

    // Override ToString() for readable output
    public override string ToString()
    {
        return \$"Account {AccountNumber} ({_owner}): {Balance:C}";
    }

    // Static method — belongs to class, not instance
    public static int GetTotalAccounts() => _accountCount;
}

class Program
{
    static void Main()
    {
        // Create objects
        var account1 = new BankAccount("Alice", 1000m);
        var account2 = new BankAccount("Bob");

        account1.Deposit(500m);
        account1.Withdraw(200m);

        Console.WriteLine(account1);  // Account ACC-0001 (Alice): $1,300.00
        Console.WriteLine(account2);  // Account ACC-0002 (Bob): $0.00

        Console.WriteLine(\$"Total accounts: {BankAccount.GetTotalAccounts()}");  // 2

        // Properties
        Console.WriteLine(account1.Balance);    // 1300
        Console.WriteLine(account1.IsRich);     // False
        // account1.Balance = -100;  // ERROR: private setter

        // Object initializer syntax
        // (only works with public settable properties)
        // var p = new Point { X = 1, Y = 2 };
    }
}

─────────────────────────────────────
PROPERTY VARIATIONS:
─────────────────────────────────────
public string Name { get; set; }           full read/write
public string Name { get; private set; }   write only inside class
public string Name { get; init; }          set only at construction (C# 9)
public string Name { get; }                read only (set in constructor)
public string Name => _name;               computed (expression-bodied)
─────────────────────────────────────

📝 KEY POINTS:
✅ Use properties over public fields — they allow validation and encapsulation
✅ Auto-properties ({ get; set; }) are the most common pattern
✅ init-only properties (C# 9) allow setting in object initializers but not later
✅ Override ToString() to make objects print readably
✅ Static members belong to the class; instance members belong to each object
❌ Don't expose public fields directly — use properties
❌ Don't put complex logic in property getters — it should feel like simple access
''',
  quiz: [
    Quiz(question: 'What is the difference between a field and a property in C#?', options: [
      QuizOption(text: 'Properties provide controlled access with get/set logic; fields are raw storage', correct: true),
      QuizOption(text: 'Fields are public; properties are private', correct: false),
      QuizOption(text: 'Properties store data; fields compute values', correct: false),
      QuizOption(text: 'They are identical — just different naming conventions', correct: false),
    ]),
    Quiz(question: 'What does { get; private set; } on a property mean?', options: [
      QuizOption(text: 'Anyone can read it, but only code inside the class can set it', correct: true),
      QuizOption(text: 'Only the class can read or write it', correct: false),
      QuizOption(text: 'It can only be set once in the constructor', correct: false),
      QuizOption(text: 'The property is read-only everywhere', correct: false),
    ]),
    Quiz(question: 'What does overriding ToString() in a class do?', options: [
      QuizOption(text: 'Controls how the object is displayed when converted to a string or printed', correct: true),
      QuizOption(text: 'Converts the class to a string class', correct: false),
      QuizOption(text: 'Prevents the object from being null', correct: false),
      QuizOption(text: 'Makes all properties readable as strings', correct: false),
    ]),
  ],
);
