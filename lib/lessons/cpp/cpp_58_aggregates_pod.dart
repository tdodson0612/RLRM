// lib/lessons/cpp/cpp_58_aggregates_pod.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson58 = Lesson(
  language: 'C++',
  title: 'Aggregates, POD Types, and Designated Initializers',
  content: '''
🎯 METAPHOR:
A POD type is like a plain wooden crate.
No hinges, no locks, no special mechanisms — just wood
and space. You can copy it by physically duplicating
the wood and contents. You can memcpy it.
You can send it over a network as raw bytes.
It is simple, predictable, and totally transparent.
A class with virtual functions and custom destructors
is like a safe with a combination lock — copying it
by duplicating the metal box misses the whole point.

📖 EXPLANATION:
AGGREGATE:
  A class/struct with no user-provided constructors,
  no private/protected non-static data members,
  no base classes (C++11), and no virtual functions.
  Supports aggregate initialization: Type t = {val1, val2, ...}

POD (Plain Old Data):
  An aggregate that is also trivially copyable and has a
  trivial layout. Can be safely memcpy'd and used with C APIs.
  Requirements: trivial default constructor, trivial copy,
  trivial destructor, standard layout.

DESIGNATED INITIALIZERS (C++20):
  Name the fields you are initializing: Point{.x = 1, .y = 2}
  Cleaner than positional initialization.

💻 CODE:
#include <iostream>
#include <cstring>
#include <type_traits>

// ─── AGGREGATE ───
struct Point {
    int x;
    int y;
    int z = 0;  // default member initializer (C++11) — still aggregate in C++14+
};

struct Color {
    uint8_t r, g, b, a;
};

// NOT an aggregate — has user constructor
struct NotAggregate {
    int x;
    NotAggregate(int x) : x(x) {}  // user-provided constructor
};

// ─── AGGREGATE INITIALIZATION ───
int main() {
    Point p1 = {1, 2, 3};    // positional
    Point p2 = {1, 2};       // z defaults to 0
    Point p3{4, 5, 6};       // brace init (same thing)

    std::cout << p1.x << " " << p1.y << " " << p1.z << std::endl;  // 1 2 3
    std::cout << p2.z << std::endl;  // 0

    Color red = {255, 0, 0, 255};
    std::cout << (int)red.r << std::endl;  // 255

    // ─── DESIGNATED INITIALIZERS (C++20) ───
    Point p4 = {.x = 10, .y = 20};        // z defaults to 0
    Point p5 = {.x = 5, .z = 100};        // y = 0 (default), z = 100
    std::cout << p4.x << " " << p4.y << " " << p4.z << std::endl;  // 10 20 0
    std::cout << p5.x << " " << p5.y << " " << p5.z << std::endl;  //  5  0 100

    // Clear, readable struct initialization
    Color skyBlue = {.r = 135, .g = 206, .b = 235, .a = 255};
    std::cout << (int)skyBlue.g << std::endl;  // 206

    // ─── POD / TRIVIAL CHECKS ───
    std::cout << std::boolalpha;
    std::cout << "Point is trivial: "
              << std::is_trivial<Point>::value << std::endl;  // true
    std::cout << "Point is POD: "
              << std::is_pod<Point>::value << std::endl;      // true (deprecated in C++20 but works)
    std::cout << "NotAggregate is aggregate: "
              << std::is_aggregate<NotAggregate>::value << std::endl; // false

    // POD types can be safely memcpy'd
    Point src = {10, 20, 30};
    Point dst;
    std::memcpy(&dst, &src, sizeof(Point));  // safe for POD
    std::cout << dst.x << " " << dst.y << " " << dst.z << std::endl;  // 10 20 30

    // Array of aggregates
    Point points[] = {{1,1,1}, {2,2,2}, {3,3,3}};
    for (const auto& pt : points) {
        std::cout << pt.x << " ";
    }
    std::cout << std::endl;

    // ─── STANDARD LAYOUT ───
    struct StandardLayout {
        int x;
        double y;
        // no virtual, no mixed access, no weird base classes
    };

    std::cout << "StandardLayout is_standard_layout: "
              << std::is_standard_layout<StandardLayout>::value << std::endl;  // true

    // Useful for interop with C code and serialization
    // The first member's address == the struct's address
    StandardLayout sl = {42, 3.14};
    int* firstMember = reinterpret_cast<int*>(&sl);
    std::cout << *firstMember << std::endl;  // 42

    return 0;
}

📝 KEY POINTS:
✅ Aggregates support {} initialization without needing a constructor
✅ Designated initializers (C++20) name fields for clarity and safety
✅ POD types can be memcpy'd and used directly with C APIs
✅ Use type traits (is_trivial, is_aggregate) to verify at compile time
✅ Designated initializers must be in declaration order — you can skip fields
❌ Designated initializers cannot reorder fields: {.y = 1, .x = 2} is an error
❌ Adding a user-provided constructor to a struct removes aggregate status
''',
  quiz: [
    Quiz(question: 'What does "aggregate initialization" allow?', options: [
      QuizOption(text: 'Initializing struct/class members with {} without a constructor', correct: true),
      QuizOption(text: 'Combining two objects into one', correct: false),
      QuizOption(text: 'Initializing an array of objects all to the same value', correct: false),
      QuizOption(text: 'Automatically generating all constructors', correct: false),
    ]),
    Quiz(question: 'What is the main benefit of a POD type?', options: [
      QuizOption(text: 'It can be safely copied with memcpy and used in C APIs', correct: true),
      QuizOption(text: 'It uses less memory than non-POD types', correct: false),
      QuizOption(text: 'It prevents accidental copies', correct: false),
      QuizOption(text: 'It can be serialized to XML automatically', correct: false),
    ]),
    Quiz(question: 'What do C++20 designated initializers allow you to do?', options: [
      QuizOption(text: 'Initialize struct members by name instead of position', correct: true),
      QuizOption(text: 'Initialize members in any order regardless of declaration', correct: false),
      QuizOption(text: 'Automatically generate getters for named fields', correct: false),
      QuizOption(text: 'Initialize multiple structs with the same values', correct: false),
    ]),
  ],
);
