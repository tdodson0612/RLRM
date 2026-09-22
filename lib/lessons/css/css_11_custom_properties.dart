// lib/lessons/css/css_11_custom_properties.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson11 = Lesson(
  language: 'CSS',
  title: 'CSS Custom Properties (Variables)',
  content: '''
🎯 METAPHOR:
CSS custom properties are like paint color codes in an
interior design firm. Instead of saying "paint the living
room #2C3E50, paint the bedroom #2C3E50, paint the hallway
#2C3E50" in every room's spec sheet, you define one code:
"--primary-color: #2C3E50" in the master document. Every
room references the code. When the client decides they want
#1A252F instead, you change ONE line and every room updates.
No more hunting through 200 spec sheets.

📖 EXPLANATION:
CSS Custom Properties (also called CSS Variables) let you
define reusable values with a name. They are:
  - Native CSS — no preprocessor needed
  - Dynamic — can be changed with JavaScript
  - Cascading — can be overridden in specific contexts
  - Scoped — can be local to a component

SYNTAX:
  Define:  --variable-name: value;
  Use:     var(--variable-name)
  Fallback: var(--variable-name, fallback-value)

Best practice: define variables on :root for global scope.

💻 CODE:
/* ─── DEFINING VARIABLES ON :ROOT ─── */
:root {
  /* Color system */
  --color-primary: #0066cc;
  --color-primary-dark: #004d99;
  --color-primary-light: #3399ff;
  --color-secondary: #6c757d;
  --color-success: #28a745;
  --color-danger: #dc3545;
  --color-warning: #ffc107;
  --color-background: #ffffff;
  --color-surface: #f8f9fa;
  --color-text: #212529;
  --color-text-muted: #6c757d;

  /* Typography */
  --font-family-base: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  --font-family-mono: 'Courier New', Courier, monospace;
  --font-size-xs:  0.75rem;   /* 12px */
  --font-size-sm:  0.875rem;  /* 14px */
  --font-size-md:  1rem;      /* 16px */
  --font-size-lg:  1.125rem;  /* 18px */
  --font-size-xl:  1.25rem;   /* 20px */
  --font-size-2xl: 1.5rem;    /* 24px */
  --font-size-3xl: 2rem;      /* 32px */

  /* Spacing */
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-5: 24px;
  --space-6: 32px;
  --space-8: 48px;

  /* Border radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 16px;
  --radius-full: 9999px;

  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
  --shadow-lg: 0 10px 15px rgba(0,0,0,0.15);

  /* Transitions */
  --transition-fast: 150ms ease;
  --transition-base: 250ms ease;
  --transition-slow: 500ms ease;

  /* Z-index scale */
  --z-dropdown: 100;
  --z-modal: 1000;
  --z-tooltip: 2000;
}

/* ─── USING VARIABLES ─── */
body {
  font-family: var(--font-family-base);
  font-size: var(--font-size-md);
  color: var(--color-text);
  background-color: var(--color-background);
}

.btn-primary {
  background-color: var(--color-primary);
  color: white;
  padding: var(--space-2) var(--space-4);
  border-radius: var(--radius-md);
  transition: background-color var(--transition-fast);
}

.btn-primary:hover {
  background-color: var(--color-primary-dark);
}

/* ─── FALLBACK VALUES ─── */
.element {
  color: var(--color-custom, var(--color-text, black));
  /* Try --color-custom, then --color-text, then black */
}

/* ─── LOCAL SCOPE OVERRIDE ─── */
.card {
  --shadow: var(--shadow-md);
  box-shadow: var(--shadow);
}

.card.elevated {
  --shadow: var(--shadow-lg);  /* override for this component */
}

/* ─── DARK MODE WITH VARIABLES ─── */
:root {
  --bg: #ffffff;
  --text: #212529;
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg: #1a1a2e;
    --text: #eaeaea;
  }
}

/* Or toggle with a class: */
[data-theme="dark"] {
  --bg: #1a1a2e;
  --text: #eaeaea;
}

body {
  background: var(--bg);
  color: var(--text);
}

/* ─── DYNAMIC VARIABLES WITH JS ─── */
/* JavaScript can read and write CSS variables: */
/* document.documentElement.style.setProperty('--color-primary', '#ff0000'); */
/* getComputedStyle(el).getPropertyValue('--color-primary'); */

/* ─── CALCULATED VARIABLES ─── */
:root {
  --base-size: 16px;
  --scale-ratio: 1.25;
}

.text-lg { font-size: calc(var(--base-size) * var(--scale-ratio)); }
.text-xl { font-size: calc(var(--base-size) * var(--scale-ratio) * var(--scale-ratio)); }

📝 KEY POINTS:
✅ Define your entire design system as custom properties on :root
✅ Custom properties are the right way to implement dark mode in CSS
✅ They cascade and can be overridden in component scope
✅ JavaScript can read and write them — enables dynamic theming
✅ Fallback values: var(--thing, default) prevents broken layouts
❌ Custom properties must start with -- (two dashes)
❌ Unlike Sass variables, CSS custom properties are evaluated at render time
''',
  quiz: [
    Quiz(question: 'What is the correct syntax to define a CSS custom property?', options: [
      QuizOption(text: '--variable-name: value; inside a selector block', correct: true),
      QuizOption(text: '\$variable-name: value; (like Sass)', correct: false),
      QuizOption(text: '@variable variable-name: value;', correct: false),
      QuizOption(text: 'var variable-name = value;', correct: false),
    ]),
    Quiz(question: 'What does var(--color, blue) do?', options: [
      QuizOption(text: 'Uses --color if defined, falls back to blue if not', correct: true),
      QuizOption(text: 'Sets --color to blue', correct: false),
      QuizOption(text: 'Creates a variable with value blue', correct: false),
      QuizOption(text: 'Mixes --color with blue', correct: false),
    ]),
    Quiz(question: 'Why are CSS custom properties ideal for implementing dark mode?', options: [
      QuizOption(text: 'You only change the variable values — all elements using them update automatically', correct: true),
      QuizOption(text: 'They only work inside media queries', correct: false),
      QuizOption(text: 'They are hidden from light mode automatically', correct: false),
      QuizOption(text: 'They are faster than regular CSS properties', correct: false),
    ]),
  ],
);
