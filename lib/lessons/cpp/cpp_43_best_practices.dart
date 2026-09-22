// lib/lessons/cpp/cpp_43_best_practices.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson43 = Lesson(
  language: 'C++',
  title: 'Best Practices and Common Pitfalls',
  content: '''
🎯 METAPHOR:
Best practices are the "house rules" developed by thousands
of programmers after thousands of hours of painful bugs.
They are not arbitrary — each one exists because someone
got burned without it. Learning them now is like reading
all the warning labels before using a power tool. You could
skip them — but the scars are not worth the shortcut.

📖 EXPLANATION:
The C++ Core Guidelines (by Bjarne Stroustrup and Herb Sutter)
are the canonical reference for modern C++ best practices.
Here is a distilled tour of the most important ones.

─────────────────────────────────────
RESOURCE MANAGEMENT:
─────────────────────────────────────
✅ Use smart pointers — never raw new/delete
✅ Follow RAII — tie resources to object lifetimes
✅ Prefer stack allocation over heap when possible
✅ Rule of Five: if you write destructor, write all 5
✅ Rule of Zero: prefer to write none of the 5 by using
   composable RAII types (vector, string, unique_ptr)

─────────────────────────────────────
DESIGN PRINCIPLES:
─────────────────────────────────────
✅ Single Responsibility — one class, one purpose
✅ Prefer composition over inheritance
✅ Program to interfaces (abstract base classes)
✅ Keep functions short (fits on one screen)
✅ Make interfaces hard to use wrong
✅ const correctness — mark everything const that can be

─────────────────────────────────────
TYPE SAFETY:
─────────────────────────────────────
✅ Use enum class over plain enum
✅ Use named casts over C-style casts
✅ Use std::optional instead of nullptr/"magic values"
✅ Use std::variant over void* or union
✅ Use string_view over const char* parameters

─────────────────────────────────────
PERFORMANCE:
─────────────────────────────────────
✅ Pass large objects by const reference, not by value
✅ Reserve vector capacity when size is known
✅ Use emplace_back over push_back for complex objects
✅ Prefer std::move for objects you no longer need
✅ Profile before optimizing — do not guess

💻 CODE:
#include <iostream>
#include <vector>
#include <memory>
#include <string>

// ─── CONST CORRECTNESS ───
class Rectangle {
    double w, h;
public:
    Rectangle(double w, double h) : w(w), h(h) {}

    // const method — doesn't modify the object
    double area() const { return w * h; }

    // Non-const — modifies the object
    void scale(double factor) { w *= factor; h *= factor; }
};

// ─── PREFER CONST REFERENCES FOR LARGE PARAMETERS ───
void processData(const std::vector<int>& data) {  // no copy!
    for (const auto& val : data) {
        std::cout << val << " ";
    }
}

// ─── EMPLACE_BACK vs PUSH_BACK ───
struct Point { int x, y; };

// ─── INTERFACE DESIGN: MAKE WRONG USE IMPOSSIBLE ───
class Temperature {
    double kelvin;  // always stored in Kelvin
    explicit Temperature(double k) : kelvin(k) {}  // explicit prevents accidental conversion
public:
    static Temperature fromCelsius(double c) { return Temperature(c + 273.15); }
    static Temperature fromFahrenheit(double f) { return Temperature((f - 32) * 5.0/9.0 + 273.15); }
    double toCelsius() const { return kelvin - 273.15; }
    double toKelvin() const { return kelvin; }
};

int main() {
    // ─── CONST CORRECTNESS ───
    const Rectangle r(4.0, 5.0);
    std::cout << r.area() << std::endl;  // 20
    // r.scale(2.0);  // ERROR — can't modify const object

    // ─── EFFICIENT VECTOR USAGE ───
    std::vector<int> data;
    data.reserve(100);  // avoid reallocations
    for (int i = 0; i < 100; i++) data.push_back(i);

    processData(data);  // passed by const ref — no copy

    // emplace_back constructs IN PLACE (no copy/move)
    std::vector<Point> points;
    points.emplace_back(1, 2);  // builds Point directly in vector
    points.emplace_back(3, 4);
    // points.push_back({5, 6});  // creates temp then moves

    // ─── INTERFACE DESIGN ───
    auto temp = Temperature::fromCelsius(100.0);
    std::cout << temp.toKelvin() << std::endl;   // 373.15
    // Temperature t(373.15);  // ERROR — explicit constructor

    // ─── AVOID MAGIC NUMBERS ───
    constexpr int MAX_RETRIES = 3;  // named constant
    constexpr double TAX_RATE  = 0.08;

    for (int attempt = 0; attempt < MAX_RETRIES; attempt++) {
        // ... try operation ...
    }

    return 0;
}

📝 KEY POINTS:
✅ const everything that should not change — compiler enforces it
✅ emplace_back constructs in-place; push_back copies or moves
✅ explicit constructors prevent unintended implicit conversions
✅ Named constants (constexpr) beat magic numbers every time
✅ The best code is code that compiles only when used correctly
❌ Don't optimize prematurely — profile first
❌ Don't ignore compiler warnings — -Wall -Wextra catches real bugs
❌ Don't use mutable to work around const — redesign instead
''',
  quiz: [
    Quiz(question: 'What does the "Rule of Zero" mean in modern C++?', options: [
      QuizOption(text: 'Write none of the five special functions by using composable RAII types', correct: true),
      QuizOption(text: 'Never allocate zero bytes of memory', correct: false),
      QuizOption(text: 'Always initialize variables to zero', correct: false),
      QuizOption(text: 'Use zero raw pointers in a class', correct: false),
    ]),
    Quiz(question: 'What is the advantage of emplace_back over push_back?', options: [
      QuizOption(text: 'emplace_back constructs the object directly in the vector — no copy or move', correct: true),
      QuizOption(text: 'emplace_back is safer for const vectors', correct: false),
      QuizOption(text: 'emplace_back only works with primitive types', correct: false),
      QuizOption(text: 'push_back is always preferred in modern C++', correct: false),
    ]),
    Quiz(question: 'What does marking a constructor explicit do?', options: [
      QuizOption(text: 'Prevents the compiler from using it for implicit type conversions', correct: true),
      QuizOption(text: 'Makes the constructor run at compile time', correct: false),
      QuizOption(text: 'Requires the caller to use a keyword when constructing', correct: false),
      QuizOption(text: 'Prevents the class from being inherited', correct: false),
    ]),
  ],
);
