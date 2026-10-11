-- One row: the number of photo app visits that got to the discover page, test runs excluded, from photo_visits.
create or replace view analysis.discover_visit_totals as
  select count(*) as visits
  from analysis.photo_visits v
  where exists (select 1 from public.selections s
                where s.session_id = v.session_id and s.step in ('register_username', 'login') and s.value = 'discover');

comment on view analysis.discover_visit_totals is
  'We count visits to the photo app that got to the discover page, from photo_visits (the photo app''s visits, excluding the team''s own test runs): visits with a selection on the register_username screen or the login screen (step = register_username or login) whose value = discover, each visit counted once.';
