// lib/lessons/css/css_13_backgrounds.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson13 = Lesson(
  language: 'CSS',
  title: 'Backgrounds',
  content: '''
🎯 METAPHOR:
CSS backgrounds are like the wallpaper and flooring in a room.
You can have a solid paint color (background-color), hang a
repeating wallpaper pattern (background-image with repeat),
place a single large mural that covers the whole wall
(background-size: cover), or even layer multiple wallpapers
on top of each other (multiple backgrounds). You control
whether the wallpaper scrolls with the room content or stays
fixed to the wall as furniture moves in front.

📖 EXPLANATION:
CSS backgrounds go far beyond solid colors. You can use:
  - Solid colors
  - Images (raster or SVG)
  - Linear, radial, and conic gradients
  - Multiple layered backgrounds
  - Pattern effects

KEY BACKGROUND PROPERTIES:
  background-color
  background-image
  background-size     cover | contain | px | %
  background-position x y
  background-repeat   repeat | no-repeat | repeat-x | repeat-y
  background-attachment fixed | scroll | local
  background-origin   content-box | padding-box | border-box
  background-clip     content-box | padding-box | border-box | text
  background          shorthand for all of the above

💻 CODE:
/* ─── SOLID COLOR ─── */
.box { background-color: #f0f0f0; }

/* ─── BACKGROUND IMAGE ─── */
.hero {
  background-image: url('/images/hero.jpg');
  background-size: cover;         /* fill entire area */
  background-position: center;    /* center the image */
  background-repeat: no-repeat;
  min-height: 400px;
}

/* background-size values */
.cover    { background-size: cover; }   /* fill, may crop */
.contain  { background-size: contain; } /* fit entirely, may leave gaps */
.exact    { background-size: 300px 200px; }
.percent  { background-size: 50% auto; }

/* ─── GRADIENTS ─── */
/* Linear gradient */
.gradient-1 {
  background: linear-gradient(to right, #0066cc, #00aaff);
}
.gradient-2 {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
.gradient-3 {
  background: linear-gradient(
    to bottom,
    transparent 0%,
    rgba(0,0,0,0.7) 100%
  );
}

/* Radial gradient */
.radial {
  background: radial-gradient(circle at center, #ff6b6b, #4ecdc4);
}
.spotlight {
  background: radial-gradient(
    ellipse at top left,
    rgba(255,255,255,0.3) 0%,
    transparent 50%
  );
}

/* Conic gradient */
.pie {
  background: conic-gradient(
    #ff0000 0deg 120deg,
    #00ff00 120deg 240deg,
    #0000ff 240deg 360deg
  );
  border-radius: 50%;
  width: 200px;
  height: 200px;
}

/* ─── MULTIPLE BACKGROUNDS ─── */
/* Layers: first listed is on top */
.layered {
  background:
    linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.4)),
    url('/images/bg.jpg') center/cover no-repeat,
    #1a1a2e;
}

/* Overlay pattern */
.dotted-bg {
  background-image:
    radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
  background-size: 20px 20px;
  background-color: #1a1a2e;
}

/* ─── BACKGROUND ATTACHMENT ─── */
.parallax {
  background-image: url('/images/scene.jpg');
  background-attachment: fixed;   /* stays as page scrolls */
  background-size: cover;
  min-height: 500px;
}

/* ─── BACKGROUND CLIP: TEXT ─── */
.gradient-text {
  background: linear-gradient(90deg, #f093fb, #f5576c);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  font-size: 3rem;
  font-weight: bold;
}

/* ─── SHORTHAND ─── */
/* background: color image position/size repeat attachment origin clip */
.shorthand {
  background: #1a1a2e url('/img/bg.png') center/cover no-repeat;
}

/* ─── ASPECT RATIO (modern) ─── */
.thumbnail {
  aspect-ratio: 16 / 9;
  background: url('/img/thumb.jpg') center/cover;
  border-radius: 8px;
}

📝 KEY POINTS:
✅ background-size: cover fills the area and may crop; contain fits completely
✅ Overlaying a semi-transparent gradient over an image improves text readability
✅ Multiple backgrounds are listed comma-separated, first is on top
✅ background-clip: text with color: transparent creates gradient text effects
✅ aspect-ratio keeps images at correct proportions automatically
❌ background-attachment: fixed has performance issues on mobile — use carefully
❌ Don't put text directly on images without a contrast overlay
''',
  quiz: [
    Quiz(question: 'What is the difference between background-size: cover and contain?', options: [
      QuizOption(text: 'cover fills the area and may crop; contain fits the whole image and may leave empty space', correct: true),
      QuizOption(text: 'contain fills the area and may crop; cover fits the whole image', correct: false),
      QuizOption(text: 'They are identical — just different names', correct: false),
      QuizOption(text: 'cover works on images; contain works on gradients', correct: false),
    ]),
    Quiz(question: 'When using multiple backgrounds, which layer appears on top?', options: [
      QuizOption(text: 'The first listed background is on top', correct: true),
      QuizOption(text: 'The last listed background is on top', correct: false),
      QuizOption(text: 'The background-color is always on top', correct: false),
      QuizOption(text: 'The largest background is on top', correct: false),
    ]),
    Quiz(question: 'What CSS technique creates gradient text?', options: [
      QuizOption(text: 'background-clip: text combined with color: transparent', correct: true),
      QuizOption(text: 'color: gradient(...)', correct: false),
      QuizOption(text: 'text-fill: gradient(...)', correct: false),
      QuizOption(text: 'font-color: linear-gradient(...)', correct: false),
    ]),
  ],
);
