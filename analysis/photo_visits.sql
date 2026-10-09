-- One row per visit to the photo app. The population every lesson 2 number starts from.
create or replace view analysis.photo_visits as
  select *
  from public.sessions
  where app = 'photo'
    and not is_test;

comment on view analysis.photo_visits is
  'We count every visit to the photo app, from sessions, excluding the team''s own test runs, because those are not real visits and other apps'' rows are not ours.';
