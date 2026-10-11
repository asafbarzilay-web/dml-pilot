-- One row: the number of visits, every app, test runs excluded.
create or replace view analysis.visit_totals as
  select count(*) as visits
  from public.sessions
  where not is_test;

comment on view analysis.visit_totals is
  'We count visits, from sessions, excluding the team''s own test runs (is_test), every app included.';
