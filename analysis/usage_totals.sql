-- One row: the totals on the lesson 2 board ("Who used the app?").
drop view if exists analysis.usage_totals cascade;
create or replace view analysis.usage_totals as
  select count(*) as visits,
         count(distinct user_id) as browsers,
         (select count(*) from analysis.people) as people
  from analysis.photo_visits;

comment on view analysis.usage_totals is
  'One row of totals for "Who used the app?". Visits: we count the rows of photo_visits (every visit to the photo app, excluding the team''s own test runs). Browsers: we count different browsers (user_id) in photo_visits, from the photo app''s visits, excluding the team''s own test runs. People: we count the rows of people (different accounts, plus one per browser that never signed in, from the same visits).';
