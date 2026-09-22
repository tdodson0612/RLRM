// lib/lessons/css/css_22_object_fit_position.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson22 = Lesson(
  language: 'CSS',
  title: 'Object-fit, Object-position, and Aspect Ratio',
  content: '''
🎯 METAPHOR:
object-fit is like how you hang a photo in a frame.
If the photo doesn't match the frame exactly:
  "cover" — zoom and crop so the frame is completely filled
  "contain" — shrink to fit entirely inside, leave blank space
  "fill" — stretch to fill (distorted!)
  "none" — photo stays its natural size, may overflow or underfit
  "scale-down" — smaller of none or contain

Think of a widescreen movie (16:9) forced into a square frame.
"Cover" crops the sides. "Contain" adds black bars. "Fill" warps.

aspect-ratio is like a "keep this frame always 16:9" rule.
Whatever the width, the height auto-adjusts to maintain
the ratio — no JavaScript needed.

📖 EXPLANATION:
object-fit — controls how replaced content (img, video)
  fits inside its container. Without it, images stretch
  to fill whatever box they're in.

object-position — controls WHERE in the box the content
  is positioned (like background-position, but for <img>).

aspect-ratio — maintains a width-to-height ratio
  regardless of how the element is sized.

APPLIES TO: img, video, iframe, canvas, svg

💻 CODE:
/* ─── OBJECT-FIT ─── */
/* The container defines the frame */
.photo-frame {
  width: 300px;
  height: 200px;
  /* Without object-fit, img inside stretches to 300×200 */
}

img {
  width: 100%;
  height: 100%;
  object-fit: cover;     /* fill, crop to maintain ratio */
}

/* All values */
.cover    { object-fit: cover; }     /* fill + crop (most common) */
.contain  { object-fit: contain; }   /* fit + letterbox */
.fill     { object-fit: fill; }      /* stretch (default — usually wrong) */
.none     { object-fit: none; }      /* natural size, may clip */
.scale    { object-fit: scale-down; }/* smaller of contain or none */

/* ─── OBJECT-POSITION ─── */
/* Where to focus when cropping */
img.center { object-position: center; }    /* default */
img.top    { object-position: top; }       /* show top of image */
img.face   { object-position: 30% 20%; }  /* custom focus point */
img.logo   { object-position: left center; }

/* ─── ASPECT RATIO ─── */
/* Keep a 16:9 ratio regardless of width */
.video-frame {
  aspect-ratio: 16 / 9;
  width: 100%;
  background: #000;
}

/* Square thumbnail */
.avatar {
  width: 64px;
  aspect-ratio: 1;        /* shorthand for 1/1 */
  border-radius: 50%;
  object-fit: cover;
}

/* Card image */
.card-image {
  width: 100%;
  aspect-ratio: 4 / 3;
  object-fit: cover;
  border-radius: 8px 8px 0 0;
}

/* ─── PRACTICAL PATTERNS ─── */

/* Responsive video embed */
.video-wrapper {
  aspect-ratio: 16 / 9;
  width: 100%;
}
.video-wrapper iframe,
.video-wrapper video {
  width: 100%;
  height: 100%;
}

/* Profile photo grid */
.photo-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 8px;
}

.photo-grid img {
  width: 100%;
  aspect-ratio: 1;
  object-fit: cover;
  display: block;         /* removes inline bottom gap */
}

/* Hero image with controlled crop */
.hero-image {
  width: 100%;
  height: 60vh;
  object-fit: cover;
  object-position: center 30%;  /* focus on upper area */
  display: block;
}

/* Magazine layout — portrait images */
.portrait-thumb {
  aspect-ratio: 2 / 3;
  object-fit: cover;
  object-position: top center;  /* keep faces in frame */
}

/* ─── AVOIDING THE LAYOUT SHIFT ─── */
/* Set aspect-ratio on img before it loads to reserve space */
img.prevent-cls {
  width: 100%;
  aspect-ratio: 16 / 9;     /* reserve exact space */
  object-fit: cover;
  background: #eee;          /* placeholder color */
}

/* ─── SVG CONSIDERATIONS ─── */
svg {
  /* SVGs have viewBox instead — set width and let height scale */
  width: 100%;
  height: auto;
}

📝 KEY POINTS:
✅ object-fit: cover is the right choice for most image thumbnails
✅ object-position lets you focus on the important part of the image (faces, logos)
✅ aspect-ratio prevents layout shift by reserving space before images load
✅ Add display: block to images to remove the mysterious gap below them
✅ aspect-ratio: 1 is shorthand for a perfect square
❌ object-fit default is fill — images stretch and distort without it
❌ object-fit only works when you set BOTH width and height on the img
''',
  quiz: [
    Quiz(question: 'What does object-fit: cover do to an image?', options: [
      QuizOption(text: 'Fills the container completely and crops the image to maintain its aspect ratio', correct: true),
      QuizOption(text: 'Fits the entire image inside the container with letterboxing', correct: false),
      QuizOption(text: 'Stretches the image to fill the container', correct: false),
      QuizOption(text: 'Displays the image at its natural size', correct: false),
    ]),
    Quiz(question: 'How does aspect-ratio: 16 / 9 benefit images before they load?', options: [
      QuizOption(text: 'It reserves the correct amount of space — preventing layout shift as images load', correct: true),
      QuizOption(text: 'It compresses the image to 16:9', correct: false),
      QuizOption(text: 'It crops the image to exactly 16:9 pixels', correct: false),
      QuizOption(text: 'It makes images download faster', correct: false),
    ]),
    Quiz(question: 'What does display: block on an img remove?', options: [
      QuizOption(text: 'The small gap below the image caused by inline element baseline alignment', correct: true),
      QuizOption(text: 'The image border', correct: false),
      QuizOption(text: 'The image alt text', correct: false),
      QuizOption(text: 'The default image width', correct: false),
    ]),
  ],
);
