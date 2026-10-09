# Lesson 2 · People vs sessions

**The question this lesson asks:** how many people used your app, and how many came back?

## 0. The class slides

Start with [the slides for this lesson](slides/02-people-vs-sessions/slides.html) (arrow keys to move). The
exercise below assumes you have been through them.

## 1. Load the practice data

You loaded this data in lesson 1, and it serves lesson 2 too: skip this step. Load it again
only if you have loaded another lesson's data since.

[the practice data](data/copy.html?f=lesson-02)

The practice data is a few weeks of visits to the photo app. It is generated, and it is
realistic on purpose: it has the same problems real data has. Some of them are traps.

Loading it again later replaces only the practice data (rows marked `is_synthetic`). Your
own test runs, and any real visits, are never touched.

## 2. Build: "Who used the app?"

Add a panel to [your dashboard's **lesson 2** board](dashboard/#unit-02) that shows:

| Number | What it should tell the reader |
| --- | --- |
| Visits | How many times the app was opened |
| Browsers | How many different browsers opened it |
| People | Your best estimate of how many humans that is |
| Came back | How many people, or what share, visited more than once |
| Visits per person | On average |

Under **every** number goes one sentence that says exactly what it counts:
*we count …, from …, excluding …, because …*

You decide the definitions, in your own words. Your AI assistant asks what each number should
count, asks about anything you left open (sometimes which column you mean: look it up), and
writes the sentence from what you said. It's yours to change any time.

Every number is a view in `analysis` with its definition as its comment, and **Is your
analysis tidy?** passes before you check your answers.

**In scope:** the numbers above, their definitions, and anything you need to check them.
**Not yet:** charts over time, funnels, heatmaps, segments. Those come in later lessons.

## 3. Check yourself

Open [**Lesson 2 · Questions**](checker/?lesson=lesson-02) and answer its questions **from your
dashboard**. A wrong answer says "not quite" and nothing else. When all are right, you're done
with the numbers.

Some questions ask about things your panel doesn't show. That's on purpose. **Now you lead:**
decide what your dashboard is missing, say what it should count, and ask your assistant to build
it. It goes on your board under **On your own**. Answer from the dashboard, never from a one-off
count.

If an answer won't come out right, don't guess. Follow one participant from the raw rows
to your dashboard and see where your count and theirs part ways.

## 4. The memo (half a page)

Write it at the end of [Lesson 2 · Questions](checker/?lesson=lesson-02). Your draft is saved as you type.
