// lib/lessons/cpp/cpp_47_friend_functions.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson47 = Lesson(
  language: 'C++',
  title: 'Friend Functions and Classes',
  content: '''
🎯 METAPHOR:
A friend function is like a trusted locksmith.
Normally your house (class) has locks (private members)
that only YOU can access. But you can give a specific
locksmith (friend function) a master key — they can get
into your private spaces too. You choose EXACTLY who to
trust with that key. It is selective, not universal.
Everyone else still cannot get in.

📖 EXPLANATION:
A friend declaration grants a non-member function (or another
class) access to a class's private and protected members.

friend is declared INSIDE the class granting access.
It is NOT a member of the class — it has no "this" pointer.
It is a deliberate, controlled breach of encapsulation —
use it sparingly.

─────────────────────────────────────
WHEN FRIEND IS USEFUL:
─────────────────────────────────────
- Operator overloading (especially << and >>)
- Two tightly coupled classes that need each other's internals
- Testing — a test class that needs to inspect private state
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <string>
#include <cmath>

class Point {
private:
    double x, y;

public:
    Point(double x, double y) : x(x), y(y) {}

    // Declare friend function — grants it access to private x, y
    friend double distance(const Point& a, const Point& b);

    // Declare << as friend so it can access private members
    friend std::ostream& operator<<(std::ostream& os, const Point& p);
};

// Definition of friend function — NOT a member of Point
double distance(const Point& a, const Point& b) {
    double dx = a.x - b.x;  // can access private x, y!
    double dy = a.y - b.y;
    return std::sqrt(dx*dx + dy*dy);
}

std::ostream& operator<<(std::ostream& os, const Point& p) {
    os << "(" << p.x << ", " << p.y << ")";  // accesses private x, y
    return os;
}

// ─── FRIEND CLASS ───
class Engine {
private:
    int horsepower;
    double displacement;

    friend class Car;  // Car can access Engine's private members

public:
    Engine(int hp, double disp) : horsepower(hp), displacement(disp) {}
};

class Car {
private:
    std::string model;
    Engine engine;

public:
    Car(std::string m, int hp, double disp)
        : model(m), engine(hp, disp) {}

    void describe() {
        // Accesses Engine's private members directly (friend class)
        std::cout << model << ": "
                  << engine.horsepower << "hp, "
                  << engine.displacement << "L" << std::endl;
    }
};

// ─── FORWARD DECLARATION for mutual friendship ───
class B;  // tell compiler B exists before defining A

class A {
private:
    int valueA = 10;
    friend class B;  // B can access A's privates
};

class B {
private:
    int valueB = 20;
    friend class A;  // A can access B's privates
public:
    void showBoth(const A& a) {
        std::cout << "A: " << a.valueA << ", B: " << valueB << std::endl;
    }
};

int main() {
    Point p1(0.0, 0.0);
    Point p2(3.0, 4.0);

    // friend function called like a regular function
    std::cout << "Distance: " << distance(p1, p2) << std::endl;  // 5

    // friend operator<<
    std::cout << p1 << " to " << p2 << std::endl;  // (0, 0) to (3, 4)

    Car car("Mustang", 450, 5.0);
    car.describe();  // Mustang: 450hp, 5L

    A a;
    B b;
    b.showBoth(a);  // A: 10, B: 20

    return 0;
}

📝 KEY POINTS:
✅ friend is declared inside the class GRANTING access
✅ friend functions are NOT members — no this pointer
✅ Use friend sparingly — it breaks encapsulation
✅ operator<< must be a non-member — friend makes this clean
✅ Forward declarations let two classes be friends with each other
❌ Friendship is not inherited — a derived class is NOT automatically a friend
❌ Friendship is not transitive — friend of a friend is NOT a friend
❌ Don't use friend as a shortcut to avoid good design
''',
  quiz: [
    Quiz(question: 'Where is a friend declaration written?', options: [
      QuizOption(text: 'Inside the class that is granting access to its private members', correct: true),
      QuizOption(text: 'Inside the friend function itself', correct: false),
      QuizOption(text: 'In the global scope outside any class', correct: false),
      QuizOption(text: 'In the header file only', correct: false),
    ]),
    Quiz(question: 'Is friendship inherited by derived classes?', options: [
      QuizOption(text: 'No — a derived class does not automatically get friend access', correct: true),
      QuizOption(text: 'Yes — derived classes inherit all friend relationships', correct: false),
      QuizOption(text: 'Only if the derived class also declares the friend', correct: false),
      QuizOption(text: 'Yes, but only for public friends', correct: false),
    ]),
    Quiz(question: 'Why is operator<< typically declared as a friend function?', options: [
      QuizOption(text: 'Because the stream is on the left side, so it must be a non-member, but still needs private access', correct: true),
      QuizOption(text: 'Because member functions cannot overload <<', correct: false),
      QuizOption(text: 'Because friend functions run faster for I/O', correct: false),
      QuizOption(text: 'It does not need to be a friend — it can be a regular member', correct: false),
    ]),
  ],
);
