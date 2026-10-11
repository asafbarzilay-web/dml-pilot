-- One row: the number of visits to the photo app, test runs excluded, from photo_visits.
create or replace view analysis.photo_visit_totals as
  select count(*) as visits
  from analysis.photo_visits;

comment on view analysis.photo_visit_totals is
  'We count visits to the photo app, from photo_visits (sessions of the photo app), excluding the team''s own test runs (is_test).';
