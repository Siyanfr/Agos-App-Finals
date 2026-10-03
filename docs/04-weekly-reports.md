# Weekly reports

## Week of: September 20, 2026

## What changed this week

- Set up the project's `lib/` folder structure: `models/`, `screens/citizen/`,
  `screens/authority/`, `widgets/`.
- Built `theme.dart` — implements the full design system as code: `AppColors`
  (all Step A color tokens including `statusPending`, `statusResolved`,
  `statusPendingBg`, `surfaceTint`), `AppSpacing`, `AppRadius`, and the
  assembled `ThemeData`.
- Built the 4 atom widgets: `PrimaryButton`, `TextInputField`, `StatusBadge`,
  `DetailRow`.
- Built the Login Screen UI (username/password fields, password visibility
  toggle, login button).
- Built the Citizen Home Dashboard, including the `StatSummaryCard` and
  `ReportCard` molecule widgets, and the Report Details modal
  (`DetailModal` organism) with the darkened backdrop over the dashboard.
- Built the Submit Report screen, wired to `image_picker` (gallery selection)
  and `geolocator` (GPS auto-detect with permission-denied/service-disabled
  handling and a manual text fallback).
- Built the Authority Review Dashboard with filter chips (All / Pending /
  Resolved / Rejected) and the Authority Report Action & Resolution screen
  (photo evidence viewer, segmented status control, notes field, save
  button).
- Added the `device_preview` wrapper to `main.dart` so screens can be
  previewed at different device sizes.
- Installed the FlutterFire CLI and `firebase-tools`, resolved a Windows PATH
  issue that prevented the `flutterfire` command from being recognized, and
  ran `flutterfire configure` to connect the project to Firebase (generating
  `lib/firebase_options.dart`).
- Added `firebase_core` to `pubspec.yaml` and initialized Firebase in
  `main.dart` — this is the start of the Firebase setup phase.

  Commit History:
  <img width="869" height="978" alt="brave_rdBn8r2o2p" src="https://github.com/user-attachments/assets/07199c54-8684-494f-b829-52f3cb0c00bf" />

## Why

The plan was to get all 5 required screens visually and functionally correct
against the proposal, mockup, and design system first — using placeholder
data — before connecting any backend. This means every screen can be checked
against the mockup on its own, one at a time, instead of debugging UI and
Firebase issues simultaneously. Firebase setup was started only after all 5
screens existed.

## What broke or what I got stuck on

- After installing `flutterfire_cli` via `dart pub global activate`, the
  `flutterfire` command wasn't recognized in the terminal. This was because
  Windows didn't have the Pub cache's `bin` folder
  (`...\AppData\Local\Pub\Cache\bin`) on its `Path` environment variable.
  Fixed by adding that folder to the User `Path` variable through Windows'
  Environment Variables settings and restarting the terminal.
- Confirmed a real architecture gap while testing: updating a report's status
  on the Authority Report Action screen does not currently reflect on the
  Citizen Dashboard. This is expected at this stage since each screen holds
  its own local placeholder list with no shared data source, but it confirms
  the core sync risk named in the proposal and is the main reason Firestore
  (with `StreamBuilder`) needs to go in next.

## What is left

- Enable Firebase Authentication (Email/Password) and create the 3 seeded
  demo accounts.
- Set up Cloud Firestore's `users` and `reports` collections, plus security
  rules enforcing per-role read/write access.
- Set up Firebase Storage for report photo uploads.
- Replace placeholder data on all 5 screens with real Firestore reads via
  `StreamBuilder`, so status updates sync live across devices.
- Wire the Submit Report screen to actually upload the photo to Storage and
  write the report document to Firestore.
- Add the Android/iOS permission entries needed for `image_picker` and
  `geolocator` on real devices.
- Implement real login-based routing so `main.dart` routes to the Citizen or
  Authority dashboard based on the signed-in user's role instead of pointing
  directly at one screen.
- Take and add real screenshots to the documentation.


# Weekly 2 Report

## Week of: September 26, 2026

## What changed this week

