// lib/lessons/cpp/cpp_49_type_aliases.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson49 = Lesson(
  language: 'C++',
  title: 'Type Aliases: using and typedef',
  content: '''
🎯 METAPHOR:
A type alias is like a nickname for a mouthful of a name.
std::vector<std::pair<std::string, int>> is like saying
"The tall red-haired left-handed software engineer who
sits by the window." A type alias lets you say "Bob" instead.
Same person. Much easier to say, write, and read.

📖 EXPLANATION:
Type aliases give a new name to an existing type.
Useful for:
  - Shortening complex template types
  - Making intent clear (what IS this type used for?)
  - Easy refactoring (change the underlying type in one place)
  - Platform portability (uint32_t etc.)

C++ has TWO ways to create type aliases:

1. typedef  — old C-style (still valid, but limited)
2. using    — modern C++11 (preferred, more powerful)

─────────────────────────────────────
typedef vs using:
─────────────────────────────────────
typedef unsigned int uint;         // old
using uint = unsigned int;         // new — reads left to right

typedef void (*FuncPtr)(int);      // old function pointer alias
using FuncPtr = void(*)(int);      // new — much clearer!

// Template aliases — ONLY possible with using, not typedef:
template<typename T>
using Vec = std::vector<T>;        // Vec<int>, Vec<string>
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <vector>
#include <map>
#include <string>
#include <functional>

// ─── SIMPLE ALIASES ───
using Byte   = unsigned char;
using Int32  = int;
using Float64 = double;

// Semantic aliases — same type, clearer intent
using UserId   = int;
using Score    = double;
using Username = std::string;

// ─── COMPLEX TYPE ALIASES ───
using StringList  = std::vector<std::string>;
using ScoreMap    = std::map<std::string, int>;
using Coordinate  = std::pair<double, double>;
using CoordList   = std::vector<Coordinate>;

// Without alias:
// std::map<std::string, std::vector<std::pair<int, std::string>>> lookup;
// With alias:
using ItemList = std::vector<std::pair<int, std::string>>;
using LookupTable = std::map<std::string, ItemList>;

// ─── FUNCTION POINTER ALIASES ───
using Comparator = bool(*)(int, int);
using Callback   = std::function<void(int)>;

bool ascending(int a, int b)  { return a < b; }
bool descending(int a, int b) { return a > b; }

void doCallback(int val, Callback cb) { cb(val); }

// ─── TEMPLATE ALIAS ───
template<typename T>
using Vec = std::vector<T>;

template<typename K, typename V>
using Dict = std::map<K, V>;

// ─── TYPEDEF (old style — know it when you see it) ───
typedef unsigned long ulong;
typedef void (*LegacyCallback)(int, const char*);

int main() {
    // Semantic aliases make intent clear
    UserId   uid   = 42;
    Score    score = 98.5;
    Username user  = "Alice";

    std::cout << user << " (id=" << uid << ") scored " << score << std::endl;

    // Complex type aliases
    ScoreMap scores;
    scores["Alice"] = 95;
    scores["Bob"]   = 87;

    StringList names = {"Alice", "Bob", "Charlie"};
    for (const auto& name : names) std::cout << name << " ";
    std::cout << std::endl;

    // Function pointer alias
    Comparator cmp = ascending;
    std::cout << cmp(3, 5) << std::endl;  // 1 (true)
    cmp = descending;
    std::cout << cmp(3, 5) << std::endl;  // 0 (false)

    // Callback alias
    Callback cb = [](int x) { std::cout << "Got: " << x << std::endl; };
    doCallback(42, cb);

    // Template alias
    Vec<int> ints = {1, 2, 3, 4, 5};
    Dict<std::string, int> dict;
    dict["one"] = 1;
    dict["two"] = 2;

    for (const auto& [k, v] : dict) {
        std::cout << k << " = " << v << std::endl;
    }

    return 0;
}

📝 KEY POINTS:
✅ Prefer using over typedef — cleaner syntax, supports templates
✅ Use semantic aliases to document intent: UserId not just int
✅ Template aliases are only possible with using, not typedef
✅ Centralize complex type aliases — change once, updates everywhere
✅ using is also used for namespace imports and base class member visibility
❌ Don't create aliases just to avoid typing — aliases should add meaning
❌ typedef for function pointers is notoriously hard to read — use using
''',
  quiz: [
    Quiz(question: 'What can "using" do that "typedef" cannot?', options: [
      QuizOption(text: 'Create template aliases', correct: true),
      QuizOption(text: 'Alias pointer types', correct: false),
      QuizOption(text: 'Alias built-in types', correct: false),
      QuizOption(text: 'Create aliases inside functions', correct: false),
    ]),
    Quiz(question: 'What is the modern C++ syntax for creating a type alias?', options: [
      QuizOption(text: 'using NewName = ExistingType;', correct: true),
      QuizOption(text: 'typedef ExistingType NewName;', correct: false),
      QuizOption(text: '#define NewName ExistingType', correct: false),
      QuizOption(text: 'alias NewName = ExistingType;', correct: false),
    ]),
    Quiz(question: 'What is the main benefit of semantic type aliases like "using UserId = int"?', options: [
      QuizOption(text: 'They document intent and make the code self-describing', correct: true),
      QuizOption(text: 'They make the type use less memory', correct: false),
      QuizOption(text: 'They prevent implicit conversions between different semantic types', correct: false),
      QuizOption(text: 'They allow the underlying type to be changed at runtime', correct: false),
    ]),
  ],
);
