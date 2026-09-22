// lib/lessons/cpp/cpp_22_namespaces.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson22 = Lesson(
  language: 'C++',
  title: 'Namespaces',
  content: '''
🎯 METAPHOR:
A namespace is like a last name.
Two people named "John" can both exist if one is "John Smith"
and the other is "John Johnson." The last name (namespace)
clarifies WHICH John you mean. In C++: two functions can
both be named "open" — one is "file::open" and the other
is "network::open." No conflict, clear meaning.

📖 EXPLANATION:
Namespaces prevent naming collisions in large programs.
Every standard library name lives in the std namespace:
std::cout, std::string, std::vector, etc.

You can:
  - Define your own namespaces
  - Nest namespaces
  - Use "using" to avoid typing the prefix
  - Use anonymous namespaces for file-local names

💻 CODE:
#include <iostream>
#include <string>

// Define a namespace
namespace math {
    const double PI = 3.14159265358979;

    double circleArea(double r) {
        return PI * r * r;
    }

    double circlePerimeter(double r) {
        return 2 * PI * r;
    }

    // Nested namespace
    namespace geometry {
        double triangleArea(double base, double height) {
            return 0.5 * base * height;
        }
    }
}

namespace physics {
    const double PI = 3.14159;  // no conflict with math::PI

    double kineticEnergy(double mass, double velocity) {
        return 0.5 * mass * velocity * velocity;
    }
}

// Anonymous namespace — only visible in this file
namespace {
    int helperValue = 42;
    void helperFunction() {
        std::cout << "Internal helper" << std::endl;
    }
}

int main() {
    // Fully qualified names
    std::cout << math::PI << std::endl;
    std::cout << math::circleArea(5.0) << std::endl;
    std::cout << math::geometry::triangleArea(4, 3) << std::endl;
    std::cout << physics::kineticEnergy(10, 5) << std::endl;

    // using declaration — imports one name
    using math::circleArea;
    std::cout << circleArea(3.0) << std::endl;  // no prefix needed

    // using directive — imports all names from namespace
    // (use sparingly — can cause conflicts)
    using namespace math;
    std::cout << PI << std::endl;             // math::PI
    std::cout << circlePerimeter(5) << std::endl;

    // Anonymous namespace function
    helperFunction();

    return 0;
}

─────────────────────────────────────
"using namespace std" — why to avoid it:
─────────────────────────────────────
It dumps ALL of std:: into your scope.
If you define a function called "count" and std::count
also exists — ambiguity error. Especially dangerous in
header files — it pollutes every file that includes yours.

Better alternatives:
  using std::cout;    // import only what you need
  using std::string;
─────────────────────────────────────

📝 KEY POINTS:
✅ Use namespaces to organize large codebases
✅ The std namespace contains all standard library names
✅ Anonymous namespaces replace static for file-local linkage
✅ Nested namespaces are fine — C++17 allows namespace A::B::C {}
❌ Never write "using namespace std" in a header file
❌ Avoid "using namespace X" in general — prefer specific using declarations
''',
  quiz: [
    Quiz(question: 'What problem do namespaces solve?', options: [
      QuizOption(text: 'Naming collisions between identifiers in different parts of a program', correct: true),
      QuizOption(text: 'Memory allocation issues', correct: false),
      QuizOption(text: 'Slow compilation times', correct: false),
      QuizOption(text: 'Class inheritance conflicts', correct: false),
    ]),
    Quiz(question: 'Why should you avoid "using namespace std" in header files?', options: [
      QuizOption(text: 'It pollutes the global namespace of every file that includes the header', correct: true),
      QuizOption(text: 'It causes slower compilation', correct: false),
      QuizOption(text: 'Headers cannot use namespaces', correct: false),
      QuizOption(text: 'It disables the std library', correct: false),
    ]),
    Quiz(question: 'What is an anonymous namespace used for?', options: [
      QuizOption(text: 'Making names visible only within the current file', correct: true),
      QuizOption(text: 'Hiding class members', correct: false),
      QuizOption(text: 'Creating temporary namespaces that are deleted after use', correct: false),
      QuizOption(text: 'Grouping template specializations', correct: false),
    ]),
  ],
);
