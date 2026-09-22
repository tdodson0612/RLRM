// lib/lessons/cpp/cpp_46_static_members.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson46 = Lesson(
  language: 'C++',
  title: 'Static Members',
  content: '''
🎯 METAPHOR:
Static members are like the shared whiteboard in an office.
Each employee (object) has their own desk (instance members)
with their own stuff on it. But there is ONE whiteboard on
the wall that everyone shares. Writing on it changes it for
everyone. That shared whiteboard is the static member —
it belongs to the CLASS, not to any individual object.

📖 EXPLANATION:
A static member belongs to the CLASS itself, not to any
particular instance. All objects of the class share the
same static member.

─────────────────────────────────────
STATIC DATA MEMBERS:
─────────────────────────────────────
- Declared inside the class with static
- Defined OUTSIDE the class (in the .cpp file)
- Shared across ALL instances
- Exists even if no objects have been created
- Accessed via ClassName::member

STATIC MEMBER FUNCTIONS:
- No "this" pointer — they have no instance context
- Can only access static data members
- Can be called without creating an object
- Useful for factory functions, utility functions, counters
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <string>

class Player {
private:
    std::string name;
    int score;

    // Static data member — shared by ALL Player objects
    static int playerCount;     // declaration only
    static int highScore;

public:
    Player(std::string n, int s) : name(n), score(s) {
        playerCount++;  // increment shared counter on each creation
        if (score > highScore) highScore = score;
    }

    ~Player() {
        playerCount--;  // decrement when destroyed
    }

    // Static member function — no "this", no instance needed
    static int getPlayerCount() { return playerCount; }
    static int getHighScore()   { return highScore; }

    void display() const {
        std::cout << name << ": " << score << std::endl;
    }
};

// DEFINITION of static members — outside the class
// (in .cpp file in real projects)
int Player::playerCount = 0;
int Player::highScore   = 0;

class MathUtils {
public:
    // Pure utility — no instance needed
    static double circleArea(double r) { return 3.14159 * r * r; }
    static int clamp(int val, int lo, int hi) {
        return val < lo ? lo : (val > hi ? hi : val);
    }
    static bool isPrime(int n) {
        if (n < 2) return false;
        for (int i = 2; i * i <= n; i++)
            if (n % i == 0) return false;
        return true;
    }
};

// Singleton pattern — a classic use of static
class AppConfig {
private:
    std::string theme = "dark";
    AppConfig() {}  // private constructor

public:
    static AppConfig& getInstance() {
        static AppConfig instance;  // created once, on first call
        return instance;
    }
    std::string getTheme() { return theme; }
    void setTheme(std::string t) { theme = t; }
};

int main() {
    std::cout << Player::getPlayerCount() << std::endl;  // 0

    Player p1("Alice", 95);
    Player p2("Bob", 87);
    Player p3("Charlie", 99);

    std::cout << Player::getPlayerCount() << std::endl;  // 3
    std::cout << Player::getHighScore() << std::endl;    // 99

    p1.display();

    {
        Player temp("Temp", 50);
        std::cout << Player::getPlayerCount() << std::endl;  // 4
    }  // temp destroyed here
    std::cout << Player::getPlayerCount() << std::endl;  // 3

    // Static utility functions — no object needed
    std::cout << MathUtils::circleArea(5.0) << std::endl;  // 78.54
    std::cout << MathUtils::clamp(150, 0, 100) << std::endl;  // 100
    std::cout << MathUtils::isPrime(17) << std::endl;  // 1

    // Singleton
    AppConfig::getInstance().setTheme("light");
    std::cout << AppConfig::getInstance().getTheme() << std::endl;  // light

    return 0;
}

📝 KEY POINTS:
✅ Static members belong to the class, not to any instance
✅ Define static data members outside the class body
✅ Static functions have no "this" pointer — can't access instance members
✅ Use static members for counters, caches, singletons, utilities
✅ C++17 allows inline static members defined inside the class
❌ Don't use static members as a backdoor for global variables
❌ Static local variables in functions are also initialized once (thread-safe in C++11)
''',
  quiz: [
    Quiz(question: 'What makes a static member different from a regular member?', options: [
      QuizOption(text: 'It belongs to the class itself and is shared by all instances', correct: true),
      QuizOption(text: 'It can only be accessed from outside the class', correct: false),
      QuizOption(text: 'It is automatically const', correct: false),
      QuizOption(text: 'It is destroyed when any object is destroyed', correct: false),
    ]),
    Quiz(question: 'What can a static member function NOT do?', options: [
      QuizOption(text: 'Access non-static (instance) member variables', correct: true),
      QuizOption(text: 'Be called without creating an object', correct: false),
      QuizOption(text: 'Return a value', correct: false),
      QuizOption(text: 'Call other static functions', correct: false),
    ]),
    Quiz(question: 'Where must static data members be defined (in traditional C++)?', options: [
      QuizOption(text: 'Outside the class body, typically in a .cpp file', correct: true),
      QuizOption(text: 'Inside the class body only', correct: false),
      QuizOption(text: 'In the main() function', correct: false),
      QuizOption(text: 'In a separate static {} block', correct: false),
    ]),
  ],
);
