// lib/lessons/cpp/cpp_32_structs.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson32 = Lesson(
  language: 'C++',
  title: 'Structs',
  content: '''
🎯 METAPHOR:
A struct is like a form or a record card.
A patient record has: name, age, diagnosis, blood type.
These are just DATA — grouped together because they belong
to the same thing. No complex behavior, no access control.
Just: "here are the fields that describe this entity."
Use struct for plain data. Use class for objects with behavior.

📖 EXPLANATION:
In C++, struct and class are nearly identical — the only
real difference is default access (struct = public, class = private).

CONVENTION:
  struct — for simple data containers (POD: Plain Old Data)
  class  — for objects with behavior, invariants, encapsulation

Modern C++ uses structs freely for:
  - Return values with multiple fields
  - Configuration options
  - Data transfer objects
  - Aggregate initialization

💻 CODE:
#include <iostream>
#include <string>
#include <vector>

// Basic struct
struct Point {
    double x;
    double y;
};

// Struct with default values (C++11)
struct Config {
    int width = 800;
    int height = 600;
    bool fullscreen = false;
    std::string title = "My App";
};

// Struct with methods (totally valid)
struct Rectangle {
    double width;
    double height;

    double area() const { return width * height; }
    double perimeter() const { return 2 * (width + height); }
    bool isSquare() const { return width == height; }
};

// Nested struct
struct Student {
    std::string name;
    int age;

    struct Grade {
        std::string subject;
        double score;
    };

    std::vector<Grade> grades;

    double average() const {
        if (grades.empty()) return 0;
        double sum = 0;
        for (const auto& g : grades) sum += g.score;
        return sum / grades.size();
    }
};

int main() {
    // Aggregate initialization
    Point p1 = {3.0, 4.0};
    Point p2{1.0, 2.0};  // brace initialization (C++11)

    std::cout << p1.x << ", " << p1.y << std::endl;  // 3, 4

    // Default values
    Config cfg;
    std::cout << cfg.width << "x" << cfg.height << std::endl;  // 800x600

    Config custom{1920, 1080, true, "Game"};
    std::cout << custom.title << std::endl;  // Game

    // Struct with methods
    Rectangle r{4.0, 6.0};
    std::cout << "Area: " << r.area() << std::endl;       // 24
    std::cout << "Perimeter: " << r.perimeter() << std::endl; // 20

    // Nested struct
    Student s;
    s.name = "Alice";
    s.age = 20;
    s.grades.push_back({"Math", 95.0});
    s.grades.push_back({"English", 88.0});
    s.grades.push_back({"Science", 92.0});
    std::cout << s.name << " avg: " << s.average() << std::endl;

    // Pointer to struct
    Point* pp = &p1;
    std::cout << pp->x << std::endl;  // use -> for pointer to struct

    return 0;
}

─────────────────────────────────────
STRUCT vs CLASS summary:
─────────────────────────────────────
struct  public by default  simple data, POD
class   private by default objects with behavior, invariants
─────────────────────────────────────

📝 KEY POINTS:
✅ Use struct for plain data groupings — it signals "just data"
✅ Structs support methods, constructors, inheritance — full C++ features
✅ Use aggregate initialization {} when possible
✅ Use -> to access members through a pointer
✅ Structs with only public data members are trivially copyable
❌ Don't use struct when you need to enforce invariants — use class
❌ Don't confuse C structs (no methods) with C++ structs (full features)
''',
  quiz: [
    Quiz(question: 'What is the only technical difference between struct and class in C++?', options: [
      QuizOption(text: 'struct members are public by default; class members are private', correct: true),
      QuizOption(text: 'struct cannot have methods; class can', correct: false),
      QuizOption(text: 'struct cannot be inherited; class can', correct: false),
      QuizOption(text: 'struct is faster than class at runtime', correct: false),
    ]),
    Quiz(question: 'How do you access struct members through a pointer?', options: [
      QuizOption(text: 'Using the -> arrow operator', correct: true),
      QuizOption(text: 'Using the . dot operator', correct: false),
      QuizOption(text: 'Using the * dereference operator', correct: false),
      QuizOption(text: 'Using the :: scope operator', correct: false),
    ]),
    Quiz(question: 'When is it most appropriate to use a struct over a class?', options: [
      QuizOption(text: 'When grouping related data with no behavioral invariants to enforce', correct: true),
      QuizOption(text: 'When you need virtual functions', correct: false),
      QuizOption(text: 'When the object manages heap memory', correct: false),
      QuizOption(text: 'When you need private data members', correct: false),
    ]),
  ],
);
