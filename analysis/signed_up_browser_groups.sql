-- Browsers that completed the registration funnel, split by how many funnel visits it took them.
create or replace view analysis.signed_up_browser_groups as
  with funnel_presses as (
    select v.user_id, v.session_id, s.step, s.label
    from analysis.photo_visits v
    join public.selections s on s.session_id = v.session_id
    where (s.step = 'start' and s.label = 'Register')
       or (s.step = 'register_email' and s.label = 'Next')
       or (s.step = 'register_username' and s.label = 'Sign up')
  ),
  completed as (
    select user_id, count(distinct session_id) as funnel_visits
    from funnel_presses
    group by user_id
    having bool_or(step = 'start') and bool_or(step = 'register_email') and bool_or(step = 'register_username')
  )
  select g.n, g.visit_group,
         (select count(*) from completed c
           where case when g.n = 1 then c.funnel_visits = 1 else c.funnel_visits > 1 end) as browsers
  from (values (1, 'in 1 visit'), (2, 'in more than 1 visit')) as g(n, visit_group);

comment on view analysis.signed_up_browser_groups is
  'We count browsers (user_id), from photo_visits (the photo app''s visits, excluding the team''s own test runs), only browsers that completed all the funnel steps (pressed Register on the start screen, Next on the email and password screen, and Sign up on the username screen), split in two by how many of that browser''s visits had a funnel step: browsers that did it in 1 visit, and browsers that did it in more than 1 visit.';
