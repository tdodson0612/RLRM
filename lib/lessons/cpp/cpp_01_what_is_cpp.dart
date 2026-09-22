// lib/lessons/cpp/cpp_01_what_is_cpp.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson01 = Lesson(
  language: 'C++',
  title: 'What is C++?',
  content: '''
🎯 METAPHOR:
C is a sharp, precise scalpel — powerful, but you do
everything by hand. C++ is that same scalpel, but now
you also have a full surgical kit: clamps, scissors,
monitors, and a team of assistants (objects).
You still have full control, but you can organize your
work into reusable, structured systems.

📖 EXPLANATION:
C++ was created by Bjarne Stroustrup at Bell Labs in 1979.
He called it "C with Classes" before renaming it C++ in 1983.
The ++ is a nod to C's increment operator — C++ is literally
"one better than C."

C++ adds to C:
  - Classes and Objects (OOP)
  - Templates (generic programming)
  - The Standard Template Library (STL)
  - References
  - Operator overloading
  - Exception handling
  - Namespaces

Where C++ is used today:
  - Game engines (Unreal Engine is C++)
  - Operating systems (Windows, parts of macOS/Linux)
  - Browsers (Chrome's V8 engine)
  - Embedded systems and robotics
  - High-frequency trading systems
  - Compilers and interpreters

C++ is one of the fastest languages that exists.
When performance is non-negotiable, C++ is the answer.

💻 CODE:
#include <iostream>  // C++ standard I/O (replaces stdio.h)

int main() {
    // cout is C++'s way of printing (replaces printf)
    std::cout << "Hello, C++!" << std::endl;
    return 0;
}

─────────────────────────────────────
C vs C++ side by side:
─────────────────────────────────────
C:    printf("Hello\\n");
C++:  std::cout << "Hello" << std::endl;

C:    // no classes
C++:  class Dog { string name; void bark(); };

C:    malloc / free
C++:  new / delete (or smart pointers)
─────────────────────────────────────

📝 KEY POINTS:
✅ C++ is a superset of C — valid C is (mostly) valid C++
✅ C++ adds OOP, templates, and the STL on top of C
✅ #include <iostream> replaces #include <stdio.h>
✅ std::cout replaces printf
❌ C++ is NOT just "C with syntax sugar" — it is a
   fundamentally different way of organizing programs
❌ Don't mix C-style and C++-style I/O in the same program
''',
  quiz: [
    Quiz(question: 'Who created C++?', options: [
      QuizOption(text: 'Bjarne Stroustrup', correct: true),
      QuizOption(text: 'Dennis Ritchie', correct: false),
      QuizOption(text: 'Linus Torvalds', correct: false),
      QuizOption(text: 'James Gosling', correct: false),
    ]),
    Quiz(question: 'What does the ++ in C++ refer to?', options: [
      QuizOption(text: 'The increment operator — C++ is one better than C', correct: true),
      QuizOption(text: 'The language version number', correct: false),
      QuizOption(text: 'Double pointer syntax', correct: false),
      QuizOption(text: 'It has no meaning', correct: false),
    ]),
    Quiz(question: 'Which header replaces stdio.h in C++?', options: [
      QuizOption(text: '<iostream>', correct: true),
      QuizOption(text: '<stdio>', correct: false),
      QuizOption(text: '<conio.h>', correct: false),
      QuizOption(text: '<output.h>', correct: false),
    ]),
  ],
);
