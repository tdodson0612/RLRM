// lib/lessons/cpp/cpp_11_strings.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson11 = Lesson(
  language: 'C++',
  title: 'Strings',
  content: '''
🎯 METAPHOR:
A C-string (char array) is like beads on a string — you
manage each bead yourself, and you need a special knot at
the end (null terminator) so you know where it stops.
std::string is like a necklace from a jewelry store —
already assembled, resizable, and comes with a clasp
(built-in methods). Use the jewelry store necklace.

📖 EXPLANATION:
C++ has two kinds of strings:

1. C-style strings — char arrays ending in '\\0' (null terminator)
   Inherited from C. Manual, error-prone. Avoid in modern C++.

2. std::string — C++ class with built-in methods
   Dynamic size, safe, easy to use. Always prefer this.

─────────────────────────────────────
STD::STRING KEY METHODS:
─────────────────────────────────────
s.length()          number of characters
s.size()            same as length()
s.empty()           true if string is empty
s.at(i)             character at index i (bounds checked)
s[i]                character at index i (no bounds check)
s.substr(pos, len)  extract substring
s.find("text")      find position of substring
s.replace(pos, len, "new")  replace portion
s + s2              concatenate strings
s.append("more")    add to end
s.compare(s2)       compare (0 = equal)
s.c_str()           convert to C-style const char*
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <string>

int main() {
    std::string name = "Alice";
    std::string greeting = "Hello, " + name + "!";

    std::cout << greeting << std::endl;        // Hello, Alice!
    std::cout << name.length() << std::endl;   // 5
    std::cout << name[0] << std::endl;         // A
    std::cout << name.at(1) << std::endl;      // l

    // Substring
    std::string s = "Hello, World!";
    std::cout << s.substr(7, 5) << std::endl;  // World

    // Find
    size_t pos = s.find("World");
    if (pos != std::string::npos) {
        std::cout << "Found at: " << pos << std::endl; // 7
    }

    // Replace
    s.replace(7, 5, "C++");
    std::cout << s << std::endl;  // Hello, C++!

    // Compare
    std::string a = "apple";
    std::string b = "banana";
    if (a < b) {
        std::cout << "apple comes first alphabetically" << std::endl;
    }

    // Convert number to string
    int num = 42;
    std::string numStr = std::to_string(num);

    // Convert string to number
    std::string pi = "3.14";
    double piVal = std::stod(pi);  // string to double

    // C-style string (avoid, but know it exists)
    char cstr[] = "hello";   // null terminator added automatically
    char cstr2[6] = {'h','e','l','l','o','\\0'};  // explicit

    return 0;
}

📝 KEY POINTS:
✅ Always use std::string in modern C++ — not char arrays
✅ Use std::string::npos to check if find() failed
✅ Strings support == != < > comparisons (lexicographic)
✅ std::to_string() converts numbers to strings
✅ std::stoi(), std::stod() convert strings to numbers
❌ Don't use C-style string functions (strcpy, strlen) — use std::string
❌ s.find() returns size_t — it can never be negative, check against npos
''',
  quiz: [
    Quiz(question: 'What does std::string::npos represent?', options: [
      QuizOption(text: 'A special value meaning "not found" returned by find()', correct: true),
      QuizOption(text: 'The null terminator position', correct: false),
      QuizOption(text: 'Negative position in the string', correct: false),
      QuizOption(text: 'The maximum allowed string length', correct: false),
    ]),
    Quiz(question: 'How do you convert an integer to a std::string?', options: [
      QuizOption(text: 'std::to_string(num)', correct: true),
      QuizOption(text: '(string)num', correct: false),
      QuizOption(text: 'string(num)', correct: false),
      QuizOption(text: 'num.toString()', correct: false),
    ]),
    Quiz(question: 'What is the main advantage of std::string over C-style char arrays?', options: [
      QuizOption(text: 'It manages memory automatically and provides built-in methods', correct: true),
      QuizOption(text: 'It uses less memory', correct: false),
      QuizOption(text: 'It is faster for every operation', correct: false),
      QuizOption(text: 'It supports Unicode by default', correct: false),
    ]),
  ],
);
