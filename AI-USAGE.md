# AI usage

This project was built with AI assistance. This file is the record of it. It is
graded as the finals badge, and it is worth 100 points.

## 1. How I used AI

### 2026-09-17 - Building the design system and atom widgets from the design spec

- **Tool:** Claude (Anthropic)
- **What I asked for:** Help turning my Design System PDF (color tokens, spacing/radius constants, typography scale) into actual Flutter code, plus the first set of reusable widgets (`PrimaryButton`, `TextInputField`, `StatusBadge`, `DetailRow`) before building any real screens.
- **What it gave back:** A `theme.dart` file with `AppColors`, `AppSpacing`, `AppRadius` classes and an assembled `ThemeData`, plus the four widget files, all pulled directly from the values in my PDF.
- **What I kept, what I changed, and why:** Kept the structure as given. One real gap it caught for me: my Design System had no color defined for a "Rejected" status, only Pending and Resolved, so it flagged this and proposed reusing the existing `error` color rather than inventing a new one, which I accepted.
- **Commit:** https://github.com/Siyanfr/Agos-App-Finals/commit/35f48fee52a2193745ae9986b2028559bdd0fc6c

### 2026-09-19 - FlutterFire CLI setup and a Windows PATH issue

- **Tool:** Claude (Anthropic)
- **What I asked for:** Step-by-step help connecting my Flutter project to Firebase, since I had no prior Firebase experience.
- **What it gave back:** Instructions for installing the FlutterFire CLI and Firebase CLI, then a walkthrough for diagnosing the "not on your path" warning I hit right after install, including exactly which Windows environment variable to edit and why a terminal restart was needed for it to take effect.
- **What I kept, what I changed, and why:** Followed the fix as given; it resolved the issue on the first attempt.
- **Commit:** https://github.com/Siyanfr/Agos-App-Finals/commit/26de71b5126ecc7d0aee00130b63bdda200e8ace

### 2026-09-21 - Redesigning photo storage after hitting Firebase's billing wall

- **Tool:** Claude (Anthropic)
- **What I asked for:** My proposal specified Firebase Storage for report photos. When I actually tried to enable it, Firebase required upgrading to the paid Blaze plan, which I can't do (no credit card). I asked for an alternative.
- **What it gave back:** A comparison of upgrading to Blaze (still free at my scale, but requires a card) versus switching to a free third-party service like Cloudinary, then a full walkthrough of setting up an unsigned Cloudinary upload preset and rewriting the storage service layer around it once I chose Cloudinary.
- **What I kept, what I changed, and why:** Went with the Cloudinary path since it avoids needing a card at all. Kept the unsigned-preset approach as given, it was flagged clearly as a real tradeoff (anyone extracting the preset name could technically upload through it), which I accepted as reasonable for a class project.
- **Commit:** https://github.com/Siyanfr/Agos-App-Finals/commit/6961a4fe3e727f7ce51c9bb58dc204213a1cd6c9

### 2026-09-21 - Writing the Firestore security rules

- **Tool:** Claude (Anthropic)
- **What I asked for:** Security rules enforcing that citizens can only read/write their own reports, and only authority accounts can update a report's status.
- **What it gave back:** A full `firestore.rules` file using helper functions (`isSignedIn`, `getRole`, `isAuthority`, `isCitizen`) that check a user's role by reading their own `users/{uid}` document.
- **What I kept, what I changed, and why:** Published the rules as given, then tested them myself by logging in as each of the 3 seeded accounts and confirming role-appropriate access actually worked, rather than trusting the rules were correct without checking.
- **Commit:** https://github.com/Siyanfr/Agos-App-Finals/commit/369f58e0a466fa1cc3c41cea73ea414349c7fc46

### 2026-09-22 - Replacing all placeholder data with real Firestore and Cloudinary

