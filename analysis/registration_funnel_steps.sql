-- One row per step of the registration funnel, from photo_visits.
create or replace view analysis.registration_funnel_steps as
  with steps(n, step_name, screen, pressed) as (
    values (1, 'Pressed Register', 'start', 'Register'),
           (2, 'Pressed Next', 'register_email', 'Next'),
           (3, 'Pressed Sign up', 'register_username', 'Sign up')
  ),
  reached as (
    select st.n, st.step_name,
           (select count(*) from analysis.photo_visits v
             where exists (select 1 from public.selections s
                           where s.session_id = v.session_id and s.step = st.screen and s.label = st.pressed)) as visits
    from steps st
  )
  select n, step_name, visits,
         round(100.0 * visits / nullif(lag(visits) over (order by n), 0), 1) as pct_of_step_before,
         round(100.0 * visits / nullif(first_value(visits) over (order by n), 0), 1) as pct_of_first_step
  from reached;

comment on view analysis.registration_funnel_steps is
  'One row per step of the registration funnel. We count visits, from photo_visits (the photo app''s visits, excluding the team''s own test runs). Step 1, Pressed Register: visits with a selection on the start screen (step = start) with label = Register. Step 2, Pressed Next: visits with a selection on the email and password screen (step = register_email) with label = Next, meaning they moved on to the username screen. Step 3, Pressed Sign up: visits with a selection on the username screen (step = register_username) with label = Sign up, which leads into the app. Each step: % of the step before, and % of the first step.';
