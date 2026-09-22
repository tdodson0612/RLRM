// lib/lessons/css/css_17_borders_shadows.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson17 = Lesson(
  language: 'CSS',
  title: 'Borders, Outlines, and Shadows',
  content: '''
🎯 METAPHOR:
Borders are like picture frames — they are PART of the element
and take up space in the layout. Outlines are like spotlight
rings drawn around the frame — they sit OUTSIDE the border,
take up NO space, and don't affect the layout at all.
This is why browsers use outline for focus indicators — the
button doesn't shift when you focus it.

Shadows are like light sources shining on objects.
box-shadow casts a shadow from the box itself.
text-shadow casts a shadow from the text characters.
Multiple shadows stack like multiple light sources.
Inset shadows go INSIDE the box — like pressing a button in.

📖 EXPLANATION:
BORDER:
  border: width style color   (shorthand)
  Takes up space. Part of box model.

OUTLINE:
  outline: width style color
  Does NOT take up space. Drawn outside border.
  Use for focus rings.

BOX-SHADOW:
  box-shadow: x-offset y-offset blur spread color
  x/y: shadow position
  blur: how fuzzy (0 = sharp)
  spread: grows/shrinks shadow size
  inset: shadow goes inside

TEXT-SHADOW:
  text-shadow: x-offset y-offset blur color

DROP-SHADOW (CSS filter):
  filter: drop-shadow(x y blur color)
  Follows the actual shape (including transparency)

💻 CODE:
/* ─── BORDERS ─── */
.box {
  border: 2px solid #333;         /* shorthand */
  border-width: 2px;
  border-style: solid;            /* solid dashed dotted double groove ridge inset outset none */
  border-color: #333;

  /* Individual sides */
  border-top: 3px solid blue;
  border-right: 1px dashed red;
  border-bottom: 2px dotted green;
  border-left: none;

  /* Individual properties */
  border-top-color: navy;
  border-top-width: 4px;
}

/* ─── BORDER RADIUS ─── */
.rounded    { border-radius: 8px; }
.pill       { border-radius: 9999px; }    /* fully rounded */
.circle     { border-radius: 50%; }       /* requires equal width/height */

/* Individual corners */
.custom-radius {
  border-top-left-radius: 16px;
  border-top-right-radius: 4px;
  border-bottom-right-radius: 16px;
  border-bottom-left-radius: 4px;
  /* Shorthand: top-left top-right bottom-right bottom-left */
  border-radius: 16px 4px 16px 4px;
}

/* Elliptical corners */
.egg { border-radius: 50% / 30%; }  /* x-radius / y-radius */

/* ─── OUTLINE ─── */
/* Default browser focus outline — DO NOT remove without replacement! */
button:focus { outline: 2px solid #0066cc; outline-offset: 2px; }
button:focus-visible { outline: 3px solid blue; } /* only keyboard focus */
button:not(:focus-visible) { outline: none; }      /* hide for mouse click */

/* ─── BOX-SHADOW ─── */
/* Subtle card shadow */
.card {
  box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
}

/* Hover elevation */
.card:hover {
  box-shadow: 0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22);
}

/* Sharp shadow (design trend) */
.sharp { box-shadow: 4px 4px 0 #000; }

/* Colored shadow (glow effect) */
.glow { box-shadow: 0 0 20px rgba(0, 102, 204, 0.5); }

/* Inset shadow (pressed button) */
.pressed { box-shadow: inset 0 2px 4px rgba(0,0,0,0.3); }

/* Multiple shadows */
.fancy {
  box-shadow:
    0 1px 1px rgba(0,0,0,0.12),
    0 2px 2px rgba(0,0,0,0.12),
    0 4px 4px rgba(0,0,0,0.12),
    0 8px 8px rgba(0,0,0,0.12);
}

/* Spread radius (grows shadow) */
.spread { box-shadow: 0 0 0 4px #0066cc; }  /* colored border effect */

/* ─── TEXT SHADOW ─── */
h1 { text-shadow: 2px 2px 4px rgba(0,0,0,0.3); }
.neon {
  text-shadow:
    0 0 7px #fff,
    0 0 10px #fff,
    0 0 21px #fff,
    0 0 42px #0066cc;
}

/* ─── DROP SHADOW FILTER (transparent-aware) ─── */
/* box-shadow follows the rectangle; drop-shadow follows the shape */
.logo-png {
  filter: drop-shadow(2px 2px 4px rgba(0,0,0,0.5));
  /* Works on transparent PNGs unlike box-shadow */
}

/* ─── BORDER IMAGE ─── */
.gradient-border {
  border: 4px solid transparent;
  border-image: linear-gradient(45deg, #f093fb, #f5576c) 1;
}

📝 KEY POINTS:
✅ Outline does NOT affect layout — perfect for focus states
✅ box-shadow: 0 0 0 4px color creates a border-like ring without layout shift
✅ Multiple box-shadows create realistic layered depth (Material Design uses this)
✅ filter: drop-shadow follows transparent shapes; box-shadow doesn't
✅ Never remove :focus outline without providing a visible replacement
❌ Don't remove focus outlines without replacement — critical for keyboard accessibility
❌ box-shadow counts toward paint but not layout — it IS performant to animate
''',
  quiz: [
    Quiz(question: 'What is the key difference between border and outline?', options: [
      QuizOption(text: 'Border takes up space in layout; outline does not affect layout at all', correct: true),
      QuizOption(text: 'Outline takes up space; border does not', correct: false),
      QuizOption(text: 'Border is for text; outline is for boxes', correct: false),
      QuizOption(text: 'They are identical with different default values', correct: false),
    ]),
    Quiz(question: 'What does box-shadow: 0 0 0 4px blue do?', options: [
      QuizOption(text: 'Creates a 4px blue ring around the element without affecting layout', correct: true),
      QuizOption(text: 'Creates a blurred blue shadow 4px below', correct: false),
      QuizOption(text: 'Adds a 4px blue border', correct: false),
      QuizOption(text: 'Creates a blue glow of 4px radius', correct: false),
    ]),
    Quiz(question: 'When should you use filter: drop-shadow instead of box-shadow?', options: [
      QuizOption(text: 'When the element has transparent areas and you want the shadow to follow the actual shape', correct: true),
      QuizOption(text: 'When you need animated shadows', correct: false),
      QuizOption(text: 'When the shadow needs to be inset', correct: false),
      QuizOption(text: 'drop-shadow is always better than box-shadow', correct: false),
    ]),
  ],
);
