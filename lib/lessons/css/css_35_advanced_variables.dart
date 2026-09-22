// lib/lessons/css/css_35_advanced_variables.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson35 = Lesson(
  language: 'CSS',
  title: 'CSS Variables Advanced: @property and Registration',
  content: '''
🎯 METAPHOR:
Regular CSS custom properties are like sticky notes —
powerful and flexible, but the browser treats their value
as a plain string. It doesn't know if --color is a color
or if --size is a length. This limits what you can do:
you cannot animate a gradient, interpolate a color variable
in a transition, or inherit with a typed default.

@property is like upgrading from sticky notes to a typed
database field. You declare "this variable is a <color>,
it inherits, and its initial value is blue." Now the browser
UNDERSTANDS the value. You can animate it. Transitions work.
Gradient animations become possible. Type safety comes to CSS.

📖 EXPLANATION:
REGULAR CUSTOM PROPERTIES:
  --name: value;          define in any rule
  var(--name)             use anywhere
  var(--name, fallback)   with fallback value

ADVANCED PATTERNS:
  Inheritance and scope
  Property fallback chains
  calc() with custom properties
  Theming systems

@PROPERTY (registered custom properties):
  syntax: "<color>" | "<length>" | "<number>" | "<percentage>"
          | "<angle>" | "<time>" | "<resolution>"
          | "<transform-function>" | "<custom-ident>" | "*"
  inherits: true | false
  initial-value: required when inherits: false

BENEFITS OF @property:
  - Can be animated/transitioned (browser understands the type)
  - Type checking (invalid values use initial-value)
  - Non-inheriting properties (scoped to element)

💻 CODE:
/* ─── ADVANCED CUSTOM PROPERTY PATTERNS ─── */

/* Fallback chain */
:root {
  --font-size-base: 1rem;
  --font-size-lg: calc(var(--font-size-base) * 1.25);
  --font-size-xl: calc(var(--font-size-lg) * 1.25);
}

/* Space scale */
:root {
  --space-1: 0.25rem;
  --space-2: 0.5rem;
  --space-3: 0.75rem;
  --space-4: 1rem;
  --space-6: 1.5rem;
  --space-8: 2rem;
  --space-12: 3rem;
  --space-16: 4rem;
}

/* Conditional value with custom property hack */
:root { --is-mobile: 0; }
@media (max-width: 768px) {
  :root { --is-mobile: 1; }
}

.element {
  /* Will be 1rem on mobile (1*1 + 0*2), 2rem on desktop (0*1 + 1*2) */
  padding: calc(var(--is-mobile) * 1rem + (1 - var(--is-mobile)) * 2rem);
}

/* ─── @PROPERTY ─── */
/* Register a color property */
@property --card-color {
  syntax: '<color>';
  inherits: false;
  initial-value: #6c63ff;
}

/* Register a percentage */
@property --progress {
  syntax: '<percentage>';
  inherits: false;
  initial-value: 0%;
}

/* Register a number */
@property --rotation {
  syntax: '<angle>';
  inherits: false;
  initial-value: 0deg;
}

/* ─── ANIMATING CUSTOM PROPERTIES ─── */
/* Without @property: cannot animate gradients */
/* With @property: YES! */

@property --gradient-angle {
  syntax: '<angle>';
  inherits: false;
  initial-value: 0deg;
}

.animated-gradient {
  background: linear-gradient(
    var(--gradient-angle),
    #6c63ff,
    #e91e8c
  );
  animation: rotate-gradient 3s linear infinite;
}

@keyframes rotate-gradient {
  to { --gradient-angle: 360deg; }
}

/* ─── ANIMATED PROGRESS BAR WITH @PROPERTY ─── */
@property --fill {
  syntax: '<percentage>';
  inherits: false;
  initial-value: 0%;
}

.progress {
  --fill: 0%;
  background: linear-gradient(
    to right,
    #6c63ff var(--fill),
    #eee var(--fill)
  );
  transition: --fill 0.5s ease;
  height: 8px;
  border-radius: 4px;
}

.progress.loaded { --fill: 75%; }

/* ─── ANIMATED CARD COLOR ─── */
.card {
  --card-color: #6c63ff;
  background: var(--card-color);
  transition: --card-color 0.3s ease;
  /* Works because --card-color is registered as <color> */
}

.card:hover { --card-color: #e91e8c; }

/* ─── NON-INHERITING PROPERTY ─── */
@property --local-size {
  syntax: '<length>';
  inherits: false;  /* Each element has its own independent value */
  initial-value: 1rem;
}

/* Each component gets its own --local-size, not inherited from parent */
.component { --local-size: 2rem; }

/* ─── CSS ENVIRONMENT VARIABLES ─── */
/* env() — browser/device environment values */
.safe-area {
  padding-top: env(safe-area-inset-top, 0px);
  padding-bottom: env(safe-area-inset-bottom, 0px);
  padding-left: env(safe-area-inset-left, 0px);
  padding-right: env(safe-area-inset-right, 0px);
  /* Critical for notch phones and tablet edges */
}

/* ─── THEMING SYSTEM WITH @PROPERTY ─── */
@property --hue {
  syntax: '<number>';
  inherits: true;
  initial-value: 260;
}

:root { --hue: 260; }

/* Generate entire palette from one hue variable */
.themed {
  --color: oklch(60% 0.2 var(--hue));
  --color-light: oklch(85% 0.1 var(--hue));
  --color-dark: oklch(35% 0.2 var(--hue));
}

/* Theme variants just change --hue */
.theme-red { --hue: 27; }
.theme-green { --hue: 145; }
.theme-purple { --hue: 290; }

📝 KEY POINTS:
✅ @property enables animating and transitioning custom property values
✅ Without @property, you cannot animate gradients — with it, you can
✅ inherits: false creates per-element independent values — not inherited from parent
✅ Registered properties type-check values — invalid values fall back to initial-value
✅ env() provides device environment values like safe area insets for notch phones
✅ A single --hue variable can drive an entire color system via oklch
❌ @property is not supported in older browsers — always provide fallback
❌ The initial-value is required when inherits: false
''',
  quiz: [
    Quiz(question: 'What does @property enable that regular custom properties cannot do?', options: [
      QuizOption(text: 'Animating and transitioning the custom property value (browser understands the type)', correct: true),
      QuizOption(text: 'Using the property in media queries', correct: false),
      QuizOption(text: 'Setting the property on pseudo-elements', correct: false),
      QuizOption(text: 'Sharing the property between different stylesheets', correct: false),
    ]),
    Quiz(question: 'What does "inherits: false" do in @property?', options: [
      QuizOption(text: 'Each element has its own independent value — the property is not inherited from parent', correct: true),
      QuizOption(text: 'The property cannot be used in child elements', correct: false),
      QuizOption(text: 'The property value cannot be changed after declaration', correct: false),
      QuizOption(text: 'The property is hidden from JavaScript', correct: false),
    ]),
    Quiz(question: 'What does env(safe-area-inset-top) provide?', options: [
      QuizOption(text: 'The safe area inset from the top of the device screen (for notch/island phones)', correct: true),
      QuizOption(text: 'The top padding of the viewport', correct: false),
      QuizOption(text: 'The browser\'s toolbar height', correct: false),
      QuizOption(text: 'The operating system\'s status bar height', correct: false),
    ]),
  ],
);
