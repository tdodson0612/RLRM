// lib/lessons/cpp/cpp_21_templates.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson21 = Lesson(
  language: 'C++',
  title: 'Templates',
  content: '''
🎯 METAPHOR:
A template is like a cookie cutter.
The cutter defines the SHAPE. You can use it with chocolate
dough, sugar dough, or gingerbread — the shape is the same,
the material varies. In C++: a template defines the LOGIC.
You can use it with int, double, string, or your own types —
the algorithm is the same, the data type varies.
Write once, use with any type.

📖 EXPLANATION:
Templates enable GENERIC PROGRAMMING — writing code that
works with any data type without rewriting it.

Two kinds of templates:
  1. Function templates — generic functions
  2. Class templates  — generic classes (like std::vector<T>)

The compiler generates the actual code at compile time
for each type you use. This is why templates are in headers —
the compiler needs to see the full definition.

💻 CODE:
#include <iostream>
#include <string>

// FUNCTION TEMPLATE
template <typename T>
T maximum(T a, T b) {
    return (a > b) ? a : b;
}

// Template with multiple type parameters
template <typename T, typename U>
void printPair(T first, U second) {
    std::cout << first << " : " << second << std::endl;
}

// CLASS TEMPLATE
template <typename T>
class Stack {
private:
    T data[100];
    int top;

public:
    Stack() : top(-1) {}

    void push(T value) {
        if (top < 99) data[++top] = value;
    }

    T pop() {
        if (top >= 0) return data[top--];
        throw std::runtime_error("Stack is empty");
    }

    T peek() const { return data[top]; }
    bool isEmpty() const { return top == -1; }
    int size() const { return top + 1; }
};

// TEMPLATE SPECIALIZATION — custom behavior for specific type
template <>
std::string maximum<std::string>(std::string a, std::string b) {
    return (a.length() > b.length()) ? a : b;  // longer string wins
}

int main() {
    // Function templates — compiler deduces T
    std::cout << maximum(3, 7) << std::endl;        // 7 (int)
    std::cout << maximum(3.14, 2.71) << std::endl;  // 3.14 (double)
    std::cout << maximum('a', 'z') << std::endl;    // z (char)

    // Explicit type
    std::cout << maximum<int>(5, 3) << std::endl;   // 5

    // Template specialization
    std::cout << maximum(std::string("hi"), std::string("hello")) << std::endl; // hello

    printPair("age", 25);       // age : 25
    printPair(3.14, "pi");      // 3.14 : pi

    // Class template
    Stack<int> intStack;
    intStack.push(10);
    intStack.push(20);
    intStack.push(30);
    std::cout << intStack.pop() << std::endl;  // 30
    std::cout << intStack.peek() << std::endl; // 20

    Stack<std::string> strStack;
    strStack.push("hello");
    strStack.push("world");
    std::cout << strStack.pop() << std::endl;  // world

    return 0;
}

─────────────────────────────────────
template <typename T> vs template <class T>:
─────────────────────────────────────
They are identical — typename and class are interchangeable
here. typename is preferred in modern C++ for clarity.
─────────────────────────────────────

📝 KEY POINTS:
✅ Templates generate type-specific code at compile time — zero runtime overhead
✅ Put template definitions in header files (not .cpp)
✅ Use typename (not class) for template parameters in modern C++
✅ Template specialization lets you override behavior for specific types
❌ Template errors are notoriously verbose — read them carefully
❌ Don't put template definitions in .cpp files — linker won't find them
''',
  quiz: [
    Quiz(question: 'When does the compiler generate template code?', options: [
      QuizOption(text: 'At compile time, for each type used with the template', correct: true),
      QuizOption(text: 'At runtime when the function is first called', correct: false),
      QuizOption(text: 'Only once, for the first type used', correct: false),
      QuizOption(text: 'Never — templates are interpreted', correct: false),
    ]),
    Quiz(question: 'Why must template definitions be in header files?', options: [
      QuizOption(text: 'The compiler needs the full definition to generate type-specific code', correct: true),
      QuizOption(text: 'Templates cannot be compiled into object files', correct: false),
      QuizOption(text: 'Header files are faster to compile', correct: false),
      QuizOption(text: 'Templates use a different compiler pass', correct: false),
    ]),
    Quiz(question: 'What is template specialization?', options: [
      QuizOption(text: 'Providing a custom implementation for a specific type', correct: true),
      QuizOption(text: 'Using a template with only one type', correct: false),
      QuizOption(text: 'Limiting a template to a specific type', correct: false),
      QuizOption(text: 'Inheriting from a template class', correct: false),
    ]),
  ],
);
