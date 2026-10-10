# Lesson 3 · Funnels and drop-off

**The question this lesson asks:** where do people give up on registration?

## 0. The class slides

Start with [the slides for this lesson](slides/03-funnels/slides.html) (arrow keys to move). The
walkthrough below assumes you have been through them.

## 1. Load the practice data

Copy the practice data with the button below and run it in Supabase. It replaces the previous
practice data; your own test runs and real visits stay.

[the practice data](data/copy.html?f=lesson-03)

## 2. Build: the start screen, and the registration funnel

> **Build it with your AI assistant.** In the Claude app (or [claude.ai/code](https://claude.ai/code)): **Code → + New**,
> check the chip above the message box says **Data-mindset**, and type: *"Let's start lesson 3"*.
> It walks you through everything below, one step at a time.

Every visit opens on the **start screen** (`start`), and goes one of three ways: **Log in**, for
people who already have an account; **Register**, the registration funnel; or neither. Registering
takes two screens: **email and password** (`register_email`), then **username** (`register_username`),
whose **Sign up** button leads into the app (`discover`).

Build these on [your dashboard's **lesson 3** board](dashboard/#unit-03), **each in its own panel**:

| Panel | What it shows |
| --- | --- |
| The start screen | Visits, and how many chose Log in, chose Register, or left without choosing |
| The registration funnel | One row per step (chose Register · email and password done · username done, in the app): how many visits reached it, its **% of the step before**, and its **% of Register** |

**Already decided**, because the questions use these exact meanings:

1. **Count visits**, not clicks.
2. **The funnel starts at Register.** Visits that chose Log in aren't registering, so they're not a
   loss. They show only on the start screen panel.
3. **A visit reached a step when it pressed that step's button:**

| Step | The visit pressed… |
| --- | --- |
| Chose Register | **Register**, on the start screen |
| Email and password done | **Next**, on the email and password screen |
| Username done (in the app) | **Sign up**, on the username screen |

Every button press is a row in `selections`.

**Yours to decide:** which visits count at all, and why. Your AI assistant asks what each number
should count, asks about anything you left open, and writes the sentence from what you said.

Every number is a view in `analysis` with its definition as its comment, and **Is your
analysis tidy?** passes before you check your answers.

**In scope:** the start screen, the registration funnel, and anything you need to check them.
**Not yet:** time on each screen, heatmaps, segments. Those come in later lessons.

## 3. Check yourself

Open [**Lesson 3 · Questions**](checker/?lesson=lesson-03) and answer its questions **from your
dashboard**. The first two are your two panels: use **Copy table** on the panel, then paste.

Some questions ask about things your panels don't show. That's on purpose. **Now you lead:**
decide what your dashboard is missing, say what it should count, and ask your assistant to build
it. It goes on your board under **On your own**. Answer from the dashboard, never from a one-off
count.

## 4. The memo (half a page)

Write it at the end of [Lesson 3 · Questions](checker/?lesson=lesson-03). Your draft is saved as you type.
