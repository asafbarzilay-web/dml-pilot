# Your analysis

`example_taps_per_screen.sql` is a complete example: the view, its definition, and (on the dashboard's **Example** board) the panel that shows it.

One file per view in the database's `analysis` schema. The file is the record of the view;
the database holds a copy of it.

Each file looks like this:

```sql
create or replace view analysis.photo_visits as
  select ...;

comment on view analysis.photo_visits is
  'We count ..., from ..., excluding ..., because ...';
```

Your assistant puts each view in your database itself (it runs `sh core/apply.sh`), so you never
paste SQL. It also refuses any file that breaks these rules, so they always hold.

Never a table of copied data here, only views. Never two views that define the same thing.
