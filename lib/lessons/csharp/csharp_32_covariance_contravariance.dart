// lib/lessons/csharp/csharp_32_covariance_contravariance.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson32 = Lesson(
  language: 'C#',
  title: 'Covariance and Contravariance',
  content: '''
🎯 METAPHOR:
Covariance is like a fruit basket rule.
"I need a basket of fruit" — a basket of apples qualifies,
because apples ARE fruit. You can substitute a more specific
type where a more general type is expected.
IEnumerable<Apple> can be used as IEnumerable<Fruit>.

Contravariance is the reverse.
"I need someone who can sort ANY fruit" — an animal trainer
who handles all animals can certainly handle dogs.
A handler for a general type can handle a specific type.
Action<Fruit> can be used where Action<Apple> is expected
— because if it can process any fruit, it can process apples.

📖 EXPLANATION:
COVARIANCE (out T) — a generic type parameter marked out
can be used in a "wider" (base type) context.
Think: producing / outputting values.
  IEnumerable<T>, IReadOnlyList<T>, Func<out TResult>

CONTRAVARIANCE (in T) — a generic type parameter marked in
can be used in a "narrower" (derived type) context.
Think: consuming / inputting values.
  IComparer<T>, Action<in T>

Only applies to:
  - Interfaces
  - Delegates
  - NOT classes or structs

💻 CODE:
using System;
using System.Collections.Generic;

class Animal { public string Name { get; set; } }
class Dog : Animal { public void Fetch() => Console.WriteLine(\$"{Name} fetches!"); }
class Cat : Animal { public void Purr() => Console.WriteLine(\$"{Name} purrs!"); }

// ─── COVARIANT INTERFACE (out) ───
interface IProducer<out T>
{
    T Produce();
    // T Consume(T item);  // ERROR: can't use T as input with 'out'
}

class DogProducer : IProducer<Dog>
{
    public Dog Produce() => new Dog { Name = "Rex" };
}

// ─── CONTRAVARIANT INTERFACE (in) ───
interface IConsumer<in T>
{
    void Consume(T item);
    // T Produce();  // ERROR: can't use T as output with 'in'
}

class AnimalConsumer : IConsumer<Animal>
{
    public void Consume(Animal a) => Console.WriteLine(\$"Processing: {a.Name}");
}

class Program
{
    static void Main()
    {
        // ─── COVARIANCE WITH IEnumerable<T> ───
        // IEnumerable<Dog> is covariant — can assign to IEnumerable<Animal>
        List<Dog> dogs = new() {
            new Dog { Name = "Rex" },
            new Dog { Name = "Buddy" }
        };

        // IEnumerable<T> is covariant (out T)
        IEnumerable<Animal> animals = dogs;  // works! Dog is-a Animal
        foreach (Animal a in animals)
            Console.WriteLine(a.Name);

        // List<T> is NOT covariant (not safe for writes)
        // List<Animal> animalList = dogs;  // ERROR — would allow adding cats!

        // ─── COVARIANCE WITH CUSTOM INTERFACE ───
        IProducer<Dog> dogProducer = new DogProducer();
        IProducer<Animal> animalProducer = dogProducer;  // covariant!
        Animal produced = animalProducer.Produce();
        Console.WriteLine(produced.Name);  // Rex

        // ─── CONTRAVARIANCE ───
        IConsumer<Animal> animalConsumer = new AnimalConsumer();
        IConsumer<Dog> dogConsumer = animalConsumer;  // contravariant!
        dogConsumer.Consume(new Dog { Name = "Luna" });  // Processing: Luna

        // ─── COVARIANCE WITH FUNC (return type) ───
        Func<Dog> getDog = () => new Dog { Name = "Spot" };
        Func<Animal> getAnimal = getDog;  // covariant return type
        Animal a2 = getAnimal();
        Console.WriteLine(a2.Name);  // Spot

        // ─── CONTRAVARIANCE WITH ACTION (parameter type) ───
        Action<Animal> processAnimal = a => Console.WriteLine(\$"Processing {a.Name}");
        Action<Dog> processDog = processAnimal;  // contravariant parameter
        processDog(new Dog { Name = "Max" });

        // ─── PRACTICAL EXAMPLE ───
        // Sort dogs using an IComparer<Animal> (contravariant)
        IComparer<Animal> animalNameComparer = Comparer<Animal>.Create(
            (a, b) => string.Compare(a.Name, b.Name)
        );

        // Works because IComparer<in T> is contravariant
        IComparer<Dog> dogNameComparer = animalNameComparer;

        var dogList = new List<Dog>
        {
            new() { Name = "Zara" },
            new() { Name = "Alpha" },
            new() { Name = "Max" }
        };
        dogList.Sort(dogNameComparer);
        foreach (var d in dogList) Console.WriteLine(d.Name);
        // Alpha, Max, Zara
    }
}

─────────────────────────────────────
COVARIANCE vs CONTRAVARIANCE:
─────────────────────────────────────
Covariance (out):
  IEnumerable<Dog>  → usable as IEnumerable<Animal>
  Func<Dog>         → usable as Func<Animal>
  "More specific" → "More general" (widening)

Contravariance (in):
  IComparer<Animal> → usable as IComparer<Dog>
  Action<Animal>    → usable as Action<Dog>
  "More general" → "More specific" (narrowing)
─────────────────────────────────────

📝 KEY POINTS:
✅ Covariance (out) enables assigning IEnumerable<Dog> to IEnumerable<Animal>
✅ Contravariance (in) enables assigning Action<Animal> to Action<Dog>
✅ IEnumerable<T> is covariant — read-only, safe to upcast
✅ List<T> is NOT covariant — it is read/write, so Dog-list cannot accept Cats
✅ Func<out T> is covariant on the return type
❌ You cannot have an invariant type parameter be both covariant and contravariant
❌ Covariance/contravariance only applies to interfaces and delegates, not classes
''',
  quiz: [
    Quiz(question: 'What does the "out" keyword on a generic type parameter indicate?', options: [
      QuizOption(text: 'Covariance — the type can be used in a more general (base type) context', correct: true),
      QuizOption(text: 'Contravariance — the type can be used in a more specific context', correct: false),
      QuizOption(text: 'The parameter is output-only and passed by reference', correct: false),
      QuizOption(text: 'The type parameter has no constraints', correct: false),
    ]),
    Quiz(question: 'Why can\'t List<Dog> be assigned to List<Animal>?', options: [
      QuizOption(text: 'List<T> is read/write — allowing it would let you add Cats to a Dog list', correct: true),
      QuizOption(text: 'List<T> only supports invariant types', correct: false),
      QuizOption(text: 'Dog does not inherit from Animal in this context', correct: false),
      QuizOption(text: 'List<T> is a struct and cannot be assigned this way', correct: false),
    ]),
    Quiz(question: 'Which built-in interface is an example of contravariance?', options: [
      QuizOption(text: 'IComparer<in T>', correct: true),
      QuizOption(text: 'IEnumerable<out T>', correct: false),
      QuizOption(text: 'IReadOnlyList<out T>', correct: false),
      QuizOption(text: 'ICollection<T>', correct: false),
    ]),
  ],
);
