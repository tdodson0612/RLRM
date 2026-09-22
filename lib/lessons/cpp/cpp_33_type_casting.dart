// lib/lessons/cpp/cpp_33_type_casting.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson33 = Lesson(
  language: 'C++',
  title: 'Type Casting',
  content: '''
🎯 METAPHOR:
Type casting is like changing someone's job title.
static_cast is the formal HR process — you verify the
person qualifies for the new role at hire time (compile time).
dynamic_cast is a background check during employment —
at runtime, you verify they actually have the credentials.
reinterpret_cast is like faking a badge — you just relabel
the person and hope for the best. Dangerous.
C-style cast is walking up and saying "you're the CEO now"
with no process at all. Avoid.

📖 EXPLANATION:
C++ has four named casts — each with a specific purpose.
Prefer them over C-style (int)x — they document intent and
are safer.

─────────────────────────────────────
THE FOUR CASTS:
─────────────────────────────────────
static_cast<T>(x)
  Compile-time cast for related types.
  int → double, double → int, base* → derived*
  No runtime check. Fast.

dynamic_cast<T>(x)
  Runtime cast for polymorphic types (need virtual functions).
  Safely downcast base* → derived*.
  Returns nullptr (for pointers) or throws (for references) if wrong type.

const_cast<T>(x)
  Add or remove const.
  Only valid cast that changes const/volatile.

reinterpret_cast<T>(x)
  Raw bit reinterpretation. Extremely low-level.
  Used for hardware access, serialization, casting between pointer types.
  Almost never needed in normal code.
─────────────────────────────────────

💻 CODE:
#include <iostream>

class Animal {
public:
    virtual ~Animal() {}
    virtual void speak() { std::cout << "..." << std::endl; }
};

class Dog : public Animal {
public:
    void speak() override { std::cout << "Woof!" << std::endl; }
    void fetch() { std::cout << "Fetching!" << std::endl; }
};

int main() {
    // ─── STATIC_CAST ───
    double pi = 3.14159;
    int truncated = static_cast<int>(pi);  // 3 — truncates decimal
    std::cout << truncated << std::endl;

    int a = 7, b = 2;
    double result = static_cast<double>(a) / b;  // 3.5 (not 3!)
    std::cout << result << std::endl;

    // ─── DYNAMIC_CAST ───
    Animal* animal = new Dog();
    animal->speak();  // Woof! (polymorphism)

    // Safe downcast — is it really a Dog?
    Dog* dog = dynamic_cast<Dog*>(animal);
    if (dog != nullptr) {
        dog->fetch();  // safe! it IS a Dog
    }

    // Try to cast to wrong type
    class Cat : public Animal {};
    Animal* animal2 = new Cat();
    Dog* notDog = dynamic_cast<Dog*>(animal2);
    if (notDog == nullptr) {
        std::cout << "Not a Dog — cast returned nullptr" << std::endl;
    }

    delete animal;
    delete animal2;

    // ─── CONST_CAST ───
    const int x = 42;
    int* modifiable = const_cast<int*>(&x);
    // *modifiable = 99;  // technically undefined behavior on const vars
    // Use const_cast only to fix API issues with legacy code

    // ─── REINTERPRET_CAST ───
    long address = reinterpret_cast<long>(&x);  // pointer as integer
    std::cout << std::hex << address << std::endl;

    // C-style cast (avoid):
    double d = 3.99;
    int i = (int)d;        // C-style — works but don't use
    int j = int(d);        // functional — same thing
    int k = static_cast<int>(d);  // correct C++ way

    return 0;
}

─────────────────────────────────────
CAST SELECTION GUIDE:
─────────────────────────────────────
Numeric conversion          → static_cast
Downcast (inheritance)      → dynamic_cast
Remove const                → const_cast
Raw memory / hardware       → reinterpret_cast
Anything else               → think again
─────────────────────────────────────

📝 KEY POINTS:
✅ Always use named C++ casts — never C-style casts in new code
✅ dynamic_cast requires at least one virtual function in the base class
✅ dynamic_cast returns nullptr on failure for pointers — always check
✅ static_cast is the most common and safest general-purpose cast
❌ reinterpret_cast is almost always a red flag — use sparingly
❌ const_cast on actual const variables is undefined behavior
''',
  quiz: [
    Quiz(question: 'Which cast performs a runtime check during downcasting?', options: [
      QuizOption(text: 'dynamic_cast', correct: true),
      QuizOption(text: 'static_cast', correct: false),
      QuizOption(text: 'reinterpret_cast', correct: false),
      QuizOption(text: 'const_cast', correct: false),
    ]),
    Quiz(question: 'What does dynamic_cast return if the cast fails (for pointers)?', options: [
      QuizOption(text: 'nullptr', correct: true),
      QuizOption(text: 'A garbage pointer', correct: false),
      QuizOption(text: 'The original pointer unchanged', correct: false),
      QuizOption(text: 'It throws std::bad_cast', correct: false),
    ]),
    Quiz(question: 'What is the only cast that can remove const from a variable?', options: [
      QuizOption(text: 'const_cast', correct: true),
      QuizOption(text: 'static_cast', correct: false),
      QuizOption(text: 'dynamic_cast', correct: false),
      QuizOption(text: 'reinterpret_cast', correct: false),
    ]),
  ],
);
