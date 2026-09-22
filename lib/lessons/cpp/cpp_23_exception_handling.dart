// lib/lessons/cpp/cpp_23_exception_handling.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson23 = Lesson(
  language: 'C++',
  title: 'Exception Handling',
  content: '''
🎯 METAPHOR:
Exception handling is like a safety net under a trapeze act.
The performer (your code) tries their best. If they fall
(something goes wrong), the net (catch block) catches them.
Without a net, a fall is fatal. With a net, you can recover
gracefully — maybe reset, maybe try again, maybe tell the
audience what happened — without the whole show collapsing.

📖 EXPLANATION:
Exceptions are a way to signal and handle errors that
are unexpected or outside normal control flow.

Three keywords:
  try    — the code that might throw an error
  throw  — signal that something went wrong
  catch  — handle the error

C++ has a hierarchy of standard exceptions in <stdexcept>:
  std::exception         (base class)
  std::runtime_error     (errors at runtime)
  std::logic_error       (programming mistakes)
  std::out_of_range      (index out of bounds)
  std::invalid_argument  (bad argument)
  std::overflow_error    (arithmetic overflow)

💻 CODE:
#include <iostream>
#include <stdexcept>
#include <string>

// Function that throws
double divide(double a, double b) {
    if (b == 0) {
        throw std::invalid_argument("Cannot divide by zero");
    }
    return a / b;
}

int getElement(int arr[], int size, int index) {
    if (index < 0 || index >= size) {
        throw std::out_of_range("Index " + std::to_string(index)
                                 + " is out of range");
    }
    return arr[index];
}

// Custom exception class
class InsufficientFundsException : public std::exception {
    double amount;
public:
    InsufficientFundsException(double amt) : amount(amt) {}
    const char* what() const noexcept override {
        return "Insufficient funds";
    }
    double getAmount() const { return amount; }
};

int main() {
    // Basic try/catch
    try {
        double result = divide(10, 0);
        std::cout << result << std::endl;  // never reached
    } catch (const std::invalid_argument& e) {
        std::cout << "Error: " << e.what() << std::endl;
    }

    // Multiple catch blocks
    int arr[] = {10, 20, 30};
    try {
        std::cout << getElement(arr, 3, 5) << std::endl;
    } catch (const std::out_of_range& e) {
        std::cout << "Range error: " << e.what() << std::endl;
    } catch (const std::exception& e) {
        std::cout << "General error: " << e.what() << std::endl;
    } catch (...) {
        std::cout << "Unknown error!" << std::endl;
    }

    // Custom exception
    try {
        throw InsufficientFundsException(50.00);
    } catch (const InsufficientFundsException& e) {
        std::cout << e.what() << " — needed $" << e.getAmount() << std::endl;
    }

    // Re-throwing
    try {
        try {
            throw std::runtime_error("inner error");
        } catch (const std::exception& e) {
            std::cout << "Caught inner, re-throwing..." << std::endl;
            throw;  // re-throw the same exception
        }
    } catch (const std::exception& e) {
        std::cout << "Caught outer: " << e.what() << std::endl;
    }

    return 0;
}

─────────────────────────────────────
CATCH ORDER MATTERS:
─────────────────────────────────────
Catch most specific FIRST, most general LAST.
catch(std::out_of_range)   // specific
catch(std::exception)      // general
catch(...)                 // catch-all — always last
─────────────────────────────────────

📝 KEY POINTS:
✅ Catch by const reference — avoids slicing and copying
✅ Most specific exception type first in catch chain
✅ catch(...) catches anything — use as last resort only
✅ noexcept on functions that guarantee no throw — enables optimizations
❌ Don't use exceptions for normal control flow — they're for errors
❌ Don't throw from destructors — can cause std::terminate
❌ Don't ignore exceptions — at minimum log them
''',
  quiz: [
    Quiz(question: 'In what order should catch blocks be arranged?', options: [
      QuizOption(text: 'Most specific exception type first, most general last', correct: true),
      QuizOption(text: 'Most general first, most specific last', correct: false),
      QuizOption(text: 'Alphabetical by exception name', correct: false),
      QuizOption(text: 'Order does not matter', correct: false),
    ]),
    Quiz(question: 'What does catch(...) do?', options: [
      QuizOption(text: 'Catches any exception regardless of type', correct: true),
      QuizOption(text: 'Catches only std::exception types', correct: false),
      QuizOption(text: 'Catches exceptions and rethrows them', correct: false),
      QuizOption(text: 'Catches only non-standard exceptions', correct: false),
    ]),
    Quiz(question: 'Why should exceptions be caught by const reference?', options: [
      QuizOption(text: 'To avoid object slicing and unnecessary copying', correct: true),
      QuizOption(text: 'References are required — you cannot catch by value', correct: false),
      QuizOption(text: 'const prevents the exception from being modified accidentally', correct: false),
      QuizOption(text: 'It is just a style convention with no technical reason', correct: false),
    ]),
  ],
);
