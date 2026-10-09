-- One row: the totals on the lesson 2 board ("Who used the app?").
create or replace view analysis.usage_totals as
  select count(*) as visits
  from analysis.photo_visits;

comment on view analysis.usage_totals is
  'One row of totals for "Who used the app?". Visits: we count the rows of photo_visits (every visit to the photo app, excluding the team''s own test runs).';
