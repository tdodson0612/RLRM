// lib/lessons/cpp/cpp_48_multiple_inheritance.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson48 = Lesson(
  language: 'C++',
  title: 'Multiple Inheritance and the Diamond Problem',
  content: '''
🎯 METAPHOR:
Multiple inheritance is like a child born to two parents —
they inherit traits from both. That's usually fine.
The Diamond Problem is like being born to two parents who
are BOTH children of the same grandparent. Now the question
is: do you have ONE copy of grandparent's DNA, or TWO?
Without virtual inheritance, C++ gives you TWO — ambiguous
and wasteful. Virtual inheritance ensures the grandparent
exists only ONCE in the family tree.

📖 EXPLANATION:
C++ allows a class to inherit from MULTIPLE base classes.
This is powerful but comes with risks.

─────────────────────────────────────
THE DIAMOND PROBLEM:
─────────────────────────────────────
        Animal
       /      \\
    Flyable  Swimmable
       \\      /
         Duck

Without virtual: Duck has TWO copies of Animal.
With virtual:    Duck has ONE copy of Animal.
─────────────────────────────────────

INTERFACE SIMULATION:
Multiple inheritance is most safely used when the additional
base classes are pure abstract (interface-like) classes
with no data members.

💻 CODE:
#include <iostream>
#include <string>

// ─── BASIC MULTIPLE INHERITANCE ───
class Flyable {
public:
    virtual void fly() {
        std::cout << "Flying!" << std::endl;
    }
    virtual ~Flyable() {}
};

class Swimmable {
public:
    virtual void swim() {
        std::cout << "Swimming!" << std::endl;
    }
    virtual ~Swimmable() {}
};

class Duck : public Flyable, public Swimmable {
public:
    void fly() override {
        std::cout << "Duck flying low over water" << std::endl;
    }
    void swim() override {
        std::cout << "Duck paddling gracefully" << std::endl;
    }
    void quack() {
        std::cout << "Quack!" << std::endl;
    }
};

// ─── THE DIAMOND PROBLEM ───
class Animal {
public:
    std::string name = "Animal";
    void breathe() { std::cout << "Breathing" << std::endl; }
};

// WITHOUT virtual inheritance — creates two Animal subobjects
class Mammal : public Animal {
public:
    void walk() { std::cout << "Walking" << std::endl; }
};

class WingedAnimal : public Animal {
public:
    void flap() { std::cout << "Flapping" << std::endl; }
};

// This creates ambiguity — which Animal::name?
class Bat_Ambiguous : public Mammal, public WingedAnimal {
    // bat.name;  // ERROR: ambiguous — Mammal::name or WingedAnimal::name?
};

// ─── SOLUTION: VIRTUAL INHERITANCE ───
class AnimalV {
public:
    std::string name = "AnimalV";
    void breathe() { std::cout << "Breathing (virtual)" << std::endl; }
};

class MammalV : virtual public AnimalV {  // virtual keyword here
public:
    void walk() { std::cout << "Walking" << std::endl; }
};

class WingedAnimalV : virtual public AnimalV {  // and here
public:
    void flap() { std::cout << "Flapping" << std::endl; }
};

class Bat : public MammalV, public WingedAnimalV {
public:
    void describe() { std::cout << name << std::endl; }  // unambiguous now!
};

// ─── SAFE PATTERN: Pure abstract interfaces ───
class ISaveable {
public:
    virtual void save() = 0;
    virtual ~ISaveable() {}
};

class IPrintable {
public:
    virtual void print() = 0;
    virtual ~IPrintable() {}
};

class Document : public ISaveable, public IPrintable {
    std::string content;
public:
    Document(std::string c) : content(c) {}
    void save() override { std::cout << "Saving: " << content << std::endl; }
    void print() override { std::cout << "Printing: " << content << std::endl; }
};

int main() {
    Duck duck;
    duck.fly();
    duck.swim();
    duck.quack();

    // Polymorphism through multiple interfaces
    Flyable* f = &duck;
    f->fly();

    Swimmable* s = &duck;
    s->swim();

    // Virtual inheritance — no diamond ambiguity
    Bat bat;
    bat.breathe();    // ONE Animal — no ambiguity
    bat.walk();
    bat.flap();
    bat.describe();   // "AnimalV"

    // Interface pattern
    Document doc("Hello World");
    doc.save();
    doc.print();

    return 0;
}

─────────────────────────────────────
CONSTRUCTOR ORDER WITH VIRTUAL:
─────────────────────────────────────
Virtual base class constructor is called by the MOST
DERIVED class — not by the intermediate classes.
Bat() must call AnimalV() directly in its initializer list.
─────────────────────────────────────

📝 KEY POINTS:
✅ Multiple inheritance is safe when extra bases are pure abstract interfaces
✅ Use virtual inheritance to solve the diamond problem
✅ The most derived class calls the virtual base constructor
✅ Prefer the interface pattern (pure abstract classes) over data-bearing MI
❌ Don't use multiple inheritance with data-bearing base classes if avoidable
❌ Virtual inheritance has a small runtime overhead (extra pointer per virtual base)
❌ Deep diamond hierarchies are a design smell — consider composition instead
''',
  quiz: [
    Quiz(question: 'What is the Diamond Problem in C++?', options: [
      QuizOption(text: 'Ambiguity from inheriting the same base class twice through two different paths', correct: true),
      QuizOption(text: 'A performance issue when inheriting from more than two classes', correct: false),
      QuizOption(text: 'A compile error when two parent classes have the same method name', correct: false),
      QuizOption(text: 'A memory leak caused by multiple destructors', correct: false),
    ]),
    Quiz(question: 'How do you solve the Diamond Problem in C++?', options: [
      QuizOption(text: 'Use virtual inheritance on the intermediate classes', correct: true),
      QuizOption(text: 'Use override on all methods', correct: false),
      QuizOption(text: 'Use private inheritance', correct: false),
      QuizOption(text: 'Avoid using the shared base class methods', correct: false),
    ]),
    Quiz(question: 'What is the safest way to use multiple inheritance?', options: [
      QuizOption(text: 'Inherit from pure abstract interface classes that have no data members', correct: true),
      QuizOption(text: 'Always use virtual inheritance for all base classes', correct: false),
      QuizOption(text: 'Limit inheritance to exactly two base classes', correct: false),
      QuizOption(text: 'Use private inheritance for all but one base', correct: false),
    ]),
  ],
);
