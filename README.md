# Your study platform

What your team starts with: an app that records how people use it, a database, and a
dashboard that is almost empty. Over the course you grow the dashboard into something that
answers real questions — and that you can prove answers them correctly.

| Folder | What it is |
| --- | --- |
| `app/` | The app participants use (the course's photo app; you will add one feature to it mid-course) |
| `dashboard/` | Your dashboard. Starts with sign-in, a capture health check and the raw tables |
| `units/` | The lessons: what to build in each. `units/CURRENT` says which one you're on |
| `data/` | Practice datasets, one per lesson |
| `checker/` | Checks your answers for a lesson: `checker/?lesson=lesson-02` |
| `core/`, `setup.sql` | The capture code and the database setup. Do not edit |

## Setting up (once, about 10 minutes)

1. **Create a Supabase project** at supabase.com (the free plan is enough).
2. **Create the tables:** in Supabase, *SQL Editor → New query*, paste all of `setup.sql`, *Run*.
   The result shows four tables with 0 rows.
3. **Create your sign-in:** *Authentication → Users → Add user*, with an email and password.
4. **Connect the app and dashboard:** put your project's URL and publishable key into
   `supabase-config.js` (*Project Settings → API* and *API Keys*).
5. **Publish:** turn on GitHub Pages for this repository (*Settings → Pages*, branch `main`).
6. **Check capture:** open `dashboard/`, sign in, press *Run the check*. It must say
   "Capture works". If it doesn't, nothing you build will have data.

## Links to share

- With participants: `app/` (add `?src=whatsapp` or similar to know where visits came from).
- For your own test runs: `app/?test=1` — recorded, but marked as tests.
