// lib/lessons/csharp/csharp_87_reflection_emit.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson87 = Lesson(
  language: 'C#',
  title: 'Reflection.Emit and Dynamic Code Generation',
  content: '''
🎯 METAPHOR:
Reflection.Emit is like being a compiler yourself.
Normal C# code is text you write → compiler turns it into IL
(Intermediate Language) → runtime executes it.
Reflection.Emit lets you WRITE IL directly, at RUNTIME,
and immediately execute it. You become the compiler.
This is how serializers, ORMs, and DI containers generate
blazing-fast code at startup that would take hours to
write by hand. AutoMapper, Dapper, and FastMember use it.

Expression Trees (from lesson 44) compile to IL via .Compile().
Reflection.Emit gives you even more direct control —
but is much harder to use correctly.

📖 EXPLANATION:
System.Reflection.Emit:
  AssemblyBuilder     — create a new assembly dynamically
  ModuleBuilder       — a module inside the assembly
  TypeBuilder         — define a new type
  MethodBuilder       — define a method
  ILGenerator         — emit IL opcodes
  DynamicMethod       — single lightweight dynamic method (simpler)

DYNAMIC METHOD (most common use):
  - Lighter than full TypeBuilder
  - Generate a single method and get a delegate
  - No assembly overhead
  - Used for: fast property access, serialization, mapping

EXPRESSION TREES (simpler alternative):
  - Compile expressions to delegates
  - Higher level than IL
  - Preferred for most dynamic code generation

💻 CODE:
using System;
using System.Reflection;
using System.Reflection.Emit;

// ─── DYNAMIC METHOD: fast property getter ───
class DynamicPropertyAccess
{
    // Generate a strongly-typed property getter at runtime
    // Instead of slow reflection (PropertyInfo.GetValue),
    // create a compiled delegate that runs at native speed
    public static Func<T, TResult> CreateGetter<T, TResult>(string propertyName)
    {
        PropertyInfo prop = typeof(T).GetProperty(propertyName)
            ?? throw new ArgumentException(\$"Property {propertyName} not found");

        // Create a dynamic method: TResult Method(T instance)
        var method = new DynamicMethod(
            name: \$"Get_{propertyName}",
            returnType: typeof(TResult),
            parameterTypes: new[] { typeof(T) },
            owner: typeof(T),
            skipVisibility: true);

        ILGenerator il = method.GetILGenerator();

        // IL: load arg0 (the instance), call get_PropertyName, return
        il.Emit(OpCodes.Ldarg_0);              // push instance onto stack
        il.Emit(OpCodes.Callvirt, prop.GetGetMethod(nonPublic: true));  // call getter
        il.Emit(OpCodes.Ret);                  // return

        return (Func<T, TResult>)method.CreateDelegate(typeof(Func<T, TResult>));
    }

    // Generate a property setter
    public static Action<T, TValue> CreateSetter<T, TValue>(string propertyName)
    {
        PropertyInfo prop = typeof(T).GetProperty(propertyName)
            ?? throw new ArgumentException(\$"Property {propertyName} not found");

        var method = new DynamicMethod(
            \$"Set_{propertyName}",
            typeof(void),
            new[] { typeof(T), typeof(TValue) },
            typeof(T), true);

        ILGenerator il = method.GetILGenerator();
        il.Emit(OpCodes.Ldarg_0);   // push instance
        il.Emit(OpCodes.Ldarg_1);   // push value
        il.Emit(OpCodes.Callvirt, prop.GetSetMethod(nonPublic: true));
        il.Emit(OpCodes.Ret);

        return (Action<T, TValue>)method.CreateDelegate(typeof(Action<T, TValue>));
    }
}

// ─── TYPEBUILDER: create a whole new type at runtime ───
class DynamicTypeCreator
{
    public static Type CreateSimpleClass(string typeName, string[] properties)
    {
        AssemblyName asmName = new AssemblyName("DynamicAssembly");
        AssemblyBuilder asmBuilder = AssemblyBuilder.DefineDynamicAssembly(
            asmName, AssemblyBuilderAccess.Run);

        ModuleBuilder modBuilder = asmBuilder.DefineDynamicModule("DynamicModule");

        TypeBuilder typeBuilder = modBuilder.DefineType(
            typeName,
            TypeAttributes.Public | TypeAttributes.Class);

        foreach (string prop in properties)
        {
            // Create backing field
            FieldBuilder field = typeBuilder.DefineField(
                \$"_{prop.ToLower()}", typeof(string), FieldAttributes.Private);

            // Create property
            PropertyBuilder property = typeBuilder.DefineProperty(
                prop, PropertyAttributes.None, typeof(string), null);

            // Create getter
            MethodBuilder getter = typeBuilder.DefineMethod(
                \$"get_{prop}",
                MethodAttributes.Public | MethodAttributes.SpecialName | MethodAttributes.Virtual,
                typeof(string), Type.EmptyTypes);

            ILGenerator getIL = getter.GetILGenerator();
            getIL.Emit(OpCodes.Ldarg_0);
            getIL.Emit(OpCodes.Ldfld, field);
            getIL.Emit(OpCodes.Ret);

            // Create setter
            MethodBuilder setter = typeBuilder.DefineMethod(
                \$"set_{prop}",
                MethodAttributes.Public | MethodAttributes.SpecialName | MethodAttributes.Virtual,
                null, new[] { typeof(string) });

            ILGenerator setIL = setter.GetILGenerator();
            setIL.Emit(OpCodes.Ldarg_0);
            setIL.Emit(OpCodes.Ldarg_1);
            setIL.Emit(OpCodes.Stfld, field);
            setIL.Emit(OpCodes.Ret);

            property.SetGetMethod(getter);
            property.SetSetMethod(setter);
        }

        return typeBuilder.CreateType();
    }
}

// ─── TEST SUBJECTS ───
class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
    public string Email { get; set; }
}

class Program
{
    static void Main()
    {
        // ─── DYNAMIC PROPERTY ACCESS ───
        var getter = DynamicPropertyAccess.CreateGetter<Person, string>("Name");
        var setter = DynamicPropertyAccess.CreateSetter<Person, string>("Name");

        var person = new Person { Name = "Alice", Age = 30 };

        // Generated getter — runs at native speed (no reflection overhead in hot path)
        Console.WriteLine(getter(person));  // Alice

        setter(person, "Bob");
        Console.WriteLine(person.Name);     // Bob

        // ─── PERFORMANCE COMPARISON ───
        var sw = System.Diagnostics.Stopwatch.StartNew();
        PropertyInfo prop = typeof(Person).GetProperty("Name");

        // Reflection (slow)
        for (int i = 0; i < 1_000_000; i++)
            _ = (string)prop.GetValue(person);
        Console.WriteLine(\$"Reflection: {sw.ElapsedMilliseconds}ms");

        sw.Restart();
        // Dynamic method (fast)
        for (int i = 0; i < 1_000_000; i++)
            _ = getter(person);
        Console.WriteLine(\$"Dynamic:    {sw.ElapsedMilliseconds}ms");

        // ─── DYNAMIC TYPE ───
        Type dynamicType = DynamicTypeCreator.CreateSimpleClass(
            "DynamicPerson", new[] { "Name", "Email", "City" });

        object instance = Activator.CreateInstance(dynamicType);
        dynamicType.GetProperty("Name").SetValue(instance, "Dynamic Alice");
        dynamicType.GetProperty("Email").SetValue(instance, "alice@dynamic.com");

        string name = (string)dynamicType.GetProperty("Name").GetValue(instance);
        Console.WriteLine(\$"Dynamic type: {name}");
        Console.WriteLine(\$"Type name: {dynamicType.Name}");
        Console.WriteLine(\$"Properties: {string.Join(", ", dynamicType.GetProperties().Select(p => p.Name))}");

        // ─── COMMON IL OPCODES ───
        Console.WriteLine("\nKey IL opcodes:");
        Console.WriteLine("  Ldarg_0     push 'this' (or first param) onto stack");
        Console.WriteLine("  Ldarg_1     push second argument");
        Console.WriteLine("  Ldfld       load field value");
        Console.WriteLine("  Stfld       store to field");
        Console.WriteLine("  Callvirt    virtual method call");
        Console.WriteLine("  Ret         return from method");
        Console.WriteLine("  Newobj      create new object");
        Console.WriteLine("  Box/Unbox   value type boxing");
    }
}

using System.Linq;

📝 KEY POINTS:
✅ DynamicMethod is the fastest way to generate callable code at runtime
✅ Generated methods run at the same speed as compiled C# code
✅ Reflection.Emit is used internally by JSON serializers, ORMs, and DI containers
✅ Expression trees (.Compile()) are a higher-level alternative — easier to write
✅ TypeBuilder lets you create entire new types complete with properties and methods
❌ Reflection.Emit requires understanding IL — it is an advanced topic
❌ In AOT-compiled apps (.NET Native, Blazor AOT), Reflection.Emit is not supported
❌ Prefer Expression Trees over raw Emit when possible — they're safer and more readable
''',
  quiz: [
    Quiz(question: 'What is the main performance advantage of using Reflection.Emit over PropertyInfo.GetValue?', options: [
      QuizOption(text: 'Generated code runs at native speed — no runtime reflection overhead in the hot path', correct: true),
      QuizOption(text: 'Emit skips JIT compilation', correct: false),
      QuizOption(text: 'Emit accesses memory directly without type checking', correct: false),
      QuizOption(text: 'PropertyInfo.GetValue always allocates; Emit never does', correct: false),
    ]),
    Quiz(question: 'What is ILGenerator used for?', options: [
      QuizOption(text: 'Emitting IL opcodes to define the body of a dynamically generated method', correct: true),
      QuizOption(text: 'Generating C# source code at runtime', correct: false),
      QuizOption(text: 'Compiling expression trees to delegates', correct: false),
      QuizOption(text: 'Loading assemblies from byte arrays', correct: false),
    ]),
    Quiz(question: 'When should you prefer Expression Trees over Reflection.Emit?', options: [
      QuizOption(text: 'When possible — they are higher-level, easier to write, and readable', correct: true),
      QuizOption(text: 'Only for simple property access — Emit is always preferred otherwise', correct: false),
      QuizOption(text: 'Expression Trees are never as fast as Emit', correct: false),
      QuizOption(text: 'Expression Trees cannot generate methods — only lambdas', correct: false),
    ]),
  ],
);
