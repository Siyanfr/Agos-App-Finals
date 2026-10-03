## Screens with Label (Step A, B, C)

### Login Screen
<img width="390" height="882" alt="Login" src="https://github.com/user-attachments/assets/9f4b7739-00c9-4472-9492-77b2bf571d2e" />

**What the user does here:** Selects or enters their seeded account credentials (for Citizen 1, Citizen 2, or Authority 1) and authenticates into the application.

**Where each tappable thing goes:**

- **Username / Password Inputs:** Tapping activates text input for credential entry.
- **Password Visibility Toggle (Eye Icon):** Toggles password masking/unmasking.
- **Login → Button:** Authenticates the user via Firebase Auth and routes them to either the Citizen Home Dashboard or the Authority Review Dashboard depending on their assigned role.

---

### Citizen Home Dashboard & History Screen (with Modal Report Details)

<img width="406" height="923" alt="Home Dashboard" src="https://github.com/user-attachments/assets/525d0788-46f4-460f-9b4c-565a2db10840" />
<img width="406" height="923" alt="Report Details Overlay" src="https://github.com/user-attachments/assets/96e33ab8-3b05-4733-a83f-8909967a9209" />

**What the user does here:** Views their overall report metrics, browses their submitted parking violation reports, opens detailed report evidence via a centered modal dialog, or initiates a new report submission.

**Where each tappable thing goes:**

- **Submit New Report Button:** Navigates directly to the Submit Report screen.
- **Report Cards in List:** Tapping any individual report card (e.g., "Double parking on main...") triggers `showDialog()`, opening the Report Details Modal Overlay directly over a darkened, blurred backdrop of the dashboard.
- **Close Details Button / 'X' Icon (on Modal Overlay):** Closes the modal dialog and returns focus to the active Citizen Home Dashboard.

---

### Submit Report
<img width="406" height="1005" alt="Submit Report" src="https://github.com/user-attachments/assets/66d67679-0608-4524-ac25-e9b127b04e29" />

**What the user does here:** Captures or uploads photo evidence of an illegally parked vehicle, auto-detects or manually types the location, adds a violation description, and submits the incident.

**Where each tappable thing goes:**

- **Photo Upload Area (Take a photo or choose from gallery):** Opens device gallery or camera via `image_picker`.
- **Auto-detect Location Button:** Triggers `geolocator` to fetch current GPS coordinates.
- **Location Text Box:** Allows manual text entry fallback if GPS is unavailable.
- **Submit Report > Button:** Uploads photo to Firebase Storage, saves report document to Cloud Firestore, and redirects back to the Home Dashboard.
- **Back Arrow (Top Left):** Cancels submission and returns to the Citizen Home Dashboard.

---

### Authority Review Dashboard

<img width="406" height="1056" alt="Authority Review Dashboard" src="https://github.com/user-attachments/assets/9398a7e8-5393-4979-9b1b-460c145ca9a2" />

**What the user does here:** Local enforcement officers monitor all incoming city-wide parking reports in real time, view jurisdiction metrics, and filter reports by resolution status.

**Where each tappable thing goes:**

- **Status Filter Segmented Bar (\[ All \| Pending \| Resolved \| Rejected \]):** Filters the incoming Firestore report stream dynamically by selected status.
- **Incoming Report Cards:** Tapping any report card opens the Authority Report Action & Resolution Screen for detailed inspection.
- **Officer Profile Avatar (Top Right):** Displays officer credentials and logout option.

---

### Authority Report Action & Resolution Screen

 <img width="422" height="1167" alt="Report Action   Resolution - Authority View" src="https://github.com/user-attachments/assets/9b393df1-cb25-4b56-a711-cc3d5fa8382e" />

**What the user does here:** Enforcement officers inspect full-resolution photo evidence, review exact GPS map coordinates, write official resolution notes, and update the report status.

**Where each tappable thing goes:**

- **Back Arrow (Top Left):** Returns to the Authority Review Dashboard.
- **Interactive Status Segmented Control (\[ Pending \| Resolved \| Rejected \]):** Selects the new status state to apply to the report.
- **Authority Notes Text Field:** Allows typing official comments or action details (e.g., "Towing unit dispatched").
- **UPDATE & SAVE STATUS Button:** Writes status updates and notes to Cloud Firestore in real time, updating the citizen's view immediately.

---

## Screen Prototype (Step D)

### Citizen Screens

<img width="1130" height="614" alt="image" src="https://github.com/user-attachments/assets/3a53bd41-a916-4779-a207-98c7dd552b92" />


### Authority Screens

<img width="729" height="600" alt="image" src="https://github.com/user-attachments/assets/92918c8b-a895-405a-b6c7-fd2c6dc45c9b" />

---

## What changed, and why

| Element | Prelim said | Now Says | Why it Changed |
|---------|-------------|----------|----------------|
| Screen Architecture & Navigation Flow | 5 separate full-page routes: Login, Home Dashboard, Submit Report, Report History, and Report Details. | 5 Primary Screens + 1 In-Place Modal Overlay: Bypasses separate Report History page by merging it into Citizen Home Dashboard, converts Report Details into a centered modal overlay (`showDialog`), and adds 2 dedicated Authority screens. | In wireframes, having separate pages for History and Details created unnecessary route depth and back-stack overhead. Merging History into the main dashboard simplifies citizen navigation. Converting Details into a modal dialog over a dimmed/blurred backdrop preserves visual context. Adding the Authority Review Dashboard and Action Screen fixes the critical logic gap in the prelim wireframe where citizen reports had no authority side to review or resolve them. |
| Bottom Navigation Bar | Wireframes included a 4-icon bottom navigation bar (Home, Reports, Alerts, Settings) on dashboard screens. | No Bottom Navigation Bar. Screens use top app bars and direct contextual primary action buttons instead. | During mockup visual painting, the bottom navigation bar proved redundant because the entire citizen workflow lives cleanly between the Home Dashboard and Submit Report screens. Removing it freed up significant vertical screen space, allowing report list cards to extend cleanly down the viewport without clutter. |
| User Roles & Account Routing | Wireframe assumed a single generic citizen user logging in with email/password and a static "Under Review" status. | Role-based system using 3 Pre-Seeded Accounts (Citizen 1, Citizen 2, Authority 1) with 3 explicit report statuses: Pending, Resolved, and Rejected. | The prelim wireframe lacked role distinction and included an ambiguous "Under Review" state. To make the app realistic for demo testing without building complex sign-up screens, pre-seeded accounts route users directly to their respective portals. Standardizing statuses to Pending, Resolved, and Rejected streamlines enforcement decision-making on the Authority Action screen. |<img width="390" height="882" alt="Login" src="https://github.com/user-attachments/assets/efdd561d-5e27-43b1-b665-6d17d0c6b080" />
