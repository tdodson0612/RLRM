// lib/lessons/cpp/cpp_17_constructors_destructors.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson17 = Lesson(
  language: 'C++',
  title: 'Constructors and Destructors',
  content: '''
🎯 METAPHOR:
A constructor is the opening ceremony when a new employee
starts — set up their desk, give them a badge, assign
their computer. Everything they need to function is ready.
A destructor is the exit interview when they leave —
return the badge, clean out the desk, release the parking
spot. Everything the object borrowed gets returned.

📖 EXPLANATION:
CONSTRUCTOR — called automatically when an object is created
  - Same name as the class
  - No return type (not even void)
  - Can be overloaded (multiple constructors)

DESTRUCTOR — called automatically when an object is destroyed
  - Same name as class with ~ prefix
  - No parameters, no return type
  - Only ONE destructor per class

MEMBER INITIALIZER LIST — the preferred way to set members
  Uses : after constructor signature, before the body
  More efficient than assignment inside the body

💻 CODE:
#include <iostream>
#include <string>

class BankAccount {
private:
    std::string owner;
    double balance;

public:
    // Default constructor (no parameters)
    BankAccount() : owner("Unknown"), balance(0.0) {
        std::cout << "Default account created" << std::endl;
    }

    // Parameterized constructor
    BankAccount(std::string name, double initialBalance)
        : owner(name), balance(initialBalance) {  // initializer list
        std::cout << owner << "'s account created with $"
                  << balance << std::endl;
    }

    // Copy constructor — creates a copy of another object
    BankAccount(const BankAccount& other)
        : owner(other.owner + " (copy)"), balance(other.balance) {
        std::cout << "Account copied" << std::endl;
    }

    // Destructor
    ~BankAccount() {
        std::cout << owner << "'s account closed" << std::endl;
    }

    void deposit(double amount) { balance += amount; }
    void show() {
        std::cout << owner << ": $" << balance << std::endl;
    }
};

int main() {
    BankAccount a1;                         // default constructor
    BankAccount a2("Alice", 1000.0);        // parameterized
    BankAccount a3(a2);                     // copy constructor

    a2.deposit(500);
    a2.show();   // Alice: $1500
    a3.show();   // Alice (copy): $1000

    return 0;
}   // destructors called here automatically (reverse order of creation)

─────────────────────────────────────
CONSTRUCTOR TYPES:
─────────────────────────────────────
Default          BankAccount()
Parameterized    BankAccount(string, double)
Copy             BankAccount(const BankAccount&)
Move             BankAccount(BankAccount&&)      (C++11)
Delegating       calls another constructor of same class
─────────────────────────────────────

📝 KEY POINTS:
✅ Always use member initializer list over body assignment
✅ If you allocate memory in constructor, free it in destructor
✅ Destructors are called automatically — in reverse order of construction
✅ If you define a destructor, also define copy constructor and copy assignment (Rule of Three)
❌ Don't throw exceptions from destructors — it can crash your program
❌ If you skip a constructor C++ provides a default one — but it won't initialize members
''',
  quiz: [
    Quiz(question: 'When is a destructor called?', options: [
      QuizOption(text: 'Automatically when the object goes out of scope or is deleted', correct: true),
      QuizOption(text: 'Only when delete is called explicitly', correct: false),
      QuizOption(text: 'When the program ends only', correct: false),
      QuizOption(text: 'When the object is copied', correct: false),
    ]),
    Quiz(question: 'What is a member initializer list?', options: [
      QuizOption(text: 'A way to initialize member variables before the constructor body runs', correct: true),
      QuizOption(text: 'A list of all class members', correct: false),
      QuizOption(text: 'A way to call multiple constructors', correct: false),
      QuizOption(text: 'An alternative to the destructor', correct: false),
    ]),
    Quiz(question: 'How many destructors can a class have?', options: [
      QuizOption(text: 'Exactly one', correct: true),
      QuizOption(text: 'As many as needed', correct: false),
      QuizOption(text: 'One per constructor', correct: false),
      QuizOption(text: 'Zero — destructors are optional', correct: false),
    ]),
  ],
);
