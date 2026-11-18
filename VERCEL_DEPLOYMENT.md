# Deploy to Vercel

## Prerequisites

- GitHub account
- Vercel account (sign up at [vercel.com](https://vercel.com))
- Supabase project set up (see `SUPABASE_SETUP.md`)

## Step 1: Push to GitHub

1. Open PowerShell in the `school-management-demo` folder
2. Initialize Git repository:

```powershell
git init
git add .
git commit -m "Initial commit: School Management System"
```

3. Create a new repository on GitHub:
   - Go to [github.com/new](https://github.com/new)
   - Name: `school-management-system`
   - **Do NOT** initialize with README (we already have one)
   - Click "Create repository"

4. Push your code:

```powershell
git remote add origin https://github.com/YOUR_USERNAME/school-management-system.git
git branch -M main
git push -u origin main
```

## Step 2: Deploy to Vercel

### Option A: Using Vercel Dashboard (Easiest)

1. Go to [vercel.com/new](https://vercel.com/new)
2. Click "Import Git Repository"
3. Select your `school-management-system` repository
4. Configure project:
   - **Framework Preset:** Next.js
   - **Root Directory:** `./`
   - **Build Command:** `next build`
   - **Output Directory:** `.next`

5. Add Environment Variables (click "Environment Variables"):
   ```
   NEXT_PUBLIC_SUPABASE_URL = https://your-project.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   SUPABASE_SERVICE_ROLE_KEY = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

6. Click "Deploy"
7. Wait 2-3 minutes
8. Your app is live! 🎉

### Option B: Using Vercel CLI

```powershell
# Install Vercel CLI
npm install -g vercel

# Login to Vercel
vercel login

# Deploy
vercel

# Follow the prompts:
# - Set up and deploy? Yes
# - Which scope? Your account
# - Link to existing project? No
# - Project name? school-management-system
# - Directory? ./
# - Override settings? No

# Add environment variables
vercel env add NEXT_PUBLIC_SUPABASE_URL
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY
vercel env add SUPABASE_SERVICE_ROLE_KEY

# Deploy to production
vercel --prod
```

## Step 3: Configure Supabase for Production

1. Go to your Supabase project → **Authentication** → **URL Configuration**
2. Add your Vercel domain to **Site URL:**
   ```
   https://your-app.vercel.app
   ```

3. Add to **Redirect URLs:**
   ```
   https://your-app.vercel.app/**
   ```

4. Click "Save"

## Step 4: Test Your Deployment

1. Visit your Vercel URL: `https://your-app.vercel.app`
2. Try logging in with:
   - **Parent:** parent1@demo.school / parent123
   - **Staff:** teacher@demo.school / teacher123

## Updating Your Deployment

Every time you push to GitHub, Vercel automatically deploys:

```powershell
git add .
git commit -m "Update: description of changes"
git push
```

Vercel will build and deploy automatically in 1-2 minutes.

## Custom Domain (Optional)

1. Go to your project in Vercel Dashboard
2. Click "Settings" → "Domains"
3. Add your domain (e.g., `schoolmanagement.example.com`)
4. Follow DNS configuration instructions
5. Update Supabase redirect URLs with your custom domain

## Troubleshooting

### Build Fails: "Missing environment variables"
- Add all three environment variables in Vercel dashboard
- Make sure there are no extra spaces in the values

### "Invalid API key" after deployment
- Check that environment variables are correct
- Make sure you're using the **public** anon key, not the service role key for NEXT_PUBLIC_SUPABASE_ANON_KEY

### Authentication not working
- Verify redirect URLs in Supabase include your Vercel domain
- Check browser console (F12) for errors

### Changes not showing up
- Vercel only auto-deploys when you push to GitHub
- Check deployment status at `https://vercel.com/your-username/school-management-system`

## Environment Variables Reference

| Variable | Where to Find | Used For |
|----------|---------------|----------|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase → Settings → API | Public database URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase → Settings → API | Public API access |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase → Settings → API | Server-side operations (Keep secret!) |

---

**Your app is now live and accessible worldwide! 🌍**
