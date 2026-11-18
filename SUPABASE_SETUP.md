# Supabase Setup Guide

## Step 1: Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign in or create an account
3. Click "New Project"
4. Fill in:
   - **Name:** School Management Demo
   - **Database Password:** (choose a strong password and save it)
   - **Region:** Choose closest to Kenya (e.g., Singapore or Frankfurt)
5. Click "Create new project" and wait 2-3 minutes

## Step 2: Get Your API Keys

1. In your Supabase project, go to **Settings** → **API**
2. Copy these values:
   - **Project URL** (starts with `https://...supabase.co`)
   - **anon public key** (starts with `eyJ...`)
   - **service_role key** (starts with `eyJ...`) - Keep this SECRET!

## Step 3: Configure Environment Variables

1. Open the file `.env.local` in the `school-management-demo` folder
2. Replace the placeholder values:

```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

3. Save the file

## Step 4: Run Database Schema

**IMPORTANT: Run these in ORDER!**

### Script 1: Complete Setup (Tables, Policies, Demo Data)

1. In Supabase, go to **SQL Editor** (left sidebar)
2. Click "New query"
3. Copy the **ENTIRE** contents of `supabase/00-complete-setup.sql`
4. Paste it into the SQL editor
5. Click "Run" (or press Ctrl+Enter)
6. Wait for "Success" message

### Script 2: Create Demo Accounts

1. Still in **SQL Editor**, click "New query"  
2. Copy the **ENTIRE** contents of `supabase/01-create-demo-accounts.sql`
3. Paste it into the SQL editor
4. Click "Run"
5. You should see a table with demo account credentials

**That's it!** The database is now fully set up with demo accounts.

## Step 5: Verify Setup

1. Go to **Authentication** → **Users** in Supabase
2. You should see 5 users:
   - parent1@demo.school
   - parent2@demo.school
   - parent3@demo.school
   - teacher@demo.school
   - admin@demo.school

3. Go to **Table Editor** → **students**
4. You should see 3 students:
   - Amina Wanjiru (STU2024001)
   - David Omondi (STU2024002)
   - Grace Achieng (STU2024003)

## Step 6: Test Locally

1. Open PowerShell in the `school-management-demo` folder
2. Run:
   ```powershell
   npm install
   npm run dev
   ```
3. Open [http://localhost:3000](http://localhost:3000)

## Demo Credentials

### Parent Accounts (Email-based login)
- **Email:** `parent1@demo.school` | **Password:** `parent123` → Links to Amina (Fees Cleared ✓)
- **Email:** `parent2@demo.school` | **Password:** `parent123` → Links to David (Fees NOT Cleared ✗)
- **Email:** `parent3@demo.school` | **Password:** `parent123` → Links to Grace (Fees Cleared ✓)

### Staff Accounts
- **Teacher:** `teacher@demo.school` | **Password:** `teacher123`
- **Admin:** `admin@demo.school` | **Password:** `admin123`

### Legacy Code-based Login (Backup)
- **Parent Code:** `PAR2024001` | **Student Code:** `STU2024001`

## Troubleshooting

### "Invalid API key" error
- Double-check your `.env.local` file
- Make sure there are no extra spaces
- Restart the dev server: Stop (Ctrl+C) and run `npm run dev` again

### "Row Level Security policy violation"
- Make sure you ran the `schema.sql` completely
- Check that the policies were created in **Database** → **Policies**

### No students showing up
- Make sure you ran `create-demo-accounts.sql`
- Check that parent-student links exist in **Table Editor** → **parent_student_links**

### Fees not cleared message
- This is correct for parent2@demo.school (David Omondi)
- Use parent1@demo.school to see a working report card

## What's Next?

Once everything works locally:
1. Push to GitHub
2. Deploy to Vercel
3. Add environment variables in Vercel dashboard
4. Test the live deployment

---

**Need help?** Check the error messages in:
- Browser console (F12 → Console)
- Terminal where `npm run dev` is running
