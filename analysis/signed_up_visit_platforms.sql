-- The funnel's completed sign-ups (step 3 visits), split by platform.
create or replace view analysis.signed_up_visit_platforms as
  with signed_up as (
    select v.platform
    from analysis.photo_visits v
    where exists (select 1 from public.selections s
                  where s.session_id = v.session_id and s.step = 'register_username' and s.label = 'Sign up')
  )
  select platform, count(*) as visits,
         round(100.0 * count(*) / sum(count(*)) over (), 1) as pct_of_signed_up
  from signed_up
  group by platform;

comment on view analysis.signed_up_visit_platforms is
  'We count the visits that completed sign-up (step 3 of the registration funnel: a selection on the username screen, step = register_username, with label = Sign up), from photo_visits (the photo app''s visits, excluding the team''s own test runs), split by platform (mobile or desktop, from sessions), with each platform''s % of those visits.';
