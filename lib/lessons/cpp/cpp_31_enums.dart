// lib/lessons/cpp/cpp_31_enums.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson31 = Lesson(
  language: 'C++',
  title: 'Enums and Enum Classes',
  content: '''
🎯 METAPHOR:
An enum is like a set of labeled light switches on a panel.
Instead of saying "set the switch to position 2" (magic number),
you say "set it to MEDIUM." The label makes the code read
like English, prevents invalid values, and documents intent.
Without enums: if (day == 3) — what's 3? Wednesday? March?
With enums: if (day == Day::WEDNESDAY) — crystal clear.

📖 EXPLANATION:
C++ has two kinds of enums:

1. C-style enum (plain enum) — old, leaks names into scope
2. enum class (scoped enum, C++11) — modern, preferred

─────────────────────────────────────
PLAIN ENUM (avoid in new code):
─────────────────────────────────────
enum Color { RED, GREEN, BLUE };
Color c = RED;  // RED leaks into global scope
int x = RED;    // implicit conversion to int — dangerous

─────────────────────────────────────
ENUM CLASS (preferred, C++11):
─────────────────────────────────────
enum class Color { RED, GREEN, BLUE };
Color c = Color::RED;  // must use scope
// int x = Color::RED;  // ERROR — no implicit conversion
─────────────────────────────────────

By default, enum values start at 0 and increment by 1.
You can set explicit values.

💻 CODE:
#include <iostream>
#include <string>

// Scoped enum — best practice
enum class Direction { NORTH, SOUTH, EAST, WEST };

// Explicit underlying type (default is int)
enum class Status : uint8_t {
    OK       = 200,
    NOT_FOUND = 404,
    ERROR    = 500
};

// Bit flags with enum class
enum class Permission : unsigned int {
    NONE    = 0,
    READ    = 1 << 0,  // 1
    WRITE   = 1 << 1,  // 2
    EXECUTE = 1 << 2,  // 4
    ALL     = READ | WRITE | EXECUTE  // 7
};

std::string directionToString(Direction d) {
    switch (d) {
        case Direction::NORTH: return "North";
        case Direction::SOUTH: return "South";
        case Direction::EAST:  return "East";
        case Direction::WEST:  return "West";
        default: return "Unknown";
    }
}

int main() {
    Direction d = Direction::NORTH;
    std::cout << directionToString(d) << std::endl;  // North

    // Must use scope resolution
    Status s = Status::OK;
    std::cout << static_cast<int>(s) << std::endl;  // 200

    // Comparison
    if (s == Status::OK) {
        std::cout << "Request succeeded" << std::endl;
    }

    // Bit flags
    unsigned int perms = static_cast<unsigned int>(Permission::READ)
                       | static_cast<unsigned int>(Permission::WRITE);

    bool canRead = perms & static_cast<unsigned int>(Permission::READ);
    std::cout << "Can read: " << canRead << std::endl;  // 1

    // Plain enum (old style — know it exists)
    enum Season { SPRING, SUMMER, FALL, WINTER };
    Season season = SUMMER;  // no scope needed — but pollutes namespace
    std::cout << season << std::endl;  // 1 (implicit int)

    return 0;
}

📝 KEY POINTS:
✅ Always use enum class in modern C++ — scoped, type-safe
✅ Use explicit underlying types when size matters (uint8_t, etc.)
✅ Use switch with enums — compiler warns if you miss a case
✅ Use static_cast<int> to get the numeric value
❌ Avoid plain enums — they pollute the surrounding namespace
❌ Don't rely on enum values being specific integers unless you set them explicitly
''',
  quiz: [
    Quiz(question: 'What is the main advantage of enum class over plain enum?', options: [
      QuizOption(text: 'enum class is scoped and does not allow implicit conversion to int', correct: true),
      QuizOption(text: 'enum class supports more values', correct: false),
      QuizOption(text: 'enum class compiles faster', correct: false),
      QuizOption(text: 'enum class allows string values', correct: false),
    ]),
    Quiz(question: 'What is the default starting value of enum members?', options: [
      QuizOption(text: '0, incrementing by 1', correct: true),
      QuizOption(text: '1, incrementing by 1', correct: false),
      QuizOption(text: 'Undefined until explicitly set', correct: false),
      QuizOption(text: '-1, incrementing by 1', correct: false),
    ]),
    Quiz(question: 'How do you access an enum class value?', options: [
      QuizOption(text: 'EnumName::VALUE using scope resolution', correct: true),
      QuizOption(text: 'Just the value name like a plain enum', correct: false),
      QuizOption(text: 'EnumName.VALUE using dot notation', correct: false),
      QuizOption(text: 'EnumName->VALUE using arrow notation', correct: false),
    ]),
  ],
);
