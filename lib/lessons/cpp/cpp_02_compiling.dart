// lib/lessons/cpp/cpp_02_compiling.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson02 = Lesson(
  language: 'C++',
  title: 'Compiling C++',
  content: '''
🎯 METAPHOR:
Your C++ source code is like an architect's blueprint.
The compiler is the construction crew — they read the
blueprint and build the actual house (executable).
Once the house is built, you don't need the blueprint
to live in it. The executable runs on its own.

📖 EXPLANATION:
C++ is a compiled language. You write .cpp files,
then a compiler translates them into machine code.

The two most common compilers:
  - g++   (GNU, free, works on Linux/Mac/Windows)
  - clang++ (LLVM-based, used on macOS by default)
  - MSVC  (Microsoft, used in Visual Studio on Windows)

The compilation pipeline:
  1. Preprocessing  → #include and #define are resolved
  2. Compilation    → C++ code becomes assembly
  3. Assembly       → assembly becomes object code (.o)
  4. Linking        → object files combined into executable

💻 CODE:
// Step 1: Save this as main.cpp
#include <iostream>

int main() {
    std::cout << "Hello, C++!" << std::endl;
    return 0;
}

// Step 2: Compile with g++
//   g++ main.cpp -o hello

// Step 3: Run it
//   ./hello      (Linux/Mac)
//   hello.exe    (Windows)

─────────────────────────────────────
USEFUL COMPILER FLAGS:
─────────────────────────────────────
g++ main.cpp -o hello         basic compile
g++ -Wall main.cpp -o hello   show all warnings
g++ -std=c++17 main.cpp -o hello  use C++17 standard
g++ -O2 main.cpp -o hello     optimize for speed
g++ -g main.cpp -o hello      include debug info
─────────────────────────────────────

C++ STANDARDS (use -std= flag):
  c++11  → lambdas, auto, range-for, smart pointers
  c++14  → minor improvements to c++11
  c++17  → structured bindings, if constexpr, std::optional
  c++20  → concepts, coroutines, ranges, modules
  c++23  → latest standard

Always compile with at least -std=c++17 for modern C++.

📝 KEY POINTS:
✅ C++ source files use .cpp extension
✅ Use g++ (not gcc) to compile C++ files
✅ Always use -std=c++17 or higher for modern features
✅ -Wall catches many common mistakes before runtime
❌ Don't use gcc for C++ — it won't link C++ libraries
❌ Don't ignore compiler warnings — treat them as errors
''',
  quiz: [
    Quiz(question: 'What file extension do C++ source files use?', options: [
      QuizOption(text: '.cpp', correct: true),
      QuizOption(text: '.c', correct: false),
      QuizOption(text: '.cx', correct: false),
      QuizOption(text: '.cxx only', correct: false),
    ]),
    Quiz(question: 'Which command compiles a C++ file with g++?', options: [
      QuizOption(text: 'g++ main.cpp -o hello', correct: true),
      QuizOption(text: 'gcc main.cpp -o hello', correct: false),
      QuizOption(text: 'compile main.cpp', correct: false),
      QuizOption(text: 'cpp main.cpp -o hello', correct: false),
    ]),
    Quiz(question: 'What does the -std=c++17 flag do?', options: [
      QuizOption(text: 'Enables C++17 language features', correct: true),
      QuizOption(text: 'Sets the optimization level to 17', correct: false),
      QuizOption(text: 'Links 17 standard libraries', correct: false),
      QuizOption(text: 'Compiles 17 files at once', correct: false),
    ]),
  ],
);
