# Proposal

> Final Project Proposal V2 — submitted September 18, 2026 (CS-302).

## The problem, in one sentence

Citizens who encounter illegally parked vehicles have an outlet to vent — public
shaming pages on Facebook — but no structured way to document the incident and
get it in front of the people who can actually act on it.

## Who it is for

- **Citizen reporters**: commuters, motorists, cyclists, and pedestrians in
  Angeles City who currently deal with illegally parked vehicles by posting to
  pages like **ParkSerye**, a public anonymous Facebook page where people share
  photos of offending vehicles. The post gets comments and the vehicle gets
  called out, but then nothing happens — no record of whether it was moved, no
  one officially notified, no way to check back later.
- **Authority reviewers**: Local Government Units (LGU), who currently have no
  single place to see what's being reported across the city in real time, only
  whatever surfaces on social media or reaches them by phone.

## Core features

| # | Feature | Flutter pieces it needs | Honest estimate |
|---|---|---|---|
| 1 | Login with seeded accounts | `TextFormField`, `FirebaseAuth.instance.signInWithEmailAndPassword`, simple account selector buttons for demo convenience, `StreamBuilder`/`Provider` for state, `Navigator.pushReplacement` based on user role (citizen vs authority) | 1 hour |
| 2 | Submit report (with location capture) | `Form`, `TextFormField`, `image_picker` (`ImagePicker().pickImage`) for photo, `geolocator` (`Geolocator.getCurrentPosition`) with fallback to manual location text entry, `ElevatedButton`, Firebase Storage upload, Firestore record creation | 10 hours |
| 3 | Citizen dashboard & modal report details | `StreamBuilder<QuerySnapshot>` reading Firestore filtered by `reporterId`, `ListView.builder`, `Card`, `Chip` for status. Tapping a report triggers `showDialog()` displaying a centered modal with photo, location, date, ID, and status badge over a darkened backdrop scrim | 2 hours |
| 4 | Track report status & authority review | `StreamBuilder<QuerySnapshot>` reading all active reports, `DropdownButton`/`SegmentedButton` filter by status, `ListTile` detail inspection, and status updates via `FirebaseFirestore.instance.collection('reports').doc(id).update({'status': newStatus})` | 8 hours |

## Out of scope, and why

These stayed off the MVP list on purpose — none of them are needed to prove the
core citizen-report → authority-review loop, and each adds real scope:

- **Real-time push notifications** (Firebase Cloud Messaging) to notify
  citizens when a report's status changes.
- **User registration / sign-up** for non-seeded accounts — the 3 pre-seeded
  demo accounts (2 citizen, 1 authority) are enough for grading and testing
  without building a full account-creation flow.
- **AI-powered image analysis** to auto-detect illegally parked vehicles.
- **Integration with LGU dashboards** for report management and monitoring.
- **CCTV integration** for automated road obstruction detection.

## Data the app remembers, and where it is saved

**Does it need to be shared?** Yes. Citizens submit reports that authority
reviewers must inspect and update. An authority user on one device needs to
see live data submitted by a citizen on another device, and the citizen must
see when the authority marks their report as "Resolved" or "Rejected." That
ruled out `shared_preferences` (device-local only) — the tradeoff accepted for
a real shared backend is higher setup overhead (Firebase project config,
security rules, environment variables, async network states) and requiring an
active internet connection during testing.

**Storage choice:** Firebase — Cloud Firestore for the database, Firebase
Authentication for the seeded accounts, Firebase Storage for photo evidence.

**Roughly how much data:** around 30–50 reports total during seeded testing
and demo execution, across the 3 pre-configured accounts.

**Concretely, what's saved:**

| Thing | Fields | Where it is saved |
|---|---|---|
| User | `uid` (doc ID), `email`, `fullName`, `role` ("citizen" or "authority") | Cloud Firestore (`users` collection) & Firebase Auth — pre-seeded with 2 citizens, 1 authority |
| Report | `id`, `reporterId`, `photoUrl`, `description`, `latitude`, `longitude`, `locationName`, `timestamp`, `status` ("Pending"/"Resolved"/"Rejected") | Cloud Firestore (`reports` collection) & Firebase Storage (photos) |

**Have I tried it yet?** In the previous iteration I spiked local JSON encoding
with `shared_preferences`. Moving to Firebase is a newly proposed architectural
shift for this revised proposal — the live Firebase SDK is not yet wired into
the main Flutter build as of this proposal's writing.

**Public repo consideration:** the project will live in a public GitHub repo.
Firebase config (`google-services.json`, `firebase_options.dart`) is needed;
the 3 seeded accounts use dummy credentials (`citizen1@agos.app`,
`citizen2@agos.app`, `authority1@agos.app`). API keys/config values load via
`.env` (git-ignored), with a `.env.example` committed to the repo.

## Risks

**Named last time:** the biggest risk was reliably implementing photo uploads
and GPS location capture while ensuring report information is correctly
stored and retrieved. If not implemented correctly, users could submit
incomplete reports or be unable to view their previously submitted reports
and current statuses.

**How it's evolved:** still a core risk, but now concrete instead of vague,
now that the storage decision is Firebase:

- Ensuring photos picked via `image_picker` upload reliably to Firebase
  Storage and return valid network URLs.
- Making sure `geolocator` GPS coordinates attach cleanly to the Firestore
  document.
- Ensuring that when an authority updates a report's status in Firestore,
  active `StreamBuilder` listeners immediately reflect that change on the
  citizen's UI without a manual refresh.

**New risk — role authorization & pre-seeded account synchronization:**
restoring report-status tracking and a two-role workflow introduces security
and state risks. If Firestore rules or state checks are misconfigured, a
citizen could accidentally modify a report's status, or an authority might be
unable to write updates to another user's submitted report.

**First step to reduce each, and when:**
- Image & GPS cloud upload risk — write a standalone test script that picks
  an image, fetches current GPS coordinates, uploads the image to Firebase
  Storage, writes the document to Firestore, and renders the result back in
  an `Image.network` widget, **by September 21, 2026**.
- Role authorization risk — write basic Firestore security rules enforcing
  read/write permissions per role, and test role switching and real-time
  state updates across the 3 seeded accounts on separate devices/simulators,
  **by September 23, 2026**.

## Changes since the last version

Re-evaluating the preliminary proposal surfaced real logic holes: it had been
planned on a whim rather than by thinking through how a real app actually
works.

- **Login was missing entirely** in the prelim, even though an app can't
  attribute reports to a user or protect admin actions without
  authentication. Added as a core feature, streamlined with 3 pre-seeded
  accounts so testing doesn't need a full sign-up build.
- **The prelim never answered where reports go.** A citizen submitting a
  report into a void with no authority to see or resolve it defeats the
  purpose. Added the Authority Review Dashboard and Report Action screen to
  close that loop.
- **Fragmented MVP rows got consolidated** — "Submit Report" and "Location
  Capture" were two separate rows in the prelim; they're one feature now,
  since they're really one user action. Same for merging "Home Dashboard"
  and "Report History" into a single Citizen Dashboard, with report details
  as an in-place modal instead of a separate route.
- **The audience got sharper.** The prelim scored 6/8 on Purpose & Audience,
  with feedback that the audience stayed broad. This version anchors the
  problem to a real existing alternative (ParkSerye) and splits citizen
  reporters and authority reviewers into two explicit user types.
