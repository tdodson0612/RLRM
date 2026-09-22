// lib/lessons/csharp/csharp_15_exception_handling.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson15 = Lesson(
  language: 'C#',
  title: 'Exception Handling',
  content: '''
🎯 METAPHOR:
Exception handling is like having a safety inspector on
a construction site. The workers (your code) do their jobs.
If someone drops a beam (an error occurs), the inspector
(catch block) catches the problem, assesses the damage,
files a report (logs it), and either fixes it or escalates.
The finally block is the cleanup crew — they clean up the
site NO MATTER WHAT, whether the beam dropped or not.
Work always leaves a clean site behind.

📖 EXPLANATION:
Exceptions in C# are objects that represent errors.
When something goes wrong, code "throws" an exception.
If nothing catches it, the program crashes.

HIERARCHY:
  Exception (base)
    ├── SystemException
    │   ├── NullReferenceException
    │   ├── IndexOutOfRangeException
    │   ├── InvalidCastException
    │   ├── OverflowException
    │   └── DivideByZeroException
    └── ApplicationException (user-defined)
        └── Your custom exceptions

try  — code that might throw
catch — handle the exception
finally — always runs (cleanup)
throw — throw an exception
when — filter catch blocks by condition

💻 CODE:
using System;
using System.IO;

// ─── CUSTOM EXCEPTION ───
class InsufficientFundsException : Exception
{
    public decimal Amount { get; }
    public decimal Balance { get; }

    public InsufficientFundsException(decimal amount, decimal balance)
        : base(\$"Cannot withdraw {amount:C}. Balance is only {balance:C}.")
    {
        Amount = amount;
        Balance = balance;
    }
}

class BankAccount
{
    private decimal _balance;

    public BankAccount(decimal initial) => _balance = initial;

    public void Withdraw(decimal amount)
    {
        if (amount <= 0)
            throw new ArgumentException("Amount must be positive", nameof(amount));

        if (amount > _balance)
            throw new InsufficientFundsException(amount, _balance);

        _balance -= amount;
    }
}

class Program
{
    static void Main()
    {
        // ─── BASIC TRY/CATCH/FINALLY ───
        try
        {
            int[] arr = { 1, 2, 3 };
            Console.WriteLine(arr[10]);  // throws IndexOutOfRangeException
        }
        catch (IndexOutOfRangeException ex)
        {
            Console.WriteLine(\$"Array error: {ex.Message}");
        }
        finally
        {
            Console.WriteLine("Finally always runs!");
        }

        // ─── MULTIPLE CATCH BLOCKS ───
        try
        {
            string text = null;
            Console.WriteLine(text.Length);  // NullReferenceException
        }
        catch (NullReferenceException ex)
        {
            Console.WriteLine(\$"Null reference: {ex.Message}");
        }
        catch (Exception ex)  // catch-all — MUST be last
        {
            Console.WriteLine(\$"General error: {ex.Message}");
        }

        // ─── CUSTOM EXCEPTION ───
        var account = new BankAccount(100m);
        try
        {
            account.Withdraw(200m);
        }
        catch (InsufficientFundsException ex)
        {
            Console.WriteLine(ex.Message);
            Console.WriteLine(\$"Tried: {ex.Amount:C}, Had: {ex.Balance:C}");
        }

        // ─── WHEN CLAUSE (exception filter) ───
        for (int i = 0; i < 3; i++)
        {
            try
            {
                if (i == 1) throw new Exception("Special error");
                if (i == 2) throw new Exception("Other error");
            }
            catch (Exception ex) when (ex.Message.Contains("Special"))
            {
                Console.WriteLine("Caught special error only");
            }
            // Other exceptions propagate normally
        }

        // ─── RETHROWING ───
        try
        {
            try
            {
                throw new InvalidOperationException("Inner");
            }
            catch (InvalidOperationException ex)
            {
                Console.WriteLine("Logging inner exception...");
                throw;  // rethrow preserving original stack trace
                // throw ex;  // BAD: resets stack trace!
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(\$"Caught outer: {ex.Message}");
        }

        // ─── USING (IDisposable — auto cleanup) ───
        // using ensures Dispose() is called even if exception occurs
        try
        {
            using var reader = new StringReader("Hello World");
            string line = reader.ReadLine();
            Console.WriteLine(line);
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
        // reader.Dispose() called automatically here

        // ─── EXCEPTION PROPERTIES ───
        try
        {
            throw new Exception("Test", new Exception("Inner cause"));
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);           // Test
            Console.WriteLine(ex.InnerException?.Message); // Inner cause
            Console.WriteLine(ex.StackTrace?[..50]); // partial stack trace
        }
    }
}

📝 KEY POINTS:
✅ Catch specific exceptions first, general Exception last
✅ Use finally for cleanup — always runs even if an exception occurs
✅ Use "throw;" (not "throw ex;") to rethrow and preserve stack trace
✅ Custom exceptions should inherit from Exception and call base()
✅ The "when" clause filters exceptions without catching and rethrowing
✅ using statement ensures IDisposable.Dispose() is always called
❌ Don't catch exceptions you can't handle — let them propagate
❌ Don't use exceptions for normal control flow — they are for errors
❌ Don't swallow exceptions silently (catch {} with no body)
''',
  quiz: [
    Quiz(question: 'What is the difference between "throw;" and "throw ex;"?', options: [
      QuizOption(text: '"throw;" preserves the original stack trace; "throw ex;" resets it', correct: true),
      QuizOption(text: '"throw ex;" preserves the stack trace; "throw;" resets it', correct: false),
      QuizOption(text: 'They are identical', correct: false),
      QuizOption(text: '"throw;" only works in the catch block; "throw ex;" works anywhere', correct: false),
    ]),
    Quiz(question: 'When does the finally block run?', options: [
      QuizOption(text: 'Always — whether an exception was thrown or not', correct: true),
      QuizOption(text: 'Only when an exception is thrown', correct: false),
      QuizOption(text: 'Only when no exception is thrown', correct: false),
      QuizOption(text: 'Only when the catch block runs', correct: false),
    ]),
    Quiz(question: 'What does the "when" clause do in a catch block?', options: [
      QuizOption(text: 'Filters whether the catch block handles this specific exception based on a condition', correct: true),
      QuizOption(text: 'Specifies when (at what time) to catch the exception', correct: false),
      QuizOption(text: 'Delays catching until a condition is true', correct: false),
      QuizOption(text: 'Only catches exceptions of a specific subtype', correct: false),
    ]),
  ],
);
