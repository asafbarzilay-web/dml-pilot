-- One row of totals for the start screen panel.
create or replace view analysis.start_screen_totals as
  select count(*) as visits,
         count(*) filter (where exists (select 1 from public.selections s
                                        where s.session_id = v.session_id and s.step = 'start' and s.value = 'login')) as chose_login,
         count(*) filter (where exists (select 1 from public.selections s
                                        where s.session_id = v.session_id and s.step = 'start' and s.value = 'register_email')) as chose_register,
         count(*) filter (where not exists (select 1 from public.selections s
                                            where s.session_id = v.session_id)) as left_without_choosing
  from analysis.photo_visits v;

comment on view analysis.start_screen_totals is
  'One row of totals for the start screen. Visits: we count every visit to the photo app (photo_visits), excluding the team''s own test runs. Chose Log in: we count those visits with a selection on the start screen (step = start) with value = login. Chose Register: we count those visits with a selection on the start screen with value = register_email. Left without choosing: we count those visits that only opened the start screen, with no selection at all anywhere in the visit.';