- Hit a real architecture blocker: Firebase Storage now requires the paid
  Blaze plan, and I can't use a credit card right now. Switched report photo
  storage to Cloudinary (free tier, unsigned upload preset) instead —
  Firebase Authentication and Cloud Firestore stayed exactly as planned,
  since those remain free on Spark.
- Set up the actual Cloud Firestore database: created the `users` and
  `reports` collections, seeded the 3 demo accounts' profile documents, and
  replaced the default locked-down rules with real role-based security rules
  (citizens can only read/write their own reports, only authority accounts
  can update a status).
- Removed all placeholder data from every screen and wired the Citizen
  Dashboard, Submit Report, Authority Dashboard, and Report Action screens to
  real Firestore reads/writes and the new Cloudinary upload service.
- Fixed a crash where tapping the photo upload button multiple times quickly
  threw `PlatformException (already_active)` — added a guard so a second tap
  can't trigger the image picker while one is already open.
- Fixed a `NotInitializedError` from `flutter_dotenv` — I'd forgotten to
  actually call `dotenv.load()` in `main()` before reading `.env` values.
- Fixed a bug where submitting a report showed a blank white screen even
  though the report was actually saved successfully — leftover placeholder
  code from before Firestore was wired in was calling `Navigator.pop()` a
  second time right after the real submission logic already popped once.
- Fixed report photos not appearing on the Authority Report Action screen —
  `PhotoEvidenceViewer` still had its old hardcoded placeholder icon and was
  never updated to actually render the real `photoUrl`.
- Made the app run on Chrome, not just the Android emulator. This meant
  switching all image handling from `dart:io`'s `File` (mobile/desktop only)
  to reading picked images as raw bytes (`Uint8List`), which works
  identically across web and mobile, and updating the Cloudinary upload to
  send those bytes directly instead of a file path.
- Cleaned up unused imports left over in `main.dart` from earlier manual
  screen-swapping during development.
- Completed the Week 2 security requirements: filled in
  `SECURITY-CHECKLIST.md` and `docs/06-security-and-privacy.md`. This caught
  a real issue — my full name and section were printed on every page of the
  proposal, mockup, and design system docs in `docs/` — which I fixed by
  removing them before the repo stayed public. Also enabled GitHub secret
  scanning and push protection, ran a full git history scan for leaked
  secrets (found only non-sensitive Firebase client API keys), and verified
  signed-out users can't read or write any report data.
- Spent today (September 26) entirely on documentation rather than app code:
  reorganized and cleaned up the design system markdown in `docs/`, removed
  redundant/duplicate doc assets, and revised the security and privacy
  documentation.

Commit History:

<img width="872" height="1170" alt="brave_YHRP7feXMa" src="https://github.com/user-attachments/assets/d3c8ded2-bb9c-46d0-8f37-f041c247703d" />


## Why

Last week's screens were all built against placeholder data. This week's
goal was making the app actually functional end-to-end — a real Firebase
backend, a real photo storage solution once the original Firebase Storage
plan hit a billing wall, and cross-platform support — plus catching up on
the documentation and security requirements that come due starting week 2.

## What broke or what I got stuck on

- Firebase Storage requiring a paid plan was the single biggest unplanned
  change this week — it meant redesigning the photo storage piece of the
  architecture mid-build rather than just following the original proposal.
- Two separate composite-index errors from Firestore (`reporterId` +
  `timestamp` for the citizen dashboard, `status` + `timestamp` for the
  authority filter chips) — each fixed by creating the index Firestore's own
  error message linked to.
- The white-screen-after-submit bug was the trickiest one to track down,
  since the report was actually saving correctly the whole time; the bug was
  purely leftover dead code still running after the real logic finished.
- Found that my own project documentation had my real name exposed
  throughout `docs/`, which I hadn't thought to check for until doing the
  security checklist properly.

## What is left

- Optionally restrict the Firebase API key in the Google Cloud console
  (documented as a deliberate, low-priority skip for now).
- Add a Firestore rule restricting the `status` field to only `Pending`,
  `Resolved`, or `Rejected`.
- Write `AI-USAGE.md`, required per the finals-badge unit — not yet started.
- Continue general edge-case testing (e.g. location permission denial paths,
  rejecting a report with notes, multi-account isolation).

