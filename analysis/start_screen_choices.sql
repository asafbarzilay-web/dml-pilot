-- One row per group on the start screen: all visits, then what they pressed (Log in, Register, or neither).
create or replace view analysis.start_screen_choices as
  with v as (
    select v.session_id,
           exists (select 1 from public.selections s
                   where s.session_id = v.session_id and s.step = 'start' and s.value = 'login') as chose_login,
           exists (select 1 from public.selections s
                   where s.session_id = v.session_id and s.step = 'start' and s.value = 'register_email') as chose_register
    from analysis.photo_visits v
  )
  select 1 as n, 'Visits' as choice, count(*) as visits from v
  union all
  select 2, 'Chose Log in', count(*) filter (where chose_login) from v
  union all
  select 3, 'Chose Register', count(*) filter (where chose_register) from v
  union all
  select 4, 'Left without choosing', count(*) filter (where not chose_login and not chose_register) from v;

comment on view analysis.start_screen_choices is
  'We count visits to the photo app, from photo_visits (every visit that belongs to the photo app and is not one of the team''s own test runs), then split them by what the visit pressed on the start screen (selections, step start): Log in, Register, or neither (left without choosing).';
