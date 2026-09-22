// lib/lessons/csharp/csharp_74_assembly_loading.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson74 = Lesson(
  language: 'C#',
  title: 'Assembly Loading and Plugin Systems',
  content: '''
🎯 METAPHOR:
AssemblyLoadContext is like a sealed cargo container at a port.
Each container (load context) has its own copies of everything
inside — even if two containers have the same part number
(type name), they are different parts that don't mix.
You can load a plugin's DLL into its own container, use it,
then unload the whole container when done — without affecting
the main ship (app). The containers are isolated.

Without isolated load contexts, two plugins that both
reference "Newtonsoft.Json v12" and "v13" would conflict.
With AssemblyLoadContext, each plugin lives in its own
bubble with its own version of shared libraries.

📖 EXPLANATION:
ASSEMBLY — the compiled unit of code (.dll / .exe)

Assembly.Load methods:
  Assembly.Load(name)              load by name (GAC/paths)
  Assembly.LoadFrom(path)          load by file path
  Assembly.LoadFile(path)          load specifically by full path
  Assembly.GetExecutingAssembly()  current assembly
  Assembly.GetEntryAssembly()      the .exe entry assembly

ASSEMBLYLOADCONTEXT (C# / .NET Core):
  - Isolates assemblies in separate contexts
  - Enables plugin systems with version isolation
  - Supports unloading (when context is collected by GC)
  - Default context: AssemblyLoadContext.Default

REFLECTION ON ASSEMBLIES:
  assembly.GetTypes()       all public/private types
  assembly.GetExportedTypes() public types only
  assembly.GetName()        name, version, culture, key

💻 CODE:
using System;
using System.IO;
using System.Reflection;
using System.Runtime.Loader;
using System.Collections.Generic;
using System.Linq;

// ─── PLUGIN INTERFACE (in a shared project) ───
public interface IPlugin
{
    string Name { get; }
    string Version { get; }
    string Execute(string input);
}

// ─── PLUGIN LOADER ───
class PluginLoader
{
    private readonly Dictionary<string, (AssemblyLoadContext ctx, IPlugin plugin)> _loaded = new();

    public IPlugin LoadPlugin(string pluginPath)
    {
        // Each plugin gets its OWN isolated load context
        var ctx = new PluginLoadContext(pluginPath);
        var assembly = ctx.LoadFromAssemblyPath(pluginPath);

        // Find types implementing IPlugin
        Type pluginType = assembly.GetExportedTypes()
            .FirstOrDefault(t => typeof(IPlugin).IsAssignableFrom(t) && !t.IsInterface);

        if (pluginType == null)
            throw new InvalidOperationException(\$"No IPlugin found in {pluginPath}");

        var plugin = (IPlugin)Activator.CreateInstance(pluginType);
        _loaded[plugin.Name] = (ctx, plugin);
        return plugin;
    }

    public void UnloadPlugin(string name)
    {
        if (_loaded.TryGetValue(name, out var entry))
        {
            _loaded.Remove(name);
            entry.ctx.Unload();  // mark for unloading
            // GC will collect when no more references
            GC.Collect();
            GC.WaitForPendingFinalizers();
            Console.WriteLine(\$"Plugin '{name}' unloaded");
        }
    }

    public IEnumerable<IPlugin> GetAll() => _loaded.Values.Select(v => v.plugin);
}

class PluginLoadContext : AssemblyLoadContext
{
    private readonly AssemblyDependencyResolver _resolver;

    public PluginLoadContext(string pluginPath) : base(isCollectible: true)
    {
        _resolver = new AssemblyDependencyResolver(pluginPath);
    }

    protected override Assembly Load(AssemblyName assemblyName)
    {
        string assemblyPath = _resolver.ResolveAssemblyToPath(assemblyName);
        if (assemblyPath != null)
            return LoadFromAssemblyPath(assemblyPath);

        // Fall back to default context for shared framework assemblies
        return null;
    }
}

class Program
{
    static void Main()
    {
        // ─── CURRENT ASSEMBLY INFO ───
        Assembly current = Assembly.GetExecutingAssembly();
        Console.WriteLine(\$"Assembly: {current.FullName}");
        Console.WriteLine(\$"Location: {current.Location}");
        Console.WriteLine(\$"Version:  {current.GetName().Version}");

        // ─── ALL TYPES IN ASSEMBLY ───
        Console.WriteLine("\nTypes in current assembly:");
        foreach (Type t in current.GetExportedTypes().Take(5))
            Console.WriteLine(\$"  {t.FullName}");

        // ─── REFLECTION ON A TYPE ───
        Type stringType = typeof(string);
        Assembly stringAssembly = stringType.Assembly;
        Console.WriteLine(\$"\nstring lives in: {stringAssembly.GetName().Name}");

        // Methods on string
        var methods = stringType.GetMethods(BindingFlags.Public | BindingFlags.Instance)
            .Where(m => m.Name.StartsWith("To"))
            .Take(5);
        Console.WriteLine("string.To* methods:");
        foreach (var m in methods)
            Console.WriteLine(\$"  {m.ReturnType.Name} {m.Name}({string.Join(", ", m.GetParameters().Select(p => p.ParameterType.Name))})");

        // ─── LOAD ASSEMBLY FROM PATH ───
        // In a real plugin system, you'd load user DLLs:
        // Assembly plugin = Assembly.LoadFrom("/path/to/plugin.dll");

        // ─── ASSEMBLYLOADCONTEXT INFO ───
        Console.WriteLine(\$"\nDefault context: {AssemblyLoadContext.Default.Name}");
        Console.WriteLine("All contexts:");
        foreach (var ctx in AssemblyLoadContext.All)
            Console.WriteLine(\$"  {ctx.Name}");

        // ─── CREATE CUSTOM CONTEXT ───
        var customCtx = new AssemblyLoadContext("MyContext", isCollectible: true);
        Console.WriteLine(\$"Custom context: {customCtx.Name}");

        // Load an assembly into custom context
        // var asm = customCtx.LoadFromAssemblyPath("/path/to/lib.dll");

        customCtx.Unload();  // mark for collection

        // ─── SCAN ASSEMBLY FOR ATTRIBUTES ───
        var obsoleteMethods = current.GetTypes()
            .SelectMany(t => t.GetMethods())
            .Where(m => m.GetCustomAttribute<ObsoleteAttribute>() != null)
            .Select(m => \$"{m.DeclaringType.Name}.{m.Name}");

        Console.WriteLine("\nObsolete methods:");
        foreach (var m in obsoleteMethods)
            Console.WriteLine(\$"  {m}");

        // ─── ASSEMBLY METADATA ───
        var attrs = current.GetCustomAttributes(false);
        Console.WriteLine(\$"\nAssembly attributes: {attrs.Length}");
    }
}

📝 KEY POINTS:
✅ AssemblyLoadContext with isCollectible: true enables unloading
✅ Plugin systems should give each plugin its own AssemblyLoadContext
✅ AssemblyDependencyResolver handles dependency resolution for isolated plugins
✅ Fall back to null in Load() to let the default context handle shared framework types
✅ GC.Collect() after Unload() helps trigger the actual unloading
❌ Assembly.LoadFrom shares types with the default context — no isolation
❌ References to types from an unloaded context will throw after unloading
''',
  quiz: [
    Quiz(question: 'Why give each plugin its own AssemblyLoadContext?', options: [
      QuizOption(text: 'Isolation — each plugin can use different versions of dependencies without conflict', correct: true),
      QuizOption(text: 'Security — prevents plugins from accessing each other\'s code', correct: false),
      QuizOption(text: 'Performance — each context runs on its own thread', correct: false),
      QuizOption(text: 'Required by .NET — all assemblies must have a context', correct: false),
    ]),
    Quiz(question: 'What does isCollectible: true enable for an AssemblyLoadContext?', options: [
      QuizOption(text: 'The context and its assemblies can be unloaded and garbage collected', correct: true),
      QuizOption(text: 'The assemblies are loaded more efficiently', correct: false),
      QuizOption(text: 'Type sharing with the default context is enabled', correct: false),
      QuizOption(text: 'The context automatically unloads after a timeout', correct: false),
    ]),
    Quiz(question: 'What should the Load() override return to use a shared framework assembly?', options: [
      QuizOption(text: 'null — to fall back to the default context for that assembly', correct: true),
      QuizOption(text: 'The assembly loaded from the default context', correct: false),
      QuizOption(text: 'A new copy of the assembly loaded from disk', correct: false),
      QuizOption(text: 'throw new NotSupportedException()', correct: false),
    ]),
  ],
);
