// lib/lessons/cpp/cpp_35_preprocessor.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson35 = Lesson(
  language: 'C++',
  title: 'The Preprocessor',
  content: '''
🎯 METAPHOR:
The preprocessor is like an editor who reads your manuscript
BEFORE the publisher sees it. It does find-and-replace,
cuts entire sections based on flags, and pastes in other
documents — all before the real work (compilation) begins.
The compiler never sees your original text — it sees the
preprocessor's edited version.

📖 EXPLANATION:
The preprocessor runs BEFORE the compiler.
It processes lines starting with # (hash directives).
It does NOT know C++ syntax — it is pure text substitution.

─────────────────────────────────────
KEY PREPROCESSOR DIRECTIVES:
─────────────────────────────────────
#include    paste contents of another file
#define     text substitution / macro
#undef      undefine a macro
#ifdef      if macro is defined
#ifndef     if macro is NOT defined
#if         if condition is true
#elif       else if
#else       else
#endif      end conditional block
#pragma     compiler-specific instructions
#error      emit compile error with message
─────────────────────────────────────

💻 CODE:
#include <iostream>

// ─── MACROS ───
#define PI 3.14159          // constant (prefer constexpr in C++)
#define SQUARE(x) ((x)*(x)) // function-like macro (prefer inline/template)
#define MAX_SIZE 100

// ─── INCLUDE GUARDS (prevent double-inclusion) ───
// In header files, always wrap with:
//   #ifndef MY_HEADER_H
//   #define MY_HEADER_H
//   ... header content ...
//   #endif
// Or use the modern #pragma once

// ─── CONDITIONAL COMPILATION ───
#define DEBUG_MODE  // comment this out to disable debug output

int main() {
    // Macro usage
    std::cout << PI << std::endl;          // 3.14159
    std::cout << SQUARE(5) << std::endl;   // 25
    std::cout << SQUARE(2+3) << std::endl; // 25 (parens prevent bugs)
    // Without parens: SQUARE(2+3) → 2+3*2+3 = 11 — WRONG!

    // Conditional compilation
    #ifdef DEBUG_MODE
        std::cout << "[DEBUG] Program started" << std::endl;
    #endif

    // Platform detection
    #ifdef _WIN32
        std::cout << "Windows" << std::endl;
    #elif defined(__linux__)
        std::cout << "Linux" << std::endl;
    #elif defined(__APPLE__)
        std::cout << "macOS" << std::endl;
    #else
        std::cout << "Unknown platform" << std::endl;
    #endif

    // Predefined macros
    std::cout << "File: " << __FILE__ << std::endl;
    std::cout << "Line: " << __LINE__ << std::endl;
    std::cout << "Date: " << __DATE__ << std::endl;

    return 0;
}

// ─── VARIADIC MACRO DEBUG LOG ───
#define LOG(msg) std::cout << "[" << __FILE__ << ":" << __LINE__ << "] " << msg << std::endl

// Usage: LOG("Error occurred");
// Output: [main.cpp:42] Error occurred

─────────────────────────────────────
#pragma once vs include guards:
─────────────────────────────────────
#pragma once    — simple, one line, widely supported
#ifndef guards  — portable, standard, more verbose
Both prevent a header from being included twice.
Prefer #pragma once in modern C++.
─────────────────────────────────────

📝 KEY POINTS:
✅ Use #pragma once at the top of every header file
✅ Always wrap macro parameters in parentheses: #define SQUARE(x) ((x)*(x))
✅ Predefined macros __FILE__, __LINE__, __DATE__ are useful for logging
✅ Conditional compilation is powerful for cross-platform code
❌ Avoid function-like macros — prefer inline functions or templates
❌ Macros have NO type safety and NO scope — they are pure text substitution
❌ Don't use macros for constants — use constexpr instead
''',
  quiz: [
    Quiz(question: 'When does the preprocessor run relative to the compiler?', options: [
      QuizOption(text: 'Before the compiler — it processes text before C++ parsing begins', correct: true),
      QuizOption(text: 'After the compiler — it optimizes the output', correct: false),
      QuizOption(text: 'At the same time as the compiler', correct: false),
      QuizOption(text: 'Only when #pragma is present', correct: false),
    ]),
    Quiz(question: 'What is the purpose of include guards or #pragma once?', options: [
      QuizOption(text: 'Prevent a header file from being included more than once', correct: true),
      QuizOption(text: 'Speed up compilation by caching header files', correct: false),
      QuizOption(text: 'Enable conditional compilation', correct: false),
      QuizOption(text: 'Protect private class members', correct: false),
    ]),
    Quiz(question: 'Why should macro parameters always be wrapped in parentheses?', options: [
      QuizOption(text: 'To prevent operator precedence bugs during text substitution', correct: true),
      QuizOption(text: 'To make the macro work with pointer types', correct: false),
      QuizOption(text: 'Parentheses are required syntax for macros', correct: false),
      QuizOption(text: 'To enable the macro to return a value', correct: false),
    ]),
  ],
);
