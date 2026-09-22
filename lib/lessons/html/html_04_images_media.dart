// lib/lessons/html/html_04_images_media.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson04 = Lesson(
  language: 'HTML',
  title: 'Images and Media',
  content: '''
🎯 METAPHOR:
Images on the web are like paintings in a gallery —
but this gallery has a twist. Every painting needs a
description card on the wall. Not just for aesthetic
reasons, but because some visitors to your gallery are
blind. The alt attribute is that description card.
Screen readers read it aloud. Search engines index it.
And when the internet connection is slow and the painting
fails to load, the description card is all the visitor has.
Always write the card. Always.

📖 EXPLANATION:
<img> — display an image (void element)
  src        — URL of the image (required)
  alt        — text description (REQUIRED for accessibility)
  width      — width in pixels or percentage
  height     — height in pixels (set both to prevent layout shift)
  loading    — "lazy" defers loading until near viewport
  decoding   — "async" decodes off main thread
  srcset     — multiple image sources for different screen densities
  sizes      — which source to use at which viewport width
  fetchpriority — "high" for LCP images

<picture> — art direction, serve different images
  Contains multiple <source> and one fallback <img>

<figure> + <figcaption> — image with semantic caption

IMAGE FORMATS:
  JPEG/JPG   photos — lossy compression, small file
  PNG        graphics with transparency — lossless
  GIF        animated — limited colors, use sparingly
  SVG        vector — scales perfectly, small for icons/logos
  WebP       modern — better compression than JPEG/PNG
  AVIF       newest — even better compression than WebP

RESPONSIVE IMAGES:
  srcset="image-400.jpg 400w, image-800.jpg 800w"
  sizes="(max-width: 600px) 100vw, 50vw"

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Images Demo</title>
</head>
<body>

  <!-- ─── BASIC IMAGE ─── -->
  <img
    src="/images/mountain.jpg"
    alt="Snow-capped mountain peak at golden hour"
    width="800"
    height="600"
  >
  <!-- Always set width/height to prevent Cumulative Layout Shift (CLS) -->

  <!-- ─── LAZY LOADING ─── -->
  <!-- Images below the fold: load only when near viewport -->
  <img
    src="/images/forest.jpg"
    alt="Dense green forest with morning mist"
    loading="lazy"
    decoding="async"
    width="800"
    height="533"
  >

  <!-- ─── HERO IMAGE (above fold — load eagerly) ─── -->
  <img
    src="/images/hero.jpg"
    alt="Aerial view of city skyline at dusk"
    fetchpriority="high"
    width="1920"
    height="1080"
  >

  <!-- ─── DECORATIVE IMAGE (empty alt) ─── -->
  <!-- alt="" tells screen readers to skip this image -->
  <img src="/images/divider.png" alt="" role="presentation">

  <!-- ─── FIGURE WITH CAPTION ─── -->
  <figure>
    <img
      src="/images/coffee-map.jpg"
      alt="World map showing major coffee-growing regions highlighted in brown"
      width="600"
      height="400"
    >
    <figcaption>
      Figure 1: Global coffee production regions, 2024.
    </figcaption>
  </figure>

  <!-- ─── RESPONSIVE IMAGES WITH SRCSET ─── -->
  <!-- Browser picks the right size for the screen -->
  <img
    src="/images/photo-800.jpg"
    srcset="
      /images/photo-400.jpg  400w,
      /images/photo-800.jpg  800w,
      /images/photo-1600.jpg 1600w
    "
    sizes="
      (max-width: 480px) 100vw,
      (max-width: 960px) 50vw,
      33vw
    "
    alt="Colorful market stall with fresh vegetables"
    width="800"
    height="600"
    loading="lazy"
  >

  <!-- ─── PICTURE ELEMENT (art direction) ─── -->
  <!-- Different image on mobile vs desktop -->
  <picture>
    <!-- AVIF for modern browsers -->
    <source
      type="image/avif"
      srcset="/images/hero-400.avif 400w, /images/hero-800.avif 800w"
      sizes="(max-width: 600px) 100vw, 50vw"
    >
    <!-- WebP for most browsers -->
    <source
      type="image/webp"
      srcset="/images/hero-400.webp 400w, /images/hero-800.webp 800w"
      sizes="(max-width: 600px) 100vw, 50vw"
    >
    <!-- Different crop on mobile -->
    <source
      media="(max-width: 600px)"
      srcset="/images/hero-portrait.jpg"
    >
    <!-- Fallback <img> is REQUIRED inside <picture> -->
    <img
      src="/images/hero-landscape.jpg"
      alt="Team working together in a bright modern office"
      width="1200"
      height="600"
    >
  </picture>

  <!-- ─── SVG IMAGE ─── -->
  <!-- As img tag (no interaction, but simple) -->
  <img src="/icons/logo.svg" alt="Company Logo" width="120" height="40">

  <!-- Inline SVG (can be styled with CSS, animated) -->
  <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 24 24"
    width="24"
    height="24"
    aria-hidden="true"
    focusable="false"
  >
    <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
  </svg>

</body>
</html>

─────────────────────────────────────
ALT TEXT GUIDE:
─────────────────────────────────────
Informative image  → describe what it shows
Functional image   → describe what it does (button icon)
Decorative image   → alt="" (empty — screen reader skips)
Complex image      → short alt + longer description nearby
Text in image      → include the text in alt
─────────────────────────────────────

📝 KEY POINTS:
✅ alt is required on every <img> — empty alt="" for decorative images
✅ Set width and height attributes to prevent layout shift (CLS)
✅ Use loading="lazy" for below-the-fold images
✅ Use fetchpriority="high" on the largest above-fold image (LCP)
✅ <picture> lets you serve different formats and crops per breakpoint
✅ srcset + sizes gives the browser multiple image options to choose from
❌ Never skip alt — it hurts accessibility, SEO, and broken-image UX
❌ Don't set width/height in HTML with a different aspect ratio than the actual image
''',
  quiz: [
    Quiz(question: 'What should alt="" (empty alt) be used for?', options: [
      QuizOption(text: 'Decorative images that add no information — screen readers will skip them', correct: true),
      QuizOption(text: 'All images — it is better than writing descriptions', correct: false),
      QuizOption(text: 'Images that are still loading', correct: false),
      QuizOption(text: 'Images inside <figure> elements that have a <figcaption>', correct: false),
    ]),
    Quiz(question: 'Why should you set both width and height attributes on <img>?', options: [
      QuizOption(text: 'Prevents Cumulative Layout Shift — the browser reserves space before the image loads', correct: true),
      QuizOption(text: 'Required for lazy loading to work', correct: false),
      QuizOption(text: 'Makes the image display faster', correct: false),
      QuizOption(text: 'Required by the HTML specification', correct: false),
    ]),
    Quiz(question: 'What is the purpose of the <picture> element?', options: [
      QuizOption(text: 'Art direction — serve different image sources based on viewport or format support', correct: true),
      QuizOption(text: 'Creating a photo gallery', correct: false),
      QuizOption(text: 'Grouping images with their captions', correct: false),
      QuizOption(text: 'Replacing the <img> element in HTML5', correct: false),
    ]),
  ],
);
