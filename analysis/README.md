# Your analysis

One file per view in the database's `analysis` schema. The file is the record of the view;
the database holds a copy of it.

Each file looks like this:

```sql
create or replace view analysis.photo_visits as
  select ...;

comment on view analysis.photo_visits is
  'We count ..., from ..., excluding ..., because ...';
```

To put a view in the database (or change it): open the file, copy all of it, paste it into
Supabase (SQL Editor, New query) and press Run. Then run **Is your analysis tidy?** on your
dashboard.

Never a table of copied data here, only views. Never two views that define the same thing.
