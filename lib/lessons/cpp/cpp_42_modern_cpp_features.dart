// lib/lessons/cpp/cpp_42_modern_cpp_features.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson42 = Lesson(
  language: 'C++',
  title: 'Modern C++: C++11/14/17 Key Features',
  content: '''
🎯 METAPHOR:
Each C++ standard is like a new iPhone model.
The phone still makes calls (backwards compatible) but gains
new superpowers with each release. C++11 was the iPhone moment
— a massive leap. C++14 and C++17 polished and extended it.
Knowing which features came from which version helps you
understand why certain code looks the way it does, and
lets you write code that works on any modern compiler.

📖 EXPLANATION:
Modern C++ (C++11 onward) added so many features that it
almost feels like a new language. Here is a tour of the
most impactful features not covered elsewhere.

─────────────────────────────────────
C++11 HIGHLIGHTS:
─────────────────────────────────────
auto               type deduction
range-based for    for (auto x : collection)
lambdas            [](args) { body }
smart pointers     unique_ptr, shared_ptr, weak_ptr
move semantics     &&, std::move
nullptr            type-safe null pointer
constexpr          compile-time computation
initializer lists  {1, 2, 3} for any type
uniform init       T x{...} — prevents narrowing
static_assert      compile-time assertions
thread library     std::thread, std::mutex
std::array         fixed-size safe array
std::tuple         heterogeneous value pack
enum class         scoped enumerations
override/final     safer virtual function syntax
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

// ─── INITIALIZER LISTS ───
class Scoreboard {
    std::vector<int> scores;
public:
    Scoreboard(std::initializer_list<int> s) : scores(s) {}
    void print() { for (int s : scores) std::cout << s << " "; }
};

// ─── DELEGATING CONSTRUCTORS (C++11) ───
class Config {
    int width, height;
    std::string title;
public:
    Config() : Config(800, 600, "Default") {}  // delegates to main ctor
    Config(int w, int h, std::string t) : width(w), height(h), title(t) {}
    void print() { std::cout << title << " " << width << "x" << height << std::endl; }
};

// ─── FINAL (C++11) — prevent further overriding or inheritance ───
class Base {
public:
    virtual void speak() {}
};

class Derived : public Base {
public:
    void speak() override final {}  // no one can override this further
};

// class MoreDerived : public Derived {};  // ERROR if speak() tries to override

// ─── static_assert (C++11) ───
static_assert(sizeof(int) >= 4, "int must be at least 4 bytes");
static_assert(sizeof(void*) == 8, "Expected 64-bit platform");

int main() {
    // Initializer list construction
    Scoreboard sb{95, 87, 92, 78};
    sb.print();  // 95 87 92 78

    // Delegating constructor
    Config c1;
    c1.print();  // Default 800x600

    // ─── C++14: Generic lambdas ───
    auto printAny = [](auto x) { std::cout << x << std::endl; };
    printAny(42);
    printAny("hello");
    printAny(3.14);

    // ─── C++14: Binary literals ───
    int flags = 0b10110011;
    std::cout << flags << std::endl;  // 179

    // ─── C++14: Digit separators ───
    int million  = 1'000'000;
    double pi    = 3.141'592'653;
    std::cout << million << std::endl;

    // ─── C++17: Structured bindings ───
    std::pair<std::string, int> person{"Alice", 30};
    auto [name, age] = person;  // C++17
    std::cout << name << " " << age << std::endl;

    // ─── C++17: if with initializer ───
    if (auto it = std::find(std::vector{1,2,3,4,5}.begin(),
                             std::vector{1,2,3,4,5}.end(), 3);
        it != std::vector{1,2,3,4,5}.end()) {
        std::cout << "Found!" << std::endl;
    }

    // ─── C++17: constexpr if ───
    auto describe = [](auto x) {
        if constexpr (std::is_integral_v<decltype(x)>) {
            std::cout << x << " is an integer" << std::endl;
        } else {
            std::cout << x << " is not an integer" << std::endl;
        }
    };
    describe(42);     // 42 is an integer
    describe(3.14);   // 3.14 is not an integer

    // ─── C++17: std::string_view (lightweight, no copy) ───
    std::string_view sv = "Hello, World!";
    std::cout << sv.substr(0, 5) << std::endl;  // Hello (no allocation!)

    return 0;
}

📝 KEY POINTS:
✅ C++11 was a revolution — most modern C++ code requires at least -std=c++11
✅ Digit separators ' make large literals readable: 1'000'000
✅ Structured bindings make working with pairs/tuples/structs clean
✅ if constexpr evaluates at compile time — removes dead branches entirely
✅ std::string_view is a non-owning reference to a string — zero-copy
❌ Don't use C++98 style in new code — modern C++ is safer and cleaner
❌ string_view must not outlive the string it references
''',
  quiz: [
    Quiz(question: 'What does "if constexpr" do differently from a regular if?', options: [
      QuizOption(text: 'It evaluates the condition at compile time and removes untaken branches', correct: true),
      QuizOption(text: 'It prevents the condition from using runtime variables', correct: false),
      QuizOption(text: 'It runs the condition in a separate thread', correct: false),
      QuizOption(text: 'It is identical to a regular if at runtime', correct: false),
    ]),
    Quiz(question: 'What is the purpose of std::string_view?', options: [
      QuizOption(text: 'A lightweight non-owning read-only reference to a string — no copy made', correct: true),
      QuizOption(text: 'A mutable view that allows editing the original string', correct: false),
      QuizOption(text: 'A string that automatically resizes itself', correct: false),
      QuizOption(text: 'A wide character string type', correct: false),
    ]),
    Quiz(question: 'What do digit separators (apostrophes) do in C++14 numeric literals?', options: [
      QuizOption(text: 'They are purely visual — ignored by the compiler, improving readability', correct: true),
      QuizOption(text: 'They divide the number into segments for bitwise operations', correct: false),
      QuizOption(text: 'They indicate the number is in a different base', correct: false),
      QuizOption(text: 'They round the number to the nearest thousand', correct: false),
    ]),
  ],
);
