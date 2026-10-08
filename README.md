# Your study platform

What you start with: an app that records how people use it, a database, and a
dashboard that is almost empty. Over the course you grow the dashboard into something that
answers real questions — and that you can prove answers them correctly.

Start at `index.html`: your home page, with the current lesson and every tool.

| Folder | What it is |
| --- | --- |
| `app/` | The app participants use (the course's photo app; you will add one feature to it mid-course) |
| `dashboard/` | Your dashboard. Starts with sign-in, a capture health check and the raw tables |
| `units/` | The lessons: what to build in each. `units/CURRENT` says which one you're on. Start with `database-map.html` |
| `analysis/` | Your views, one `.sql` file each: the record of every number you build |
| `data/` | Practice datasets, one per lesson |
| `checker/` | Checks your answers for a lesson: `checker/?lesson=lesson-01` |
| `core/`, `setup.sql` | The capture code and the database setup. Do not edit |

## Setting up (once, about 15 minutes)

You work in two places: **GitHub** holds your platform and publishes it as your site, and
**Supabase** holds your data. Your AI assistant works in the cloud, on your GitHub repository:
nothing needs installing on your computer.

**GitHub**
1. **Your repository** is the copy of this platform your lecturer gave you.
2. **Make it public:** *Settings → General → Danger zone → Change visibility → Public*. The free
   GitHub plan only publishes sites from public repositories. Your data is not in the repository;
   it stays in Supabase, which only lets the public add rows.
3. **Publish your site:** *Settings → Pages → Deploy from a branch → main, / (root) → Save*. After a
   minute it shows your site's address, `https://<your-name>.github.io/<repository>/`.

**Supabase**
4. **Create a project** at supabase.com (the free plan is enough).
5. **Create the tables:** open *SQL Editor → New query*, paste the setup (copy it in one click from
   your site: `data/copy.html?f=setup`), and press *Run*. The result shows four tables with 0 rows.
6. **Create your sign-in:** *Authentication → Users → Add user*, with an email and password.
7. **Let the dashboard read your views:** *Project Settings → Data API*, under *Exposed schemas*
   add `analysis`, and save.

**Your AI assistant**
8. **Start it in the cloud:** in the Claude app, open *Code*, press *+ New*, choose *Cloud* instead
   of *Local*, connect GitHub if asked, and pick your repository.
9. **Connect everything:** give it three things in one message: your site's address, your
   Supabase project URL (*Project Settings → API*) and your publishable key (*Project Settings →
   API Keys*, the one starting `sb_publishable_`). It puts them into `SITE` and
   `supabase-config.js` and publishes. Never give it, or anyone, the secret key.
10. **Check capture:** open your site, then *Dashboard → Checks → Is capture working?*. It must say
    "Capture works". If it doesn't, nothing you build will have data.

## Links to share

- With participants: `app/` (add `?src=whatsapp` or similar to know where visits came from).
- For your own test runs: `app/?test=1` — recorded, but marked as tests.
