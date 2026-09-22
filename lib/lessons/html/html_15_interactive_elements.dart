// lib/lessons/html/html_15_interactive_elements.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson15 = Lesson(
  language: 'HTML',
  title: 'Interactive Elements: dialog, details, popover',
  content: '''
🎯 METAPHOR:
Modern HTML is like getting a Swiss Army knife upgraded.
The old knife had a blade (basic elements). Modals,
tooltips, dropdowns, and accordions used to require
elaborate JavaScript and often had accessibility bugs.
Now the knife comes with these tools built in.
<dialog> is a native modal — it traps focus, handles
Escape key, and announces itself to screen readers.
<details>/<summary> is a native accordion — click to expand,
no JavaScript at all. The new popover API is a native
tooltip/menu system. Free. Accessible. No libraries needed.

📖 EXPLANATION:
<details> + <summary>:
  Native expandable/collapsible widget.
  No JavaScript required.
  <summary> is the clickable header.
  open attribute shows it expanded.

<dialog>:
  Native modal dialog.
  dialog.showModal() — opens as modal (traps focus, adds backdrop)
  dialog.show() — opens as non-modal
  dialog.close() — closes it
  ::backdrop pseudo-element — styles the overlay
  Escape key closes modal automatically.
  Returns a value via dialog.returnValue.

POPOVER API (new!):
  popover attribute — marks element as a popover
  popovertarget="id" — button to toggle popover
  popovertargetaction="show|hide|toggle"
  Auto: Escape closes, clicking outside closes.

<menu>:
  A list of commands (toolbar or context menu).

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Interactive Elements</title>
  <style>
    /* Dialog backdrop */
    dialog::backdrop {
      background: rgba(0,0,0,0.5);
      backdrop-filter: blur(4px);
    }

    dialog {
      border: none;
      border-radius: 12px;
      padding: 2rem;
      max-width: 480px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    }

    /* Details/Summary styling */
    details {
      border: 1px solid #e0e0e0;
      border-radius: 8px;
      margin-bottom: 0.5rem;
    }

    summary {
      padding: 1rem;
      cursor: pointer;
      font-weight: 600;
      list-style: none;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    summary::after {
      content: "▼";
      transition: transform 0.2s;
    }

    details[open] summary::after {
      transform: rotate(180deg);
    }

    details .content {
      padding: 0 1rem 1rem;
    }

    /* Popover */
    [popover] {
      border: none;
      border-radius: 8px;
      padding: 1rem;
      box-shadow: 0 4px 20px rgba(0,0,0,0.15);
      background: white;
    }
  </style>
</head>
<body>

  <!-- ─── DETAILS / SUMMARY (FAQ ACCORDION) ─── -->
  <section aria-labelledby="faq-heading">
    <h2 id="faq-heading">Frequently Asked Questions</h2>

    <details>
      <summary>What is HTML? ✨</summary>
      <div class="content">
        <p>HTML (HyperText Markup Language) is the standard
        markup language for creating web pages. It describes
        the structure and content of a web page.</p>
      </div>
    </details>

    <details>
      <summary>Do I need JavaScript to build websites? 🤔</summary>
      <div class="content">
        <p>For basic websites, no! HTML and CSS can create
        fully functional, beautiful pages. JavaScript adds
        interactivity and dynamic behavior.</p>
      </div>
    </details>

    <!-- open attribute: starts expanded -->
    <details open>
      <summary>Is HTML free to use? 💰</summary>
      <div class="content">
        <p>Absolutely! HTML is an open standard maintained
        by the W3C. It's free for everyone to use.</p>
      </div>
    </details>
  </section>

  <!-- ─── DIALOG (MODAL) ─── -->
  <!-- Trigger button -->
  <button
    type="button"
    onclick="document.getElementById('confirm-modal').showModal()"
  >
    Delete Account 🗑️
  </button>

  <!-- The dialog element -->
  <dialog
    id="confirm-modal"
    aria-labelledby="modal-title"
    aria-describedby="modal-desc"
  >
    <h2 id="modal-title">⚠️ Confirm Account Deletion</h2>
    <p id="modal-desc">
      This will permanently delete your account and all your data.
      This action <strong>cannot be undone</strong>.
    </p>

    <form method="dialog">
      <!-- method="dialog": submitting closes the dialog -->
      <!-- value attribute becomes dialog.returnValue -->
      <button type="submit" value="cancel">Cancel</button>
      <button type="submit" value="delete" autofocus>
        Yes, delete my account
      </button>
    </form>
  </dialog>

  <script>
    const modal = document.getElementById('confirm-modal');
    modal.addEventListener('close', () => {
      if (modal.returnValue === 'delete') {
        console.log('User confirmed deletion');
        // Perform deletion
      } else {
        console.log('User cancelled');
      }
    });
  </script>

  <!-- ─── NON-MODAL DIALOG ─── -->
  <button
    type="button"
    onclick="document.getElementById('info-dialog').show()"
  >
    Show Info Panel
  </button>

  <dialog id="info-dialog">
    <h3>Information Panel</h3>
    <p>This is a non-modal dialog — you can still interact
    with the rest of the page.</p>
    <button
      onclick="document.getElementById('info-dialog').close()"
    >
      Close
    </button>
  </dialog>

  <!-- ─── POPOVER API ─── -->
  <!-- Trigger: button with popovertarget -->
  <button
    type="button"
    popovertarget="my-tooltip"
    popovertargetaction="toggle"
  >
    Show Tooltip ℹ️
  </button>

  <!-- Popover content -->
  <div
    id="my-tooltip"
    popover
    role="tooltip"
  >
    <p>🎉 This is a native popover!</p>
    <p>Press Escape or click outside to dismiss.</p>
  </div>

  <!-- Popover menu -->
  <button type="button" popovertarget="actions-menu">
    Actions ▼
  </button>

  <menu id="actions-menu" popover>
    <li><button type="button">Edit</button></li>
    <li><button type="button">Duplicate</button></li>
    <li><button type="button">Archive</button></li>
    <li><button type="button">Delete</button></li>
  </menu>

</body>
</html>

─────────────────────────────────────
NATIVE vs JAVASCRIPT PATTERNS:
─────────────────────────────────────
Accordion:    <details> + <summary>     — no JS!
Modal:        <dialog>.showModal()      — minimal JS
Tooltip:      popover attribute         — no JS!
Alert:        <dialog> or role="alert"  — minimal JS
─────────────────────────────────────

📝 KEY POINTS:
✅ <details>/<summary> creates accordions with zero JavaScript
✅ dialog.showModal() traps focus, handles Escape, and adds ::backdrop
✅ form method="dialog" inside a dialog closes it on submit
✅ dialog.returnValue tells you which button was pressed
✅ Popover API provides Escape-to-close and outside-click-to-close for free
✅ Native interactive elements are always more accessible than custom JS versions
❌ dialog.show() is non-modal — it doesn't trap focus; dialog.showModal() does
❌ Don't build custom modal systems when <dialog> exists and is well-supported
''',
  quiz: [
    Quiz(question: 'What is the difference between dialog.show() and dialog.showModal()?', options: [
      QuizOption(text: 'showModal() traps focus and adds backdrop; show() opens without modal behavior', correct: true),
      QuizOption(text: 'show() opens with a backdrop; showModal() does not', correct: false),
      QuizOption(text: 'They are identical — just different naming', correct: false),
      QuizOption(text: 'showModal() requires a form inside; show() does not', correct: false),
    ]),
    Quiz(question: 'What does <form method="dialog"> inside a <dialog> do?', options: [
      QuizOption(text: 'Closes the dialog when submitted — the submit button value becomes dialog.returnValue', correct: true),
      QuizOption(text: 'Sends the form data to the server using the dialog protocol', correct: false),
      QuizOption(text: 'Opens a new dialog with the form response', correct: false),
      QuizOption(text: 'Validates the form without submitting', correct: false),
    ]),
    Quiz(question: 'What behavior does the popover attribute provide for free?', options: [
      QuizOption(text: 'Escape to close and clicking outside to dismiss — no JavaScript needed', correct: true),
      QuizOption(text: 'Animated entrance and exit transitions', correct: false),
      QuizOption(text: 'Automatic positioning near its trigger button', correct: false),
      QuizOption(text: 'Accessibility roles and ARIA attributes', correct: false),
    ]),
  ],
);
