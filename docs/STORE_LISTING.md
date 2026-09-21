<!-- docs/STORE_LISTING.md -->

# Store listing draft: RLRM

Draft wording for the App Store and Google Play. Not legal advice. Before you
submit, re-read Epic's Fan Content Policy and each store's rules on trademarks
and impersonation.

## Names
- **App name:** RLRM
- **iOS subtitle (30 characters max):** Unofficial training roadmap
- **Play short description (80 characters max):** An unofficial, offline practice roadmap and session planner.

## Description (App Store and Google Play)
RLRM is a free, unofficial practice roadmap for Rocket League players. It turns
"what should I practice?" into a clear answer.

- A Beginner to SSL roadmap of 82 skills, each with steps, drills, a mastery test and a match test
- Home tells you what to work on next, and why
- Timed sessions of 10, 30 or 60 minutes that pick skills for your mode (1v1, 2v2, 3v3 or any)
- Lessons show your own controller buttons
- Progress, favorites and skills to refresh, all kept on your device
- Search across skills and training packs

RLRM works fully offline. It has no account, no ads, no purchases and no
tracking.

Training packs are made by community creators and are listed with their credit.
RLRM does not host them and cannot open the game for you.

Finishing the roadmap does not guarantee any rank.

This is an unofficial fan project. It is not made, approved or endorsed by Epic
Games or Psyonix.

{{EPIC_DISCLAIMER}}

## Other fields
- **Keywords (iOS, 100 characters max):** training,practice,roadmap,skills,drills,coach,progress,checklist,sessions,offline
- **Suggested category:** Entertainment
- **What's new (first release):** First release.
- **Screenshots and video:** app screens only. No game footage, game screenshots, logos or characters.
- **Apple privacy label / Google Data safety:** no data collected, none shared.
- **Privacy policy URL:** host `docs/PRIVACY_POLICY.md` somewhere public (see `docs/LEGAL_CHECKLIST.md`).
- **Support contact:** your email address.
- **Pricing:** free, with no in-app purchases and no ads. Epic's policy does not allow a monetary goal.

## Filling in the required Epic notice
The placeholder above must be replaced with the exact notice from section 1.10
of Epic's policy. If you already pasted it into `lib/core/legal/legal_text.dart`,
this command copies it in for you (run it from the project folder):

```bash
python3 - <<'PY'
import re, pathlib
src = pathlib.Path('lib/core/legal/legal_text.dart').read_text()
notice = re.search(r"epicDisclaimer =\s*'([^'\n]*)';", src).group(1)
doc = pathlib.Path('docs/STORE_LISTING.md')
doc.write_text(doc.read_text().replace('{{EPIC_' + 'DISCLAIMER}}', notice))
PY
```