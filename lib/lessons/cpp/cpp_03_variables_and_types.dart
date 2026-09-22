// lib/lessons/cpp/cpp_03_variables_and_types.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson03 = Lesson(
  language: 'C++',
  title: 'Variables and Data Types',
  content: '''
🎯 METAPHOR:
A variable is like a labeled storage locker.
Each locker has a number (memory address), a name
on the door (variable name), and can only hold one
specific type of item (data type).
You cannot store a surfboard in a locker sized for books.
The TYPE determines the locker size and what fits inside.

📖 EXPLANATION:
Every variable in C++ has THREE things:
  1. A type   — what kind of data it holds
  2. A name   — how you refer to it in code
  3. A value  — the actual data stored

C++ is STATICALLY TYPED — the type is set at compile time
and cannot change. This lets the compiler catch mistakes
before your program even runs.

─────────────────────────────────────
FUNDAMENTAL TYPES:
─────────────────────────────────────
Type          Size      Range / Use
─────────────────────────────────────
int           4 bytes   whole numbers (-2B to 2B)
long          8 bytes   bigger whole numbers
short         2 bytes   small whole numbers
char          1 byte    single character / small int
float         4 bytes   decimal (7 digits precision)
double        8 bytes   decimal (15 digits precision)
bool          1 byte    true or false
─────────────────────────────────────

💻 CODE:
#include <iostream>

int main() {
    // Declaring and initializing variables
    int age = 25;
    double price = 9.99;
    char grade = 'A';
    bool isOnline = true;

    // C++11: preferred initialization style
    int score{100};       // brace initialization
    double pi{3.14159};

    // auto: compiler figures out the type for you
    auto name = "Alice";  // deduces const char*
    auto count = 42;      // deduces int
    auto ratio = 3.14;    // deduces double

    std::cout << "Age: " << age << std::endl;
    std::cout << "Price: " << price << std::endl;
    std::cout << "Grade: " << grade << std::endl;
    std::cout << "Online: " << isOnline << std::endl;

    return 0;
}

─────────────────────────────────────
TYPE MODIFIERS:
─────────────────────────────────────
unsigned int   → only positive (0 to 4B)
long int       → larger range
long long int  → even larger
long double    → more precision than double
─────────────────────────────────────

sizeof() tells you the byte size of any type:
  std::cout << sizeof(int);    // prints 4
  std::cout << sizeof(double); // prints 8

📝 KEY POINTS:
✅ Always initialize variables — uninitialized values are garbage
✅ Use double over float — more precision, same speed
✅ Use auto when the type is obvious from context
✅ Brace initialization {} prevents narrowing conversions
❌ int x;  is declared but NOT initialized — danger!
❌ float for money — use integer cents or a decimal library
❌ Don't assume sizes — use sizeof() or fixed-size types
   (int32_t, int64_t from <cstdint>) for portability
''',
  quiz: [
    Quiz(question: 'Which type stores a decimal number with the most precision?', options: [
      QuizOption(text: 'double', correct: true),
      QuizOption(text: 'float', correct: false),
      QuizOption(text: 'int', correct: false),
      QuizOption(text: 'long', correct: false),
    ]),
    Quiz(question: 'What does "auto" do in C++?', options: [
      QuizOption(text: 'Lets the compiler deduce the type automatically', correct: true),
      QuizOption(text: 'Creates an automatic pointer', correct: false),
      QuizOption(text: 'Makes the variable global', correct: false),
      QuizOption(text: 'Allocates memory on the heap', correct: false),
    ]),
    Quiz(question: 'What is the size of an int on most modern systems?', options: [
      QuizOption(text: '4 bytes', correct: true),
      QuizOption(text: '2 bytes', correct: false),
      QuizOption(text: '8 bytes', correct: false),
      QuizOption(text: '1 byte', correct: false),
    ]),
  ],
);
