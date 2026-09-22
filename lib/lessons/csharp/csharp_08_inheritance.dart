// lib/lessons/csharp/csharp_08_inheritance.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson08 = Lesson(
  language: 'C#',
  title: 'Inheritance',
  content: '''
🎯 METAPHOR:
Inheritance is like job titles in a company hierarchy.
A Software Engineer has all the skills of an Employee
(shows up, gets paid, has a name badge), PLUS coding skills.
A Senior Engineer has everything an Engineer has, PLUS
mentoring and architecture skills. Each level ADDS to what
came before — it never starts from zero. You build UP the
hierarchy, never sideways.

📖 EXPLANATION:
C# supports single inheritance (one parent class) but
multiple interface implementation.

Key keywords:
  : BaseClass          inherit from a class
  override             replace a virtual method
  virtual              allow overriding in subclasses
  abstract             must be overridden (no base implementation)
  sealed               prevent further inheritance
  base                 access the parent class members
  base()               call parent constructor

IMPORTANT: In C#, ALL methods are non-virtual by default.
You must explicitly mark them virtual to allow overriding.
This is the opposite of Java.

💻 CODE:
using System;

// ─── BASE CLASS ───
class Animal
{
    public string Name { get; set; }
    public int Age { get; set; }

    public Animal(string name, int age)
    {
        Name = name;
        Age = age;
    }

    // virtual — CAN be overridden
    public virtual void Speak()
    {
        Console.WriteLine(\$"{Name} makes a sound");
    }

    public virtual string Describe()
    {
        return \$"{Name}, age {Age}";
    }

    // NOT virtual — cannot be overridden
    public void Breathe()
    {
        Console.WriteLine(\$"{Name} breathes");
    }
}

// ─── DERIVED CLASS ───
class Dog : Animal
{
    public string Breed { get; set; }

    // Call base constructor with : base(...)
    public Dog(string name, int age, string breed)
        : base(name, age)
    {
        Breed = breed;
    }

    // override — replaces base implementation
    public override void Speak()
    {
        Console.WriteLine(\$"{Name} says: Woof!");
    }

    public override string Describe()
    {
        return base.Describe() + \$", {Breed}";  // call base version too
    }

    public void Fetch() => Console.WriteLine(\$"{Name} fetches the ball!");
}

// ─── ABSTRACT CLASS ───
abstract class Shape
{
    public string Color { get; set; } = "black";

    // abstract — MUST be overridden, has no body here
    public abstract double Area();
    public abstract double Perimeter();

    // concrete method — shared behavior
    public void Display()
    {
        Console.WriteLine(\$"{GetType().Name}: area={Area():F2}, perimeter={Perimeter():F2}");
    }
}

class Circle : Shape
{
    public double Radius { get; set; }
    public Circle(double r) => Radius = r;

    public override double Area() => Math.PI * Radius * Radius;
    public override double Perimeter() => 2 * Math.PI * Radius;
}

class Rectangle : Shape
{
    public double Width { get; set; }
    public double Height { get; set; }
    public Rectangle(double w, double h) { Width = w; Height = h; }

    public override double Area() => Width * Height;
    public override double Perimeter() => 2 * (Width + Height);
}

// ─── SEALED ───
sealed class FinalClass : Dog
{
    public FinalClass(string name) : base(name, 1, "Mix") {}
    // No one can inherit from FinalClass
}

class Program
{
    static void Main()
    {
        var dog = new Dog("Rex", 3, "Husky");
        dog.Speak();       // Rex says: Woof!
        dog.Breathe();     // Rex breathes (inherited, not overridable)
        dog.Fetch();       // Rex fetches the ball!
        Console.WriteLine(dog.Describe()); // Rex, age 3, Husky

        // Polymorphism — Animal reference holding a Dog
        Animal animal = new Dog("Luna", 2, "Poodle");
        animal.Speak();   // Luna says: Woof! (virtual dispatch)

        // Abstract classes
        var shapes = new Shape[] {
            new Circle(5),
            new Rectangle(4, 6)
        };

        foreach (var shape in shapes)
            shape.Display();
        // Circle: area=78.54, perimeter=31.42
        // Rectangle: area=24.00, perimeter=20.00

        // Shape s = new Shape();  // ERROR: cannot instantiate abstract class
    }
}

📝 KEY POINTS:
✅ All C# methods are non-virtual by default — add virtual explicitly
✅ Always use override when overriding — compiler catches typos
✅ Abstract classes cannot be instantiated directly
✅ sealed prevents a class or method from being further overridden
✅ Call base.Method() to extend (not replace) the parent's behavior
❌ C# does NOT support multiple class inheritance — only one base class
❌ Don't override without virtual — it compiles but hides, doesn't override
''',
  quiz: [
    Quiz(question: 'In C#, are methods virtual by default?', options: [
      QuizOption(text: 'No — you must explicitly mark them virtual to allow overriding', correct: true),
      QuizOption(text: 'Yes — all methods are virtual unless sealed', correct: false),
      QuizOption(text: 'Only public methods are virtual by default', correct: false),
      QuizOption(text: 'Only methods in abstract classes are virtual', correct: false),
    ]),
    Quiz(question: 'What does the "sealed" keyword do on a class?', options: [
      QuizOption(text: 'Prevents the class from being inherited', correct: true),
      QuizOption(text: 'Makes all members private', correct: false),
      QuizOption(text: 'Prevents the class from being instantiated', correct: false),
      QuizOption(text: 'Makes the class immutable', correct: false),
    ]),
    Quiz(question: 'What is the purpose of an abstract class?', options: [
      QuizOption(text: 'To define a base with some implementation and force subclasses to implement abstract members', correct: true),
      QuizOption(text: 'To create a class that cannot have methods', correct: false),
      QuizOption(text: 'To create a class that can only be used as a variable type', correct: false),
      QuizOption(text: 'To prevent a class from having a constructor', correct: false),
    ]),
  ],
);
