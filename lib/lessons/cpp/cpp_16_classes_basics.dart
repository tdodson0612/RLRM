// lib/lessons/cpp/cpp_16_classes_basics.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson16 = Lesson(
  language: 'C++',
  title: 'Classes and Objects: Basics',
  content: '''
🎯 METAPHOR:
A class is a blueprint for a house.
The blueprint describes how many rooms, where the doors go,
what materials to use. An object is the ACTUAL house built
from that blueprint. You can build many houses from one
blueprint — each has the same structure but different
paint colors, furniture, and people living inside.
The blueprint = class. The house = object (instance).

📖 EXPLANATION:
A class bundles together:
  - DATA (member variables / fields) — what it KNOWS
  - BEHAVIOR (member functions / methods) — what it CAN DO

This is the core idea of Object-Oriented Programming (OOP):
group related data and functions together into one unit.

─────────────────────────────────────
ACCESS MODIFIERS:
─────────────────────────────────────
private   → only accessible inside the class (default)
public    → accessible from anywhere
protected → accessible inside class and subclasses
─────────────────────────────────────

STRUCT vs CLASS in C++:
The only difference is default access:
  struct → members are public by default
  class  → members are private by default
Prefer class for OOP; struct for simple data containers.

💻 CODE:
#include <iostream>
#include <string>

class Dog {
private:
    // Data members — private by default
    std::string name;
    int age;
    std::string breed;

public:
    // Constructor — called when object is created
    Dog(std::string n, int a, std::string b) {
        name = n;
        age = a;
        breed = b;
    }

    // Member functions (methods)
    void bark() {
        std::cout << name << " says: Woof!" << std::endl;
    }

    void describe() {
        std::cout << name << " is a " << age
                  << "-year-old " << breed << std::endl;
    }

    // Getters — controlled read access to private data
    std::string getName() { return name; }
    int getAge() { return age; }

    // Setter — controlled write access
    void setAge(int a) {
        if (a >= 0) age = a;  // validation!
    }
};

int main() {
    // Create objects (instances of Dog)
    Dog dog1("Rex", 3, "German Shepherd");
    Dog dog2("Luna", 5, "Labrador");

    dog1.bark();        // Rex says: Woof!
    dog2.describe();    // Luna is a 5-year-old Labrador

    // Access through getter
    std::cout << dog1.getName() << std::endl;  // Rex

    // dog1.name = "Max";  // ERROR — name is private!
    dog1.setAge(4);         // OK — goes through setter

    return 0;
}

📝 KEY POINTS:
✅ Keep data members private — expose them through getters/setters
✅ Getters/setters let you add validation and control access
✅ One class = one concept (Single Responsibility Principle)
✅ struct is fine for simple data with no behavior
❌ Don't make everything public — defeats the purpose of encapsulation
❌ Don't put implementation in header files for large projects
   (keep declarations in .h, definitions in .cpp)
''',
  quiz: [
    Quiz(question: 'What is the default access level for class members in C++?', options: [
      QuizOption(text: 'private', correct: true),
      QuizOption(text: 'public', correct: false),
      QuizOption(text: 'protected', correct: false),
      QuizOption(text: 'internal', correct: false),
    ]),
    Quiz(question: 'What is the difference between a class and an object?', options: [
      QuizOption(text: 'A class is the blueprint; an object is an instance built from it', correct: true),
      QuizOption(text: 'A class holds data; an object holds methods', correct: false),
      QuizOption(text: 'An object is the blueprint; a class is the instance', correct: false),
      QuizOption(text: 'They are the same thing with different names', correct: false),
    ]),
    Quiz(question: 'Why should data members typically be private?', options: [
      QuizOption(text: 'To control access and allow validation through getters/setters', correct: true),
      QuizOption(text: 'Because private members run faster', correct: false),
      QuizOption(text: 'Because public members cannot be modified', correct: false),
      QuizOption(text: 'To prevent the class from being inherited', correct: false),
    ]),
  ],
);
