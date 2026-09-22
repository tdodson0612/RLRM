// lib/lessons/html/html_06_tables.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson06 = Lesson(
  language: 'HTML',
  title: 'Tables',
  content: '''
🎯 METAPHOR:
An HTML table is like a spreadsheet embedded in a document.
It has rows, columns, and cells — each cell sits at the
intersection of its row and column. Tables are magnificent
for displaying data that has relationships across both
dimensions: "this product, at this price, with this rating."
The dark history of tables is that developers once used them
for PAGE LAYOUT — columns, sidebars, entire page structures
built in table cells. This was a nightmare for accessibility
and responsiveness. Layouts belong to CSS Grid and Flexbox.
Tables belong to tabular data. Know the difference.

📖 EXPLANATION:
TABLE ELEMENTS:
  <table>      the container
  <thead>      header section (column labels)
  <tbody>      body section (data rows)
  <tfoot>      footer section (summaries, totals)
  <tr>         table row
  <th>         table header cell (bold, centered by default)
  <td>         table data cell

SPANNING:
  colspan="2"  cell spans 2 columns
  rowspan="3"  cell spans 3 rows

ACCESSIBILITY:
  scope="col"  on <th> — column header
  scope="row"  on <th> — row header
  <caption>    visible description above/below table
  headers="id" on <td> — links to header cell by id

COLGROUP / COL:
  Apply styling to entire columns at once.

TABLE ATTRIBUTES (legacy but valid):
  <table border="1">  — most styling belongs in CSS

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Tables Demo</title>
</head>
<body>

  <!-- ─── BASIC TABLE ─── -->
  <table>
    <caption>Monthly Sales Report Q1 2024</caption>

    <thead>
      <tr>
        <th scope="col">Month</th>
        <th scope="col">Revenue</th>
        <th scope="col">Units Sold</th>
        <th scope="col">Growth</th>
      </tr>
    </thead>

    <tbody>
      <tr>
        <td>January</td>
        <td>\$42,000</td>
        <td>840</td>
        <td>+12%</td>
      </tr>
      <tr>
        <td>February</td>
        <td>\$38,500</td>
        <td>770</td>
        <td>-8%</td>
      </tr>
      <tr>
        <td>March</td>
        <td>\$51,200</td>
        <td>1,024</td>
        <td>+33%</td>
      </tr>
    </tbody>

    <tfoot>
      <tr>
        <th scope="row">Total</th>
        <td>\$131,700</td>
        <td>2,634</td>
        <td>+12%</td>
      </tr>
    </tfoot>
  </table>

  <!-- ─── COLSPAN AND ROWSPAN ─── -->
  <table>
    <caption>Conference Schedule</caption>
    <thead>
      <tr>
        <th scope="col">Time</th>
        <th scope="col">Room A</th>
        <th scope="col">Room B</th>
        <th scope="col">Room C</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <th scope="row">9:00 AM</th>
        <!-- colspan: this cell spans across ALL THREE rooms -->
        <td colspan="3">Opening Keynote — Main Hall</td>
      </tr>
      <tr>
        <th scope="row">10:00 AM</th>
        <td>HTML Basics</td>
        <td>CSS Deep Dive</td>
        <!-- rowspan: this talk runs for 2 hours -->
        <td rowspan="2">JavaScript Workshop</td>
      </tr>
      <tr>
        <th scope="row">11:00 AM</th>
        <td>Accessibility</td>
        <td>Performance</td>
        <!-- rowspan="2" cell from above occupies this space -->
      </tr>
      <tr>
        <th scope="row">12:00 PM</th>
        <td colspan="3">Lunch Break</td>
      </tr>
    </tbody>
  </table>

  <!-- ─── ROW HEADERS ─── -->
  <!-- When first column is a header, use th with scope="row" -->
  <table>
    <caption>Product Comparison</caption>
    <thead>
      <tr>
        <td></td>  <!-- empty corner cell -->
        <th scope="col">Basic Plan</th>
        <th scope="col">Pro Plan</th>
        <th scope="col">Enterprise</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <th scope="row">Price</th>
        <td>Free</td>
        <td>\$9/month</td>
        <td>Custom</td>
      </tr>
      <tr>
        <th scope="row">Storage</th>
        <td>5 GB</td>
        <td>50 GB</td>
        <td>Unlimited</td>
      </tr>
      <tr>
        <th scope="row">Support</th>
        <td>Community</td>
        <td>Email</td>
        <td>24/7 Phone</td>
      </tr>
    </tbody>
  </table>

  <!-- ─── COLGROUP: STYLE WHOLE COLUMNS ─── -->
  <table>
    <colgroup>
      <col>                  <!-- no style on first column -->
      <col class="highlight"> <!-- style second column -->
      <col span="2">          <!-- style third and fourth together -->
    </colgroup>
    <thead>
      <tr>
        <th>Name</th>
        <th>Score</th>
        <th>Level</th>
        <th>Badge</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Alice</td>
        <td>9,840</td>
        <td>Gold</td>
        <td>⭐</td>
      </tr>
    </tbody>
  </table>

</body>
</html>

📝 KEY POINTS:
✅ Always use <thead>, <tbody>, <tfoot> — they enable semantic styling and sticky headers
✅ Use scope="col" on column headers, scope="row" on row headers for accessibility
✅ <caption> provides an accessible title for the table — always include it
✅ colspan spans columns horizontally; rowspan spans rows vertically
✅ <colgroup> + <col> applies CSS to entire columns efficiently
❌ NEVER use tables for page layout — that is what CSS Grid/Flexbox is for
❌ Don't skip <thead> — it allows the browser to repeat headers when printing
''',
  quiz: [
    Quiz(question: 'What is scope="col" used for on a <th> element?', options: [
      QuizOption(text: 'Tells screen readers this header applies to the column below it', correct: true),
      QuizOption(text: 'Limits the column width to the header text width', correct: false),
      QuizOption(text: 'Creates a collapsible column in the table', correct: false),
      QuizOption(text: 'Applies CSS column styling to that header', correct: false),
    ]),
    Quiz(question: 'What does colspan="3" on a <td> do?', options: [
      QuizOption(text: 'Makes the cell span across 3 columns horizontally', correct: true),
      QuizOption(text: 'Makes the cell span across 3 rows vertically', correct: false),
      QuizOption(text: 'Sets the cell\'s width to 3 times the default', correct: false),
      QuizOption(text: 'Groups 3 cells together visually', correct: false),
    ]),
    Quiz(question: 'Why should you never use tables for page layout?', options: [
      QuizOption(text: 'Tables are for tabular data — using them for layout breaks accessibility and responsiveness', correct: true),
      QuizOption(text: 'Tables are too slow to render', correct: false),
      QuizOption(text: 'CSS cannot style table elements', correct: false),
      QuizOption(text: 'Tables are deprecated in HTML5', correct: false),
    ]),
  ],
);
