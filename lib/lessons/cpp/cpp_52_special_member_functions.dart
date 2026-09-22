// lib/lessons/cpp/cpp_52_special_member_functions.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson52 = Lesson(
  language: 'C++',
  title: 'Special Member Functions: default and delete',
  content: '''
🎯 METAPHOR:
C++ automatically writes certain functions for your class
if you don't — like a contractor who finishes unspecified
rooms with bare concrete. The rooms exist, but they might
not be what you wanted. = default says "actually, use your
automatic version — it is fine." = delete says "don't build
that room at all — I forbid it. Anyone who tries gets a
locked door." Explicit control over what the compiler generates.

📖 EXPLANATION:
C++ automatically generates six "special member functions":
  1. Default constructor
  2. Destructor
  3. Copy constructor
  4. Copy assignment operator
  5. Move constructor       (C++11)
  6. Move assignment operator (C++11)

= default  → explicitly ask the compiler to generate the default
= delete   → explicitly PREVENT the compiler from generating it
             (and prevent callers from using it)

This is the foundation of the Rule of Five / Rule of Zero.

─────────────────────────────────────
WHEN THE COMPILER STOPS AUTO-GENERATING:
─────────────────────────────────────
If you define a destructor    → move ops NOT auto-generated
If you define copy ops        → move ops NOT auto-generated
If you define move ops        → copy ops are deleted
If you define any constructor → default constructor NOT generated
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <string>

// ─── = default ───
class Timer {
    double seconds;
public:
    Timer() = default;              // explicitly use compiler default
    Timer(double s) : seconds(s) {}
    Timer(const Timer&) = default;  // use compiler-generated copy
    Timer& operator=(const Timer&) = default;
    ~Timer() = default;

    double get() const { return seconds; }
};

// ─── = delete: non-copyable class ───
class UniqueResource {
    int id;
public:
    UniqueResource(int i) : id(i) {
        std::cout << "Resource " << id << " acquired" << std::endl;
    }
    ~UniqueResource() {
        std::cout << "Resource " << id << " released" << std::endl;
    }

    // Forbid copying — this resource cannot be duplicated
    UniqueResource(const UniqueResource&) = delete;
    UniqueResource& operator=(const UniqueResource&) = delete;

    // Allow moving — ownership CAN transfer
    UniqueResource(UniqueResource&& other) noexcept : id(other.id) {
        other.id = -1;
        std::cout << "Resource moved" << std::endl;
    }

    int getId() const { return id; }
};

// ─── = delete on free functions ───
// Prevent calling a function with certain types
void process(int x) { std::cout << "Processing int: " << x << std::endl; }
void process(double) = delete;  // prevent double → int implicit conversion
// process(3.14);  // ERROR — deleted!
// process(42);    // OK

// ─── Singleton: prevent all construction except through getInstance ───
class AppLogger {
public:
    AppLogger(const AppLogger&) = delete;
    AppLogger& operator=(const AppLogger&) = delete;

    static AppLogger& getInstance() {
        static AppLogger instance;
        return instance;
    }

    void log(const std::string& msg) {
        std::cout << "[LOG] " << msg << std::endl;
    }

private:
    AppLogger() {}  // private — only getInstance can call this
};

int main() {
    // Timer — defaulted members work fine
    Timer t1;
    Timer t2(5.0);
    Timer t3 = t2;  // copy — works (default copy)
    t1 = t3;        // copy assign — works

    // UniqueResource — non-copyable, but movable
    UniqueResource r1(1);
    // UniqueResource r2 = r1;  // ERROR: copy constructor deleted!
    UniqueResource r2 = std::move(r1);  // OK — move allowed

    std::cout << "r2 id: " << r2.getId() << std::endl;  // 1
    std::cout << "r1 id: " << r1.getId() << std::endl;  // -1 (moved-from)

    // Deleted free function
    process(42);     // OK
    // process(3.14); // ERROR: deleted

    // Singleton
    AppLogger::getInstance().log("App started");
    // AppLogger copy = AppLogger::getInstance();  // ERROR: deleted

    return 0;
}

─────────────────────────────────────
RULE OF FIVE vs RULE OF ZERO:
─────────────────────────────────────
Rule of Five:
  If you write any of the five, write all five.
  (destructor, copy ctor, copy assign, move ctor, move assign)

Rule of Zero:
  Write NONE of the five. Use RAII members (vector, unique_ptr)
  to handle resources automatically. Compiler generates correct
  versions for free.

Rule of Zero is the goal in modern C++.
─────────────────────────────────────

📝 KEY POINTS:
✅ = default makes compiler-generated versions explicit and documented
✅ = delete prevents use of specific operations — compile-time enforcement
✅ = delete on free functions prevents unwanted implicit conversions
✅ Aim for Rule of Zero — let RAII types handle resources
✅ noexcept on move operations enables STL container optimizations
❌ Mixing = default and manual implementations carelessly breaks the Rule of Five
❌ Forgetting = delete on copy ops for non-copyable resources is a common bug
''',
  quiz: [
    Quiz(question: 'What does "= delete" do to a function?', options: [
      QuizOption(text: 'Prevents the function from being called — any attempt is a compile error', correct: true),
      QuizOption(text: 'Removes the function from memory at runtime', correct: false),
      QuizOption(text: 'Makes the function return void', correct: false),
      QuizOption(text: 'Marks the function as deprecated', correct: false),
    ]),
    Quiz(question: 'What is the Rule of Zero in modern C++?', options: [
      QuizOption(text: 'Write none of the five special functions — use RAII types to handle resources', correct: true),
      QuizOption(text: 'Always define all five special functions', correct: false),
      QuizOption(text: 'Never use dynamic memory allocation', correct: false),
      QuizOption(text: 'Always initialize variables to zero', correct: false),
    ]),
    Quiz(question: 'If you define a destructor in C++, what happens to the move constructor?', options: [
      QuizOption(text: 'It is NOT automatically generated by the compiler', correct: true),
      QuizOption(text: 'It is automatically generated as usual', correct: false),
      QuizOption(text: 'It is deleted', correct: false),
      QuizOption(text: 'It falls back to the copy constructor', correct: false),
    ]),
  ],
);
