// lib/lessons/csharp/csharp_54_string_formatting.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson54 = Lesson(
  language: 'C#',
  title: 'String Formatting In Depth',
  content: '''
🎯 METAPHOR:
String formatting is like a template system for text.
"Dear {0}, your order #{1} totaling {2:C} has shipped."
The placeholders are slots. You pour in the data and
the template produces the final string. C# has several
layers of this — from basic {0} placeholders to full
custom format providers that control exactly how every
number, date, and custom type renders as text.

📖 EXPLANATION:
C# string formatting options:

1. String interpolation: \$"Hello {name}"
2. String.Format: string.Format("{0:F2}", pi)
3. ToString(format): pi.ToString("F2")
4. IFormattable: implement custom format on your types
5. IFormatProvider / ICustomFormatter: custom format rules
6. FormattableString: deferred interpolation (for SQL safety etc.)

FORMAT SPECIFIERS:
  D   integer          42 → "42", D5 → "00042"
  F   fixed-point      3.14159 → "3.14" (F2)
  E   scientific       "3.14E+000"
  G   general          compact representation
  N   number           1234567 → "1,234,567"
  P   percent          0.75 → "75.00%"
  X   hex              255 → "FF", x → "ff"
  C   currency         9.99 → "\$9.99" (culture-dependent)
  R   roundtrip        preserve all significant digits

ALIGNMENT:
  {value,width}        right-align in width
  {value,-width}       left-align in width

💻 CODE:
using System;
using System.Globalization;
using System.Text;

class Program
{
    static void Main()
    {
        double pi = Math.PI;
        int    n  = 1234567;
        decimal price = 9.99m;
        DateTime date = new DateTime(2024, 3, 15, 14, 30, 0);

        // ─── INTERPOLATION WITH FORMAT SPECIFIERS ───
        Console.WriteLine(\$"{pi:F2}");       // 3.14
        Console.WriteLine(\$"{pi:F6}");       // 3.141593
        Console.WriteLine(\$"{pi:E3}");       // 3.142E+000
        Console.WriteLine(\$"{n:N0}");        // 1,234,567
        Console.WriteLine(\$"{n:D8}");        // 01234567
        Console.WriteLine(\$"{price:C}");     // \$9.99
        Console.WriteLine(\$"{0.75:P0}");     // 75%
        Console.WriteLine(\$"{255:X}");       // FF
        Console.WriteLine(\$"{255:x4}");      // 00ff

        // ─── ALIGNMENT ───
        Console.WriteLine(\$"{"Name",-15} {"Score",6}");
        Console.WriteLine(\$"{"Alice",-15} {95,6}");
        Console.WriteLine(\$"{"Bob",-15} {87,6}");
        Console.WriteLine(\$"{"Charlie",-15} {92,6}");
        // Name              Score
        // Alice                95
        // Bob                  87
        // Charlie              92

        // ─── DATE/TIME FORMATS ───
        Console.WriteLine(\$"{date:yyyy-MM-dd}");         // 2024-03-15
        Console.WriteLine(\$"{date:HH:mm:ss}");           // 14:30:00
        Console.WriteLine(\$"{date:dddd, MMMM d, yyyy}"); // Friday, March 15, 2024
        Console.WriteLine(\$"{date:d}");   // short date (culture-dependent)
        Console.WriteLine(\$"{date:t}");   // short time
        Console.WriteLine(\$"{date:f}");   // full date/time
        Console.WriteLine(\$"{date:R}");   // RFC 1123: Fri, 15 Mar 2024 14:30:00 GMT
        Console.WriteLine(\$"{date:O}");   // ISO 8601 roundtrip

        // ─── STRING.FORMAT (old style, still valid) ───
        string msg = string.Format("Hello {0}, you have {1} messages.", "Alice", 5);
        Console.WriteLine(msg);

        string aligned = string.Format("{0,-10} {1,6:F2}", "Pi", pi);
        Console.WriteLine(aligned);  // Pi          3.14

        // ─── CULTURE-SPECIFIC FORMATTING ───
        CultureInfo us  = CultureInfo.GetCultureInfo("en-US");
        CultureInfo de  = CultureInfo.GetCultureInfo("de-DE");
        CultureInfo jp  = CultureInfo.GetCultureInfo("ja-JP");

        Console.WriteLine(price.ToString("C", us)); // \$9.99
        Console.WriteLine(price.ToString("C", de)); // 9,99 €
        Console.WriteLine(price.ToString("C", jp)); // ¥10

        Console.WriteLine(n.ToString("N", us));   // 1,234,567.00
        Console.WriteLine(n.ToString("N", de));   // 1.234.567,00

        // ─── FORMATTABLESTRING ───
        // Captures interpolation as data — useful for parameterized SQL, logging
        FormattableString fs = \$"SELECT * FROM users WHERE id = {42}";
        Console.WriteLine(fs.Format);       // SELECT * FROM users WHERE id = {0}
        Console.WriteLine(fs.ArgumentCount); // 1
        Console.WriteLine(fs.GetArgument(0)); // 42

        // ─── CUSTOM IFORMATTABLE ───
        var vec = new Vector3D(1.5, 2.7, 3.1);
        Console.WriteLine(\$"{vec}");          // (1.5, 2.7, 3.1)
        Console.WriteLine(\$"{vec:F1}");       // (1.5, 2.7, 3.1)
        Console.WriteLine(\$"{vec:F4}");       // (1.5000, 2.7000, 3.1000)
        Console.WriteLine(\$"{vec:short}");    // [1.5 2.7 3.1]

        // ─── COMPOSITE PADDING TABLE ───
        var sb = new StringBuilder();
        sb.AppendLine(\$"{"Product",-20} {"Qty",5} {"Price",10} {"Total",12}");
        sb.AppendLine(new string('-', 49));
        sb.AppendLine(\$"{"Widget",-20} {10,5} {9.99m,10:C} {99.90m,12:C}");
        sb.AppendLine(\$"{"Gadget",-20} {5,5} {24.99m,10:C} {124.95m,12:C}");
        Console.WriteLine(sb);
    }
}

class Vector3D : IFormattable
{
    public double X, Y, Z;
    public Vector3D(double x, double y, double z) { X = x; Y = y; Z = z; }

    public string ToString(string format, IFormatProvider provider)
    {
        if (format == "short")
            return \$"[{X} {Y} {Z}]";

        string fmt = string.IsNullOrEmpty(format) ? "G" : format;
        return \$"({X.ToString(fmt, provider)}, {Y.ToString(fmt, provider)}, {Z.ToString(fmt, provider)})";
    }

    public override string ToString() => ToString("G", CultureInfo.CurrentCulture);
}

📝 KEY POINTS:
✅ Format specifiers go after : in interpolation: \$"{value:F2}"
✅ Alignment goes after , in interpolation: \$"{value,-10}" (left) or \$"{value,10}" (right)
✅ Use :C for currency — it respects the current culture automatically
✅ FormattableString captures interpolation as data — useful for safe SQL/logging
✅ Implement IFormattable to make your types respond to format strings
❌ Don't hardcode currency symbols — use :C and CultureInfo
❌ Don't use string.Format in new code — prefer interpolation
''',
  quiz: [
    Quiz(question: 'What does the format specifier :N0 produce for the number 1234567?', options: [
      QuizOption(text: '"1,234,567" — number with thousand separators, no decimal places', correct: true),
      QuizOption(text: '"1234567.0"', correct: false),
      QuizOption(text: '"N1234567"', correct: false),
      QuizOption(text: '"01234567"', correct: false),
    ]),
    Quiz(question: 'What does negative width in alignment like {value,-15} do?', options: [
      QuizOption(text: 'Left-aligns the value in a field of 15 characters', correct: true),
      QuizOption(text: 'Right-aligns with a negative sign prefix', correct: false),
      QuizOption(text: 'Truncates the value to 15 characters', correct: false),
      QuizOption(text: 'Pads with dashes instead of spaces', correct: false),
    ]),
    Quiz(question: 'What is FormattableString useful for?', options: [
      QuizOption(text: 'Capturing interpolation format and arguments separately — useful for parameterized SQL', correct: true),
      QuizOption(text: 'Formatting strings faster than regular interpolation', correct: false),
      QuizOption(text: 'Creating multiline strings', correct: false),
      QuizOption(text: 'Applying culture settings to a string', correct: false),
    ]),
  ],
);
