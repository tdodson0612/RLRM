<!-- docs/LEGAL_CHECKLIST.md -->

# Legal checklist: RLRM

Not legal advice. Source: Epic Games Fan Content Policy
(https://legal.epicgames.com/epicgames/fan-art-policy), last read 2026-09-19.
Epic may change the policy or withdraw permission at any time (section 1.5), so
re-read it before every release and update `LegalText.policyCheckedOn`.

## What the policy covers
Personal, non-commercial fan content, including free public apps. Section 2 says
Epic's terms and the game's own EULA still apply. Nothing in this app touches the
game (no memory reading, no automation), so there is no conflict with them.

## Rules and how the app complies
| Policy | Requirement (paraphrased) | Status |
|---|---|---|
| 1.4 | No monetary objective | OK. No ads, purchases, donations, affiliate or sponsored links. Do not add any. |
| 1.6, 1.8 | Never imply endorsement; must not look official | OK. Own name, palette and icons; About page says unofficial. Never call packs, stats or results "official" or "verified by the game". |
| 1.7 | No links to cheat or hack sites | Applies to training-pack source URLs (Stage 5). |
| 1.10 | Show Epic's exact disclaimer | OPEN. Paste it into `legal_text.dart`; also put it in the store listing. |
| 1.11 | Game marks only to discuss the game; never alter them; no look-alike domains | OK today (no logos, no title in the name, no assets). Gray area: the "RL" in "RLRM". |

## Before release
1. Paste the disclaimer verbatim; `flutter test` must pass.
2. Decide the name risk (the "RL" in "RLRM"): keep "Unofficial" in the store title, get a short legal review, or pick a name without "RL".
3. Original launcher icon (replace the Flutter default). No car, ball or game-logo look-alikes.
4. Bundle/application ID and any website domain must not contain the game's name.
5. Store screenshots and video: app screens only, no game footage or logos.
6. Privacy policy URL for both stores. Photo Stat Check (planned) stays on-device: no upload, photo discarded after reading, clear camera/photo permission text.
7. Training packs: record only code, name, creator, source URL and dates. Write our own descriptions. Credit creators.
8. Keep `showLicensePage`; add credits for any font or package added later.
9. Keep the app free of ads, accounts and chat (the game has younger players).