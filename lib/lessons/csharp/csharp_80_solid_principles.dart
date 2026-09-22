// lib/lessons/csharp/csharp_80_solid_principles.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson80 = Lesson(
  language: 'C#',
  title: 'SOLID Principles in C#',
  content: '''
🎯 METAPHOR:
SOLID principles are five rules that keep your code from
turning into a tightly wound ball of yarn. Pull one thread
(change one class) and it shouldn't unravel everything else.
Each principle enforces a different kind of "keep things
separate" — separate responsibilities, separate extension
from modification, separate concrete from abstract.
Code that follows SOLID is easy to test, easy to change,
and easy for other developers to understand.

📖 EXPLANATION:
S — Single Responsibility Principle
    A class should have ONE reason to change.

O — Open/Closed Principle
    Open for extension, closed for modification.
    Add new behavior by adding new code, not editing old code.

L — Liskov Substitution Principle
    Derived classes must be substitutable for their base class.
    If S inherits from T, you can use S wherever T is expected.

I — Interface Segregation Principle
    Clients should not depend on interfaces they don't use.
    Many small interfaces > one large interface.

D — Dependency Inversion Principle
    Depend on abstractions, not concretions.
    High-level modules should not depend on low-level modules.

💻 CODE:
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

// ─── S: SINGLE RESPONSIBILITY ───
// BAD: UserService does too many things
class BadUserService
{
    public void CreateUser(string name, string email) { /* ... */ }
    public void SendWelcomeEmail(string email) { /* ... */ }  // email responsibility
    public void SaveToDatabase(object user) { /* ... */ }     // DB responsibility
    public string GenerateReport() { return "..."; }          // reporting responsibility
}

// GOOD: Each class has one job
class UserRepository
{
    public void Save(User user)   => Console.WriteLine(\$"Saving {user.Name}");
    public User Find(int id)      => new User { Id = id, Name = "Alice" };
    public void Delete(int id)    => Console.WriteLine(\$"Deleting {id}");
}

class UserEmailService
{
    public void SendWelcome(string email)    => Console.WriteLine(\$"Welcome email → {email}");
    public void SendReset(string email)      => Console.WriteLine(\$"Reset email → {email}");
}

class UserService
{
    private readonly UserRepository _repo;
    private readonly UserEmailService _email;
    public UserService(UserRepository repo, UserEmailService email)
    { _repo = repo; _email = email; }

    public void Register(string name, string email)
    {
        var user = new User { Name = name, Email = email };
        _repo.Save(user);
        _email.SendWelcome(email);
    }
}

class User { public int Id; public string Name; public string Email; }

// ─── O: OPEN/CLOSED ───
// BAD: must modify this class for every new discount type
class BadDiscountCalculator
{
    public decimal Calculate(string type, decimal price) => type switch
    {
        "vip"      => price * 0.8m,
        "student"  => price * 0.9m,
        // Adding "senior" requires modifying this class!
        _ => price
    };
}

// GOOD: add new discounts without changing existing code
interface IDiscountStrategy
{
    decimal Apply(decimal price);
    bool Applies(string customerType);
}
class VipDiscount     : IDiscountStrategy { public decimal Apply(decimal p) => p * 0.8m; public bool Applies(string t) => t == "vip"; }
class StudentDiscount : IDiscountStrategy { public decimal Apply(decimal p) => p * 0.9m; public bool Applies(string t) => t == "student"; }
class SeniorDiscount  : IDiscountStrategy { public decimal Apply(decimal p) => p * 0.85m; public bool Applies(string t) => t == "senior"; }

class DiscountCalculator
{
    private readonly List<IDiscountStrategy> _strategies;
    public DiscountCalculator(IEnumerable<IDiscountStrategy> strategies)
        => _strategies = strategies.ToList();

    public decimal Calculate(string type, decimal price)
        => _strategies.FirstOrDefault(s => s.Applies(type))?.Apply(price) ?? price;
}

// ─── L: LISKOV SUBSTITUTION ───
// BAD: Square "breaks" the Rectangle contract
class BadRectangle { public virtual double Width { get; set; } public virtual double Height { get; set; } }
class BadSquare : BadRectangle
{
    public override double Width  { get => base.Width;  set { base.Width = value; base.Height = value; } }
    public override double Height { get => base.Height; set { base.Height = value; base.Width = value; } }
    // Violates LSP: setting Width also changes Height — unexpected for a Rectangle
}

// GOOD: separate shapes, both implement IShape
interface IShape { double Area(); }
class Rectangle2 : IShape { public double W, H; public double Area() => W * H; }
class Square2 : IShape { public double Side; public double Area() => Side * Side; }

// ─── I: INTERFACE SEGREGATION ───
// BAD: one fat interface
interface IBadWorker
{
    void Work();
    void Eat();
    void Sleep();
    // Robots can Work() but not Eat() or Sleep()!
}

// GOOD: small focused interfaces
interface IWorkable { void Work(); }
interface IEatable  { void Eat(); }
interface ISleepable { void Sleep(); }

class HumanWorker : IWorkable, IEatable, ISleepable
{
    public void Work()  => Console.WriteLine("Human working");
    public void Eat()   => Console.WriteLine("Human eating");
    public void Sleep() => Console.WriteLine("Human sleeping");
}

class RobotWorker : IWorkable
{
    public void Work() => Console.WriteLine("Robot working");
    // No Eat or Sleep — clean!
}

// ─── D: DEPENDENCY INVERSION ───
// BAD: OrderService depends directly on SqlDatabase
class BadOrderService
{
    private SqlDatabase _db = new SqlDatabase();  // concrete dependency!
    public void PlaceOrder(string item) => _db.Save(item);
}
class SqlDatabase { public void Save(string x) => Console.WriteLine(\$"SQL: {x}"); }

// GOOD: depend on abstraction
interface IOrderRepository { void Save(string item); }
class SqlOrderRepository : IOrderRepository   { public void Save(string x) => Console.WriteLine(\$"SQL: {x}"); }
class NoSqlOrderRepository : IOrderRepository { public void Save(string x) => Console.WriteLine(\$"NoSQL: {x}"); }

class OrderService
{
    private readonly IOrderRepository _repo;
    public OrderService(IOrderRepository repo) => _repo = repo;  // injected!
    public void PlaceOrder(string item) => _repo.Save(item);
}

class Program
{
    static void Main()
    {
        // S
        var userSvc = new UserService(new UserRepository(), new UserEmailService());
        userSvc.Register("Alice", "alice@example.com");

        // O
        var calc = new DiscountCalculator(new IDiscountStrategy[]
            { new VipDiscount(), new StudentDiscount(), new SeniorDiscount() });
        Console.WriteLine(calc.Calculate("vip", 100));     // 80
        Console.WriteLine(calc.Calculate("student", 100)); // 90
        Console.WriteLine(calc.Calculate("senior", 100));  // 85
        Console.WriteLine(calc.Calculate("regular", 100)); // 100

        // L
        IShape[] shapes = { new Rectangle2 { W = 4, H = 5 }, new Square2 { Side = 4 } };
        foreach (var s in shapes) Console.WriteLine(s.Area());  // 20, 16

        // I
        IWorkable[] workers = { new HumanWorker(), new RobotWorker() };
        foreach (var w in workers) w.Work();

        // D
        OrderService sqlOrders   = new(new SqlOrderRepository());
        OrderService noSqlOrders = new(new NoSqlOrderRepository());
        sqlOrders.PlaceOrder("Widget");    // SQL: Widget
        noSqlOrders.PlaceOrder("Gadget");  // NoSQL: Gadget
    }
}

📝 KEY POINTS:
✅ Single Responsibility: if a class changes for two different reasons, split it
✅ Open/Closed: use interfaces + DI to add behaviors without editing existing code
✅ Liskov: derived types must honor ALL contracts of the base type
✅ Interface Segregation: prefer many small interfaces over one large one
✅ Dependency Inversion: depend on IRepository, not SqlRepository
❌ Don't apply SOLID blindly to tiny scripts — it's for systems that grow
❌ LSP violation (like Bad Square) causes subtle bugs in polymorphic code
''',
  quiz: [
    Quiz(question: 'What does the Single Responsibility Principle state?', options: [
      QuizOption(text: 'A class should have only one reason to change', correct: true),
      QuizOption(text: 'A class should have only one method', correct: false),
      QuizOption(text: 'A class should inherit from only one base class', correct: false),
      QuizOption(text: 'A class should implement only one interface', correct: false),
    ]),
    Quiz(question: 'What does the Dependency Inversion Principle say about dependencies?', options: [
      QuizOption(text: 'Depend on abstractions (interfaces), not concrete implementations', correct: true),
      QuizOption(text: 'Dependencies should be passed as constructor parameters', correct: false),
      QuizOption(text: 'High-level modules should control low-level modules', correct: false),
      QuizOption(text: 'All dependencies should be singletons', correct: false),
    ]),
    Quiz(question: 'The Bad Square / Rectangle example violates which SOLID principle?', options: [
      QuizOption(text: 'Liskov Substitution — Square cannot be substituted for Rectangle without breaking behavior', correct: true),
      QuizOption(text: 'Single Responsibility — Square has too many responsibilities', correct: false),
      QuizOption(text: 'Open/Closed — Square modifies Rectangle instead of extending it', correct: false),
      QuizOption(text: 'Interface Segregation — the interface is too large', correct: false),
    ]),
  ],
);
