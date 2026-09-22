// lib/lessons/cpp/cpp_36_multifile_projects.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson36 = Lesson(
  language: 'C++',
  title: 'Multi-File Projects and Headers',
  content: '''
🎯 METAPHOR:
A multi-file project is like a team building a skyscraper.
One crew does the foundation (.cpp file with implementation),
another does the electrical (.cpp file), another the plumbing.
The blueprints (.h header files) are shared between all crews —
everyone can read the plans, but each crew does their own work.
Headers are the contracts: "here is what exists and how to use it."
Implementation files are the labor: "here is how it actually works."

📖 EXPLANATION:
Real C++ projects split code across multiple files:
  .h / .hpp  — header files: declarations, interfaces
  .cpp       — source files: definitions, implementations

WHY:
  - Faster compilation (only recompile changed files)
  - Better organization (each file = one concept)
  - Encapsulation (hide implementation details)
  - Reusability (share headers between projects)

─────────────────────────────────────
WHAT GOES WHERE:
─────────────────────────────────────
Header (.h):
  class declarations
  function prototypes
  inline functions
  templates (must be in header!)
  constants
  type definitions
  #pragma once or include guard

Source (.cpp):
  function definitions/implementations
  class method implementations
  global variable definitions
─────────────────────────────────────

💻 CODE:
// ─── math_utils.h ───
#pragma once
#include <string>

// Just DECLARATIONS (no implementations)
int add(int a, int b);
int multiply(int a, int b);
double power(double base, int exp);

class Calculator {
private:
    std::string name;
    double memory;
public:
    Calculator(std::string n);
    double add(double a, double b);
    double subtract(double a, double b);
    void storeMemory(double val);
    double recallMemory() const;
    std::string getName() const;
};

// ─── math_utils.cpp ───
#include "math_utils.h"  // include our own header
#include <cmath>

// Implement the free functions
int add(int a, int b) { return a + b; }
int multiply(int a, int b) { return a * b; }

double power(double base, int exp) {
    return std::pow(base, exp);
}

// Implement Calculator methods
// Note: ClassName:: prefix tells compiler these belong to Calculator
Calculator::Calculator(std::string n) : name(n), memory(0.0) {}

double Calculator::add(double a, double b) { return a + b; }
double Calculator::subtract(double a, double b) { return a - b; }
void Calculator::storeMemory(double val) { memory = val; }
double Calculator::recallMemory() const { return memory; }
std::string Calculator::getName() const { return name; }

// ─── main.cpp ───
#include <iostream>
#include "math_utils.h"  // quotes for local headers, <> for system

int main() {
    std::cout << add(3, 4) << std::endl;        // 7
    std::cout << power(2.0, 10) << std::endl;   // 1024

    Calculator calc("MyCalc");
    std::cout << calc.add(10.5, 20.3) << std::endl;  // 30.8
    calc.storeMemory(42.0);
    std::cout << calc.recallMemory() << std::endl;    // 42

    return 0;
}

// ─── Compile all together: ───
// g++ -std=c++17 main.cpp math_utils.cpp -o program

─────────────────────────────────────
INCLUDE: "" vs <>:
─────────────────────────────────────
#include <vector>      system/library header (searches system paths)
#include "myfile.h"    local header (searches current directory first)
─────────────────────────────────────

📝 KEY POINTS:
✅ Every .cpp file that uses something must #include its header
✅ Use #pragma once in every header to prevent double-inclusion
✅ Use quotes "" for local headers, angle brackets <> for system headers
✅ Templates must be defined in headers (not .cpp files)
✅ Compile all .cpp files together in one g++ command
❌ Never #include a .cpp file — only include .h files
❌ Never define variables in headers (except inline/constexpr) — causes multiple definition errors
''',
  quiz: [
    Quiz(question: 'What is the purpose of a header file (.h)?', options: [
      QuizOption(text: 'To declare interfaces so other files know what exists and how to use it', correct: true),
      QuizOption(text: 'To store the implementation of all functions', correct: false),
      QuizOption(text: 'To hold the main() function', correct: false),
      QuizOption(text: 'To contain only constants and macros', correct: false),
    ]),
    Quiz(question: 'What is the syntax difference between including local vs system headers?', options: [
      QuizOption(text: 'Local headers use quotes ""; system headers use angle brackets <>', correct: true),
      QuizOption(text: 'Local headers use angle brackets <>; system headers use quotes ""', correct: false),
      QuizOption(text: 'Both use the same syntax', correct: false),
      QuizOption(text: 'Local headers use #import; system headers use #include', correct: false),
    ]),
    Quiz(question: 'Why must template definitions be in header files?', options: [
      QuizOption(text: 'The compiler needs the full definition to generate type-specific code at compile time', correct: true),
      QuizOption(text: 'Templates cannot be compiled into object files', correct: false),
      QuizOption(text: 'Header files support a different syntax for templates', correct: false),
      QuizOption(text: 'It is just a convention, not a requirement', correct: false),
    ]),
  ],
);
