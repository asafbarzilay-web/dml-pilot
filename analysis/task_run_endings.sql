-- One row per way a run of the team's task ended, plus a row for all runs.
create or replace view analysis.task_run_endings as
  with runs as (
    select case r.ended_by
             when 'success' then 'success'
             when 'gave_up' then 'gave up'
             else 'never ended'
           end as ending
    from public.task_runs r
    join analysis.photo_visits v on v.session_id = r.session_id
    where r.task = 'On Jane''s profile, like the photo of the woman with purple hair'
  )
  select n, ending, runs
  from (
    select 0 as n, 'all runs' as ending, count(*) as runs from runs
    union all
    select case ending when 'success' then 1 when 'gave up' then 2 else 3 end, ending, count(*)
    from runs group by ending
  ) t;

comment on view analysis.task_run_endings is
  'We count runs of the team''s task, from task_runs, only rows whose task is: On Jane''s profile, like the photo of the woman with purple hair; and whose visit is in the photo app (photo_visits), excluding the team''s own test runs (is_test), split by how the run ended (ended_by): success, gave up, or never ended.';
