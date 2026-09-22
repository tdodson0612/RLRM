// lib/lessons/cpp/cpp_06_input_output.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson06 = Lesson(
  language: 'C++',
  title: 'Input and Output',
  content: '''
🎯 METAPHOR:
cin and cout are like a two-way intercom system.
cout is the speaker — you push information OUT to the user.
cin is the microphone — information comes IN from the user.
The << and >> arrows tell you which direction data is flowing:
  << points TOWARD cout (out to screen)
  >> points TOWARD your variable (in from keyboard)

📖 EXPLANATION:
C++ I/O uses streams from the <iostream> library.

─────────────────────────────────────
OUTPUT — std::cout:
─────────────────────────────────────
std::cout << "Hello";         print text
std::cout << 42;              print number
std::cout << std::endl;       print newline + flush buffer
std::cout << "\\n";            print newline (faster, no flush)
std::cout << x << " " << y;  chain multiple values
─────────────────────────────────────

─────────────────────────────────────
INPUT — std::cin:
─────────────────────────────────────
std::cin >> x;          read one value (stops at whitespace)
std::cin >> x >> y;     read two values
std::getline(std::cin, str);  read entire line including spaces
─────────────────────────────────────

NAMESPACES:
std:: prefix means "from the standard library namespace."
You can write "using namespace std;" at the top to avoid
typing std:: every time — but avoid this in header files.

💻 CODE:
#include <iostream>
#include <string>

int main() {
    // Basic output
    std::cout << "Enter your name: ";

    // Read a single word
    std::string name;
    std::cin >> name;

    std::cout << "Hello, " << name << "!" << std::endl;

    // Reading numbers
    std::cout << "Enter two numbers: ";
    int a, b;
    std::cin >> a >> b;
    std::cout << "Sum: " << a + b << std::endl;

    // Reading a full line (including spaces)
    std::cin.ignore(); // clear the leftover newline in buffer
    std::cout << "Enter your full name: ";
    std::string fullName;
    std::getline(std::cin, fullName);
    std::cout << "Full name: " << fullName << std::endl;

    return 0;
}

─────────────────────────────────────
FORMATTING OUTPUT:
─────────────────────────────────────
#include <iomanip>

std::cout << std::fixed << std::setprecision(2) << 3.14159;
// prints: 3.14

std::cout << std::setw(10) << "hello";
// prints with padding:      hello
─────────────────────────────────────

📝 KEY POINTS:
✅ std::endl flushes the buffer — use "\\n" for better performance
✅ cin >> stops at whitespace — use getline for full lines
✅ After cin >>, a newline stays in the buffer — use cin.ignore()
   before getline or you'll read an empty line
✅ Chain << to print multiple values on one line
❌ Don't mix cin >> and getline without cin.ignore() between them
❌ Don't forget #include <string> when using std::string
''',
  quiz: [
    Quiz(question: 'Which operator sends data to cout?', options: [
      QuizOption(text: '<<', correct: true),
      QuizOption(text: '>>', correct: false),
      QuizOption(text: '->', correct: false),
      QuizOption(text: '::', correct: false),
    ]),
    Quiz(question: 'What is the difference between std::endl and "\\n"?', options: [
      QuizOption(text: 'endl flushes the buffer; \\n does not', correct: true),
      QuizOption(text: 'They are exactly identical', correct: false),
      QuizOption(text: '\\n flushes the buffer; endl does not', correct: false),
      QuizOption(text: 'endl prints two newlines', correct: false),
    ]),
    Quiz(question: 'Why use std::getline instead of cin >> for strings?', options: [
      QuizOption(text: 'getline reads the full line including spaces', correct: true),
      QuizOption(text: 'getline is faster', correct: false),
      QuizOption(text: 'cin >> cannot read strings at all', correct: false),
      QuizOption(text: 'getline works with numbers too', correct: false),
    ]),
  ],
);
