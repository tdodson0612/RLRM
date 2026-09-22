// lib/lessons/cpp/cpp_39_optional_variant.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson39 = Lesson(
  language: 'C++',
  title: 'std::optional and std::variant',
  content: '''
🎯 METAPHOR:
std::optional is like a gift box that might be empty.
You shake it (check has_value()), and if there is something
inside, you open it (use .value()). If it is empty, you
handle that gracefully instead of crashing.
Compare to a function that returns -1 to mean "not found"
— that is a hack. optional makes the absence explicit.

std::variant is like a labeled shipping box that can hold
exactly ONE type from a list of allowed types.
The box always knows what type is inside, and you must
handle each possibility. A "type-safe union."

📖 EXPLANATION:
std::optional<T>  (C++17) — a value that might not exist
std::variant<T1, T2, ...> (C++17) — one of several possible types
std::any (C++17) — can hold any type (less safe)

These replace common C++ anti-patterns:
  - Returning nullptr to mean "not found" → use optional
  - Using void* or union for mixed types → use variant
  - Magic values like -1, "", 0 to signal failure → use optional

💻 CODE:
#include <iostream>
#include <optional>
#include <variant>
#include <string>
#include <vector>

// ─── std::optional ───
std::optional<int> findAge(const std::string& name) {
    if (name == "Alice") return 30;
    if (name == "Bob")   return 25;
    return std::nullopt;  // nothing found
}

std::optional<double> safeDivide(double a, double b) {
    if (b == 0.0) return std::nullopt;
    return a / b;
}

// ─── std::variant ───
using JsonValue = std::variant<int, double, std::string, bool>;

void printJsonValue(const JsonValue& val) {
    // std::visit dispatches to the correct handler
    std::visit([](const auto& v) {
        std::cout << v << std::endl;
    }, val);
}

int main() {
    // ─── OPTIONAL ───
    auto age = findAge("Alice");
    if (age.has_value()) {
        std::cout << "Age: " << age.value() << std::endl;  // 30
    }

    auto missing = findAge("Charlie");
    if (!missing) {  // operator bool works too
        std::cout << "Not found" << std::endl;
    }

    // value_or — default if empty
    std::cout << findAge("Bob").value_or(0) << std::endl;     // 25
    std::cout << findAge("Dave").value_or(-1) << std::endl;   // -1

    // Safe divide
    auto result = safeDivide(10.0, 3.0);
    if (result) std::cout << *result << std::endl;  // * works too

    auto badDiv = safeDivide(10.0, 0.0);
    if (!badDiv) std::cout << "Cannot divide by zero" << std::endl;

    // ─── VARIANT ───
    std::vector<JsonValue> data = {42, 3.14, std::string("hello"), true};

    for (const auto& val : data) {
        printJsonValue(val);
    }

    // Check which type is active
    JsonValue v = std::string("world");
    if (std::holds_alternative<std::string>(v)) {
        std::cout << "It's a string: " << std::get<std::string>(v) << std::endl;
    }

    // std::get throws if wrong type
    try {
        int x = std::get<int>(v);  // throws — v holds string
    } catch (const std::bad_variant_access& e) {
        std::cout << "Wrong type!" << std::endl;
    }

    // std::get_if — safe version (returns pointer, nullptr if wrong type)
    if (auto* s = std::get_if<std::string>(&v)) {
        std::cout << *s << std::endl;  // world
    }

    return 0;
}

📝 KEY POINTS:
✅ Use optional instead of magic values (-1, nullptr, "") to signal absence
✅ value_or() gives a clean default without an if statement
✅ Use variant for type-safe tagged unions
✅ std::visit with a lambda is the cleanest way to handle variant values
✅ std::get_if is safer than std::get — returns nullptr instead of throwing
❌ Calling .value() on an empty optional throws std::bad_optional_access
❌ Don't use std::any unless you truly need a completely unknown type
''',
  quiz: [
    Quiz(question: 'What does std::nullopt represent?', options: [
      QuizOption(text: 'An empty optional — representing the absence of a value', correct: true),
      QuizOption(text: 'A null pointer', correct: false),
      QuizOption(text: 'A zero value for numeric types', correct: false),
      QuizOption(text: 'An uninitialized optional', correct: false),
    ]),
    Quiz(question: 'What does optional.value_or(default) do?', options: [
      QuizOption(text: 'Returns the value if present, or the default if empty', correct: true),
      QuizOption(text: 'Sets the optional to the default if empty', correct: false),
      QuizOption(text: 'Throws an exception if the value equals the default', correct: false),
      QuizOption(text: 'Returns the default always', correct: false),
    ]),
    Quiz(question: 'What is std::variant used for?', options: [
      QuizOption(text: 'Holding exactly one value of several possible types in a type-safe way', correct: true),
      QuizOption(text: 'Storing multiple values of different types simultaneously', correct: false),
      QuizOption(text: 'Replacing pointers with safer alternatives', correct: false),
      QuizOption(text: 'Creating optional function parameters', correct: false),
    ]),
  ],
);
