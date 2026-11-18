# School Management Demo - Presentation Guide

## 10-Minute Demo Script

### Introduction (1 minute)

"Good morning. I'm presenting our School Management System—a mobile-first platform that helps schools track academic performance and communicate directly with parents."

### 1. Landing Page (30 seconds)

- Open http://localhost:3000
- Show the two portals: Parent Portal and Staff Portal
- Explain: "Parents and staff have completely separate interfaces. Parents never see admin functions."

### 2. Parent Portal Demo (3 minutes)

**Click "Parent Portal"**

**Step 1: Authentication**
- Enter Parent Code: `PAR2024001`
- Enter Student Code: `STU2024001`
- Click "Access Report"

**Explain:** "Parents must verify both codes. This ensures only authorized parents see their child's information."

**Step 2: Overview Tab**
- Show Amina Wanjiru's performance:
  - Overall Average: 78.5%
  - Class Position: 3/45
  - Attendance: 58/60 days
- Scroll through subject performance
- Point out the +/- indicators showing improvement/decline

**Step 3: Messages Tab**
- Click "Messages"
- Show different notification types (App, SMS, WhatsApp)
- Explain: "Parents receive notifications through multiple channels."

**Step 4: Full Report Tab**
- Click "Report"
- Show complete report card with all subjects
- Point out teacher remarks and principal remarks
- Explain: "This can be printed or downloaded as PDF."

**Step 5: Fee Verification (Optional)**
- Click browser back to logout
- Login with: `PAR2024002` and `STU2024002`
- Show: "Fee balance must be cleared to access reports"
- Explain: "System automatically blocks access until fees are paid."

### 3. Staff Portal Demo (4 minutes)

**Return to home, click "Staff Portal"**

**Step 1: Login**
- Enter any email (e.g., `teacher@school.ac.ke`)
- Password: `demo123`
- Click "Sign In"

**Desktop View:**

**Dashboard Tab**
- Show school statistics:
  - Total Students: 342
  - Total Teachers: 28
  - Classes: 12
  - Attendance: 94%
- Show recent admissions list

**Students Tab**
- Click "Students"
- Use search: type "Amina"
- Show student details with fee status
- Point out color coding (green = fees cleared, red = balance)

**Marks Entry Tab**
- Click "Marks Entry"
- Show class and subject dropdowns
- Explain: "Teachers can enter marks for entire classes at once"
- Change a mark (e.g., change Amina's mark from 85 to 90)
- Show how grade updates automatically
- Click "Save Marks"

**Send Reports Tab**
- Click "Send Reports"
- Show the three methods: App Push, SMS, WhatsApp
- Select different recipient groups
- Show message template
- Explain: "One click sends reports to all parents via their preferred channel"

### 4. Mobile Responsiveness Demo (1 minute)

**Resize browser window to mobile size (or use browser dev tools)**

- Show parent portal with bottom navigation
- Show staff portal with scrolling tabs
- Explain: "Everything works seamlessly on phones, which most parents in Kenya use."

### 5. Technical Highlights (30 seconds)

"This is built with:
- Next.js for speed and reliability
- Tailwind CSS for clean, modern design
- TypeScript for code safety
- Ready to integrate with SchoolPay, M-Pesa, and WhatsApp Business API"

### 6. Closing & Questions (1 minute)

**Summary:**
"This demo shows three core features:
1. Parents can securely view their child's academic progress
2. Staff can efficiently manage marks and communicate with parents
3. Everything works on both mobile and desktop

The next phase will add:
- Real database with Supabase
- Live fee payment integration
- AI-powered marks sheet scanning
- SMS and WhatsApp automation"

**Open for questions.**

---

## Troubleshooting

### If the app doesn't start:
1. Check Node.js is installed: `node --version`
2. Install dependencies: `npm install`
3. Start dev server: `npm run dev`

### If login doesn't work:
- Parent credentials: `PAR2024001` / `STU2024001`
- Staff credentials: any email / `demo123`

### If styling looks broken:
- Clear browser cache
- Restart the dev server
- Check that Tailwind CSS compiled correctly

---

## Demo Data Reference

### Students
1. **Amina Wanjiru** - PAR2024001 / STU2024001 (Fees Cleared ✓)
2. **David Omondi** - PAR2024002 / STU2024002 (Fees NOT cleared ✗)
3. **Grace Achieng** - PAR2024003 / STU2024003 (Fees Cleared ✓)

### School Statistics
- Total Students: 342
- Total Teachers: 28
- Classes: 12
- Overall Attendance: 94%

### Amina's Term 2 Performance
- Overall Average: 78.5%
- Class Position: 3/45
- Attendance: 58/60 days
- Best Subject: Mathematics (85%)
- Improved: Mathematics (+7), Chemistry (+5)
- Declined: Biology (-2), Physics (-2)

---

**Preparation Checklist:**

- [ ] App running on http://localhost:3000
- [ ] Browser window sized appropriately
- [ ] Demo credentials memorized
- [ ] Backup browser tab ready
- [ ] Questions anticipated
- [ ] Next steps clearly defined
