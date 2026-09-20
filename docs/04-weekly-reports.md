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




