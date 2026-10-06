# The database, on one page

Four tables. The app adds rows to them; nothing ever changes or deletes a row.

```
                       sessions                  one row per VISIT
                       ─────────
                       session_id   ◄──────────────┬─────────────────┬──────────────────┐
                       user_id      a BROWSER      │                 │                  │
                       app          which app      │                 │                  │
                       platform     mobile/desktop │                 │                  │
                       browser                     │                 │                  │
                       source       ?src= link     │                 │                  │
                       screen_w                    │                 │                  │
                       is_test      your own runs  │                 │                  │
                       is_synthetic practice data  │                 │                  │
                       started_at                  │                 │                  │
                                                   │                 │                  │
              clicks   every TAP          selections  every CHOICE   identities  every SIGN-IN
              ──────                      ──────────                 ──────────
              session_id                  session_id                 session_id
              step      the screen        step        the screen     account   a scrambled
              overlay   layer on top      value       what           id for the account
              x, y      0–1 in the frame  duration_ms time on screen
              seq       1st, 2nd… there   created_at                 created_at
              hit       what it landed on
                        ('none' = nothing)
              created_at
```

## Four things people get wrong

| | It looks like | It is |
| --- | --- | --- |
| `user_id` | a person | a **browser**. One person on two devices is two; two people on one tablet are one |
| a row in `sessions` | someone using the app | a **visit**. Some visits have no clicks at all |
| `is_test` / `is_synthetic` | the same thing | `is_test` = your own runs; `is_synthetic` = the course's practice data. Real visits have both false |
| `app` | always photo | whichever app wrote the row. Always filter on it |

## Who may do what

| Who | May |
| --- | --- |
| The app (anyone who opens it) | **add** rows. Never read, change or delete |
| You, signed in to the dashboard | **read** rows. Never change or delete |
| Your views (`analysis` schema) | everything you build on top of the raw rows |

## Following one visit

A visit's rows share its `session_id`. To follow one: find it in `sessions`, then every row
with that `session_id` in `clicks`, `selections` and `identities`, ordered by `created_at`.
That is the visit, tap by tap.
