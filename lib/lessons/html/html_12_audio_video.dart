// lib/lessons/html/html_12_audio_video.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson12 = Lesson(
  language: 'HTML',
  title: 'Audio, Video, and Embedded Media',
  content: '''
🎯 METAPHOR:
Before HTML5, embedding video on a web page was like trying
to show a movie at a house party — you needed a special
projector (Flash plugin) that most guests might not have.
Sometimes it worked. Often it crashed. It required a
software license and a team of engineers.
HTML5 gave every browser a built-in projector. <video> and
<audio> are native cinema. No plugins. No Flash. No drama.
Just point the browser at your media file and it plays,
with controls, captions, chapter marks, and full keyboard
accessibility — right out of the box.

📖 EXPLANATION:
<audio> — embed audio
  controls  — show player controls
  autoplay  — start immediately (blocked without muted in most browsers)
  muted     — start muted
  loop      — repeat
  preload   — none | metadata | auto
  src       — audio file URL
  <source>  — multiple format fallbacks

<video> — embed video
  Same attributes as audio PLUS:
  width, height  — dimensions
  poster         — thumbnail image before play
  playsinline    — play inline on iOS (not fullscreen)

FORMATS:
  Video:  MP4 (H.264), WebM (VP8/VP9), OGG
  Audio:  MP3, OGG Vorbis, WAV, AAC

<source> — multiple formats for compatibility:
  <source src="video.mp4" type="video/mp4">
  <source src="video.webm" type="video/webm">

<track> — captions and subtitles
  kind:  subtitles | captions | descriptions | chapters | metadata
  src:   .vtt file (WebVTT format)
  srclang: language code
  label:  human-readable label
  default: active by default

<iframe> — embed external content
  src, width, height
  title — REQUIRED for accessibility
  allow — feature policy
  sandbox — security restrictions
  loading="lazy"

<embed> — plugin content (legacy)
<object> — plugin fallback (legacy)

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Media Demo</title>
</head>
<body>

  <!-- ─── BASIC VIDEO ─── -->
  <video
    width="800"
    height="450"
    controls
    poster="/images/video-thumbnail.jpg"
  >
    <!-- Multiple sources — browser picks the first it supports -->
    <source src="/videos/coffee-brewing.mp4"  type="video/mp4">
    <source src="/videos/coffee-brewing.webm" type="video/webm">

    <!-- Captions (WebVTT format) -->
    <track
      kind="captions"
      src="/captions/coffee-en.vtt"
      srclang="en"
      label="English"
      default
    >
    <track
      kind="subtitles"
      src="/captions/coffee-es.vtt"
      srclang="es"
      label="Español"
    >

    <!-- Fallback for browsers that don't support video -->
    <p>
      Your browser doesn't support HTML5 video.
      <a href="/videos/coffee-brewing.mp4">Download the video instead</a>.
    </p>
  </video>

  <!-- ─── AUTOPLAYING BACKGROUND VIDEO ─── -->
  <!-- muted is REQUIRED for autoplay to work in most browsers -->
  <video
    autoplay
    muted
    loop
    playsinline
    aria-hidden="true"
    style="width:100%; height:auto;"
  >
    <source src="/videos/background.mp4" type="video/mp4">
    <source src="/videos/background.webm" type="video/webm">
  </video>

  <!-- ─── AUDIO PLAYER ─── -->
  <audio controls>
    <source src="/audio/podcast-ep1.mp3" type="audio/mpeg">
    <source src="/audio/podcast-ep1.ogg" type="audio/ogg">
    <p>Your browser doesn't support HTML5 audio.
      <a href="/audio/podcast-ep1.mp3">Download the audio</a>.
    </p>
  </audio>

  <!-- Audio with all attributes -->
  <audio
    controls
    loop
    preload="metadata"
  >
    <!-- preload="metadata": load only duration/dimensions, not file -->
    <!-- preload="none": don't preload at all (save bandwidth) -->
    <!-- preload="auto": browser decides -->
    <source src="/audio/music.mp3" type="audio/mpeg">
  </audio>

  <!-- ─── WEBVTT CAPTION FORMAT ─── -->
  <!--
  WEBVTT

  00:00:00.000 --> 00:00:03.500
  Welcome to this video about brewing coffee.

  00:00:03.500 --> 00:00:07.000
  Today we'll cover the three essential variables:
  temperature, grind size, and ratio.

  00:00:07.000 --> 00:00:10.500 position:20%
  <b>Temperature</b> should be between 90-96°C.
  -->

  <!-- ─── IFRAME (YouTube embed) ─── -->
  <iframe
    width="560"
    height="315"
    src="https://www.youtube.com/embed/VIDEO_ID"
    title="How to Brew the Perfect Espresso — Coffee Tutorial"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    allowfullscreen
    loading="lazy"
  ></iframe>

  <!-- ─── IFRAME (Google Maps) ─── -->
  <iframe
    src="https://maps.google.com/maps?q=coffee+shop&output=embed"
    width="600"
    height="450"
    title="Map showing coffee shop location"
    loading="lazy"
    referrerpolicy="no-referrer-when-downgrade"
  ></iframe>

  <!-- ─── IFRAME SANDBOX ─── -->
  <!-- sandbox restricts what the iframe can do -->
  <iframe
    src="/untrusted-content.html"
    title="Sandboxed user content"
    sandbox="allow-scripts"
    <!-- No sandbox: all restrictions active -->
    <!-- allow-scripts: permit JS but no forms/popups -->
    <!-- allow-forms: permit form submission -->
    <!-- allow-same-origin: allow same-origin API access -->
    <!-- allow-popups: allow opening new windows -->
  ></iframe>

</body>
</html>

─────────────────────────────────────
VIDEO FORMAT SUPPORT:
─────────────────────────────────────
MP4 (H.264)   Chrome ✅ Firefox ✅ Safari ✅ — best compat
WebM (VP9)    Chrome ✅ Firefox ✅ Safari ✅ (recent)
OGG Theora    Chrome ✅ Firefox ✅ Safari ❌

Always provide MP4 + WebM for full browser coverage.
─────────────────────────────────────

📝 KEY POINTS:
✅ Always add controls — users need to pause/volume/fullscreen
✅ Autoplay only works when muted — browser policy prevents surprise audio
✅ poster gives video a nice thumbnail before the user hits play
✅ <track> with captions makes video accessible — legally required in many countries
✅ Always add title to <iframe> — screen readers announce it
✅ sandbox on iframes restricts potentially dangerous third-party content
❌ Never use video/audio autoplay without muted — browsers will block it
❌ Providing only one format risks the video not playing in some browsers
''',
  quiz: [
    Quiz(question: 'Why does autoplay only work when the muted attribute is also present?', options: [
      QuizOption(text: 'Browsers block autoplay with sound to prevent unwanted audio — muted satisfies this policy', correct: true),
      QuizOption(text: 'It is a CSS restriction on video elements', correct: false),
      QuizOption(text: 'autoplay alone works fine — muted is just a best practice', correct: false),
      QuizOption(text: 'muted enables the autoplay attribute in HTML', correct: false),
    ]),
    Quiz(question: 'What is a WebVTT file used for?', options: [
      QuizOption(text: 'Captions and subtitles for video elements', correct: true),
      QuizOption(text: 'A video thumbnail format', correct: false),
      QuizOption(text: 'A compressed video format', correct: false),
      QuizOption(text: 'Metadata describing video duration', correct: false),
    ]),
    Quiz(question: 'Why is the title attribute required on <iframe>?', options: [
      QuizOption(text: 'Screen readers need it to announce what the iframe contains to visually impaired users', correct: true),
      QuizOption(text: 'Without it, the iframe will not load', correct: false),
      QuizOption(text: 'It sets the browser tab title for the iframe content', correct: false),
      QuizOption(text: 'It is required by the CSP (Content Security Policy)', correct: false),
    ]),
  ],
);
