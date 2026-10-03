# Mockup and wireframes

## Mockup
### 1. Login Screen
<img width="390" height="882" alt="Login" src="https://github.com/user-attachments/assets/9f4b7739-00c9-4472-9492-77b2bf571d2e" />

**What the user does here:** Selects or enters their seeded account credentials (for Citizen 1, Citizen 2, or Authority 1) and authenticates into the application.

**Where each tappable thing goes:**

- **Username / Password Inputs:** Tapping activates text input for credential entry.
- **Password Visibility Toggle (Eye Icon):** Toggles password masking/unmasking.
- **Login → Button:** Authenticates the user via Firebase Auth and routes them to either the Citizen Home Dashboard or the Authority Review Dashboard depending on their assigned role.

---

### 2. Citizen Home Dashboard & History Screen (with Modal Report Details)

<img width="406" height="923" alt="Home Dashboard" src="https://github.com/user-attachments/assets/525d0788-46f4-460f-9b4c-565a2db10840" />
<img width="406" height="923" alt="Report Details Overlay" src="https://github.com/user-attachments/assets/96e33ab8-3b05-4733-a83f-8909967a9209" />

**What the user does here:** Views their overall report metrics, browses their submitted parking violation reports, opens detailed report evidence via a centered modal dialog, or initiates a new report submission.

**Where each tappable thing goes:**

- **Submit New Report Button:** Navigates directly to the Submit Report screen.
- **Report Cards in List:** Tapping any individual report card (e.g., "Double parking on main...") triggers `showDialog()`, opening the Report Details Modal Overlay directly over a darkened, blurred backdrop of the dashboard.
- **Close Details Button / 'X' Icon (on Modal Overlay):** Closes the modal dialog and returns focus to the active Citizen Home Dashboard.

---

### 3. Submit Report
<img width="406" height="1005" alt="Submit Report" src="https://github.com/user-attachments/assets/66d67679-0608-4524-ac25-e9b127b04e29" />

**What the user does here:** Captures or uploads photo evidence of an illegally parked vehicle, auto-detects or manually types the location, adds a violation description, and submits the incident.

**Where each tappable thing goes:**

- **Photo Upload Area (Take a photo or choose from gallery):** Opens device gallery or camera via `image_picker`.
- **Auto-detect Location Button:** Triggers `geolocator` to fetch current GPS coordinates.
- **Location Text Box:** Allows manual text entry fallback if GPS is unavailable.
- **Submit Report > Button:** Uploads photo to Firebase Storage, saves report document to Cloud Firestore, and redirects back to the Home Dashboard.
- **Back Arrow (Top Left):** Cancels submission and returns to the Citizen Home Dashboard.

---

### 4. Authority Review Dashboard

<img width="406" height="1056" alt="Authority Review Dashboard" src="https://github.com/user-attachments/assets/9398a7e8-5393-4979-9b1b-460c145ca9a2" />

**What the user does here:** Local enforcement officers monitor all incoming city-wide parking reports in real time, view jurisdiction metrics, and filter reports by resolution status.

**Where each tappable thing goes:**

- **Status Filter Segmented Bar (\[ All \| Pending \| Resolved \| Rejected \]):** Filters the incoming Firestore report stream dynamically by selected status.
- **Incoming Report Cards:** Tapping any report card opens the Authority Report Action & Resolution Screen for detailed inspection.
- **Officer Profile Avatar (Top Right):** Displays officer credentials and logout option.

---

### 5. Authority Report Action & Resolution Screen

 <img width="422" height="1167" alt="Report Action   Resolution - Authority View" src="https://github.com/user-attachments/assets/9b393df1-cb25-4b56-a711-cc3d5fa8382e" />

**What the user does here:** Enforcement officers inspect full-resolution photo evidence, review exact GPS map coordinates, write official resolution notes, and update the report status.

**Where each tappable thing goes:**

- **Back Arrow (Top Left):** Returns to the Authority Review Dashboard.
- **Interactive Status Segmented Control (\[ Pending \| Resolved \| Rejected \]):** Selects the new status state to apply to the report.
- **Authority Notes Text Field:** Allows typing official comments or action details (e.g., "Towing unit dispatched").
- **UPDATE & SAVE STATUS Button:** Writes status updates and notes to Cloud Firestore in real time, updating the citizen's view immediately.

---

## Screen Prototype 

### Citizen Screens

<img width="1130" height="614" alt="image" src="https://github.com/user-attachments/assets/3a53bd41-a916-4779-a207-98c7dd552b92" />


### Authority Screens

<img width="729" height="600" alt="image" src="https://github.com/user-attachments/assets/92918c8b-a895-405a-b6c7-fd2c6dc45c9b" />

---

## Wireframes

## 1. Login

> **[PASTE IMAGE HERE: Figure 3. Mobile Login Screen]**
> Replace this block with: `![Figure 3. Mobile Login Screen](path/to/login-mobile.png)`


| Screen | Layout Notes | Inputs | Actions → Destination | Data Shown |
|--------|--------------|--------|-----------------------|------------|
| Login | Displays the AGOS logo at the top, followed by email and password input fields, and a Sign In button at the bottom. | Email, Password | Sign In → Home Dashboard | User credentials |

---

## Home Dashboard

> **[PASTE IMAGE HERE: Figure 5. Mobile Home Dashboard Screen]**
> Replace this block with: `![Figure 5. Mobile Home Dashboard Screen](path/to/home-mobile.png)`


| Screen | Layout Notes | Inputs | Actions → Destination | Data Shown |
|--------|--------------|--------|-----------------------|------------|
| Home Dashboard | Displays the app header, New Report and History buttons, and a Recent Reports section showing previously submitted reports. | None | New Report → SubmitReport<br>History → Report History<br>Tap Recent Report → Report Details | User information, Recent Reports |

---

## Submit Report

> **[PASTE IMAGE HERE: Figure 7. Mobile Submit Report Screen]**
> Replace this block with: `![Figure 7. Mobile Submit Report Screen](path/to/submit-report-mobile.png)`



| Screen | Layout Notes | Inputs | Actions → Destination | Data Shown |
|--------|--------------|--------|-----------------------|------------|
| Submit Report | Contains buttons to Upload Photo and Select Location, a text area for the report description, and a Submit button. | Photo upload, GPS location, Report description | Upload Photo → Opens device gallery/camera<br>Select Location → Opens location picker or GPS<br>Submit → Report Details | Report information (photo, location, description) |

---

## Report History

> **[PASTE IMAGE HERE: Figure 9. Mobile Report History Screen]**
> Replace this block with: `![Figure 9. Mobile Report History Screen](path/to/report-history-mobile.png)`



| Screen | Layout Notes | Inputs | Actions → Destination | Data Shown |
|--------|--------------|--------|-----------------------|------------|
| Report History | Displays a list of all reports previously submitted by the user along with their current status (e.g., Pending, Resolved). | None | Tap Report → Report Details<br>Back → Home Dashboard | List of Reports, Report Status |

---

## Report Details

> **[PASTE IMAGE HERE: Figure 11. Mobile Report Details Screen]**
> Replace this block with: `![Figure 11. Mobile Report Details Screen](path/to/report-details-mobile.png)`



| Screen | Layout Notes | Inputs | Actions → Destination | Data Shown |
|--------|--------------|--------|-----------------------|------------|
| Report Details | Displays the selected report, including the uploaded photo and description of the incident. | None | Back → Home Dashboard or Report History | Report Photo, Description, Location, Date Submitted, Report Status |



