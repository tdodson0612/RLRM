// lib/lessons/cpp/cpp_19_polymorphism.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson19 = Lesson(
  language: 'C++',
  title: 'Polymorphism and Virtual Functions',
  content: '''
🎯 METAPHOR:
Polymorphism is like a universal remote control.
The same "PLAY" button works on a DVD player, a TV, a Blu-ray —
each device responds differently to the same command.
You don't need a different remote for each device.
In C++: you call the same method on different objects,
and each one does it its own way. One interface, many forms.

📖 EXPLANATION:
Polymorphism means "many forms." In C++ it comes in two kinds:

COMPILE-TIME (static) polymorphism:
  - Function overloading
  - Templates
  Resolved at compile time — fast

RUNTIME (dynamic) polymorphism:
  - Virtual functions + inheritance
  Resolved at runtime — slightly slower but very powerful

VIRTUAL FUNCTIONS:
  Declared with virtual in the base class.
  Derived classes override them.
  When called through a base pointer/reference, C++ calls
  the DERIVED version — this is dynamic dispatch.

VTABLE: How it works under the hood
  Every class with virtual functions gets a vtable
  (virtual function table) — a lookup table of function pointers.
  At runtime, C++ looks up which version to call. This is
  why virtual functions have a tiny performance overhead.

PURE VIRTUAL / ABSTRACT CLASS:
  virtual void speak() = 0;   // pure virtual
  Any class with a pure virtual function is ABSTRACT —
  you cannot create instances of it directly.
  Forces all derived classes to implement the method.

💻 CODE:
#include <iostream>
#include <vector>
#include <memory>

class Shape {
public:
    // Pure virtual — Shape is now abstract
    virtual double area() const = 0;
    virtual void describe() const = 0;

    // Virtual destructor — ALWAYS needed in base classes!
    virtual ~Shape() {}
};

class Circle : public Shape {
    double radius;
public:
    Circle(double r) : radius(r) {}
    double area() const override { return 3.14159 * radius * radius; }
    void describe() const override {
        std::cout << "Circle with radius " << radius
                  << ", area = " << area() << std::endl;
    }
};

class Rectangle : public Shape {
    double width, height;
public:
    Rectangle(double w, double h) : width(w), height(h) {}
    double area() const override { return width * height; }
    void describe() const override {
        std::cout << "Rectangle " << width << "x" << height
                  << ", area = " << area() << std::endl;
    }
};

int main() {
    // Polymorphism in action — vector of base class pointers
    std::vector<std::unique_ptr<Shape>> shapes;
    shapes.push_back(std::make_unique<Circle>(5.0));
    shapes.push_back(std::make_unique<Rectangle>(4.0, 6.0));
    shapes.push_back(std::make_unique<Circle>(3.0));

    // Same call — different behavior per type
    double totalArea = 0;
    for (const auto& shape : shapes) {
        shape->describe();         // virtual dispatch!
        totalArea += shape->area();
    }
    std::cout << "Total area: " << totalArea << std::endl;

    // Shape s;  // ERROR: cannot instantiate abstract class

    return 0;
}

─────────────────────────────────────
VIRTUAL DESTRUCTOR RULE:
─────────────────────────────────────
If a class has ANY virtual function, its destructor
must also be virtual. Otherwise, deleting a derived
object through a base pointer won't call the derived
destructor → resource leak!
─────────────────────────────────────

📝 KEY POINTS:
✅ Use virtual for any method you expect to be overridden
✅ ALWAYS declare a virtual destructor in base classes
✅ Pure virtual (= 0) makes a class abstract — cannot be instantiated
✅ override keyword confirms you're overriding a virtual function
✅ Use base class pointers/references to achieve runtime polymorphism
❌ Forgetting virtual destructor is a classic C++ resource leak bug
❌ Calling virtual functions in constructors/destructors doesn't work as expected
''',
  quiz: [
    Quiz(question: 'What makes a class abstract in C++?', options: [
      QuizOption(text: 'Having at least one pure virtual function (= 0)', correct: true),
      QuizOption(text: 'Using the abstract keyword', correct: false),
      QuizOption(text: 'Having only private constructors', correct: false),
      QuizOption(text: 'Inheriting from another class', correct: false),
    ]),
    Quiz(question: 'Why must base classes have a virtual destructor?', options: [
      QuizOption(text: 'So deleting a derived object through a base pointer calls the correct destructor', correct: true),
      QuizOption(text: 'To allow the class to be inherited', correct: false),
      QuizOption(text: 'To enable pure virtual functions', correct: false),
      QuizOption(text: 'Virtual destructors are optional — it is just a best practice', correct: false),
    ]),
    Quiz(question: 'What is a vtable?', options: [
      QuizOption(text: 'A runtime lookup table used to dispatch virtual function calls', correct: true),
      QuizOption(text: 'A table of all class variables', correct: false),
      QuizOption(text: 'A list of all inherited methods', correct: false),
      QuizOption(text: 'A compile-time optimization structure', correct: false),
    ]),
  ],
);
