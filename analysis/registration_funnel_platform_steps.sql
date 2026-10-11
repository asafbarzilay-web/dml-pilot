-- One row per platform and step of the registration funnel, from photo_visits.
create or replace view analysis.registration_funnel_platform_steps as
  with steps(n, step_name, screen, led_to) as (
    values (1, 'Chose Register', 'start', 'register_email'),
           (2, 'Got past email and password', 'register_email', 'register_username'),
           (3, 'Got past the username, into the app', 'register_username', 'discover')
  ),
  platforms as (
    select distinct platform from analysis.photo_visits
  ),
  reached as (
    select p.platform, st.n, st.step_name,
           (select count(*) from analysis.photo_visits v
             where v.platform = p.platform
               and exists (select 1 from public.selections s
                           where s.session_id = v.session_id and s.step = st.screen and s.value = st.led_to)) as visits
    from platforms p cross join steps st
  )
  select platform, n, step_name, visits,
         round(100.0 * visits / nullif(lag(visits) over (partition by platform order by n), 0), 1) as pct_of_step_before,
         round(100.0 * visits / nullif(first_value(visits) over (partition by platform order by n), 0), 1) as pct_of_first_step
  from reached;

comment on view analysis.registration_funnel_platform_steps is
  'The registration funnel, split by platform (desktop or mobile, from sessions). We count visits, from photo_visits (the photo app''s visits, excluding the team''s own test runs), with the same steps as the registration funnel (step and value in selections): 1, Chose Register: a selection on the start screen that led to register_email. 2, Got past email and password: a selection on register_email that led to register_username. 3, Got past the username, into the app: a selection on register_username that led to discover. For each platform, each step: % of the step before, and % of the first step.';
