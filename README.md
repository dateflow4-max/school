# School Management System Demo

A modern, mobile-first school management system with separate parent and staff portals.

## Features

### Parent Portal
- Secure two-code authentication (Parent Code + Student Code)
- View student report cards with grades and performance
- Track academic progress across terms
- View school messages (App, SMS, WhatsApp notifications)
- Fee clearance verification
- Responsive design for mobile and desktop

### Staff Portal
- School dashboard with key metrics
- Student directory with search
- Marks entry system with automatic grade calculation
- Send reports via Push/SMS/WhatsApp
- Responsive layout with sidebar (desktop) and tabs (mobile)

## Quick Start

### Option 1: Using the Start Script (Recommended)

1. Double-click `start.ps1` in the `school-management-demo` folder
2. Wait for dependencies to install (first time only)
3. The app will open at http://localhost:3000

### Option 2: Manual Installation

```powershell
cd school-management-demo

# Install dependencies
npm install --legacy-peer-deps

# Start development server
npm run dev
```

### If Installation Fails

Run the dedicated installation script:
```powershell
.\install-deps.ps1
```

Or try these steps:
1. Delete `node_modules` folder and `package-lock.json` if they exist
2. Run: `npm cache clean --force`
3. Run: `npm install --legacy-peer-deps`
4. Run: `npm run dev`

### 3. Demo Credentials

#### Email-Based Login (With Supabase)
**Parent Portal:**
- Email: `parent1@demo.school` | Password: `parent123` (Amina - Fees Cleared ✓)
- Email: `parent2@demo.school` | Password: `parent123` (David - Fees NOT Cleared ✗)

**Staff Portal:**
- Email: `teacher@demo.school` | Password: `teacher123`
- Email: `admin@demo.school` | Password: `admin123`

#### Code-Based Login (Demo Mode, No Database)
- **Parent Code:** `PAR2024001`
- **Student Code:** `STU2024001`

> **Note:** Email-based login requires Supabase setup. See `SUPABASE_SETUP.md` for instructions.

## Project Structure

\`\`\`
school-management-demo/
├── app/
│   ├── page.tsx                 # Landing page with portal selection
│   ├── parent/
│   │   └── page.tsx            # Parent login & dashboard
│   ├── faculty-access/
│   │   └── page.tsx            # Staff login & workspace
│   ├── layout.tsx              # Root layout
│   └── globals.css             # Global styles
├── components/
│   ├── ParentDashboard.tsx     # Parent portal UI
│   └── StaffDashboard.tsx      # Staff portal UI
├── lib/
│   └── demo-data.ts            # Demo data and authentication
└── README.md
\`\`\`

## Design Principles

This demo follows anti-AI-slop design principles:

- **Clean Color Palette:** White (#FFFFFF), Black (#0A0A0A), Gray (#F4F4F5), Emerald Green (#10B981)
- **Typography:** Inter font with tabular numbers for grades and percentages
- **No Generic Elements:** No purple gradients, no emoji, no cluttered dashboards
- **Responsive First:** Mobile-optimized with bottom nav (mobile) and top nav (desktop)
- **Academic Aesthetic:** Inspired by Harvard transcripts and modern fintech apps

## Key Features for Demo

### Parent Authentication Flow
1. Parent enters Parent Code and Student Code
2. System validates both codes match same student
3. System checks fee clearance status
4. If fees cleared: Show full report and performance data
5. If fees NOT cleared: Show blurred preview with payment info

### Staff Workspace
1. Dashboard with school statistics
2. Student search and directory
3. Marks entry with real-time grade calculation
4. Report distribution via multiple channels

## Technology Stack

- **Framework:** Next.js 15 (App Router)
- **Language:** TypeScript
- **Styling:** Tailwind CSS
- **Fonts:** Inter (Google Fonts)
- **Animations:** Framer Motion (optional)

## Build for Production

\`\`\`bash
npm run build
npm start
\`\`\`

## Deployment

This app can be deployed to:
- **Vercel** (recommended, zero-config)
- **Netlify**
- **Railway**
- **Any Node.js hosting**

### Deploy to Vercel

\`\`\`bash
npm install -g vercel
vercel
\`\`\`

## Next Steps (Post-Demo)

1. **Database Integration:** Replace demo data with Supabase
2. **Authentication:** Implement proper auth with session management
3. **Fee Payment:** Integrate SchoolPay or M-Pesa API
4. **Notifications:** Add Africa's Talking for SMS/WhatsApp
5. **AI Document Parser:** Add Gemini API for marks sheet scanning
6. **PWA:** Convert to Progressive Web App for offline access

## Support

For questions or issues, contact your development team.

---

**Built for school management demonstration purposes.**