- **Tool:** Claude (Anthropic)
- **What I asked for:** Rewrite the Citizen Dashboard, Submit Report, Authority Dashboard, and Report Action screens to use real Firestore `StreamBuilder`s and the new Cloudinary upload service instead of the hardcoded placeholder lists I'd been testing UI against.
- **What it gave back:** Full rewrites of all four screens, plus new `FirestoreService` and `StorageService` classes.
- **What I kept, what I changed, and why:** Kept the rewrites as given. This is also where I hit two separate Firestore "missing composite index" errors and an image-picker double-tap crash, covered in Section 2.
- **Commit:** https://github.com/Siyanfr/Agos-App-Finals/commit/1241cfca90479e4c2cc82df3506210efef1fa36b

### 2026-09-25 - Making the app work on Flutter Web

- **Tool:** Claude (Anthropic)
- **What I asked for:** The app only worked on the Android emulator; I wanted it usable in Chrome too so classmates without Android Studio could try it.
- **What it gave back:** An explanation that `dart:io`'s `File` class doesn't exist on Flutter Web, then a rewrite of the image-picking and Cloudinary upload code to use raw bytes (`Uint8List`) instead of file paths, which works identically on both platforms.
- **What I kept, what I changed, and why:** Kept the byte-based approach as given; re-tested on both the Android emulator and Chrome afterward to confirm neither platform regressed.
- **Commit:** https://github.com/Siyanfr/Agos-App-Finals/commit/33d63d7f008be10a7c79c595daac0a4c8b34f7c0

## 2. Where the AI got it wrong

### Case 1 - Never flagged Firebase Storage's billing requirement

- **What it gave me:** Early setup instructions for Firebase Storage, matching my proposal's original plan, with no mention that this service now requires the paid Blaze plan.
- **What was wrong with it:** I only discovered this by hitting the paywall directly inside the Firebase console while trying to enable Storage, mid-build, forcing an unplanned architecture change rather than something I could plan around in advance.
- **What I did instead:** Asked for alternatives on the spot and switched to Cloudinary for photo storage, keeping Firebase for Authentication and Firestore.
- **Commit:** https://github.com/Siyanfr/Agos-App-Finals/commit/6961a4fe3e727f7ce51c9bb58dc204213a1cd6c9

### Case 2 - Missing re-entrancy guard on the image picker

- **What it gave me:** The first version of the photo-picking function had no protection against being triggered twice in quick succession.
- **What was wrong with it:** Tapping the upload button rapidly caused a real `PlatformException(already_active, Image picker is already active)` crash, which then left the app in an unresponsive state requiring a full restart.
- **What I did instead:** Had it add a boolean guard flag so a second tap while a picker session is already open is simply ignored instead of triggering a second picker instance.
- **Commit:** https://github.com/Siyanfr/Agos-App-Finals/commit/109b540b1baf9a90e3cd4811469cedf0402e693f

### Case 3 - No warning about Firestore's composite index requirement

- **What it gave me:** `FirestoreService` queries combining a `.where()` filter with an `.orderBy()` on a different field (e.g. filtering by `reporterId`, sorting by `timestamp`), with no mention that Firestore requires a manually created composite index for each such combination before the query will even run.
- **What was wrong with it:** I hit this as two separate confusing runtime errors in the app (`cloud_firestore/failed-precondition`) instead of being told upfront that these specific queries would need indexes created in the Firebase console first.
- **What I did instead:** Followed the auto-generated links in each error message to create the missing indexes, and in one case caught that the console had visually truncated a field name (`ReportId` instead of `reporterId`) before creating a wrong index.
- **Commit:** https://github.com/Siyanfr/Agos-App-Finals/commit/1241cfca90479e4c2cc82df3506210efef1fa36b

## 3. Who wrote what

Left open for now. As of this entry, I don't have a piece of this project that's genuinely code I wrote independently, without asking Claude to do it. Filling this section with something that presents AI-written code as my own would defeat the point of this file, so I'm leaving it incomplete rather than write something false. I plan to come back and complete this once I've written and committed something real on my own.
