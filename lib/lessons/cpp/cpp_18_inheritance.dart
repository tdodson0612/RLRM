// lib/lessons/cpp/cpp_18_inheritance.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson18 = Lesson(
  language: 'C++',
  title: 'Inheritance',
  content: '''
🎯 METAPHOR:
Inheritance is like a family tree.
A child inherits their parents' traits — eye color, height,
general personality. But the child also has their own unique
traits. You don't rewrite the DNA from scratch for every
new family member — you build ON TOP of what already exists.
In C++: the child class (derived) inherits from the parent
class (base) and can add or change behavior.

📖 EXPLANATION:
Inheritance lets a class REUSE the code of another class.
The derived class automatically gets all public and protected
members of the base class. It can:
  - Use inherited members as-is
  - Override methods with new behavior
  - Add its own new members

─────────────────────────────────────
INHERITANCE TYPES:
─────────────────────────────────────
public    → public/protected members stay same visibility
protected → public becomes protected
private   → all become private
Almost always use public inheritance.
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <string>

// BASE CLASS (parent)
class Animal {
protected:
    std::string name;
    int age;

public:
    Animal(std::string n, int a) : name(n), age(a) {
        std::cout << name << " (Animal) created" << std::endl;
    }

    void eat() {
        std::cout << name << " is eating" << std::endl;
    }

    void sleep() {
        std::cout << name << " is sleeping" << std::endl;
    }

    // virtual — allows derived class to override it
    virtual void speak() {
        std::cout << name << " makes a sound" << std::endl;
    }
};

// DERIVED CLASS (child) — inherits from Animal
class Dog : public Animal {
private:
    std::string breed;

public:
    // Call base constructor with : Animal(n, a)
    Dog(std::string n, int a, std::string b)
        : Animal(n, a), breed(b) {
        std::cout << name << " (Dog) created" << std::endl;
    }

    // Override base class method
    void speak() override {  // 'override' keyword = safety check
        std::cout << name << " says: Woof!" << std::endl;
    }

    // Dog-specific method
    void fetch() {
        std::cout << name << " fetches the ball!" << std::endl;
    }
};

class Cat : public Animal {
public:
    Cat(std::string n, int a) : Animal(n, a) {}

    void speak() override {
        std::cout << name << " says: Meow!" << std::endl;
    }
};

int main() {
    Dog dog("Rex", 3, "Husky");
    Cat cat("Whiskers", 5);

    dog.eat();    // inherited from Animal
    dog.sleep();  // inherited from Animal
    dog.speak();  // overridden — Rex says: Woof!
    dog.fetch();  // Dog-specific

    cat.speak();  // Whiskers says: Meow!

    return 0;
}

─────────────────────────────────────
INHERITANCE CHAIN:
─────────────────────────────────────
Animal → Dog → GoldenRetriever
Each level inherits all of the above and can add more.
─────────────────────────────────────

📝 KEY POINTS:
✅ Use public inheritance for "is-a" relationships (Dog IS-A Animal)
✅ Always use override keyword when overriding — compiler catches errors
✅ Call base constructor in derived constructor's initializer list
✅ protected members are visible to derived classes; private is not
❌ Don't use inheritance for "has-a" relationships — use composition
❌ Avoid deep inheritance chains (more than 3 levels) — gets complex fast
❌ Never override without virtual in base — calls won't be polymorphic
''',
  quiz: [
    Quiz(question: 'What keyword is used in C++ to inherit from a base class?', options: [
      QuizOption(text: ': public BaseClass', correct: true),
      QuizOption(text: 'extends BaseClass', correct: false),
      QuizOption(text: 'inherits BaseClass', correct: false),
      QuizOption(text: '-> BaseClass', correct: false),
    ]),
    Quiz(question: 'What does the override keyword do?', options: [
      QuizOption(text: 'Tells the compiler to verify this method actually overrides a virtual function', correct: true),
      QuizOption(text: 'Forces the base class method to be replaced', correct: false),
      QuizOption(text: 'Prevents further overriding in subclasses', correct: false),
      QuizOption(text: 'Makes the method run faster', correct: false),
    ]),
    Quiz(question: 'Which access modifier makes base class members visible to derived classes but not outside?', options: [
      QuizOption(text: 'protected', correct: true),
      QuizOption(text: 'private', correct: false),
      QuizOption(text: 'public', correct: false),
      QuizOption(text: 'internal', correct: false),
    ]),
  ],
);
