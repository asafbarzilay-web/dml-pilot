create or replace view analysis.task_participant_results as
  with runs as (
    select r.id, r.session_id, r.started_at, r.ended_at, r.ended_by, s.user_id,
           row_number() over (partition by s.user_id order by r.started_at desc, r.id desc) as nth_from_last
    from public.task_runs r
    join public.sessions s on s.session_id = r.session_id
    where r.task = 'On Jane''s profile, like the photo of the woman with purple hair'
      and not s.is_test
  ),
  last_runs as (
    select l.*,
           (select count(*) from public.selections c
             where c.session_id = l.session_id
               and c.created_at between l.started_at and l.ended_at) as choices
    from runs l
    where l.nth_from_last = 1
  )
  select
    case
      when ended_by is distinct from 'success' then 'failed'
      when choices <= 3 then 'direct'
      else 'indirect'
    end as result,
    count(*) as participants
  from last_runs
  group by 1;

comment on view analysis.task_participant_results is
  'We count participants (browsers, user_id in sessions) who tried the team''s task (On Jane''s profile, like the photo of the woman with purple hair), from task_runs, all runs, excluding the team''s own test runs (is_test in sessions). A participant''s result is their last run: direct = it succeeded with no more choices than the best route (3); indirect = it succeeded with more; failed = it did not succeed. A run''s choices are the selections in the same visit (session_id) between the run''s started_at and ended_at.';
