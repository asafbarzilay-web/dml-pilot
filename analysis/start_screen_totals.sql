-- One row of totals for the start screen panel.
create or replace view analysis.start_screen_totals as
  select count(*) as visits
  from analysis.photo_visits;

comment on view analysis.start_screen_totals is
  'One row of totals for "The start screen". Visits: we count every visit to the photo app, from photo_visits (sessions, excluding the team''s own test runs), because every visit opens on the start screen.';
