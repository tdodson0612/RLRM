// lib/lessons/cpp/cpp_34_bitwise_operators.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson34 = Lesson(
  language: 'C++',
  title: 'Bitwise Operators',
  content: '''
🎯 METAPHOR:
Bitwise operators work directly on the binary switches inside
a number — like flipping light switches in a panel.
Each bit (0 or 1) is one switch: ON or OFF.
Bitwise AND (&) is like two switches in series — both must
be ON for current to flow. OR (|) is parallel — either
switch being ON lights the bulb. XOR (^) is like a motion
sensor that triggers when exactly ONE input changes.

📖 EXPLANATION:
Computers store everything as bits (binary 0s and 1s).
Bitwise operators manipulate these bits directly.
They are extremely fast and essential for:
  - Flags and permission systems
  - Low-level hardware programming
  - Performance optimization
  - Networking (IP addresses, masks)
  - Cryptography

─────────────────────────────────────
BITWISE OPERATORS:
─────────────────────────────────────
&     AND    1&1=1, 1&0=0, 0&0=0
|     OR     1|1=1, 1|0=1, 0|0=0
^     XOR    1^1=0, 1^0=1, 0^0=0
~     NOT    ~1=0, ~0=1  (flips all bits)
<<    left shift   x << n  multiply by 2^n
>>    right shift  x >> n  divide by 2^n
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <bitset>  // for visualizing bits

int main() {
    int a = 0b1010;  // 10 in decimal
    int b = 0b1100;  // 12 in decimal

    // Show binary representation
    std::cout << "a = " << std::bitset<4>(a) << " = " << a << std::endl;
    std::cout << "b = " << std::bitset<4>(b) << " = " << b << std::endl;

    // AND — both bits must be 1
    std::cout << "a & b = " << std::bitset<4>(a & b) << " = " << (a & b) << std::endl;
    // 1010 & 1100 = 1000 = 8

    // OR — at least one bit must be 1
    std::cout << "a | b = " << std::bitset<4>(a | b) << " = " << (a | b) << std::endl;
    // 1010 | 1100 = 1110 = 14

    // XOR — exactly one bit must be 1
    std::cout << "a ^ b = " << std::bitset<4>(a ^ b) << " = " << (a ^ b) << std::endl;
    // 1010 ^ 1100 = 0110 = 6

    // NOT — flip all bits
    std::cout << "~a = " << (~a) << std::endl;  // depends on int size

    // LEFT SHIFT — multiply by 2 per shift
    std::cout << "a << 1 = " << (a << 1) << std::endl;  // 10 << 1 = 20
    std::cout << "a << 2 = " << (a << 2) << std::endl;  // 10 << 2 = 40

    // RIGHT SHIFT — divide by 2 per shift
    std::cout << "a >> 1 = " << (a >> 1) << std::endl;  // 10 >> 1 = 5

    // ─── PRACTICAL: BIT FLAGS ───
    // Use each bit as a boolean flag
    const unsigned int READ    = 1 << 0;  // 0001
    const unsigned int WRITE   = 1 << 1;  // 0010
    const unsigned int EXECUTE = 1 << 2;  // 0100

    unsigned int perms = READ | WRITE;  // 0011

    // Check if READ is set
    if (perms & READ) std::cout << "Can read" << std::endl;

    // Set EXECUTE flag
    perms |= EXECUTE;  // 0111

    // Clear WRITE flag
    perms &= ~WRITE;   // 0101

    // Toggle READ flag
    perms ^= READ;     // flip it

    // ─── PRACTICAL: FAST POWER OF 2 ───
    int x = 1 << 10;  // 1024 — faster than pow(2, 10)

    // Check if number is power of 2
    int n = 64;
    bool isPow2 = n && !(n & (n - 1));  // classic bit trick
    std::cout << n << " is power of 2: " << isPow2 << std::endl;

    return 0;
}

📝 KEY POINTS:
✅ & checks/clears bits, | sets bits, ^ toggles bits, ~ inverts
✅ Use bit flags instead of multiple booleans for compact state
✅ << n multiplies by 2^n (faster than multiplication for powers of 2)
✅ >> n divides by 2^n
✅ Use unsigned types for bit manipulation — signed bit shifting has edge cases
❌ Don't confuse & (bitwise AND) with && (logical AND)
❌ Don't confuse | (bitwise OR) with || (logical OR)
❌ Shifting by the bit width of the type is undefined behavior
''',
  quiz: [
    Quiz(question: 'What does the bitwise AND operator (&) do?', options: [
      QuizOption(text: 'Returns 1 for each bit position where BOTH operands have a 1', correct: true),
      QuizOption(text: 'Returns 1 for each bit position where EITHER operand has a 1', correct: false),
      QuizOption(text: 'Flips all bits of the operand', correct: false),
      QuizOption(text: 'Returns 1 only when bits differ', correct: false),
    ]),
    Quiz(question: 'What does "x << 3" do to the value of x?', options: [
      QuizOption(text: 'Multiplies x by 8 (2^3)', correct: true),
      QuizOption(text: 'Divides x by 8', correct: false),
      QuizOption(text: 'Adds 3 to x', correct: false),
      QuizOption(text: 'Shifts the decimal point 3 places', correct: false),
    ]),
    Quiz(question: 'How do you clear (turn off) a specific bit flag using bitwise operators?', options: [
      QuizOption(text: 'value &= ~FLAG', correct: true),
      QuizOption(text: 'value |= FLAG', correct: false),
      QuizOption(text: 'value ^= FLAG', correct: false),
      QuizOption(text: 'value -= FLAG', correct: false),
    ]),
  ],
);
