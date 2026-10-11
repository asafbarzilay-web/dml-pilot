-- One row per step of the registration funnel, from photo_visits.
create or replace view analysis.registration_funnel_steps as
  with steps(n, step_name, screen, led_to) as (
    values (1, 'Chose Register', 'start', 'register_email'),
           (2, 'Got past email and password', 'register_email', 'register_username'),
           (3, 'Got past the username, into the app', 'register_username', 'discover')
  ),
  reached as (
    select st.n, st.step_name,
           (select count(*) from analysis.photo_visits v
             where exists (select 1 from public.selections s
                           where s.session_id = v.session_id and s.step = st.screen and s.value = st.led_to)) as visits
    from steps st
  )
  select n, step_name, visits,
         round(100.0 * visits / nullif(lag(visits) over (order by n), 0), 1) as pct_of_step_before,
         round(100.0 * visits / nullif(first_value(visits) over (order by n), 0), 1) as pct_of_first_step
  from reached;

comment on view analysis.registration_funnel_steps is
  'One row per step of the registration funnel. We count visits, from photo_visits (the photo app''s visits, excluding the team''s own test runs). Each step is marked by where the visit got to (step and value in selections): 1, Chose Register: a selection on the start screen (step = start) that led to register_email. 2, Got past email and password: a selection on register_email that led to register_username. 3, Got past the username, into the app: a selection on register_username that led to discover. Each step: % of the step before, and % of the first step.';
