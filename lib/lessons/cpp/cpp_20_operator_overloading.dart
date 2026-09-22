// lib/lessons/cpp/cpp_20_operator_overloading.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson20 = Lesson(
  language: 'C++',
  title: 'Operator Overloading',
  content: '''
🎯 METAPHOR:
Operator overloading is like teaching a new word a new meaning
in a specific context. The word "plus" normally means adding
numbers. But in music, "plus" might mean "and also play this
note." Same symbol, new meaning, same intuitive feel.
In C++: the + operator normally adds ints. You can teach it
to add Vector objects, concatenate custom strings, or combine
colors — making your custom types feel as natural as built-ins.

📖 EXPLANATION:
C++ lets you redefine how operators work for your own classes.
When you write vec1 + vec2, C++ calls your operator+ function.

You can overload:
  Arithmetic:   + - * / %
  Comparison:   == != < > <= >=
  Assignment:   = += -= *= /=
  Stream:       << >> (for cout/cin)
  Subscript:    []
  Call:         ()
  Increment:    ++ --

You CANNOT overload:
  ::   .   .*   ?:   sizeof

💻 CODE:
#include <iostream>

class Vector2D {
public:
    double x, y;

    Vector2D(double x = 0, double y = 0) : x(x), y(y) {}

    // + operator: vec1 + vec2
    Vector2D operator+(const Vector2D& other) const {
        return Vector2D(x + other.x, y + other.y);
    }

    // - operator
    Vector2D operator-(const Vector2D& other) const {
        return Vector2D(x - other.x, y - other.y);
    }

    // * scalar: vec * 2.0
    Vector2D operator*(double scalar) const {
        return Vector2D(x * scalar, y * scalar);
    }

    // == comparison
    bool operator==(const Vector2D& other) const {
        return x == other.x && y == other.y;
    }

    // += compound assignment
    Vector2D& operator+=(const Vector2D& other) {
        x += other.x;
        y += other.y;
        return *this;  // return reference to self
    }

    // [] subscript
    double operator[](int index) const {
        if (index == 0) return x;
        if (index == 1) return y;
        throw std::out_of_range("Index out of range");
    }
};

// << for cout — defined OUTSIDE the class (non-member)
std::ostream& operator<<(std::ostream& os, const Vector2D& v) {
    os << "(" << v.x << ", " << v.y << ")";
    return os;  // return stream for chaining
}

int main() {
    Vector2D a(1.0, 2.0);
    Vector2D b(3.0, 4.0);

    Vector2D c = a + b;
    std::cout << c << std::endl;       // (4, 6)

    Vector2D d = a * 3.0;
    std::cout << d << std::endl;       // (3, 6)

    a += b;
    std::cout << a << std::endl;       // (4, 6)

    std::cout << (c == a) << std::endl; // 1 (true)

    std::cout << c[0] << std::endl;    // 4 (x component)

    return 0;
}

─────────────────────────────────────
MEMBER vs NON-MEMBER:
─────────────────────────────────────
Member:     vec * 2.0   (object on left side)
Non-member: 2.0 * vec   (need non-member for left-hand scalar)
<< and >> must be non-member (stream on left side)
─────────────────────────────────────

📝 KEY POINTS:
✅ Overload operators to make custom types feel natural
✅ Return *this from assignment operators (enables chaining)
✅ Return by value for arithmetic; by reference for assignment
✅ << and >> should be non-member friends
❌ Don't overload operators to mean something unintuitive
❌ Don't overload && and || — short-circuit evaluation breaks
❌ If you overload ==, also overload != for consistency
''',
  quiz: [
    Quiz(question: 'What does "return *this" mean in an operator= overload?', options: [
      QuizOption(text: 'Returns a reference to the current object, enabling chained assignment', correct: true),
      QuizOption(text: 'Returns a copy of the object', correct: false),
      QuizOption(text: 'Deletes the object after assignment', correct: false),
      QuizOption(text: 'Returns the right-hand operand', correct: false),
    ]),
    Quiz(question: 'Why is operator<< typically defined as a non-member function?', options: [
      QuizOption(text: 'Because the stream (cout) is on the left side, not the class object', correct: true),
      QuizOption(text: 'Because it runs faster as non-member', correct: false),
      QuizOption(text: 'Because member functions cannot access cout', correct: false),
      QuizOption(text: 'Non-member is required for all comparison operators', correct: false),
    ]),
    Quiz(question: 'Which operator CANNOT be overloaded in C++?', options: [
      QuizOption(text: '::', correct: true),
      QuizOption(text: '+', correct: false),
      QuizOption(text: '[]', correct: false),
      QuizOption(text: '==', correct: false),
    ]),
  ],
);
