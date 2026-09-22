// lib/lessons/csharp/csharp_25_attributes_reflection.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson25 = Lesson(
  language: 'C#',
  title: 'Attributes and Reflection',
  content: '''
🎯 METAPHOR:
Attributes are like sticky labels on a package.
The box (class/method) does its job — but the label says
"FRAGILE," "THIS SIDE UP," or "REFRIGERATE."
Other systems read those labels and behave accordingly.
[Obsolete] is a "DO NOT USE" sticker. [Required] is
a "MUST BE FILLED" sticker. The code still compiles,
but the label changes how tools, frameworks, and other
code interact with it.

Reflection is like reading those labels at runtime.
"What labels does this box have? What type is it?
What methods does it have?" Reflection lets code
inspect ITSELF and other code.

📖 EXPLANATION:
ATTRIBUTES — metadata attached to code elements.
  Applied with [AttributeName] before the target.
  Read at compile time by the compiler or at runtime via Reflection.
  Used extensively by: ASP.NET, Entity Framework, test frameworks,
  serialization libraries, Unity, etc.

REFLECTION — the System.Reflection namespace.
  Inspect types, methods, properties at runtime.
  Create instances dynamically.
  Call methods dynamically.
  Used by: dependency injection, ORMs, serializers.

💻 CODE:
using System;
using System.Reflection;
using System.ComponentModel.DataAnnotations;

// ─── BUILT-IN ATTRIBUTES ───
[Obsolete("Use NewMethod() instead", error: false)]
static void OldMethod() => Console.WriteLine("Old method");

// ─── CUSTOM ATTRIBUTE ───
[AttributeUsage(AttributeTargets.Class | AttributeTargets.Method,
                AllowMultiple = false,
                Inherited = true)]
class AuthorAttribute : Attribute
{
    public string Name { get; }
    public string Version { get; }

    public AuthorAttribute(string name, string version = "1.0")
    {
        Name = name;
        Version = version;
    }
}

[Author("Alice", "2.0")]
class MyService
{
    [Author("Bob")]
    public void ProcessData() => Console.WriteLine("Processing...");

    [Obsolete("Use ProcessDataV2 instead")]
    public void OldProcess() { }

    public void ProcessDataV2() => Console.WriteLine("V2 Processing...");
}

// ─── DATA ANNOTATIONS (validation attributes) ───
class UserModel
{
    [Required(ErrorMessage = "Name is required")]
    [StringLength(50, MinimumLength = 2)]
    public string Name { get; set; }

    [Required]
    [EmailAddress]
    public string Email { get; set; }

    [Range(0, 150)]
    public int Age { get; set; }

    [Phone]
    public string PhoneNumber { get; set; }
}

class Program
{
    static void Main()
    {
        // ─── REFLECTION: Inspect a type ───
        Type type = typeof(MyService);

        Console.WriteLine(\$"Type: {type.Name}");
        Console.WriteLine(\$"Namespace: {type.Namespace}");
        Console.WriteLine(\$"Is class: {type.IsClass}");

        // Get all public methods
        Console.WriteLine("\\nMethods:");
        foreach (var method in type.GetMethods(BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly))
        {
            Console.WriteLine(\$"  {method.ReturnType.Name} {method.Name}()");
        }

        // ─── READ CUSTOM ATTRIBUTE ───
        var authorAttr = type.GetCustomAttribute<AuthorAttribute>();
        if (authorAttr != null)
            Console.WriteLine(\$"\\nAuthor: {authorAttr.Name} v{authorAttr.Version}");

        // Check method for attribute
        var method2 = type.GetMethod("ProcessData");
        var methodAuthor = method2?.GetCustomAttribute<AuthorAttribute>();
        Console.WriteLine(\$"Method author: {methodAuthor?.Name}");

        // Get all properties
        Type userType = typeof(UserModel);
        Console.WriteLine("\\nUserModel properties and their attributes:");
        foreach (var prop in userType.GetProperties())
        {
            Console.Write(\$"  {prop.PropertyType.Name} {prop.Name}");
            var attrs = prop.GetCustomAttributes();
            foreach (var attr in attrs)
                Console.Write(\$" [{attr.GetType().Name.Replace("Attribute", "")}]");
            Console.WriteLine();
        }

        // ─── REFLECTION: Create instance dynamically ───
        object instance = Activator.CreateInstance(typeof(MyService));
        MethodInfo processMethod = typeof(MyService).GetMethod("ProcessData");
        processMethod?.Invoke(instance, null);  // Calls ProcessData()

        // ─── REFLECTION: Set/Get properties dynamically ───
        var user = new UserModel();
        Type t = user.GetType();

        PropertyInfo nameProp = t.GetProperty("Name");
        nameProp?.SetValue(user, "Alice");

        string name = (string)nameProp?.GetValue(user);
        Console.WriteLine(\$"\\nName set via reflection: {name}");

        // ─── DATA ANNOTATION VALIDATION ───
        var invalidUser = new UserModel { Name = "A", Email = "not-an-email", Age = 200 };
        var context = new ValidationContext(invalidUser);
        var results = new System.Collections.Generic.List<ValidationResult>();
        bool isValid = Validator.TryValidateObject(invalidUser, context, results, true);

        Console.WriteLine(\$"\\nValid: {isValid}");
        foreach (var result in results)
            Console.WriteLine(\$"  Error: {result.ErrorMessage}");
    }
}

📝 KEY POINTS:
✅ Attributes add declarative metadata to code elements
✅ [Obsolete] triggers compiler warnings when marked code is used
✅ Data annotations ([Required], [Range]) are used by ASP.NET and EF Core
✅ Reflection is powerful but slow — cache reflected data when possible
✅ typeof(T) gets the type at compile time; obj.GetType() at runtime
❌ Don't use reflection in performance-critical hot paths
❌ Custom attributes must inherit from System.Attribute
''',
  quiz: [
    Quiz(question: 'What does the [Obsolete] attribute do?', options: [
      QuizOption(text: 'Generates a compiler warning (or error) when the marked member is used', correct: true),
      QuizOption(text: 'Removes the member from compiled output', correct: false),
      QuizOption(text: 'Prevents the member from being called at runtime', correct: false),
      QuizOption(text: 'Marks the member as internal', correct: false),
    ]),
    Quiz(question: 'What is reflection used for in C#?', options: [
      QuizOption(text: 'Inspecting and interacting with types, methods, and properties at runtime', correct: true),
      QuizOption(text: 'Mirroring objects to create copies', correct: false),
      QuizOption(text: 'Compiling code at runtime', correct: false),
      QuizOption(text: 'Generating documentation automatically', correct: false),
    ]),
    Quiz(question: 'What does Activator.CreateInstance(typeof(MyClass)) do?', options: [
      QuizOption(text: 'Creates an instance of MyClass dynamically at runtime', correct: true),
      QuizOption(text: 'Activates a singleton instance of MyClass', correct: false),
      QuizOption(text: 'Calls the static constructor of MyClass', correct: false),
      QuizOption(text: 'Creates a deep copy of a MyClass instance', correct: false),
    ]),
  ],
);
