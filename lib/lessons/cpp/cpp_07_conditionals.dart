// lib/lessons/cpp/cpp_07_conditionals.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson07 = Lesson(
  language: 'C++',
  title: 'Conditionals: if, else, switch',
  content: '''
🎯 METAPHOR:
Conditionals are the traffic lights of your program.
Without them, every car (instruction) just drives straight
through every intersection. Conditionals let you say:
"IF the light is red, stop. ELSE IF it is yellow, slow down.
ELSE, go." Your program makes decisions and takes different
roads based on the current situation.

📖 EXPLANATION:
C++ has three main conditional structures:
  1. if / else if / else  — for conditions
  2. switch               — for matching specific values
  3. ternary operator     — shorthand for simple if/else

─────────────────────────────────────
IF / ELSE IF / ELSE:
─────────────────────────────────────
if (condition) {
    // runs if condition is true
} else if (anotherCondition) {
    // runs if first was false, this is true
} else {
    // runs if ALL above were false
}
─────────────────────────────────────

─────────────────────────────────────
SWITCH:
─────────────────────────────────────
Like a hotel key — you match your key number to the
exact room. Much cleaner than 10 else-ifs when you're
checking one variable against many specific values.
─────────────────────────────────────

💻 CODE:
#include <iostream>

int main() {
    // if / else if / else
    int score = 85;

    if (score >= 90) {
        std::cout << "A" << std::endl;
    } else if (score >= 80) {
        std::cout << "B" << std::endl;  // prints this
    } else if (score >= 70) {
        std::cout << "C" << std::endl;
    } else {
        std::cout << "F" << std::endl;
    }

    // switch — best for exact value matching
    int day = 3;
    switch (day) {
        case 1:
            std::cout << "Monday" << std::endl;
            break;  // MUST break or it falls through!
        case 2:
            std::cout << "Tuesday" << std::endl;
            break;
        case 3:
            std::cout << "Wednesday" << std::endl; // prints this
            break;
        default:
            std::cout << "Other day" << std::endl;
    }

    // Intentional fall-through (rare, but valid):
    switch (day) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            std::cout << "Weekday" << std::endl; // prints for 1-5
            break;
        case 6:
        case 7:
            std::cout << "Weekend" << std::endl;
            break;
    }

    // Ternary operator: condition ? valueIfTrue : valueIfFalse
    int age = 20;
    std::string status = (age >= 18) ? "adult" : "minor";
    std::cout << status << std::endl; // adult

    return 0;
}

📝 KEY POINTS:
✅ Every switch case needs a break — or execution falls through
✅ Use switch when checking one variable against specific values
✅ Use if/else for ranges and complex conditions
✅ Ternary is great for simple one-line assignments
❌ Forgetting break in switch is one of the most common bugs
❌ switch only works with integral types (int, char, enum)
❌ Don't use switch for string comparisons — use if/else
''',
  quiz: [
    Quiz(question: 'What happens if you forget "break" in a switch case?', options: [
      QuizOption(text: 'Execution falls through to the next case', correct: true),
      QuizOption(text: 'The program crashes', correct: false),
      QuizOption(text: 'A compiler error occurs', correct: false),
      QuizOption(text: 'The switch exits automatically', correct: false),
    ]),
    Quiz(question: 'What does the ternary operator ? : do?', options: [
      QuizOption(text: 'Returns one of two values based on a condition', correct: true),
      QuizOption(text: 'Checks three conditions at once', correct: false),
      QuizOption(text: 'Creates a three-way comparison', correct: false),
      QuizOption(text: 'Replaces switch statements', correct: false),
    ]),
    Quiz(question: 'When is switch preferred over if/else if?', options: [
      QuizOption(text: 'When checking one variable against many specific values', correct: true),
      QuizOption(text: 'When comparing ranges like score >= 90', correct: false),
      QuizOption(text: 'When using string comparisons', correct: false),
      QuizOption(text: 'When you have only two conditions', correct: false),
    ]),
  ],
);
