// lib/lessons/cpp/cpp_15_smart_pointers.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson15 = Lesson(
  language: 'C++',
  title: 'Smart Pointers',
  content: '''
🎯 METAPHOR:
A raw pointer is like borrowing a library book with no
return date and no reminders. You might forget to return it.
A smart pointer is like borrowing with an automatic library
system — when you're done (the smart pointer goes out of scope),
the book is automatically returned. No fines, no leaks.

📖 EXPLANATION:
Smart pointers are wrappers around raw pointers that
automatically delete the heap memory when no longer needed.
They are part of RAII — Resource Acquisition Is Initialization.

C++11 provides three smart pointers in <memory>:

─────────────────────────────────────
1. unique_ptr — exclusive ownership
─────────────────────────────────────
Only ONE owner. When it goes out of scope → auto delete.
Cannot be copied — only moved.
Use this by default for heap objects.

─────────────────────────────────────
2. shared_ptr — shared ownership
─────────────────────────────────────
Multiple owners share the same object.
Uses reference counting — deletes when count reaches 0.
Slightly more overhead than unique_ptr.
Use when multiple places truly need to own the resource.

─────────────────────────────────────
3. weak_ptr — non-owning observer
─────────────────────────────────────
Observes a shared_ptr WITHOUT increasing the ref count.
Does not prevent deletion.
Use to break circular reference cycles.
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <memory>

class Dog {
public:
    std::string name;
    Dog(std::string n) : name(n) {
        std::cout << name << " created" << std::endl;
    }
    ~Dog() {
        std::cout << name << " destroyed" << std::endl;
    }
    void bark() { std::cout << name << ": Woof!" << std::endl; }
};

int main() {
    // unique_ptr — preferred for single ownership
    {
        std::unique_ptr<Dog> dog1 = std::make_unique<Dog>("Rex");
        dog1->bark();
        // auto dog2 = dog1;  // ERROR: can't copy unique_ptr
        auto dog2 = std::move(dog1);  // transfer ownership
        dog2->bark();
        // dog1 is now empty (nullptr)
    }  // dog2 goes out of scope → Dog destructor called automatically

    std::cout << "---" << std::endl;

    // shared_ptr — multiple owners
    {
        std::shared_ptr<Dog> sp1 = std::make_shared<Dog>("Buddy");
        {
            std::shared_ptr<Dog> sp2 = sp1;  // both own Buddy
            std::cout << "Count: " << sp1.use_count() << std::endl; // 2
            sp2->bark();
        }  // sp2 goes out of scope — count drops to 1
        std::cout << "Count: " << sp1.use_count() << std::endl; // 1
    }  // sp1 goes out of scope — count drops to 0 → deleted

    return 0;
}

─────────────────────────────────────
RULE: always use make_unique / make_shared
─────────────────────────────────────
Good:  auto p = std::make_unique<Dog>("Rex");
Bad:   std::unique_ptr<Dog> p(new Dog("Rex"));
Why:   make_unique is exception-safe and more efficient
─────────────────────────────────────

📝 KEY POINTS:
✅ Prefer unique_ptr by default — zero overhead, clear ownership
✅ Use shared_ptr only when shared ownership is genuinely needed
✅ Use make_unique and make_shared — never use new directly with smart ptrs
✅ weak_ptr prevents circular references from causing memory leaks
❌ Don't mix raw pointers and smart pointers managing the same object
❌ Don't call delete on the raw pointer inside a smart pointer
❌ shared_ptr cycles (A owns B, B owns A) cause leaks — use weak_ptr
''',
  quiz: [
    Quiz(question: 'What is the main advantage of smart pointers over raw pointers?', options: [
      QuizOption(text: 'They automatically free memory when no longer needed', correct: true),
      QuizOption(text: 'They are faster than raw pointers', correct: false),
      QuizOption(text: 'They can point to stack memory', correct: false),
      QuizOption(text: 'They prevent all runtime errors', correct: false),
    ]),
    Quiz(question: 'What happens when a unique_ptr goes out of scope?', options: [
      QuizOption(text: 'The managed object is automatically deleted', correct: true),
      QuizOption(text: 'The pointer becomes nullptr', correct: false),
      QuizOption(text: 'Ownership is transferred to another pointer', correct: false),
      QuizOption(text: 'Nothing — it must still be manually deleted', correct: false),
    ]),
    Quiz(question: 'What is the purpose of weak_ptr?', options: [
      QuizOption(text: 'To observe a shared_ptr without taking ownership or affecting the ref count', correct: true),
      QuizOption(text: 'To hold a weak reference that can be null', correct: false),
      QuizOption(text: 'To share ownership like shared_ptr but faster', correct: false),
      QuizOption(text: 'To replace unique_ptr when copying is needed', correct: false),
    ]),
  ],
);
