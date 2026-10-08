# Lesson 8 · Segmentation

**The question this lesson asks:** do some groups of visitors do better than others, and is
the difference real?

## 0. The class slides

Start with [the slides for this lesson](slides/08-segmentation/slides.html) (arrow keys to move). The
exercise below assumes you have been through them.

## 1. Load the practice data

Open [**the practice data**](data/copy.html?f=lesson-08), copy it with one click, and run it in
Supabase. The page says what the result must show.

This replaces the previous practice data. Your own test runs and real visits stay.

## 2. Build: segments, everywhere

The metric for this lesson is **activation**: a visit in which the person got into the app.
In the data, that is a visit with a choice (a row in `selections`) whose value is `discover`:
they logged in or signed up and reached the home screen.

Add to [your dashboard's **lesson 8** board](dashboard/#unit-08):

1. **Activation, overall:** how many visits, how many activated, the rate.
2. **A segment control** that splits visits by:
   - **device** (`platform`)
   - **source** (where the visit came from: `source`)
   - **new vs returning** (has this browser visited before?)
3. **Every number on the page follows the segment.** Nothing stays "all visits" by accident.
4. **Size next to every rate.** And a visible warning on any segment too small to trust.
   You decide what "too small" is, before you look at the results.

Before you build the control, look at what values `platform` and `source` actually take.

Every number is a view in `analysis` with its definition as its comment, and **Is your
analysis tidy?** passes before you check your answers.

**In scope:** activation, the three segment types, combining two of them, sizes and warnings.
**Not yet:** funnels by step, time on screen, heatmaps.

## 3. Check yourself

Open [**the lesson 8 checker**](checker/?lesson=lesson-08) and answer **from your dashboard**. One of the questions
compares mobile and desktop twice, in two different ways. If the two answers seem to
disagree, don't fix it: explain it in the memo.

## 4. The memo (half a page)

- How you defined each segment, and what you did with visits that fit none.
- Your minimum segment size, and why that number.
- One difference between segments that **disappeared or flipped** when you split by something else.
- One check you did that could have failed, and what it showed.
