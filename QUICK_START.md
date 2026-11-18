# 🚀 Quick Start Guide

## For Your HR Demo

### 1. Run Locally (Immediate)

```powershell
cd school-management-demo
.\start.ps1
```

Open http://localhost:3000

**Demo Credentials:**
- Parent: `PAR2024001` / `STU2024001`
- Staff: any email / `demo123`

### 2. Deploy to Production (30 minutes)

#### Step A: Push to GitHub

```powershell
# Create repo at github.com/new
# Then:
git remote add origin https://github.com/YOUR_USERNAME/school-management-system.git
git push -u origin main
```

#### Step B: Set Up Supabase

1. Create project at [supabase.com](https://supabase.com)
2. SQL Editor → Run `supabase/00-complete-setup.sql`
3. SQL Editor → Run `supabase/01-create-demo-accounts.sql`
4. Get URL and keys from Settings → API

#### Step C: Deploy to Vercel

1. Go to [vercel.com/new](https://vercel.com/new)
2. Import your GitHub repo
3. Add these environment variables:
   ```
   NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
   SUPABASE_SERVICE_ROLE_KEY=your-service-key
   ```
4. Click Deploy
5. Done! Your app is live 🎉

#### Step D: Update Supabase URLs

In Supabase → Authentication → URL Configuration:
- Site URL: `https://your-app.vercel.app`
- Redirect URLs: `https://your-app.vercel.app/**`

### 3. Test Production

**Email Login:**
- `parent1@demo.school` / `parent123`
- `teacher@demo.school` / `teacher123`

---

## File Overview

| File | Purpose |
|------|---------|
| `DEPLOYMENT_SUMMARY.md` | Complete feature list & architecture |
| `README.md` | Installation instructions |
| `SUPABASE_SETUP.md` | Database setup steps |
| `VERCEL_DEPLOYMENT.md` | Deployment details |
| `DEMO_GUIDE.md` | 10-minute presentation script |

## Troubleshooting

### "npm install fails"
```powershell
.\install-deps.ps1
```

### "Supabase tables don't exist"
- Run `00-complete-setup.sql` FIRST
- Then run `01-create-demo-accounts.sql`

### "Can't login"
- Check `.env.local` has correct Supabase credentials
- Restart dev server: Stop (Ctrl+C) and `npm run dev`

### "Fees not cleared error"
- This is correct for `parent2@demo.school`
- Use `parent1@demo.school` to see working report

---

**Need Help?** Check the full guides in the repo or ask in chat.
