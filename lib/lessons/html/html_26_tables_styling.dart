// lib/lessons/html/html_26_tables_styling.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson26 = Lesson(
  language: 'HTML',
  title: 'HTML + CSS: Beautiful Data Tables',
  content: '''
🎯 METAPHOR:
A raw HTML table is like a spreadsheet printed directly
from Excel with zero formatting. The data is all there,
every number correct — but it assaults the eyes. Rows bleed
into each other. Column headers look identical to data cells.
Nobody can tell which row they are reading halfway across.
CSS transforms that data dump into a Bloomberg Terminal —
clean column headers with sort indicators, alternating row
shading that guides the eye across wide tables, hover
highlights that tell you exactly which row you're on,
sticky headers that follow you as you scroll, and status
badges that communicate at a glance. Same data. Total
transformation. The difference is entirely CSS.

📖 EXPLANATION:
TECHNIQUES COVERED:
  border-collapse: collapse — clean borders
  thead sticky headers      — position: sticky
  Zebra striping            — :nth-child(even)
  Row hover highlight       — tr:hover
  Responsive wrapper        — overflow-x: auto
  Sort indicator arrows     — ::after pseudo-element
  Status badges             — inline-block with colors
  Numeric alignment         — text-align: right + tabular-nums
  Column group coloring     — colgroup + col
  Truncated cells           — text-overflow: ellipsis

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Coffee Sales Dashboard</title>
  <style>
    :root {
      --brand:        #6c63ff;
      --surface:      #ffffff;
      --bg:           #f5f5fc;
      --text:         #1a1a2e;
      --muted:        #6b7280;
      --border:       #e5e7eb;
      --row-hover:    #f0f0ff;
      --row-stripe:   #f9f9fb;
      --header-bg:    #1a1a2e;
      --header-text:  #ffffff;
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; }

    body {
      font-family: system-ui, sans-serif;
      background: var(--bg);
      color: var(--text);
      padding: 2rem;
    }

    /* ─── PAGE HEADER ─── */
    .dashboard-header {
      margin-bottom: 2rem;
    }

    .dashboard-header h1 {
      font-size: 1.75rem;
      font-weight: 800;
      margin-bottom: 0.25rem;
    }

    .dashboard-header p {
      color: var(--muted);
      font-size: 0.95rem;
    }

    /* ─── STATS ROW ─── */
    .stats-row {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
      gap: 1rem;
      margin-bottom: 2rem;
    }

    .stat-card {
      background: var(--surface);
      border-radius: 12px;
      padding: 1.25rem;
      box-shadow: 0 1px 4px rgba(0,0,0,0.06);
    }

    .stat-card__label {
      font-size: 0.75rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      color: var(--muted);
      margin-bottom: 0.5rem;
    }

    .stat-card__value {
      font-size: 1.75rem;
      font-weight: 800;
      color: var(--brand);
      font-variant-numeric: tabular-nums;
    }

    .stat-card__change {
      font-size: 0.8rem;
      font-weight: 600;
      margin-top: 0.25rem;
    }
    .stat-card__change--up   { color: #16a34a; }
    .stat-card__change--down { color: #dc2626; }

    /* ─── TABLE WRAPPER ─── */
    .table-wrap {
      background: var(--surface);
      border-radius: 16px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.07);
      overflow: hidden;
    }

    .table-toolbar {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 1.25rem 1.5rem;
      border-bottom: 1px solid var(--border);
    }

    .table-toolbar h2 { font-size: 1.1rem; font-weight: 700; }

    .table-scroll { overflow-x: auto; }

    /* ─── TABLE ─── */
    table {
      width: 100%;
      border-collapse: collapse;
      table-layout: fixed;
      font-size: 0.9rem;
    }

    /* ─── COLUMN WIDTHS ─── */
    col.col-product { width: 30%; }
    col.col-origin  { width: 15%; }
    col.col-units   { width: 12%; }
    col.col-revenue { width: 14%; }
    col.col-growth  { width: 12%; }
    col.col-stock   { width: 11%; }
    col.col-status  { width: 10%; }

    /* ─── HEADER ─── */
    thead {
      position: sticky;
      top: 0;
      z-index: 2;
    }

    thead th {
      background: var(--header-bg);
      color: var(--header-text);
      text-align: left;
      padding: 0.875rem 1rem;
      font-size: 0.75rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      white-space: nowrap;
    }

    /* Numeric headers right-aligned */
    thead th.num { text-align: right; }

    /* Sort indicators */
    th.sortable { cursor: pointer; user-select: none; }
    th.sortable:hover { background: #2d2d4e; }
    th.sort-asc::after  { content: " ↑"; color: #a78bfa; }
    th.sort-desc::after { content: " ↓"; color: #a78bfa; }

    /* ─── ROWS ─── */
    tbody tr {
      border-bottom: 1px solid var(--border);
      transition: background 0.1s;
    }

    tbody tr:last-child { border-bottom: none; }
    tbody tr:nth-child(even) { background: var(--row-stripe); }
    tbody tr:hover { background: var(--row-hover); cursor: pointer; }

    td {
      padding: 0.875rem 1rem;
      vertical-align: middle;
    }

    /* Truncate long text */
    td.truncate {
      max-width: 0;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    /* Numeric cells */
    td.num {
      text-align: right;
      font-variant-numeric: tabular-nums;
      font-feature-settings: 'tnum';
    }

    /* ─── PRODUCT CELL ─── */
    .product-cell {
      display: flex;
      align-items: center;
      gap: 0.75rem;
    }

    .product-thumb {
      width: 36px;
      height: 36px;
      border-radius: 8px;
      object-fit: cover;
      flex-shrink: 0;
      background: var(--bg);
    }

    .product-name  { font-weight: 600; }
    .product-sku   { font-size: 0.75rem; color: var(--muted); }

    /* ─── GROWTH INDICATOR ─── */
    .growth {
      font-weight: 600;
      font-variant-numeric: tabular-nums;
    }
    .growth--up   { color: #16a34a; }
    .growth--down { color: #dc2626; }

    /* ─── STATUS BADGE ─── */
    .badge {
      display: inline-flex;
      align-items: center;
      gap: 0.3rem;
      padding: 0.25rem 0.6rem;
      border-radius: 999px;
      font-size: 0.7rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      white-space: nowrap;
    }
    .badge--in-stock  { background: #dcfce7; color: #15803d; }
    .badge--low       { background: #fef9c3; color: #a16207; }
    .badge--out       { background: #fee2e2; color: #b91c1c; }

    /* ─── TABLE FOOTER ─── */
    tfoot td {
      padding: 0.875rem 1rem;
      font-weight: 700;
      border-top: 2px solid var(--border);
      background: #f9f9fb;
    }
  </style>
</head>
<body>

<main>
  <div class="dashboard-header">
    <h1>☕ Sales Dashboard</h1>
    <p>Q1 2024 · Updated March 15, 2024</p>
  </div>

  <!-- Stat cards -->
  <div class="stats-row">
    <div class="stat-card">
      <div class="stat-card__label">Total Revenue</div>
      <div class="stat-card__value">\$84,220</div>
      <div class="stat-card__change stat-card__change--up">↑ 18.3% vs last quarter</div>
    </div>
    <div class="stat-card">
      <div class="stat-card__label">Units Sold</div>
      <div class="stat-card__value">4,811</div>
      <div class="stat-card__change stat-card__change--up">↑ 12.7%</div>
    </div>
    <div class="stat-card">
      <div class="stat-card__label">Avg Order Value</div>
      <div class="stat-card__value">\$17.50</div>
      <div class="stat-card__change stat-card__change--down">↓ 2.1%</div>
    </div>
    <div class="stat-card">
      <div class="stat-card__label">Products Active</div>
      <div class="stat-card__value">24</div>
      <div class="stat-card__change stat-card__change--up">↑ 3 new</div>
    </div>
  </div>

  <!-- Table -->
  <div class="table-wrap">
    <div class="table-toolbar">
      <h2>Product Performance</h2>
    </div>

    <div class="table-scroll">
      <table>
        <caption class="sr-only">Q1 2024 Product Sales Performance</caption>

        <colgroup>
          <col class="col-product">
          <col class="col-origin">
          <col class="col-units">
          <col class="col-revenue">
          <col class="col-growth">
          <col class="col-stock">
          <col class="col-status">
        </colgroup>

        <thead>
          <tr>
            <th scope="col" class="sortable sort-asc">Product</th>
            <th scope="col">Origin</th>
            <th scope="col" class="num sortable">Units</th>
            <th scope="col" class="num sortable">Revenue</th>
            <th scope="col" class="num sortable">Growth</th>
            <th scope="col" class="num">Stock</th>
            <th scope="col">Status</th>
          </tr>
        </thead>

        <tbody>
          <tr>
            <td>
              <div class="product-cell">
                <img class="product-thumb" src="/images/eth.jpg" alt="" width="36" height="36">
                <div>
                  <div class="product-name">Yirgacheffe Natural</div>
                  <div class="product-sku">ETH-NAT-250</div>
                </div>
              </div>
            </td>
            <td>Ethiopia</td>
            <td class="num">1,240</td>
            <td class="num">\$17,360</td>
            <td class="num"><span class="growth growth--up">↑ 24%</span></td>
            <td class="num">148</td>
            <td><span class="badge badge--in-stock">● In Stock</span></td>
          </tr>
          <tr>
            <td>
              <div class="product-cell">
                <img class="product-thumb" src="/images/col.jpg" alt="" width="36" height="36">
                <div>
                  <div class="product-name">Huila Washed</div>
                  <div class="product-sku">COL-WAS-250</div>
                </div>
              </div>
            </td>
            <td>Colombia</td>
            <td class="num">987</td>
            <td class="num">\$14,805</td>
            <td class="num"><span class="growth growth--up">↑ 11%</span></td>
            <td class="num">22</td>
            <td><span class="badge badge--low">⚠ Low Stock</span></td>
          </tr>
          <tr>
            <td>
              <div class="product-cell">
                <img class="product-thumb" src="/images/guat.jpg" alt="" width="36" height="36">
                <div>
                  <div class="product-name">Antigua Dark</div>
                  <div class="product-sku">GTM-DRK-250</div>
                </div>
              </div>
            </td>
            <td>Guatemala</td>
            <td class="num">456</td>
            <td class="num">\$7,296</td>
            <td class="num"><span class="growth growth--down">↓ 3%</span></td>
            <td class="num">0</td>
            <td><span class="badge badge--out">✕ Out of Stock</span></td>
          </tr>
        </tbody>

        <tfoot>
          <tr>
            <td colspan="2">Total</td>
            <td class="num">2,683</td>
            <td class="num">\$39,461</td>
            <td class="num">—</td>
            <td class="num">170</td>
            <td></td>
          </tr>
        </tfoot>
      </table>
    </div>
  </div>
</main>

</body>
</html>

📝 KEY POINTS:
✅ table-layout: fixed prevents columns shifting when data loads
✅ position: sticky on thead keeps headers visible while scrolling
✅ font-variant-numeric: tabular-nums aligns numbers in columns
✅ overflow-x: auto on wrapper handles wide tables on mobile
✅ :nth-child(even) zebra striping helps eyes track across wide rows
✅ caption with .sr-only class provides accessible table title
❌ Don't rely on fixed px column widths — use percentages via col elements
❌ Decorative thumbnail images inside td should have empty alt=""
''',
  quiz: [
    Quiz(question: 'What does font-variant-numeric: tabular-nums do in a data table?', options: [
      QuizOption(text: 'Makes all digits equal width so numbers align perfectly in columns', correct: true),
      QuizOption(text: 'Converts numbers to tabular format with borders', correct: false),
      QuizOption(text: 'Adds thousand separators to numbers', correct: false),
      QuizOption(text: 'Right-aligns numeric cells automatically', correct: false),
    ]),
    Quiz(question: 'How do you make a table header row sticky on scroll?', options: [
      QuizOption(text: 'position: sticky; top: 0 on the thead element', correct: true),
      QuizOption(text: 'position: fixed; top: 0 on each th element', correct: false),
      QuizOption(text: 'overflow: sticky on the table wrapper', correct: false),
      QuizOption(text: 'sticky="true" attribute on thead', correct: false),
    ]),
    Quiz(question: 'Why should table caption have class="sr-only" instead of being hidden entirely?', options: [
      QuizOption(text: 'Screen readers announce the caption — it provides context while remaining visually clean', correct: true),
      QuizOption(text: 'Hidden captions break table accessibility rules', correct: false),
      QuizOption(text: 'sr-only is required for caption to work', correct: false),
      QuizOption(text: 'It prevents the caption from taking up space in the layout', correct: false),
    ]),
  ],
);
