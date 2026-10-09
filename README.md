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
| `data/` | The copy page for the setup. Practice data is made for your team by the course, with its own answers |
| `checker/` | Checks your answers for a lesson: `checker/?lesson=lesson-01` |
| `core/`, `setup.sql` | The capture code and the database setup. Do not edit |

## Setting up (once, about 20 minutes)

Follow the step-by-step guide on your site: `units/setup.html` (the **One-time setup** link on your
home page). In short: fork this repository, publish it with GitHub Pages, create a Supabase
project, and start your assistant in a Claude cloud session.

## Links to share

- With participants: `app/` (add `?src=whatsapp` or similar to know where visits came from).
- For your own test runs: `app/?test=1` — recorded, but marked as tests.
