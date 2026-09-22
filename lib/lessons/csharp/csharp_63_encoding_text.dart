// lib/lessons/csharp/csharp_63_encoding_text.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson63 = Lesson(
  language: 'C#',
  title: 'Encoding, Text, and Globalization',
  content: '''
🎯 METAPHOR:
Text encoding is like a translation codebook.
The letter "A" is not the number 65 — until you agree on
a codebook (encoding) that says it is. ASCII is a tiny
codebook (128 entries, English only). UTF-8 is a vast
international codebook that represents every character in
every human language — but uses 1-4 bytes per character.
UTF-16 is C#'s internal format — every char is 2 bytes.
When bytes cross a boundary (file, network, database),
you must AGREE on the encoding — or garbage results.

Globalization is the bigger picture: dates, numbers,
currencies, and sorting all look different around the world.
"1/3/2024" means January 3rd in the US and March 1st in Europe.
CultureInfo is the rulebook for a specific region.

📖 EXPLANATION:
ENCODING — converting between text (string) and bytes:
  Encoding.UTF8        — most common for files/network
  Encoding.ASCII       — 128 chars, English only
  Encoding.Unicode     — UTF-16 (C# native)
  Encoding.Latin1      — Western European
  Encoding.GetEncoding("windows-1252")  — by name/codepage

BASE64 — binary data as printable ASCII text:
  Convert.ToBase64String()
  Convert.FromBase64String()

GLOBALIZATION:
  CultureInfo         — region-specific formatting rules
  Thread.CurrentCulture / CurrentUICulture
  IFormatProvider     — pass culture to format methods
  StringComparer      — culture-aware string comparison
  CultureInfo.InvariantCulture — culture-independent

💻 CODE:
using System;
using System.Text;
using System.Globalization;
using System.Threading;

class Program
{
    static void Main()
    {
        // ─── ENCODING: string ↔ bytes ───
        string text = "Hello, 世界! 🌍";  // Unicode text

        // UTF-8: variable width (1-4 bytes per char)
        byte[] utf8Bytes = Encoding.UTF8.GetBytes(text);
        Console.WriteLine(\$"UTF-8 bytes: {utf8Bytes.Length}");  // ~20

        string fromUtf8 = Encoding.UTF8.GetString(utf8Bytes);
        Console.WriteLine(fromUtf8);  // Hello, 世界! 🌍

        // UTF-16 (Unicode): 2 bytes per code unit
        byte[] utf16Bytes = Encoding.Unicode.GetBytes(text);
        Console.WriteLine(\$"UTF-16 bytes: {utf16Bytes.Length}");  // varies

        // ASCII: only 128 chars — non-ASCII becomes ?
        byte[] asciiBytes = Encoding.ASCII.GetBytes("Hello!");
        Console.WriteLine(Encoding.ASCII.GetString(asciiBytes));  // Hello!

        // ─── BYTE COUNT BEFORE ALLOCATING ───
        int byteCount = Encoding.UTF8.GetByteCount(text);
        byte[] buffer = new byte[byteCount];
        int written = Encoding.UTF8.GetBytes(text, 0, text.Length, buffer, 0);
        Console.WriteLine(\$"Written: {written} bytes");

        // ─── BASE64 ───
        byte[] data = { 0x48, 0x65, 0x6C, 0x6C, 0x6F };  // "Hello"
        string base64 = Convert.ToBase64String(data);
        Console.WriteLine(base64);  // SGVsbG8=

        byte[] decoded = Convert.FromBase64String(base64);
        Console.WriteLine(Encoding.ASCII.GetString(decoded));  // Hello

        // Base64 URL-safe (replace + with - and / with _)
        string urlSafe = base64.Replace('+', '-').Replace('/', '_').TrimEnd('=');

        // ─── CULTURE INFO ───
        var us  = new CultureInfo("en-US");
        var de  = new CultureInfo("de-DE");
        var fr  = new CultureInfo("fr-FR");
        var tr  = new CultureInfo("tr-TR");

        decimal price = 1234567.89m;
        Console.WriteLine(price.ToString("C", us));   // \$1,234,567.89
        Console.WriteLine(price.ToString("C", de));   // 1.234.567,89 €
        Console.WriteLine(price.ToString("C", fr));   // 1 234 567,89 €

        DateTime date = new DateTime(2024, 3, 15);
        Console.WriteLine(date.ToString("d", us));    // 3/15/2024
        Console.WriteLine(date.ToString("d", de));    // 15.03.2024
        Console.WriteLine(date.ToString("d", fr));    // 15/03/2024

        // Parsing with culture
        decimal parsed = decimal.Parse("1.234.567,89", de);
        Console.WriteLine(parsed);  // 1234567.89

        // ─── INVARIANT CULTURE (for data, not UI) ───
        // Always use InvariantCulture for data that crosses systems
        string stored = price.ToString(CultureInfo.InvariantCulture);
        Console.WriteLine(stored);  // 1234567.89 (always this format)

        decimal restored = decimal.Parse(stored, CultureInfo.InvariantCulture);
        Console.WriteLine(restored);  // 1234567.89

        // ─── STRING COMPARISON ───
        string a = "café";
        string b = "cafe";

        // Ordinal (byte comparison — fastest, culture-unaware)
        Console.WriteLine(string.Compare(a, b, StringComparison.Ordinal));  // != 0

        // Current culture (linguistic comparison)
        Console.WriteLine(string.Compare(a, b, StringComparison.CurrentCulture));

        // Ignore case
        Console.WriteLine(string.Equals("Hello", "hello", StringComparison.OrdinalIgnoreCase)); // True

        // Turkish i problem: "i".ToUpper() = "İ" in Turkish culture!
        Thread.CurrentThread.CurrentCulture = tr;
        Console.WriteLine("i".ToUpper());      // İ (Turkish dotted I)
        Thread.CurrentThread.CurrentCulture = us;
        Console.WriteLine("i".ToUpper());      // I

        // Safe: always use Ordinal or InvariantCulture for code logic
        Console.WriteLine("file.TXT".Equals("file.txt", StringComparison.OrdinalIgnoreCase)); // True

        // ─── STRING COMPARER FOR COLLECTIONS ───
        var dict = new System.Collections.Generic.Dictionary<string, int>(
            StringComparer.OrdinalIgnoreCase);
        dict["hello"] = 1;
        Console.WriteLine(dict["HELLO"]);  // 1 — case-insensitive key lookup

        // ─── UNICODE NORMALIZATION ───
        // "café" can be stored as "cafe\u0301" (e + combining accent)
        // or "caf\u00E9" (precomposed é)
        string form1 = "caf\u00E9";           // precomposed
        string form2 = "cafe\u0301";          // decomposed
        Console.WriteLine(form1 == form2);    // False (byte-different)
        Console.WriteLine(string.Compare(form1, form2,
            StringComparison.InvariantCulture) == 0);  // True (linguistically same)
    }
}

📝 KEY POINTS:
✅ Use UTF-8 for files and network; C# strings are internally UTF-16
✅ Always specify encoding when reading/writing files (default is UTF-8 with BOM)
✅ Use CultureInfo.InvariantCulture for data serialization/parsing
✅ Use StringComparison.OrdinalIgnoreCase for case-insensitive comparisons in code
✅ The Turkish i problem is real — never use ToUpper()/ToLower() for code logic
✅ StringComparer.OrdinalIgnoreCase makes Dictionary keys case-insensitive
❌ Never compare formatted numbers/dates across cultures without specifying the culture
❌ Don't use CurrentCulture for data storage — it changes per machine
''',
  quiz: [
    Quiz(question: 'Which encoding should you use for data serialization that crosses different systems?', options: [
      QuizOption(text: 'CultureInfo.InvariantCulture — culture-independent formatting', correct: true),
      QuizOption(text: 'CultureInfo.CurrentCulture — use the machine\'s local settings', correct: false),
      QuizOption(text: 'en-US culture — most widely used', correct: false),
      QuizOption(text: 'No culture needed — numbers are universal', correct: false),
    ]),
    Quiz(question: 'What is the "Turkish i problem" in C#?', options: [
      QuizOption(text: '"i".ToUpper() returns "İ" in Turkish culture, breaking culture-sensitive code comparisons', correct: true),
      QuizOption(text: 'Turkish characters cannot be stored in a C# string', correct: false),
      QuizOption(text: 'Turkish locale causes DateTime.Parse to fail', correct: false),
      QuizOption(text: 'The letter i cannot be compared with == in Turkish culture', correct: false),
    ]),
    Quiz(question: 'What does Convert.ToBase64String() do?', options: [
      QuizOption(text: 'Encodes binary data as a printable ASCII string', correct: true),
      QuizOption(text: 'Converts a number to base 64', correct: false),
      QuizOption(text: 'Encodes a string in 64-bit Unicode', correct: false),
      QuizOption(text: 'Compresses a byte array', correct: false),
    ]),
  ],
);
