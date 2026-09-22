// lib/lessons/cpp/cpp_41_type_deduction.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson41 = Lesson(
  language: 'C++',
  title: 'Type Deduction: auto and decltype',
  content: '''
🎯 METAPHOR:
auto is like handing a package to a coworker and saying
"figure out what size box you need." You don't specify
the box size — the coworker looks at the package and
picks the right one. In C++: you don't specify the type
— the compiler looks at the value and picks the right one.
decltype is like saying "give me a box the SAME SIZE as
the one on that shelf." Not the contents — the TYPE of
whatever that variable is.

📖 EXPLANATION:
C++11 introduced two powerful type deduction tools:

auto    — deduce type from the initializer (right side)
decltype — deduce type from an expression (without evaluating it)

These reduce verbosity, prevent type mismatch errors, and
make code more maintainable — especially with complex
template or iterator types.

─────────────────────────────────────
AUTO RULES:
─────────────────────────────────────
auto x = 5;          → int
auto x = 5.0;        → double
auto x = 5.0f;       → float
auto x = "hello";    → const char*
auto x = std::string("hi"); → std::string
auto& x = ref;       → reference to type of ref
const auto x = val;  → const version of deduced type
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <vector>
#include <map>
#include <typeinfo>

int getValue() { return 42; }
double getDouble() { return 3.14; }

int main() {
    // ─── AUTO ───
    auto i = 42;           // int
    auto d = 3.14;         // double
    auto s = std::string("hello");  // std::string
    auto b = true;         // bool

    // auto shines with complex types
    std::map<std::string, std::vector<int>> data;
    data["scores"] = {95, 87, 92};

    // Without auto:
    // std::map<std::string, std::vector<int>>::iterator it = data.begin();
    // With auto:
    auto it = data.begin();  // much cleaner!

    for (const auto& [key, values] : data) {
        std::cout << key << ": ";
        for (auto val : values) std::cout << val << " ";
        std::cout << std::endl;
    }

    // auto with references
    int x = 10;
    auto  copy = x;   // copy — modifying copy doesn't affect x
    auto& ref  = x;   // reference — modifying ref DOES affect x
    ref = 99;
    std::cout << x << std::endl;  // 99

    // auto in function return (C++14)
    auto square = [](auto n) { return n * n; };  // generic lambda
    std::cout << square(5) << std::endl;     // 25
    std::cout << square(3.14) << std::endl;  // 9.8596

    // ─── DECLTYPE ───
    int a = 5;
    double b2 = 3.14;

    decltype(a) x2 = 10;         // int — same type as a
    decltype(b2) y = 2.71;       // double — same type as b2
    decltype(a + b2) z = 8.14;   // double — type of expression a+b2

    // decltype useful for templates
    template <typename T, typename U>
    // auto add(T a, U b) -> decltype(a + b) { return a + b; }
    // The return type is whatever a+b evaluates to

    // decltype(auto) — C++14, preserve reference-ness
    int arr[] = {1, 2, 3};
    auto elem = arr[0];           // int — copy
    decltype(auto) ref2 = arr[0]; // int& — reference!

    // typeid for runtime type info (from <typeinfo>)
    std::cout << typeid(i).name() << std::endl;   // i (int)
    std::cout << typeid(d).name() << std::endl;   // d (double)
    std::cout << typeid(s).name() << std::endl;   // std::string

    return 0;
}

─────────────────────────────────────
WHEN TO USE auto:
─────────────────────────────────────
✅ Iterator types (always verbose without auto)
✅ Lambda return types
✅ Structured bindings
✅ When type is obvious from right side: auto x = std::make_unique<Dog>()
❌ When type clarity matters: auto x = getConfig() — what IS that?
❌ Don't use auto for function parameters (use templates instead)
─────────────────────────────────────

📝 KEY POINTS:
✅ auto deduces type from the initializer at compile time
✅ auto& deduces a reference; const auto& is read-only reference
✅ decltype deduces the type of an expression without evaluating it
✅ Generic lambdas use auto parameters (effectively templates)
❌ auto drops references and const unless you write auto& or const auto&
❌ Don't use auto when the deduced type would be surprising to readers
''',
  quiz: [
    Quiz(question: 'What type does "auto x = 3.14f;" deduce?', options: [
      QuizOption(text: 'float', correct: true),
      QuizOption(text: 'double', correct: false),
      QuizOption(text: 'long double', correct: false),
      QuizOption(text: 'int', correct: false),
    ]),
    Quiz(question: 'What is the difference between auto x = val and auto& x = val?', options: [
      QuizOption(text: 'auto copies the value; auto& creates a reference to the original', correct: true),
      QuizOption(text: 'auto& copies the value; auto creates a reference', correct: false),
      QuizOption(text: 'They are identical in behavior', correct: false),
      QuizOption(text: 'auto& only works with pointers', correct: false),
    ]),
    Quiz(question: 'What does decltype(expr) produce?', options: [
      QuizOption(text: 'The type of the expression without evaluating it', correct: true),
      QuizOption(text: 'The value of the expression', correct: false),
      QuizOption(text: 'A runtime type check', correct: false),
      QuizOption(text: 'A string name of the type', correct: false),
    ]),
  ],
);
