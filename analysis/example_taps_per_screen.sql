-- An example of the pattern every view follows. Copy it; replace it with your own.
create or replace view analysis.example_taps_per_screen as
  select s.app, c.step as screen, count(*) as taps
  from public.clicks c
  join public.sessions s using (session_id)
  group by s.app, c.step;

comment on view analysis.example_taps_per_screen is
  'Example. We count taps, per screen and app, from every visit, excluding nothing (tests and practice data included).';
