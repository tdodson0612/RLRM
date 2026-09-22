// lib/lessons/cpp/cpp_09_functions.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson09 = Lesson(
  language: 'C++',
  title: 'Functions',
  content: '''
🎯 METAPHOR:
A function is like a vending machine.
You put something in (arguments), press a button (call it),
and get something back (return value). The machine does its
job the same way every time, and you don't need to know
the electronics inside — just what goes in and what comes out.
That's the power of functions: reusable, self-contained,
predictable machines.

📖 EXPLANATION:
A function in C++ has:
  - A return type (what it gives back — void if nothing)
  - A name
  - Parameters (inputs, in parentheses)
  - A body (the code inside {})

DECLARATION vs DEFINITION:
  Declaration (prototype) — tells the compiler the function exists
  Definition — the actual code of the function

In C++, functions must be declared BEFORE they are called,
OR you write a prototype at the top.

💻 CODE:
#include <iostream>

// Function declaration (prototype) — tells compiler it exists
int add(int a, int b);
void greet(std::string name);

int main() {
    // Calling functions
    int result = add(3, 4);
    std::cout << result << std::endl;  // 7

    greet("Alice");  // Hello, Alice!

    // Function with no return value
    void printLine();  // just does something, returns nothing

    return 0;
}

// Function definitions (the actual code)
int add(int a, int b) {
    return a + b;  // returns the sum
}

void greet(std::string name) {
    std::cout << "Hello, " << name << "!" << std::endl;
    // no return needed for void
}

// DEFAULT PARAMETERS — caller can omit them
int power(int base, int exp = 2) {  // exp defaults to 2
    int result = 1;
    for (int i = 0; i < exp; i++) result *= base;
    return result;
}
// power(3)    → 9  (uses default exp=2)
// power(3, 3) → 27

// FUNCTION OVERLOADING — same name, different parameters
double add(double a, double b) {
    return a + b;
}
// C++ picks the right version based on argument types
// add(3, 4)     → int version
// add(3.0, 4.0) → double version

// INLINE FUNCTIONS — hint to compiler to expand in place
inline int square(int x) {
    return x * x;
}

📝 KEY POINTS:
✅ Functions must be declared before use — use prototypes
✅ void means the function returns nothing
✅ Default parameters must come LAST in the parameter list
✅ Overloading works on parameter types and count, not return type
✅ Keep functions small and focused on ONE thing
❌ Don't use global variables inside functions — pass them in
❌ Overloading on return type only is NOT allowed
❌ Don't make functions too long — if it scrolls, break it up
''',
  quiz: [
    Quiz(question: 'What is a function prototype in C++?', options: [
      QuizOption(text: 'A declaration that tells the compiler a function exists before its definition', correct: true),
      QuizOption(text: 'The first version of a function', correct: false),
      QuizOption(text: 'A function that returns void', correct: false),
      QuizOption(text: 'A built-in standard library function', correct: false),
    ]),
    Quiz(question: 'What does function overloading allow?', options: [
      QuizOption(text: 'Multiple functions with the same name but different parameters', correct: true),
      QuizOption(text: 'A function to return multiple values', correct: false),
      QuizOption(text: 'Running two functions simultaneously', correct: false),
      QuizOption(text: 'Calling a function before declaring it', correct: false),
    ]),
    Quiz(question: 'Where must default parameters appear in a function signature?', options: [
      QuizOption(text: 'At the end (rightmost parameters)', correct: true),
      QuizOption(text: 'At the beginning', correct: false),
      QuizOption(text: 'Anywhere in any order', correct: false),
      QuizOption(text: 'Only in the definition, not the declaration', correct: false),
    ]),
  ],
);
