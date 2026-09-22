// lib/lessons/cpp/cpp_04_constants.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson04 = Lesson(
  language: 'C++',
  title: 'Constants and constexpr',
  content: '''
🎯 METAPHOR:
A constant is like a tattoo — written once, permanent forever.
A variable is like writing on a whiteboard — you can erase
and rewrite it anytime. Some values SHOULD be tattoos:
pi is always 3.14159, the speed of light doesn't change,
and your tax rate shouldn't change mid-calculation.
Use const to make that permanence explicit and enforced.

📖 EXPLANATION:
C++ has two ways to define constants:

1. const — value is fixed at runtime
2. constexpr — value is fixed at COMPILE TIME (faster)

The difference:
  const int x = someFunction();  // OK, determined at runtime
  constexpr int y = 5 * 5;       // must be known at compile time

constexpr is preferred when possible — the compiler can
optimize it away entirely, replacing it with the literal value.

ALSO: #define (the old C way — avoid in C++)
  #define PI 3.14159   // no type, no scope, just text replace
  const double PI = 3.14159;  // better: typed, scoped
  constexpr double PI = 3.14159; // best: compile-time

💻 CODE:
#include <iostream>

// Compile-time constants — preferred
constexpr double PI = 3.14159265358979;
constexpr int MAX_SIZE = 100;
constexpr int SECONDS_PER_HOUR = 60 * 60; // compiler computes this

// Runtime constant — value locked after assignment
const int userId = getUserId(); // value set at runtime, then locked

int main() {
    constexpr double radius = 5.0;
    constexpr double area = PI * radius * radius;

    std::cout << "Area: " << area << std::endl;

    // This would cause a compile error:
    // PI = 3.0;  // ERROR: cannot assign to const

    // const in function parameters — caller's value is safe
    auto printValue = [](const int val) {
        // val = 10;  // ERROR: val is const
        std::cout << val << std::endl;
    };

    printValue(42);
    return 0;
}

─────────────────────────────────────
const vs constexpr vs #define:
─────────────────────────────────────
#define PI 3.14    no type, no scope, text substitution
const PI = 3.14    typed, scoped, runtime or compile
constexpr PI = 3.14  typed, scoped, MUST be compile-time
─────────────────────────────────────

📝 KEY POINTS:
✅ Prefer constexpr over const when value is known at compile time
✅ Prefer const over #define — it has type safety and scope
✅ Use ALL_CAPS naming for constants (convention)
✅ Mark function parameters const when you won't modify them
❌ Never use #define for constants in modern C++
❌ constexpr functions must be computable at compile time
''',
  quiz: [
    Quiz(question: 'What is the difference between const and constexpr?', options: [
      QuizOption(text: 'constexpr is evaluated at compile time; const can be runtime', correct: true),
      QuizOption(text: 'const is faster than constexpr', correct: false),
      QuizOption(text: 'They are identical', correct: false),
      QuizOption(text: 'constexpr only works with integers', correct: false),
    ]),
    Quiz(question: 'Why is const preferred over #define in C++?', options: [
      QuizOption(text: 'const has type safety and proper scoping', correct: true),
      QuizOption(text: '#define is faster at runtime', correct: false),
      QuizOption(text: 'const uses less memory', correct: false),
      QuizOption(text: '#define only works in C', correct: false),
    ]),
    Quiz(question: 'What happens if you try to modify a const variable?', options: [
      QuizOption(text: 'The compiler gives an error', correct: true),
      QuizOption(text: 'The change is silently ignored', correct: false),
      QuizOption(text: 'The program crashes at runtime', correct: false),
      QuizOption(text: 'It creates a new variable', correct: false),
    ]),
  ],
);
