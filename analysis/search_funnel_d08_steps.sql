-- One row per step of the team's search funnel ending in photo d08, from photo_visits. Each step counts only visits that also reached the steps before it.
create or replace view analysis.search_funnel_d08_steps as
  with opened as (
    select v.session_id from analysis.photo_visits v
    where exists (select 1 from public.selections s
                  where s.session_id = v.session_id and s.value = 'search')
  ),
  searched as (
    select o.session_id from opened o
    where exists (select 1 from public.selections s
                  where s.session_id = o.session_id and s.value like 'search:%')
  ),
  opened_photo as (
    select x.session_id from searched x
    where exists (select 1 from public.selections s
                  where s.session_id = x.session_id and s.step = 'search_results' and s.value = 'open:d08')
  )
  select 1 as n, 'Opened Search' as step_name, (select count(*) from opened) as visits
  union all
  select 2, 'Searched for something', (select count(*) from searched)
  union all
  select 3, 'Opened photo d08 from the search results', (select count(*) from opened_photo);

comment on view analysis.search_funnel_d08_steps is
  'One row per step of the search funnel. We count visits, from photo_visits (the photo app''s visits, excluding the team''s own test runs), each step only among the visits of the step before: 1, Opened Search: a selection whose value = search. 2, Searched for something: of those, a selection whose value starts with search:. 3, Opened a photo from the search results: of those, a selection on the search results screen (step = search_results) whose value = open:d08.';
