# Lesson 2 · People vs sessions

**The question this lesson asks:** how many people used your app, and how many came back?

## 1. Load the practice data

1. In Supabase, open **SQL Editor → New query**.
2. Paste the whole of `data/lesson-02.sql` and press **Run**.
3. The last rows of the result show how many sessions, clicks, selections and identities were loaded.

The practice data is a few weeks of visits to the photo app. It is generated, and it is
realistic on purpose: it has the same problems real data has. Some of them are traps.

Loading it again later replaces only the practice data (rows marked `is_synthetic`). Your
own test runs, and any real visits, are never touched.

## 2. Build: "Who used the app?"

Add a panel to your dashboard that shows:

| Number | What it should tell the reader |
| --- | --- |
| Visits | How many times the app was opened |
| Browsers | How many different browsers opened it |
| People | Your best estimate of how many humans that is |
| Came back | How many people, or what share, visited more than once |
| Visits per person | On average |

Under **every** number, write one sentence:
*We count ___, from ___, excluding ___, because ___.*

You decide the definitions. Your AI assistant will ask you for them; that's on purpose.

**In scope:** the numbers above, their definitions, and anything you need to check them.
**Not yet:** charts over time, funnels, heatmaps, segments. Those come in later lessons.

## 3. Check yourself

Open **`checker/?lesson=lesson-02`** on your site and answer its questions **from your
dashboard**. A wrong answer says "not quite" and nothing else. When all are right, you're done
with the numbers.

If an answer won't come out right, don't guess. Follow one participant from the raw rows
to your dashboard and see where your count and theirs part ways.

## 4. The memo (half a page)

- How you defined **people**, and why that definition.
- What you left out of every number, and why.
- One check you did that **could have failed**, and what it showed.
- One thing in the data that surprised you.
