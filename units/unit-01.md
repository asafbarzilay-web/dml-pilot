# Lesson 1 · The data you start with

**The question this lesson asks:** what exactly does the app record, and can you follow one
visit through it?

Before any number, you need to know the raw rows by heart. Every number you build later is
made of them; if you misread them now, every later number inherits the mistake and nothing
will warn you.

## 0. The class slides

Start with [the slides for this lesson](slides/01-the-data-you-start-with/slides.html) (arrow keys to move). The
exercise below assumes you have been through them.

## 1. Load the practice data

1. In Supabase, open **SQL Editor → New query**.
2. Paste the whole of `data/lesson-02.sql` and press **Run**. (The same practice data serves
   lessons 1 and 2.)
3. The last rows of the result show how many sessions, clicks, selections and identities were loaded.

## 2. Read the map

Open **The database on one page** from your home page (`units/database-map.html`). Then draw the
four tables and how they connect on paper, in your own words, and compare your drawing with the map.

## 3. Watch yourself being recorded

1. On your dashboard, press **Is capture working? → Run the check**. It must say "Capture works".
2. Open your app with `?test=1` at the end of the link and use it for a minute: open a photo,
   visit a profile, start signing up.
3. Find your visit in the dashboard's raw `sessions` table, then your taps in `clicks`.
   Does what you see match what you did?

## 4. Build: "Replay a visit"

Add a panel to your dashboard's **lesson 1** board: paste a `session_id`, and it shows that visit as one timeline,
oldest first: every click, choice and sign-in, with the time, the screen and what happened.

This is your first view. First run `analysis/example_taps_per_screen.sql` in Supabase and see its
panel appear on the dashboard: that is the whole pattern. Then build yours the same way:
- the timeline is a **view** in the `analysis` schema, with its SQL in `analysis/` and a
  one-sentence definition as its comment (your AI assistant knows the rules);
- the dashboard only displays it;
- **Is your analysis tidy?** passes.

You will use this panel in every lesson after this one: it is how you check a number, by
following one participant from the raw rows to the dashboard.

**In scope:** the replay panel and its view. **Not yet:** any counting. That starts in lesson 2.

## 5. Check yourself

Open **`checker/?lesson=lesson-01`** and answer its questions. Use your replay panel for the
questions about one visit.

## 6. The memo (half a page)

- The four tables in your own words: what one row of each is.
- Your own test visit: one thing the data recorded that you did not expect, or one thing you
  did that it did not record.
- How you checked that your replay panel is right.
